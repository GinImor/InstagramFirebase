//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class UserProfileHeadder: UICollectionViewCell {

  var user: User? {
    didSet {
      loadProfileImage()
    }
  }
  
  private var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 40
    imageView.layer.masksToBounds = true
    imageView.layer.borderColor = UIColor.black.cgColor
    imageView.layer.borderWidth = 1.0
    return imageView
  }()
  private var usernameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.text = "username"
    label.numberOfLines = 2
    label.textAlignment = .center
    return label
  }()
  
  private lazy var postLabel = postRelatedLabel(type: "post")
  private lazy var followingLabel = postRelatedLabel(type: "following")
  private lazy var followerLabel = postRelatedLabel(type: "follower")
  private var editProfileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 3
    return button
  }()
  
  private lazy var gridButton: UIButton = {
    let button = displayModeButton(imageNamed: "rectangle.grid.2x2")
    button.tintColor = nil
    return button
  }()
  private lazy var listButton = displayModeButton(imageNamed: "list.dash")
  private lazy var bookmarkButton = displayModeButton(imageNamed: "bookmark")
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    setupProfileStack()
  }
  
  private func setupProfileStack() {
    let contentStack = profileContentStack()
    UIStackView.verticalStack(
      arrangedSubviews: [contentStack, displayModeStack()],
      pinToSuperview: self,
      edgeInsets: UIEdgeInsets(top: UIView.defaultPadding, left: 0, bottom: 0, right: 0)
    )
    
    contentStack.isLayoutMarginsRelativeArrangement = true
    contentStack.layoutMargins = UIEdgeInsets(
      top: 0,
      left: UIView.defaultPadding,
      bottom: 0,
      right: UIView.defaultPadding
    )
  }
  
  private func profileContentStack() -> UIStackView{
    let stack = UIStackView(arrangedSubviews: [profileImageUsernameStack(), postsAndEditProfileStack()])
    stack.alignment = .top
    stack.spacing = 2 * UIView.defaultPadding
    return stack
  }
  
  private func profileImageUsernameStack() -> UIStackView {
    let stack = UIStackView.verticalStack(arrangedSubviews: [profileImageView, usernameLabel])
    NSLayoutConstraint.activate([
      profileImageView.widthAnchor.constraint(equalToConstant: 80),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1.0)
    ])
    return stack
  }
  
  private func postsAndEditProfileStack() -> UIStackView {
    return UIStackView.verticalStack(arrangedSubviews: [postsStack(), editProfileButton])
  }
  
  private func postsStack() -> UIStackView {
    return UIStackView.horizontalFillEqualStack(arrangedSubviews: [postLabel, followingLabel, followerLabel])
  }
  
  private func displayModeStack() -> UIStackView {
    let stackView = UIStackView.horizontalFillEqualStack(arrangedSubviews: [gridButton, listButton, bookmarkButton])
    stackView.addTopBorder(withColor: .black, borderWidth: 0.5)
    stackView.addBottomBorder(withColor: .black, borderWidth: 0.5)
    return stackView
  }
  
  private func loadProfileImage() {
    guard let user = self.user, let imageUrl = URL(string: user.profileImageUrl) else { return }
    let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
      if let error = error {
        print("load image error: \(error)")
        return
      }
      guard let httpResponse = response as? HTTPURLResponse,
        (200...299).contains(httpResponse.statusCode) else {
          print("status error")
          return
      }
      if let data = data {
        DispatchQueue.main.async {
          self.profileImageView.image = UIImage(data: data)
        }
      }
    }
    task.resume()
  }
  
  private func displayModeButton(imageNamed: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: imageNamed)!, for: .normal)
    button.tintColor = UIColor(white: 0.0, alpha: 0.2)
    return button
  }
  
  private func postRelatedLabel(type: String) -> UILabel {
    let label = UILabel()
    label.numberOfLines = 2
    let numAttributedString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    let typeAttributedString = NSAttributedString(string: type, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray])
    
    numAttributedString.append(typeAttributedString)
    label.attributedText = numAttributedString
    label.textAlignment = .center
    return label
  }
  
}

