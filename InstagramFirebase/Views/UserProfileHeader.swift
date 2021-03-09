//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class UserProfileHeadder: UICollectionViewCell {
  
  private var profileImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.disableTAMIC()
    imageView.layer.cornerRadius = 40
    imageView.layer.masksToBounds = true
    imageView.layer.borderColor = UIColor.black.cgColor
    imageView.layer.borderWidth = 2.0
    return imageView
  }()
  
  var user: User? {
    didSet {
      loadProfileImage()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = .darkBlue
    addSubview(profileImageView)
    NSLayoutConstraint.activate([
      profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
      profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
      profileImageView.widthAnchor.constraint(equalToConstant: 80),
      profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, constant: 0.0)
    ])
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
  
}
