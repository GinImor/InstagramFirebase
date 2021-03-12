//
//  User.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct User {
  let uid: String
  let username: String
  let profileImageUrl: String
  
  init(uid: String, dic: [String: Any]) {
    self.uid = uid
    self.username = dic["username"] as? String ?? ""
    self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
  }
}
