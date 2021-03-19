//
//  PopAnimator.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/18/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  let duration = 0.5
  var presenting = true
  var originalFrame = CGRect.zero
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    let toView = transitionContext.view(forKey: .to)!
    let cameraView = transitionContext.view(forKey: presenting ? .to : .from)!
    let cameraController = transitionContext.viewController(forKey: presenting ? .to : .from)!
    
    cameraView.frame = presenting ?
      transitionContext.finalFrame(for: cameraController) :
      transitionContext.initialFrame(for: cameraController)
    
    let initialFrame = presenting ? originalFrame : cameraView.frame
    let finalFrame = presenting ? cameraView.frame : originalFrame
    
    print("cameraView frame:", cameraView.frame)
    let xScaleFactor = originalFrame.width / cameraView.frame.width
    let yScaleFactor = originalFrame.height / cameraView.frame.height
    let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
    
    if presenting {
      cameraView.transform = scaleTransform
      cameraView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
      cameraView.clipsToBounds = true
      cameraView.alpha = 0.0
      cameraView.layer.cornerRadius = 10.0/xScaleFactor
    }
    
    containerView.addSubview(toView)
    containerView.bringSubviewToFront(cameraView)
    
    UIView.animate(withDuration: duration, animations: {
      cameraView.transform = self.presenting ? .identity : scaleTransform
      cameraView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
      cameraView.alpha = self.presenting ? 1.0 : 0.0
      cameraView.layer.cornerRadius = self.presenting ? 0.0 : 10.0/xScaleFactor
    }) { (_) in
      transitionContext.completeTransition(true)
    }
    
  }
  
}
