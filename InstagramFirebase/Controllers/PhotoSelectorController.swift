//
//  PhotoSelectorController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/10/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class PhotoSelectorController: UICollectionViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCollectionView()
  }
  
  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextStep))
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CellID.photoSelectorCell)
    collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellID.photoSelectorHeader)
    setupLayout()
  }
  
  private func setupLayout() {
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    let collectionWidth = collectionView.bounds.width
    let itemWidth = floor((collectionWidth - 3) / 4)
    flowLayout.sectionInset = UIEdgeInsets(top: 1.0, left: 0.0, bottom: 0.0, right: 0.0)
    flowLayout.headerReferenceSize = CGSize(width: collectionWidth, height: collectionWidth)
    flowLayout.minimumLineSpacing = 1.0
    flowLayout.minimumInteritemSpacing = 1.0
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
  }
  
  @objc func cancel() {
    presentingViewController?.dismiss(animated: true)
  }
  
  @objc func nextStep() {
    print("go to next step")
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.photoSelectorCell, for: indexPath)
    
    cell.backgroundColor = .systemGray4
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellID.photoSelectorHeader, for: indexPath)
    cell.backgroundColor = .black
    return cell
  }
}
