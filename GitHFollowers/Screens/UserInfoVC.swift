//
//  UserInfoVC.swift
//  GitHFollowers
//
//  Created by Afir Thes on 11.12.2022.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
  func didTapGitHubProfile(for user: User)
  func didTapGetFollowers(for user: User)
}

class UserInfoVC: GFDataLoadingVC {
  let headerView = UIView()
  let itemViewOne = UIView()
  let itemViewTwo = UIView()
  let dateLabel = GFBodyLabel(textAlignment: .center)
  var userName: String!
  var itemViews: [UIView] = []

  weak var delegate: FollowerListVCDelegate!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    self.configureNavBar()
    self.layoutUI()
    self.getUserInfo()
  }

  func getUserInfo() {
    NetworkManager.shared.getUserInfo(for: self.userName) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case let .success(user):
        DispatchQueue.main.async {
          self.configureUIElements(with: user)
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

  func configureUIElements(with user: User) {
    let repoItemVC = GFRepoItemVC(user: user)
    repoItemVC.delegate = self
    self.add(childVC: repoItemVC, to: self.itemViewOne)

    let followerItemVC = GFFollowerItemVC(user: user)
    followerItemVC.delegate = self
    self.add(childVC: followerItemVC, to: self.itemViewTwo)

    self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)
    self.dateLabel.text = "GitHub since \(user.createdAt.converToMonthYearFormat())"
  }

  func layoutUI() {
    let padding: CGFloat = 20
    let itemHeight: CGFloat = 140
    self.itemViews = [self.headerView, self.itemViewOne, self.itemViewTwo, self.dateLabel]

    for itemView in self.itemViews {
      view.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
      ])
    }

    NSLayoutConstraint.activate([
      self.headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      self.headerView.heightAnchor.constraint(equalToConstant: 180),

      self.itemViewOne.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: padding),
      self.itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

      self.itemViewTwo.topAnchor.constraint(equalTo: self.itemViewOne.bottomAnchor, constant: padding),
      self.itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

      self.dateLabel.topAnchor.constraint(equalTo: self.itemViewTwo.bottomAnchor, constant: padding),
      self.dateLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  func configureNavBar() {
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = .systemPurple
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.compactAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance

    let doneButton = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(self.doneBarButtonPressed)
    )
    navigationItem.rightBarButtonItem = doneButton
  }

  func add(childVC: UIViewController, to containerView: UIView) {
    addChild(childVC)
    containerView.addSubview(childVC.view)
    childVC.view.frame = containerView.bounds
    childVC.didMove(toParent: self)
  }

  @objc
  func doneBarButtonPressed() {
    dismiss(animated: true)
  }
}

// MARK: UserInfoVCDelegate

extension UserInfoVC: UserInfoVCDelegate {
  func didTapGitHubProfile(for user: User) {
    guard let url = URL(string: user.htmlUrl) else {
      presentGFAlertOnMainThread(
        title: "Invaid URL",
        message: "The url attached to this user is invalid",
        buttonTitle: "Ok"
      )
      return
    }

    presentSafariVC(with: url)
  }

  func didTapGetFollowers(for user: User) {
    guard user.followers != 0 else {
      presentGFAlertOnMainThread(
        title: "No followers",
        message: "This user has no followers. What a shame 8)",
        buttonTitle: "Ok"
      )
      return
    }

    self.delegate.didRequestFollowers(for: user.login)
    dismiss(animated: true)
  }
}
