//
//  User.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/9/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct User {
  let username: String
  let profileImageUrl: String
  
  init(dic: [String: Any]) {
    self.username = dic["username"] as? String ?? ""
    self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""
  }
}
