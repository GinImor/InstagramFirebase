//
//  UIColor+colorConstructor.swift
//  IntermediateTraining
//
//  Created by Gin Imor on 1/30/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIColor {
  
  static var primaryBlue: UIColor { UIColor(rgb: (17, 154, 237)) }
  static func whiteWithAlpha(_ alpha: CGFloat) -> UIColor {
    return UIColor(white: 0.0, alpha: alpha)
  }
  
  convenience init(rgb: (red: Int, green: Int, blue: Int), alpha: CGFloat = 1.0) {
    self.init(red: CGFloat(rgb.red)/255,
              green: CGFloat(rgb.green)/255,
              blue: CGFloat(rgb.blue)/255, alpha: alpha
         )
  }
  
}
