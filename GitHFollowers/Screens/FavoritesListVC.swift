//
//  FavoritesListVC.swift
//  GitHFollowers
//
//  Created by Afir Thes on 30.08.2022.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {
  let tableView = UITableView()
  var favorites: [Follower] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configureViewController()
    self.configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.getFavorites()
  }

  func configureViewController() {
    view.backgroundColor = .systemBackground
    title = "Favorites"
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  func configureTableView() {
    view.addSubview(self.tableView)
    self.tableView.frame = view.bounds
    self.tableView.rowHeight = 80
    self.tableView.delegate = self
    self.tableView.dataSource = self

    self.tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
  }

  func getFavorites() {
    PersistenceManager.retrieveFavorites { [weak self] result in
      guard let self = self else { return }
      switch result {
      case let .success(favorites):

        if favorites.isEmpty {
          self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
        } else {
          self.favorites = favorites
          DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
          }
        }

      case let .failure(error):
        self.presentGFAlertOnMainThread(
          title: "Something went wrong",
          message: error.rawValue,
          buttonTitle: "Ok"
        )
      }
    }
  }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension FavoritesListVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return self.favorites.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell

    let favorite = self.favorites[indexPath.row]
    cell.set(favorite: favorite)

    return cell
  }

  func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    let favorite = self.favorites[indexPath.row]
    let destVC = FollowerListVC(userName: favorite.login)

    navigationController?.pushViewController(destVC, animated: true)
  }

  func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    guard editingStyle == .delete else { return }

    let favorite = self.favorites[indexPath.row]
    self.favorites.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .left)

    PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
      guard let self = self else { return }
      guard let error = error else { return }
      self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
    }
  }
}
