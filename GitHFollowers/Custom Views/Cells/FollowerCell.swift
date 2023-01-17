//
//  FollowerCell.swift
//  GitHFollowers
//
//  Created by Afir Thes on 13.09.2022.
//

import UIKit

class FollowerCell: UICollectionViewCell {
  static let reuseID = "FollowerCell"
  let avatarImageView = GFAvatarImageView(frame: .zero)
  let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configure()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(follower: Follower) {
    self.usernameLabel.text = follower.login
    self.avatarImageView.downloadAvatarImage(fromURL: follower.avatarUrl)
  }

  private func configure() {
    contentView.addSubview(self.avatarImageView)
    contentView.addSubview(self.usernameLabel)

    let padding: CGFloat = 8

    NSLayoutConstraint.activate([
      self.avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
      self.avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      self.avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      self.avatarImageView.heightAnchor.constraint(equalTo: self.avatarImageView.widthAnchor),

      self.usernameLabel.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor, constant: 12),
      self.usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
      self.usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
      self.usernameLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
}
