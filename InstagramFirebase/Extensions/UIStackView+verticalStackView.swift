//
//  UIStackView+verticalStackView.swift
//  Podcast
//
//  Created by Gin Imor on 2/22/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIStackView {
  
  /// Creates a stack view configured for displaying content vertically.
  public static func verticalStack(arrangedSubviews: [UIView]) -> UIStackView {
    let stack = UIStackView(arrangedSubviews: arrangedSubviews)
    stack.axis = .vertical
    stack.disableTAMIC()
    return stack
  }
  
  @discardableResult
  public static func verticalStack(arrangedSubviews: [UIView], pinToSuperview pinedView: UIView) -> UIStackView {
    let stackView = UIStackView.verticalStack(arrangedSubviews: arrangedSubviews)
    pinedView.addSubview(stackView)
    stackView.pinToSuperviewEdges()
    return stackView
  }
}
