//
//  FollowerCell.swift
//  GitHFollowers
//
//  Created by Afir Thes on 13.09.2022.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    
    static let reuseId = "FollowerCell"
    
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let userNameLablel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(follower: Follower) {
        userNameLablel.text = follower.login
    }
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(userNameLablel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            userNameLablel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            userNameLablel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            userNameLablel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            userNameLablel.heightAnchor.constraint(equalToConstant: 20)
            
        ])
    }
}
