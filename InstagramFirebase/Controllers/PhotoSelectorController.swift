//
//  PhotoSelectorController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/10/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController {
  
  var images = [UIImage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupCollectionView()
    fetchPhotos()
  }
  
  private func setupNavigationBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextStep))
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: CellID.photoSelectorCell)
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
  
  private func fetchPhotos() {
    let fetchOption = PHFetchOptions()
    fetchOption.fetchLimit = 10
    fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    PHPhotoLibrary.shared().register(self)
    
    PHPhotoLibrary.requestAuthorization { (status) in
      switch status {
      case .authorized:
        let fetchedImageAssets = PHAsset.fetchAssets(with: .image, options: fetchOption)
        fetchedImageAssets.enumerateObjects { (phAsset, index, stop) in
          let imageRequestOptions = PHImageRequestOptions()
          imageRequestOptions.isSynchronous = true
          PHImageManager.default().requestImage(
            for: phAsset,
            targetSize: CGSize(width: 350, height: 350),
            contentMode: .aspectFit,
            options: imageRequestOptions) { (image, info) in
              guard let image = image else { return }
              self.images.append(image)
              if index == fetchedImageAssets.count - 1 {
                DispatchQueue.main.async {
                  print("fetch successfully")
                  self.collectionView.reloadData()
                }
              }
          }
      }
      default: ()
      }
    }
  }
  
  @objc func cancel() {
    presentingViewController?.dismiss(animated: true)
  }
  
  @objc func nextStep() {
    print("go to next step")
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.photoSelectorCell, for: indexPath) as! PhotoSelectorCell
    
    cell.imageView.image = images[indexPath.item]
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CellID.photoSelectorHeader, for: indexPath)
    cell.backgroundColor = .black
    return cell
  }
}

extension PhotoSelectorController: PHPhotoLibraryChangeObserver {
  
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    
  }
}
