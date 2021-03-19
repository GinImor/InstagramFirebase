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
      commentLabel.text = comment?.content
    }
  }
  
  private var commentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = .red
    commentLabel.pinToSuperviewEdges(
      edgeInsets: UIEdgeInsets(padding: 8),
      pinnedView: self)
  }
}
