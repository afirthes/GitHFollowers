//
//  FollowerListVC.swift
//  GitHFollowers
//
//  Created by Afir Thes on 30.08.2022.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class FollowerListVC: GFDataLoadingVC {
    enum Section { case main }

    var userName: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    init(userName: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = userName
        title = userName
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewController()
        self.configureSearchController()
        self.configureCollectionView()
        self.getFollowers(userName: self.userName, page: self.page)
        self.configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // bug fix - swiping back-forth
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(self.addButtonTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }

    @objc
    func addButtonTapped() {
        showLoadingView()

        NetworkManager.shared.getUserInfo(for: self.userName) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()

            switch result {
            case let .success(user):
                self.addUserToFavorites(user: user)

            case let .failure(error):
                self.presentGFAlertOnMainThread(
                    title: "Something went wrong",
                    message: error.rawValue,
                    buttonTitle: "Ok"
                )
            }
        }
    }

    func configureCollectionView() {
        self.collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view)
        )
        view.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        self.collectionView.delegate = self
    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func getFollowers(userName: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] result in

            guard let self = self else { return }
            self.dismissLoadingView()

            switch result {
            case let .success(followers):
                self.updateUI(with: followers)

            case let .failure(error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    func updateUI(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)

        if self.followers.isEmpty {
            DispatchQueue.main.async {
                let message = "This user doesn't have any followers. Go follow them 🤣."
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.followers)
    }

    func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: self.collectionView,
            cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FollowerCell.reuseID,
                    for: indexPath
                ) as! FollowerCell
                cell.set(follower: follower)
                return cell
            }
        )
    }

    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }

    func addUserToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)

        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGFAlertOnMainThread(
                    title: "Success!",
                    message: "You have successfully favorited this user!",
                    buttonTitle: "Hooray!"
                )
                return
            }

            self.presentGFAlertOnMainThread(
                title: "Something went wrong",
                message: error.rawValue,
                buttonTitle: "Ok"
            )
        }
    }
}

// MARK: UICollectionViewDelegate

extension FollowerListVC: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = self.isSearching ? self.filteredFollowers : self.followers
        let follower = activeArray[indexPath.row]
        let destVC = UserInfoVC()
        destVC.userName = follower.login

        destVC.delegate = self

        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate _: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            guard self.hasMoreFollowers else { return }

            self.page += 1
            self.getFollowers(userName: self.userName, page: self.page)
        }
    }
}

// MARK: UISearchResultsUpdating, UISearchBarDelegate

extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        self.isSearching = true
        self.filteredFollowers = self.followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        self.updateData(on: self.filteredFollowers)
    }

    func searchBarCancelButtonClicked(_: UISearchBar) {
        self.isSearching = false
        self.updateData(on: self.followers)
    }
}

// MARK: FollowerListVCDelegate

extension FollowerListVC: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        self.userName = username
        title = username
        self.page = 1
        self.followers.removeAll()
        self.filteredFollowers.removeAll()
        let searchFrame = navigationItem.searchController!.searchBar.frame
        let dy = searchFrame.origin.y + searchFrame.height
        self.collectionView.setContentOffset(CGPoint(x: 0, y: -dy), animated: true)
        self.isSearching = false
        self.getFollowers(userName: self.userName, page: self.page)
    }
}
