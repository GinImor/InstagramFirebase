//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBarAppearance()
    setupViewControllerToShow()
  }
  
  private func setupBarAppearance() {
    tabBar.tintColor = .black
  }
  
  private func setupViewControllerToShow() {
    guard Auth.auth().currentUser != nil else {
      DispatchQueue.main.async { self.setupLoginVC() }
      return
    }
    setupChildVCs()
  }
  
  private func setupLoginVC() {
    let loginController = LoginController()
    let nav = UINavigationController(rootViewController: loginController)
    present(nav, animated: true)
  }
  
  private func setupChildVCs() {
    let flowLayout = UICollectionViewFlowLayout()
    let userProfileController = UserProfileController(collectionViewLayout: flowLayout)
    let userProfileImage = UIImage(systemName: "person")!
    let userProfileSelectedImage = UIImage(systemName: "person.fill")!
    
    viewControllers = [
      userProfileController.wrapInNav(tabBarImage: userProfileImage, selectedImage: userProfileSelectedImage),
      SignUpController()
    ]
  }
}
