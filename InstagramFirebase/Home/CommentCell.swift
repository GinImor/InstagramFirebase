//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/19/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
  
  var comment: Comment? {
    didSet {
      commentTextView.text = comment?.content
      responderImageView.fetchImage(withUrl: comment?.responderUser?.profileImageUrl)
    }
  }
  
  var responderImageView: ImageFetchView = {
    let imv = ImageFetchView()
    imv.contentMode = .scaleAspectFill
    imv.clipsToBounds = true
    imv.layer.cornerRadius = 20
    imv.backgroundColor = .black
    return imv
  }()
  
  var commentTextView: UITextView = {
    let textView = UITextView()
    textView.font = UIFont.preferredFont(forTextStyle: .body)
    textView.isScrollEnabled = false
    textView.isEditable = false
    textView.textContainerInset = UIEdgeInsets(padding: 0)
    return textView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.pinToSuperviewEdges()
  }
  
  private func setup() {
    let separator = UIView()
    separator.backgroundColor = .whiteWithAlpha(0.5)
    
    let contentStack = UIStackView.verticalStack(arrangedSubviews: [commentTextView, separator])
    let containerStack = UIStackView(arrangedSubviews: [responderImageView, contentStack])
    contentStack.spacing = 8.0
    containerStack.spacing = 8.0
    containerStack.alignment = .top

    contentView.addSubview(containerStack)
    containerStack.disableTAMIC()
    
    NSLayoutConstraint.activate([
      responderImageView.widthAnchor.constraint(equalToConstant: 40),
      responderImageView.heightAnchor.constraint(equalTo: responderImageView.widthAnchor, multiplier: 1.0),
      
      contentStack.heightAnchor.constraint(greaterThanOrEqualTo: responderImageView.heightAnchor, multiplier: 1.0),
      
      separator.heightAnchor.constraint(equalToConstant: 0.5),
    ])
    
    containerStack.pinToSuperviewEdges(edgeInsets: UIEdgeInsets(padding: 8), pinnedView: contentView, forSelfSizing: true)

  }
}

