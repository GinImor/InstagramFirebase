//
//  LoadingButton.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/15/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
  
  struct ButtonState {
    var state: UIControl.State
    var title: String?
    var image: UIImage?
  }
  
  private(set) var buttonStates: [ButtonState] = []
  private lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = self.titleColor(for: .normal)
    activityIndicator.disableTAMIC()
    self.addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      self.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
      self.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor)
    ])
    return activityIndicator
  }()
  
  func showLoading() {
    guard !activityIndicator.isAnimating else { return }
    activityIndicator.startAnimating()
    var buttonStates: [ButtonState] = []
    for state in [UIControl.State.disabled] {
      let buttonState = ButtonState(state: state, title: title(for: state), image: image(for: state))
      buttonStates.append(buttonState)
      setTitle("", for: state)
      setImage(UIImage(), for: state)
    }
    self.buttonStates = buttonStates
    isEnabled = false
  }
  
  func hideLoading() {
    guard activityIndicator.isAnimating else { return }
    activityIndicator.stopAnimating()
    for buttonState in buttonStates {
      setTitle(buttonState.title, for: buttonState.state)
      setImage(buttonState.image, for: buttonState.state)
    }
    isEnabled = true
  }
  
}
