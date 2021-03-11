//
//  Post.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct Post {
  let imageUrl: String
  
  init(postDic: [String: Any]) {
    self.imageUrl = postDic["imageUrl"] as? String ?? ""
  }
}
