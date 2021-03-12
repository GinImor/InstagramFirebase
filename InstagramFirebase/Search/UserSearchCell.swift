//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/12/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
  
  var imageView: ImageFetchView = {
    let imv = ImageFetchView()
    imv.contentMode = .scaleAspectFill
    imv.clipsToBounds = true
    imv.layer.cornerRadius = 25
    imv.backgroundColor = .black
    return imv
  }()
  
  var usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "username"
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()
  
  var postsNumLabel: UILabel = {
    let label = UILabel()
    label.text = "0 post"
    label.textColor = .systemGray3
    label.font = UIFont.systemFont(ofSize: 14)
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
    let messageStackView = UIStackView.verticalStack(arrangedSubviews: [usernameLabel, postsNumLabel])
    let profileStackView = UIStackView(arrangedSubviews: [imageView, messageStackView])
    let edgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    let separator = UIView()
    
    addSubview(separator)
    separator.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
    separator.disableTAMIC()
    
    messageStackView.distribution = .fillEqually
    messageStackView.spacing = 0
    
    profileStackView.spacing = 8
    profileStackView.pinToSuperviewEdges(edgeInsets: edgeInsets, pinnedView: self)
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalToConstant: 50),
      imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
      
      separator.leadingAnchor.constraint(equalTo: messageStackView.leadingAnchor),
      separator.trailingAnchor.constraint(equalTo: messageStackView.trailingAnchor),
      separator.heightAnchor.constraint(equalToConstant: 0.5),
      separator.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}
