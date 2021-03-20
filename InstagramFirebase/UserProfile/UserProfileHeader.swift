//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

protocol UserProfileHeaderProtocol: class {
  func didRequiredNewLayout(_ isGridLayout: Bool)
}

class UserProfileHeadder: UICollectionViewCell {
  
  /// need to deal with the first time input user is nil
  /// for current user, enable the editProfileOrFollowButton when finished fetching profile image
  /// otherwise, enable the button after got the follow status
  var isCurrentUser = false {
    didSet {
      if !isCurrentUser { editProfileOrFollowButton.showLoading() }
    }
  }

  var user: User! {
    didSet {
      guard user != nil else { return }
      fetchProfileImage()
      setupEditProfileOrFollowButton()
    }
  }
  
  var isFollowing: Bool = false {
    didSet {
      if isFollowing {
        editProfileOrFollowButton.setTitle("unfollow", for: .normal)
        editProfileOrFollowButton.backgroundColor = .white
        editProfileOrFollowButton.setTitleColor(.black, for: .normal)
      } else {
        editProfileOrFollowButton.setTitle("follow", for: .normal)
        editProfileOrFollowButton.backgroundColor = .primaryBlue
        editProfileOrFollowButton.setTitleColor(.white, for: .normal)
        editProfileOrFollowButton.layer.borderColor = UIColor.whiteWithAlpha(0.2).cgColor
        editProfileOrFollowButton.layer.borderWidth = 1.0
      }
    }
  }
  
  private var profileImageView: ImageFetchView = {
    let imageView = ImageFetchView()
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
  private lazy var editProfileOrFollowButton: LoadingButton = {
    let button = LoadingButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.isEnabled = false
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 3
    button.addTarget(self, action: #selector(handleEditOrFollow), for: .touchUpInside)
    return button
  }()
  
  weak var delegate: UserProfileHeaderProtocol?
  
  var isGridLayout = true {
    didSet {
      guard oldValue != isGridLayout else { return }
        // now require grid layout
        if isGridLayout {
          gridButton.tintColor = .primaryBlue
          listButton.tintColor = .whiteWithAlpha(0.2)
        } else {
          listButton.tintColor = .primaryBlue
          gridButton.tintColor = .whiteWithAlpha(0.2)
      }
      delegate?.didRequiredNewLayout(isGridLayout)
    }
  }
  private lazy var gridButton: UIButton = {
    let button = displayModeButton(imageNamed: "rectangle.grid.2x2")
    button.tintColor = .primaryBlue
    button.addTarget(self, action: #selector(didTappedGridButton), for: .touchUpInside)
    return button
  }()
  private lazy var listButton: UIButton = {
    let button = displayModeButton(imageNamed: "list.dash")
    button.addTarget(self, action: #selector(didTappedListButton), for: .touchUpInside)
    return button
  }()
  private lazy var bookmarkButton = displayModeButton(imageNamed: "bookmark")
  
  @objc func didTappedGridButton() {
    isGridLayout = true
  }
  
  @objc func didTappedListButton() {
    isGridLayout = false
  }
  
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
    UIStackView.verticalStack(
      arrangedSubviews: [profileContentStack(), displayModeStack()],
      pinToSuperview: self,
      edgeInsets: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    )
  }
  
  private func profileContentStack() -> UIStackView{
    let stack = UIStackView(arrangedSubviews: [profileImageUsernameStack(), postsAndEditProfileStack()])
    stack.alignment = .top
    stack.spacing = 16
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8 )
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
    let stack = UIStackView.verticalStack(arrangedSubviews: [postsStack(), editProfileOrFollowButton])
    editProfileOrFollowButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    return stack
  }
  
  private func postsStack() -> UIStackView {
    return UIStackView.horizontalFillEqualStack(arrangedSubviews: [postLabel, followingLabel, followerLabel])
  }
  
  private func displayModeStack() -> UIStackView {
    let stackView = UIStackView.horizontalFillEqualStack(arrangedSubviews: [gridButton, listButton, bookmarkButton])
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    stackView.addTopBorder(withColor: .black, borderWidth: 0.5)
    stackView.addBottomBorder(withColor: .black, borderWidth: 0.5)
    return stackView
  }
  
  private func fetchProfileImage() {
    profileImageView.fetchImage(withUrl: self.user?.profileImageUrl) {
      if self.isCurrentUser {
        DispatchQueue.main.async {
          self.editProfileOrFollowButton.isEnabled = true
        }
      }
    }
  }
  
  private func setupEditProfileOrFollowButton() {
    if isCurrentUser {
      
    } else {
      InstagramFirebaseService.isCurrentUserFollowing(user) { isFollowing, error in
        DispatchQueue.main.async {
          self.editProfileOrFollowButton.hideLoading()
          guard error == nil, isFollowing != nil else { return }
          self.isFollowing = isFollowing!
        }
      }
    }
  }
  
  @objc func handleEditOrFollow() {
    if isCurrentUser {
      
    } else {
      editProfileOrFollowButton.showLoading()
      InstagramFirebaseService.follow(!isFollowing, user: user) { (error) in
        self.editProfileOrFollowButton.hideLoading()
        guard error == nil else { return }
        UIView.transition(with: self.editProfileOrFollowButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
          self.isFollowing = !self.isFollowing
        })
      }
    }
  }
  
  private func displayModeButton(imageNamed: String) -> UIButton {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: imageNamed)!, for: .normal)
    button.tintColor = .whiteWithAlpha(0.2)
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

