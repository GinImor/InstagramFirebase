//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/19/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation

struct Comment {
  var responderUser: User?
  let content: String
  let responder: String
  
  init?(dic: Any?) {
    guard let dic = dic as? [String: Any] else { return nil}
    self.content = dic["content"] as? String ?? ""
    self.responder = dic["responder"] as? String ?? ""
  }
  
}
