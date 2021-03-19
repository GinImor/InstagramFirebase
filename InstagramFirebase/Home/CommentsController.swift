//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/19/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
  
  var post: Post?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .red
  }
}
