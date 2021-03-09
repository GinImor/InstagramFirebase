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
  
  private var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    fetchUserProfile()
  }
  
  private func fetchUserProfile() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("Users/\(uid)").observeSingleEvent(of: .value, with: {snapshot in
      print("snapshot: \(snapshot.value ?? "")")
      guard let snapshotDic = snapshot.value as? [String: Any] else { return }
      
      self.user = User(dic: snapshotDic)
      self.navigationItem.title = self.user?.username
      self.collectionView.reloadData()
    }) { (error) in
      print("error happen: \(error)")
    }
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.register(UserProfileHeadder.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:CellID.userProfileHeader)
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellID.userProfileHeader, for: indexPath) as! UserProfileHeadder
    
    header.user = user
    return header
  }
  
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: 200, height: 200)
  }
}
