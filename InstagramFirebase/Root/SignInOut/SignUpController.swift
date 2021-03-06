//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/6/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
  
  var avatarButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "plus_photo"), for: .normal)
    button.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
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
  
  private func setupViews() {
    view.backgroundColor = .systemBackground
    setupSignUpStackView()
    setupLoginMessage()
  }

  private func setupSignUpStackView() {
    let inputStackView = UIStackView.verticalStack(arrangedSubviews: [emailTextField, userNameTextField, passwordTextField, signUpButton])
    let signUpStackView = UIStackView.verticalStack(arrangedSubviews: [avatarButton, inputStackView])
    
    inputStackView.spacing = 2 * UIView.defaultPadding
    signUpStackView.spacing = 3 * UIView.defaultPadding
    signUpStackView.alignment = .center
    
    view.addSubview(signUpStackView)
    NSLayoutConstraint.activate([
      avatarButton.widthAnchor.constraint(equalToConstant: 100),
      avatarButton.heightAnchor.constraint(equalTo: avatarButton.widthAnchor, multiplier: 1.0),
      
      inputStackView.widthAnchor.constraint(equalTo: signUpStackView.widthAnchor, multiplier: 1.0),
      
      signUpStackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 4.0),
      signUpStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 4.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: signUpStackView.trailingAnchor, multiplier: 4.0),])
    
    emailTextField.text = "Dumy@gmail.com"
    userNameTextField.text = "Dumy"
    passwordTextField.text = "123456"
  }
  
  private func setupLoginMessage() {
    let loginMessageLabel = UILabel()
    let loginMessageButton = UIButton(type: .system)
    let loginMessageStack = UIStackView(arrangedSubviews: [loginMessageLabel, loginMessageButton])
    loginMessageLabel.text = "Already have an account?"
    loginMessageButton.setTitle("Login", for: .normal)
    loginMessageButton.setTitleColor(.primaryBlue, for: .normal)
    loginMessageButton.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
    loginMessageStack.spacing = 8
    loginMessageStack.disableTAMIC()
    view.addSubview(loginMessageStack)
    NSLayoutConstraint.activate([
      loginMessageStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loginMessageStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  @objc func pickImage() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    
    present(imagePicker, animated: true)
  }
  
  @objc func textChange() {
    if emailTextField.text ?? "" != "" && userNameTextField.text ?? "" != "" && passwordTextField.text ?? ""  != "" {
      signUpButton.isEnabled = true
      signUpButton.backgroundColor = .primaryBlue
    } else {
      signUpButton.isEnabled = false
      signUpButton.backgroundColor = UIColor(rgb: (149, 204, 244))
    }
  }
  
  @objc func signUp() {
    guard let email = emailTextField.text, email != "",
      let username = userNameTextField.text, username != "",
      let password = passwordTextField.text, password != "" else { return }
    
    InstagramFirebaseService.createUser(
      withEmail: email,
      username: username,
      password: password,
      profileImageDataProvider: {
        guard let image = self.avatarButton.image(for: .normal) else { return nil }
        return image.jpegData(compressionQuality: 0.3)
    }) { error in
      guard error == nil else { return }
      DispatchQueue.main.async {
        NotificationCenter.default.post(name: .didLoginInstagramUser, object: nil)
        self.presentingViewController?.dismiss(animated: true)
      }
    }
  }
  
  @objc func showLogin() {
    navigationController?.popViewController(animated: true)
  }
  
  func inputTextField(placeholder: String) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = .roundedRect
    textField.font = UIFont.preferredFont(forTextStyle: .body)
    textField.backgroundColor = .whiteWithAlpha(0.03)
    textField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    return textField
  }

}

extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let editedImage = info[.editedImage] as? UIImage {
      avatarButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
    } else if let originalImage = info[.originalImage] as? UIImage {
      avatarButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    setupAvatarButtonWithImage()
    dismiss(animated: true)
  }
  
  func setupAvatarButtonWithImage() {
    if avatarButton.layer.borderWidth == 0.0 {
      avatarButton.layer.cornerRadius = avatarButton.frame.width/2
      avatarButton.layer.masksToBounds = true
      avatarButton.layer.borderColor = UIColor.black.cgColor
      avatarButton.layer.borderWidth = 3.0
    }
  }
}

