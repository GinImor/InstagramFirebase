//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/6/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
  
  var avatarButton: UIButton = {
    let button = UIButton(type: .system)
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(named: "plus_photo"), for: .normal)
    return button
  }()
  lazy var emailTextField = inputTextField(placeholder: "Email")
  lazy var userNameTextField = inputTextField(placeholder: "Username")
  lazy var passwordTextField: UITextField = {
    let textField = inputTextField(placeholder: "Password")
    textField.isSecureTextEntry = true
    return textField
  }()
  var signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.backgroundColor = UIColor(rgb: (149, 204, 244))
    button.layer.cornerRadius = 5
    button.tintColor = .white
    button.isEnabled = false
    button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    setupViews()
  }
  
  @objc func textChange() {
    if emailTextField.text ?? "" != "" && userNameTextField.text ?? "" != "" && passwordTextField.text ?? ""  != "" {
      signUpButton.isEnabled = true
      signUpButton.backgroundColor = UIColor(rgb: (17, 154, 237))
    } else {
      signUpButton.isEnabled = false
      signUpButton.backgroundColor = UIColor(rgb: (149, 204, 244))
    }
  }
  
  @objc func signUp() {
    guard let email = emailTextField.text, email != "",
      let userName = userNameTextField.text, userName != "",
      let password = passwordTextField.text, password != "" else { return }
    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
      guard error == nil else { print("create user error: \(String(describing: error))"); return }
      print("successfully create a user: \(authResult?.user.uid ?? "")")
    }
  }
  func setupViews() {
    view.backgroundColor = .systemBackground
    let inputStackView = UIStackView.verticalStack(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
    let signUpStackView = UIStackView.verticalStack(arrangedSubviews: [avatarButton, inputStackView])
    
    inputStackView.spacing = 2 * UIView.defaultPadding
    signUpStackView.spacing = 3 * UIView.defaultPadding
    view.addSubview(signUpStackView)
    NSLayoutConstraint.activate([
      signUpStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4.0),
      signUpStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 4.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: signUpStackView.trailingAnchor, multiplier: 4.0),])
  }

  func inputTextField(placeholder: String) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = .roundedRect
    textField.font = UIFont.preferredFont(forTextStyle: .body)
    textField.backgroundColor = UIColor(white: 0.0, alpha: 0.03)
    textField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    return textField
  }
  

}

