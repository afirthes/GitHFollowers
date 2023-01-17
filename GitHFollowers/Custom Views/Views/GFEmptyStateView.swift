//
//  GFEmptyStateView.swift
//  GitHFollowers
//
//  Created by Afir Thes on 10.12.2022.
//

import UIKit

class GFEmptyStateView: UIView {
    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(message: String) {
        self.init(frame: .zero)
        self.messageLabel.text = message
    }

    private func configure() {
        addSubview(self.messageLabel)
        addSubview(self.logoImageView)

        self.messageLabel.numberOfLines = 3
        self.messageLabel.textColor = .secondaryLabel

        self.logoImageView.image = Images.emptyStateLogo
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150),
            self.messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            self.messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            self.messageLabel.heightAnchor.constraint(equalToConstant: 200),

            self.logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            self.logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            self.logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            self.logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 40)
        ])
    }
}
