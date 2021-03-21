//
//  Post.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct Post {
  var id: String?
  let user: User?
  let imageUrl: String
  let caption: String
  let creationDate: Date
  var isLiking: Bool = false
  
  init?(user: User?, postDic: Any?) {
    guard let postDic = postDic as? [String: Any] else { return nil }
    self.user = user
    self.imageUrl = postDic["imageUrl"] as? String ?? ""
    self.caption = postDic["caption"] as? String ?? ""
    let timeInterval = postDic["creationDate"] as? TimeInterval ?? 0
    self.creationDate = Date(timeIntervalSince1970: timeInterval)
  }
}
