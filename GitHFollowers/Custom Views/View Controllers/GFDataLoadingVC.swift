//
//  GFDataLoadingVC.swift
//  GitHFollowers
//
//  Created by Afir Thes on 15.01.2023.
//

import UIKit

class GFDataLoadingVC: UIViewController {
  var containerView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func showLoadingView() {
    self.containerView = UIView(frame: view.bounds)
    view.addSubview(self.containerView)

    self.containerView.backgroundColor = .systemBackground
    self.containerView.alpha = 0

    UIView.animate(withDuration: 0.25) {
      self.containerView.alpha = 0.8
    }

    let activityIndicator = UIActivityIndicatorView(style: .large)
    self.containerView.addSubview(activityIndicator)

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      activityIndicator.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor)
    ])

    activityIndicator.startAnimating()
  }

  func dismissLoadingView() {
    DispatchQueue.main.async {
      self.containerView.removeFromSuperview()
      self.containerView = nil
    }
  }

  func showEmptyStateView(with message: String, in view: UIView) {
    let emptyStateView = GFEmptyStateView(message: message)
    emptyStateView.frame = view.bounds
    view.addSubview(emptyStateView)
  }
}
