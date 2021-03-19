//
//  HomeController+transitioningDelegate.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/18/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension HomeController: UIViewControllerTransitioningDelegate {
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if presented is CameraController {
      guard let cameraButton = navigationItem.leftBarButtonItem else { return nil }
      let cameraView = (cameraButton.value(forKey: "view") as! UIView)
      transition.originalFrame = cameraView.superview!.convert(cameraView.frame, to: nil)
      print("original frame:", transition.originalFrame)
      transition.presenting = true
      return transition
    }
    return nil
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if dismissed is CameraController {
      transition.presenting = false
      return transition
    }
    return nil
  }
}
