//
//  UIViewController+navInTabBar.swift
//  Podcast
//
//  Created by Gin Imor on 2/14/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func wrapInNav(tabBarImage: UIImage, selectedImage: UIImage) -> UINavigationController {
    let nav = UINavigationController(rootViewController: self)
    nav.tabBarItem.image = tabBarImage
    nav.tabBarItem.selectedImage = selectedImage
    return nav
  }
}
