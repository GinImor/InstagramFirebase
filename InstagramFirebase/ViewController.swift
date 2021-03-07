//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/6/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  static func textField(placeholder: String) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = .roundedRect
    textField.font = UIFont.preferredFont(forTextStyle: .body)
    textField.backgroundColor = UIColor(white: 0.0, alpha: 0.03)
    return textField
  }
  
  var avatarButton: UIButton = {
    let button = UIButton(type: .system)
    button.imageView?.contentMode = .scaleAspectFit
    button.setImage(UIImage(named: "plus_photo"), for: .normal)
    return button
  }()
  var emailTextField = ViewController.textField(placeholder: "Email")
  var userNameTextField = ViewController.textField(placeholder: "Username")
  var passwordTextField: UITextField = {
    let textField = ViewController.textField(placeholder: "Password")
    textField.isSecureTextEntry = true
    return textField
  }()
  var signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.backgroundColor = UIColor(rgb: (149, 204, 244))
    button.layer.cornerRadius = 5
    button.tintColor = .white
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    setupViews()
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


}

