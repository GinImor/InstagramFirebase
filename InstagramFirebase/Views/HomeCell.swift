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
  
  var width: CGFloat? {
    didSet {
      guard width != nil && !widthConstraint.isActive else { return }
      widthConstraint.isActive = true
      widthConstraint.constant = width!
    }
  }
  
  @IBOutlet private var widthConstraint: NSLayoutConstraint! {
    didSet { widthConstraint.isActive = false }
  }

  @IBOutlet weak var userProfileImageView: ImageFetchView! {
    didSet {
      userProfileImageView.layer.cornerRadius = 20
      userProfileImageView.backgroundColor = .black
    }
  }
  @IBOutlet weak var usernameLabel: UILabel!
  
  @IBOutlet weak var photoImageView: ImageFetchView!
  
  @IBOutlet weak var captionLabel: UILabel! {
    didSet {
      captionLabel.attributedText = attributedTextForCaptionLabel(username: "Username", caption: " Some caption text below the image")
    }
  }
  @IBOutlet weak var creationLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.disableTAMIC()
    NSLayoutConstraint.activate([
      contentView.leftAnchor.constraint(equalTo: leftAnchor),
      contentView.rightAnchor.constraint(equalTo: rightAnchor),
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func fetchImage() {
    photoImageView.fetchImage(withUrl: self.post.imageUrl)
  }
  
  private func attributedTextForCaptionLabel(username: String, caption: String) -> NSAttributedString {
    let result = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
    let captionPart = NSAttributedString(string: caption, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
    result.append(captionPart)
    return result
  }
}

