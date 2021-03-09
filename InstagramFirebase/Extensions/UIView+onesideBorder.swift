//
//  UIView+onesideBorder.swift
//  Podcast
//
//  Created by Gin Imor on 2/19/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIView {
  
  func addTopBorder(withColor color: UIColor?, borderWidth: CGFloat) {
      let border = UIView()
      border.backgroundColor = color
      border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
      border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: borderWidth)
      addSubview(border)
  }

  func addBottomBorder(withColor color: UIColor?, borderWidth: CGFloat) {
      let border = UIView()
      border.backgroundColor = color
      border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
      border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
      addSubview(border)
  }

  func addLeftBorder(withColor color: UIColor?, borderWidth: CGFloat) {
      let border = UIView()
      border.backgroundColor = color
      border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
      border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
      addSubview(border)
  }

  func addRightBorder(withColor color: UIColor?, borderWidth: CGFloat) {
      let border = UIView()
      border.backgroundColor = color
      border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
      border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
      addSubview(border)
  }

}
