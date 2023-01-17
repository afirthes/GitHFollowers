//
//  GFTextField.swift
//  GitHFollowers
//
//  Created by Afir Thes on 30.08.2022.
//

import UIKit

class GFTextField: UITextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configure()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false

    layer.cornerRadius = 10
    layer.borderWidth = 2
    layer.borderColor = UIColor.systemGray4.cgColor

    textColor = .label
    tintColor = .label // blinking cursor
    textAlignment = .center
    font = UIFont.preferredFont(forTextStyle: .title2)
    adjustsFontSizeToFitWidth = true
    minimumFontSize = 12

    backgroundColor = .tertiarySystemBackground
    autocorrectionType = .no

    placeholder = "Enter a username"

    returnKeyType = .go

    clearButtonMode = .whileEditing
  }
}
