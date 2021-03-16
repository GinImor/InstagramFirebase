//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController {
  
  var posts: [Post] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNotification()
    setupNavigationBar()
    setupCollectionView()
    fetchUserPosts()
  }
  
  private func setupNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didPost, object: nil)
  }
  
  private func setupNavigationBar() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    let nib = UINib(nibName: "HomeCell", bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: CellID.homeCell)
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    collectionView.refreshControl = refreshControl
    setupLayout()
  }
  
  private func setupLayout() {
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    let collectionWidth = collectionView.frame.width
    flowLayout.estimatedItemSize = CGSize(width: collectionWidth, height: collectionWidth + 200)
  }
  
  private func fetchUserPosts() {
    InstagramFirebaseService.fetchPostsForCurrentUserAndFollowings { (pendingPosts) in
      self.collectionView.refreshControl?.endRefreshing()
      guard let pendingPosts = pendingPosts else { return }
      self.posts.append(contentsOf: pendingPosts)
      self.posts.sort { (post1, post2) in
        post1.creationDate > post2.creationDate
      }
      self.collectionView.reloadData()
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.homeCell, for: indexPath) as! HomeCell
    if !posts.isEmpty {
      cell.post = posts[indexPath.item]
    }
    cell.width = collectionView.bounds.width
    return cell
  }
  
  @objc func refresh() {
    posts.removeAll()
    fetchUserPosts()
  }
  
}
