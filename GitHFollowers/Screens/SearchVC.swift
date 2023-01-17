//
//  SearchVC.swift
//  GitHFollowers
//
//  Created by Afir Thes on 30.08.2022.
//

import UIKit

/*

 View/ViewController
 1. Configure View -> VC
 2. Event Handling -> VC
 10. Animation -> VC

 Router
 3. Navigation -> VC

 Adapter
 4. Datasource/Delegate -> VC

 Presenter
 5. Business Logic -> VC/Service
 6. Save State -> VC
 7. Update Model -> VC
 8. Update View -> VC

 Configureator
 9. Configure Module -> VC

 Model
 11. DAO

 Service
 12. Networking
 13. DB
 14. Bluetooth/Geo

 Provider
 15. Facade

 Dependency Container
 16. DI

 */

class SearchVC: UIViewController {
  let logoImageView = UIImageView()
  let userNameTextField = GFTextField()
  let callToActionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")

  var isUsernameEntered: Bool {
    !userNameTextField.text!.isEmpty
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.configureLogoImageView()
    self.configureTextField()
    self.configureCallToActionButton()
    self.createDismissKeyboardTapGesture()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  func createDismissKeyboardTapGesture() {
    let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
    view.addGestureRecognizer(tap)
  }

  @objc
  func pushFollowerListVC() {
    guard self.isUsernameEntered else {
      presentGFAlertOnMainThread(
        title: "Empty Username",
        message: "Please enter a username. We need to know who to look for 🤣.",
        buttonTitle: "Ok"
      )
      return
    }

    self.userNameTextField.resignFirstResponder()

    // 8. Configure Module
    let followerLitVC = FollowerListVC(userName: userNameTextField.text!)

    // 3. Navigation
    navigationController?.pushViewController(followerLitVC, animated: true)
  }

  func configureLogoImageView() {
    view.addSubview(self.logoImageView)
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
    self.logoImageView.image = Images.ghLogo

    let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80

    NSLayoutConstraint.activate([
      self.logoImageView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor,
        constant: topConstraintConstant
      ),
      self.logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      self.logoImageView.heightAnchor.constraint(equalToConstant: 200),
      self.logoImageView.widthAnchor.constraint(equalToConstant: 200)
    ])
  }

  func configureTextField() {
    view.addSubview(self.userNameTextField)
    self.userNameTextField.delegate = self
    self.userNameTextField.text = "SAllen0400"

    NSLayoutConstraint.activate([
      self.userNameTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 48),
      self.userNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      self.userNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      self.userNameTextField.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  func configureCallToActionButton() {
    view.addSubview(self.callToActionButton)

    self.callToActionButton.addTarget(self, action: #selector(self.pushFollowerListVC), for: .touchUpInside)

    NSLayoutConstraint.activate([
      self.callToActionButton.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
        constant: -50
      ),
      self.callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      self.callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      self.callToActionButton.heightAnchor.constraint(equalToConstant: 50)
    ])
  }
}

// MARK: UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
  func textFieldShouldReturn(_: UITextField) -> Bool {
    self.pushFollowerListVC()
    return true
  }
}
