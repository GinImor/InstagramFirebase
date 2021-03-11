//
//  PostPhotoController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import Photos
import Firebase

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
    setupNavigationBar()
    setupViews()
  }
  
  private func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(post))
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
  
  @objc func post() {
    guard textView.text ?? "" != "",
      let postImage = imageView.image,
      let postImageData = postImage.jpegData(compressionQuality: 0.5) else { return }
    navigationItem.rightBarButtonItem?.isEnabled = false
    let uuid = NSUUID().uuidString
    let storageRef = Storage.storage().reference().child("post_images/\(uuid)")
    storageRef.putData(postImageData, metadata: nil) {[weak self] (metaData, error) in
      guard error == nil else {
        print("put data error: \(String(describing: error))")
        self?.navigationItem.rightBarButtonItem?.isEnabled = true
        return
      }
      
      storageRef.downloadURL { (url, error) in
        guard error == nil else {
          self?.navigationItem.rightBarButtonItem?.isEnabled = true
          print("fetch download url error: \(String(describing: error))")
          return
        }
        guard let imageUrl = url?.absoluteString else {
          self?.navigationItem.rightBarButtonItem?.isEnabled = true
          print("image url == nil")
          return
        }
        self?.savePostMetaDataWithImageURL(imageUrl)
      }
    }
  }
  
  private func savePostMetaDataWithImageURL(_ imageUrl: String) {
    guard let uid = Auth.auth().currentUser?.uid,
      let caption = textView.text,
      let image = imageView.image else { return }
    let postMetaData: [String: Any] = [
      "imageUrl": imageUrl,
      "caption": caption,
      "creationData": Date().timeIntervalSince1970,
      "imageWidth": image.size.width,
      "imageHeight": image.size.height
      ]
    let postRef = Database.database().reference().child("Posts/\(uid)").childByAutoId()
    postRef.updateChildValues(postMetaData) {[weak self] (error, ref) in
      guard error == nil else {
        self?.navigationItem.rightBarButtonItem?.isEnabled = true
        print("updata post database")
        return
      }
      self?.presentingViewController?.dismiss(animated: true)
    }
  }
  
}
