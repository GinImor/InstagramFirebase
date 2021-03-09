//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewAppearance()
    fetchUserProfile()
  }
  
  private func fetchUserProfile() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("Users/\(uid)").observeSingleEvent(of: .value, with: {snapshot in
      print("snapshot: \(snapshot.value ?? "")")
      guard let snapshotDic = snapshot.value as? [String: Any],
        let username = snapshotDic["username"] as? String,
        let profileImageUrl = snapshotDic["profileImageUrl"] as? String else { return }
      
      self.navigationItem.title = username
      
    }) { (error) in
      print("error happen: \(error)")
    }
  }
  
  private func setupViewAppearance() {
    collectionView.backgroundColor = .systemBackground
  }
}
