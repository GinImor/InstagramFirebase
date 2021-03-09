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
    setupChildVCs()
  }
  
  private func setupBarAppearance() {
    tabBar.tintColor = .black
  }
  
  private func setupChildVCs() {
    let flowLayout = UICollectionViewFlowLayout()
    let userProfileController = UserProfileController(collectionViewLayout: flowLayout)
    let userProfileImage = UIImage(systemName: "person")!
    let userProfileSelectedImage = UIImage(systemName: "person.fill")!
    
    viewControllers = [
      userProfileController.wrapInNav(tabBarImage: userProfileImage, selectedImage: userProfileSelectedImage),
      ViewController()
    ]
  }
}
