//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class UserProfileController: UICollectionViewController {
  
  var uid: String?
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
    InstagramFirebaseService.signOutCurrentUser {
      let loginController = LoginController()
      let nav = UINavigationController(rootViewController: loginController)
      self.present(nav, animated: true)
    }
  }
  
  private func fetchContents() {
    InstagramFirebaseService.fetchUserWithUid(uid) { (user) in
      DispatchQueue.main.async {
        self.user = user
        self.navigationItem.title = self.user?.username
        self.collectionView.reloadData()
        self.paginatePosts()
      }
    }
  }
  
  var isFinishedLoading = false
  
  private func paginatePosts() {
    InstagramFirebaseService.paginatePosts(
      user: user!,
      endingAt: posts.count > 0 ? posts.last?.creationDate.timeIntervalSince1970 : nil,
      nextPostHandler: { (post) in
        self.posts.append(post)
    }) { isFinishedLoading in
      self.isFinishedLoading = isFinishedLoading
      self.collectionView.reloadData()
    }
  }
  
  private func fetchUserPosts() {
    InstagramFirebaseService.fetchOrderedPosts(byChild: "creationDate", user: user!) { (post) in
      DispatchQueue.main.async {
        self.posts.append(post)
        self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
      }
    }
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.register(UserProfileCell.self, forCellWithReuseIdentifier: CellID.userProfileCell)
    let nib = UINib(nibName: "HomeCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: CellID.homeCell)
    collectionView.register(UserProfileHeadder.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:CellID.userProfileHeader)
    setupLayout()
  }
  
  var isGridLayout = true
  
  private func setupLayout() {
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    
    let collectionWidth = collectionView.bounds.width
    if isGridLayout {
      flowLayout.minimumInteritemSpacing = 1.0
      flowLayout.minimumLineSpacing = 1.0
      
      let itemWidth = floor((collectionWidth - 2) / 3)
      flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
      flowLayout.headerReferenceSize = CGSize(width: 0, height: 186)
      flowLayout.estimatedItemSize = .zero
    } else {
      flowLayout.minimumInteritemSpacing = 10.0
      flowLayout.minimumLineSpacing = 10.0
      flowLayout.estimatedItemSize = CGSize(width: collectionWidth, height: collectionWidth + 200)
    }
    collectionView.reloadData()
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    if indexPath.item == posts.count - 1 && !isFinishedLoading {
      paginatePosts()
    }
    if isGridLayout {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.userProfileCell, for: indexPath) as! UserProfileCell
      cell.post = posts[indexPath.item]
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.homeCell, for: indexPath) as! HomeCell
      cell.width = collectionView.bounds.width
      cell.post = posts[indexPath.item]
      return cell
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellID.userProfileHeader, for: indexPath) as! UserProfileHeadder
    header.user = user
    header.isCurrentUser = uid == nil ? true : false
    header.delegate = self
    return header
  }
  
}

extension UserProfileController: UserProfileHeaderProtocol {
  
  func didRequiredNewLayout(_ isGridLayout: Bool) {
    self.isGridLayout = isGridLayout
    setupLayout()
  }
  
  
}
