//
//  HomeCell.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
 
  var post: Post! {
    didSet {
      fetchImage()
    }
  }
  
  var imageView: ImageFetchView = {
    let imv = ImageFetchView()
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
  
  private func setup() {
    imageView.pinToSuperviewEdges(pinnedView: self)
  }
  
  private func fetchImage() {
    imageView.fetchImage(withUrl: self.post.imageUrl)
  }
}
