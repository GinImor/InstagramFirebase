//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
  
  var posts: [Post] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCollectionView()
    fetchUserPosts()
  }
  
  private func setupNavigationBar() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    let nib = UINib(nibName: "HomeCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: CellID.homeCell)
    setupLayout()
  }
  
  private func setupLayout() {
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
  }
  
  private func fetchUserPosts() {
    InstagramFirebaseService.fetchCurrentUser { (user) in
      InstagramFirebaseService.fetchPostsForUser(user) { (posts) in
        self.posts = posts
        self.collectionView.reloadData()
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.homeCell, for: indexPath) as! HomeCell
    cell.post = posts[indexPath.item]
    cell.width = collectionView.bounds.width
    return cell
  }
  
}
