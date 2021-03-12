//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/12/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController {
  
  var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.disableTAMIC()
    searchBar.placeholder = "Search for users"
    searchBar.tintColor = UIColor.gray
    UITextField.appearance(
      whenContainedInInstancesOf: [UISearchBar.self]
    ).backgroundColor = UIColor(rgb: (230, 230, 230))
    return searchBar
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchBar()
    setupCollectionView()
  }
 
  private func setupSearchBar() {
    guard let nvBar = navigationController?.navigationBar else { return }
    searchBar.pinToSuperviewEdges(edgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), pinnedView: nvBar)
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.alwaysBounceVertical = true
    collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: CellID.userSearchCell)
    setupLayout()
  }
  
  private func setupLayout() {
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: 66)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.userSearchCell, for: indexPath) as! UserSearchCell
    return cell
  }
}
