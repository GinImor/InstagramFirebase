//
//  PhotoSelectorCell.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/10/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class PhotoSelectorCell: UICollectionViewCell {
  
  var imageView: UIImageView = {
    let imv = UIImageView()
    imv.disableTAMIC()
    imv.contentMode = .scaleAspectFill
    imv.clipsToBounds = true
    return imv
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    imageView.pinToSuperviewEdges(pinnedView: self)
  }
  
}
