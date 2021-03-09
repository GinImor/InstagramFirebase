//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
  
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
    setupSignUpMessage()
  }
  
  private func setupSignUpMessage() {
    let signUpLabel = UILabel()
    let signUpButton = UIButton(type: .system)
    let signUpStack = UIStackView(arrangedSubviews: [signUpLabel, signUpButton])
    signUpLabel.text = "Doesn't have an account yet?"
    signUpButton.setTitle("Sign Up", for: .normal)
    signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    signUpStack.spacing = 8
    signUpStack.disableTAMIC()
    view.addSubview(signUpStack)
    NSLayoutConstraint.activate([
      signUpStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      signUpStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  @objc func signUp() {
    let signUpController = SignUpController()
    navigationController?.pushViewController(signUpController, animated: true)
  }
  
}
