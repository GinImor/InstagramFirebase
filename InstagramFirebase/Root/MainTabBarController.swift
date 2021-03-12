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
    setupNotification()
    setupViewControllerToShow()
  }
  
  private func setupBarAppearance() {
    tabBar.tintColor = .black
  }
  
  private func setupNotification() {
    delegate = self
    NotificationCenter.default.addObserver(forName: .didLoginInstagramUser, object: nil, queue: .main) { (_) in
      self.setupChildVCs()
    }
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
    let homeImage = UIImage(systemName: "house")!
    let homeSelectedImage = UIImage(systemName: "house.fill")!
    let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
    
    let searchFlowLayout = UICollectionViewFlowLayout()
    let searchImage = UIImage(systemName: "magnifyingglass.circle")!
    let searchSelectedImage = UIImage(systemName: "magnifyingglass.circle.fill")!
    let searchController = UserSearchController(collectionViewLayout: searchFlowLayout)
    
    let plusImage = UIImage(systemName: "plus.square")!
    let plusSelectedImage = UIImage(systemName: "plus.square.fill")!
    let plusController = UIViewController()
    
    let likeImage = UIImage(systemName: "heart.circle")!
    let likeSelectedImage = UIImage(systemName: "heart.circle.fill")!
    let likeController = UIViewController()
    
    let profileFlowLayout = UICollectionViewFlowLayout()
    let userProfileImage = UIImage(systemName: "person")!
    let userProfileSelectedImage = UIImage(systemName: "person.fill")!
    let userProfileController = UserProfileController(collectionViewLayout: profileFlowLayout)
    
    viewControllers = [
      homeController.wrapInNav(tabBarImage: homeImage, selectedImage: homeSelectedImage),
      searchController.wrapInNav(tabBarImage: searchImage, selectedImage: searchSelectedImage),
      plusController.wrapInNav(tabBarImage: plusImage, selectedImage: plusSelectedImage),
      likeController.wrapInNav(tabBarImage: likeImage, selectedImage: likeSelectedImage),
      userProfileController.wrapInNav(tabBarImage: userProfileImage, selectedImage: userProfileSelectedImage)
    ]
  }
}
 
extension MainTabBarController: UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    if viewControllers?.firstIndex(of: viewController)! == 2 {
      let photoSelectorController = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
      let nav = UINavigationController(rootViewController: photoSelectorController)
      present(nav, animated: true)
      return false
    }
    return true
  }
}
