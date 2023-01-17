//
//  GFItemInfoView.swift
//  GitHFollowers
//
//  Created by Afir Thes on 11.12.2022.
//

import UIKit

enum ItemInfoType {
  case repos
  case gists
  case followers
  case following
}

class GFItemInfoView: UIView {
  let symbolImageView = UIImageView()
  let titleLable = GFTitleLabel(textAlignment: .left, fontSize: 14)
  let countLabel = GFTitleLabel(textAlignment: .center, fontSize: 14)

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configure()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    addSubview(self.symbolImageView)
    addSubview(self.titleLable)
    addSubview(self.countLabel)

    self.symbolImageView.translatesAutoresizingMaskIntoConstraints = false
    self.symbolImageView.contentMode = .scaleAspectFill
    self.symbolImageView.tintColor = .label

    NSLayoutConstraint.activate([
      self.symbolImageView.topAnchor.constraint(equalTo: topAnchor),
      self.symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      self.symbolImageView.widthAnchor.constraint(equalToConstant: 20),
      self.symbolImageView.heightAnchor.constraint(equalToConstant: 20),

      self.titleLable.centerYAnchor.constraint(equalTo: self.symbolImageView.centerYAnchor),
      self.titleLable.leadingAnchor.constraint(equalTo: self.symbolImageView.trailingAnchor, constant: 12),
      self.titleLable.trailingAnchor.constraint(equalTo: trailingAnchor),
      self.titleLable.heightAnchor.constraint(equalToConstant: 18),

      self.countLabel.topAnchor.constraint(equalTo: self.symbolImageView.bottomAnchor, constant: 4),
      self.countLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
      self.countLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
      self.countLabel.heightAnchor.constraint(equalToConstant: 18)
    ])
  }

  func set(itemInfoType: ItemInfoType, withCount count: Int) {
    switch itemInfoType {
    case .repos:
      self.symbolImageView.image = SFSymbols.repos
      self.titleLable.text = "Public Repos"
    case .gists:
      self.symbolImageView.image = SFSymbols.gists
      self.titleLable.text = "Public Gists"
    case .followers:
      self.symbolImageView.image = SFSymbols.followers
      self.titleLable.text = "Followers"
    case .following:
      self.symbolImageView.image = SFSymbols.following
      self.titleLable.text = "Following"
    }

    self.countLabel.text = String(count)
  }
}
