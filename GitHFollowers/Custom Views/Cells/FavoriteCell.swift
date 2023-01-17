//
//  FavoriteCell.swift
//  GitHFollowers
//
//  Created by Afir Thes on 09.01.2023.
//

import UIKit

class FavoriteCell: UITableViewCell {
  static let reuseID = "FavoriteCell"
  let avatarImageView = GFAvatarImageView(frame: .zero)
  let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configure()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(favorite: Follower) {
    self.usernameLabel.text = favorite.login
    self.avatarImageView.downloadAvatarImage(fromURL: favorite.avatarUrl)
  }

  private func configure() {
    addSubview(self.avatarImageView)
    addSubview(self.usernameLabel)

    accessoryType = .disclosureIndicator
    let padding: CGFloat = 12

    NSLayoutConstraint.activate([
      self.avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      self.avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
      self.avatarImageView.heightAnchor.constraint(equalToConstant: 60),
      self.avatarImageView.widthAnchor.constraint(equalToConstant: 60),

      self.usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      self.usernameLabel.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 24),
      self.usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
      self.usernameLabel.heightAnchor.constraint(equalToConstant: 40)
    ])
  }

  func getFavorites() {}
}
