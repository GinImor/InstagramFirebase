//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
  
  var logoView: UIView = {
    let lgView = UIView()
    let lgImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
    lgView.backgroundColor = UIColor(rgb: (0, 120, 175))
    lgView.disableTAMIC()
    lgImageView.centerToSuperviewSafeAreaLayoutGuide(superview: lgView)
    return lgView
  }()
  
  lazy var emailTextField = inputTextField(placeholder: "Email")
  lazy var passwordTextField: UITextField = {
    let textField = inputTextField(placeholder: "Password")
    textField.isSecureTextEntry = true
    return textField
  }()
  var loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.backgroundColor = UIColor(rgb: (149, 204, 244))
    button.layer.cornerRadius = 5
    button.tintColor = .white
    button.isEnabled = false
//    button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupViews()
  }
  
  private func setupNavigationBar() {
    navigationController?.isNavigationBarHidden = true
  }
  
  private func setupViews() {
    view.backgroundColor = .systemBackground
    setupLogoView()
    setupInputStackView()
    setupSignUpMessage()
  }
  
  private func setupLogoView() {
    view.addSubview(logoView)
    NSLayoutConstraint.activate([
      logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      logoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: logoView.trailingAnchor),
      logoView.heightAnchor.constraint(equalToConstant: 200)
    ])
  }
  
  private func setupInputStackView() {
    let inputStackView = UIStackView.verticalStack(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
    view.addSubview(inputStackView)
    NSLayoutConstraint.activate([
      inputStackView.topAnchor.constraint(equalToSystemSpacingBelow: logoView.bottomAnchor, multiplier: 4.0),
      inputStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 4.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: inputStackView.trailingAnchor, multiplier: 4.0)
    ])
  }
  
  private func setupSignUpMessage() {
    let signUpLabel = UILabel()
    let signUpButton = UIButton(type: .system)
    let signUpStack = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
    signUpLabel.text = "Doesn't have an account yet?"
    signUpButton.setTitle("Sign Up", for: .normal)
    signUpButton.setTitleColor(UIColor(rgb: (17, 154, 237)), for: .normal)
    signUpButton.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
    signUpStack.spacing = 8
    signUpStack.disableTAMIC()
    view.addSubview(signUpStack)
    NSLayoutConstraint.activate([
      signUpStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      signUpStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  @objc func showSignUp() {
    let signUpController = SignUpController()
    navigationController?.pushViewController(signUpController, animated: true)
  }
  
  func inputTextField(placeholder: String) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = .roundedRect
    textField.font = UIFont.preferredFont(forTextStyle: .body)
    textField.backgroundColor = UIColor(white: 0.0, alpha: 0.03)
//    textField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    return textField
  }
  
}
