//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/12/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController {
  
  var users: [User] = []
  var searchedUsers: [User] = [] {
    didSet { collectionView.reloadData() }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchBar()
    setupCollectionView()
    fetchAllOtherUsers()
  }
  
  private func setupSearchBar() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.delegate = self
    navigationItem.searchController = searchController
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.alwaysBounceVertical = true
    collectionView.keyboardDismissMode = .onDrag
    collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: CellID.userSearchCell)
    setupLayout()
  }
  
  private func fetchAllOtherUsers() {
    InstagramFirebaseService.fetchAllUsersButCurrent { (users) in
      self.users = users.sorted(by: { (user1, user2) -> Bool in
        user1.username.localizedCompare(user2.username) == ComparisonResult.orderedAscending
      })
      self.searchedUsers = self.users
    }
  }
  
  private func setupLayout() {
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: 66)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchedUsers.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.userSearchCell, for: indexPath) as! UserSearchCell
    cell.user = searchedUsers[indexPath.item]
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
    userProfileController.uid = searchedUsers[indexPath.item].uid
    navigationController?.pushViewController(userProfileController, animated: true)
  }
  
}

extension UserSearchController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard let searchText = searchBar.text, searchText != "" else {
      searchedUsers = users
      return
    }
    searchedUsers = users.filter {
      $0.username.localizedCaseInsensitiveContains(searchText)
    }
    collectionView.reloadData()
  }
}
