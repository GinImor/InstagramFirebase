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
  
  var posts: [Post] = []
  private var user: User?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCollectionView()
    fetchContents()
  }
  
  private func setupNavigationBar() {
    let itemImage = UIImage(systemName: "gear")!
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: itemImage, style: .plain, target: self, action: #selector(showSetting))
    
    navigationController?.navigationBar.tintColor = .black
  }
  
  @objc func showSetting() {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
      self.logout()
    }))
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(actionSheet, animated: true)
  }
  
  private func logout() {
    do {
      try Auth.auth().signOut()
      let loginController = LoginController()
      let nav = UINavigationController(rootViewController: loginController)
      present(nav, animated: true)
    } catch {
      print("sign out error: \(error)")
    }
  }
  
  private func fetchContents() {
    InstagramFirebaseService.fetchCurrentUser { (user) in
      self.user = user
      self.navigationItem.title = self.user?.username
      self.collectionView.reloadData()
      self.fetchUserPosts(forUser: user)
    }
  }
  
  private func fetchUserPosts(forUser user: User) {
    InstagramFirebaseService.fetchOrderedPosts(byChild: "creationDate", user: user) { (post) in
      self.posts.append(post)
      self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
    }
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: CellID.userProfileCell)
    collectionView.register(UserProfileHeadder.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:CellID.userProfileHeader)
    setupLayout()
  }
  
  private func setupLayout() {
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    flowLayout.minimumInteritemSpacing = 1.0
    flowLayout.minimumLineSpacing = 1.0
    
    let itemWidth = floor((collectionView.bounds.width - 2) / 3)
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.userProfileCell, for: indexPath) as! UserProfileCell
    cell.post = postForItem(indexPath.item)
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellID.userProfileHeader, for: indexPath) as! UserProfileHeadder
    header.user = user
    return header
  }
  
  private func postForItem(_ item: Int) -> Post {
    let lastIndex = posts.count - 1
    return posts[lastIndex - item]
  }
  
}

extension UserProfileController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: 0, height: 200)
  }
}
