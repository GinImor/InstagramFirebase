//
//  HomeCell.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

protocol HomeCellDelegate {
  
  func didTappedComment(ofPost: Post)
}

class HomeCell: UICollectionViewCell {
 
  var post: Post! {
    didSet { updateUI() }
  }
  
  var width: CGFloat? {
    didSet {
      guard width != nil && !widthConstraint.isActive else { return }
      widthConstraint.constant = width!
      widthConstraint.isActive = true
    }
  }
  
  var delegate: HomeCellDelegate?
  
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
  
  @IBOutlet weak var captionLabel: UILabel!
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
  
  private func updateUI() {
    userProfileImageView.fetchImage(withUrl: post.user?.profileImageUrl)
    usernameLabel.text = post.user?.username
    photoImageView.fetchImage(withUrl: post.imageUrl)
    captionLabel.attributedText = attributedTextForPost()
    creationLabel.text = post.creationDate.timeAgo()
  }
  
  private func attributedTextForPost() -> NSAttributedString {
    let result = NSMutableAttributedString(string: post.user?.username ?? "", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)])
    let captionPart = NSAttributedString(string: " " + post.caption, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)])
    result.append(captionPart)
    return result
  }
  
  @IBAction func didTappedComment(_ sender: Any) {
    guard let post = self.post else { return }
    delegate?.didTappedComment(ofPost: post)
  }
  
}

