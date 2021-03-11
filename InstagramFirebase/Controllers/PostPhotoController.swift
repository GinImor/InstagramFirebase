//
//  PostPhotoController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import Photos

class PostPhotoController: UIViewController {
  
  var asset: PHAsset! {
    didSet {
      PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 2000, height: 2000), contentMode: .default, options: nil) { (image, info) in
        self.imageView.image = image
      }
    }
  }
  
  var imageView: UIImageView = {
    let imv = UIImageView()
    imv.backgroundColor = .systemGray4
    imv.contentMode = .scaleAspectFill
    imv.clipsToBounds = true
    imv.layer.cornerRadius = 2
    return imv
  }()
  
  var textView: UITextView = {
    let tv = UITextView()
    tv.font = UIFont.preferredFont(forTextStyle: .body)
    tv.backgroundColor = .blue
    return tv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  private func setupViews() {
    view.backgroundColor = UIColor(rgb: (240, 240, 240))
    
    let imageStackView = UIStackView(arrangedSubviews: [imageView])
    imageStackView.isLayoutMarginsRelativeArrangement = true
    imageStackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    let contentStackView = UIStackView(arrangedSubviews: [imageStackView, textView])
    contentStackView.disableTAMIC()
    contentStackView.backgroundColor = .black
    let backgroundView = UIView()
    backgroundView.disableTAMIC()
    backgroundView.backgroundColor = .white
    
    backgroundView.addSubview(contentStackView)
    view.addSubview(backgroundView)
    
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 80),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
      
      backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
    ])
    contentStackView.pinToSuperviewEdges()
  }
}
