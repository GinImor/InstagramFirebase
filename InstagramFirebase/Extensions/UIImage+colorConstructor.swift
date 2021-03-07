//
//  UIImage+colorConstructor.swift
//  IntermediateTraining
//
//  Created by Gin Imor on 1/30/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

extension UIColor {
  
  static let darkBlue = UIColor(rgb: (9, 45, 64))
  static let lightRed = UIColor(rgb: (247, 66, 82))
  static let tealColor = UIColor(rgb: (48, 164, 182))
  static let lightBlue = UIColor(rgb: (218, 235, 242))
  
  convenience init(rgb: (red: Int, green: Int, blue: Int), alpha: CGFloat = 1.0) {
    self.init(red: CGFloat(rgb.red)/255,
              green: CGFloat(rgb.green)/255,
              blue: CGFloat(rgb.blue)/255, alpha: alpha
         )
  }
  
}
