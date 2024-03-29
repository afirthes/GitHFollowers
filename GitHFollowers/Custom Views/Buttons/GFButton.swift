//
//  GFButton.swift
//  GitHFollowers
//
//  Created by Afir Thes on 30.08.2022.
//

import UIKit

class GFButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        set(backgroundColor: backgroundColor, title: title)
    }

    private func configure() {
        
        if #available(iOS 15.0, *) {
            self.configuration = .tinted()
            self.configuration?.cornerStyle = .medium
        } else {
            layer.cornerRadius = 10
            setTitleColor(.white, for: .normal)
            titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        }

        translatesAutoresizingMaskIntoConstraints = false
    }

    func set(backgroundColor: UIColor, title: String) {
        self.backgroundColor = backgroundColor
        setTitle(title, for: .normal)
    }
}
