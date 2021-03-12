//
//  InstagramFirebaseService.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/12/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import Foundation
import Firebase

enum InstagramFirebaseService {
  
  static func fetchCurrentUser(completion: @escaping (User) -> Void) {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("Users/\(uid)").observeSingleEvent(of: .value, with: {snapshot in
      print("snapshot: \(snapshot.value ?? "")")
      guard let snapshotDic = snapshot.value as? [String: Any] else { return }
      DispatchQueue.main.async {
        completion(User(uid: uid, dic: snapshotDic))
      }
    }) { (error) in
      print("error happen: \(error)")
    }
  }
  
  static func fetchPostsForUser(_ user: User, completion: @escaping ([Post]) -> Void) {
    let postRef = Database.database().reference().child("Posts/\(user.uid)")
      postRef.observeSingleEvent(of: .value, with: { (snapshot) in
        print("user post snapshot value: \(String(describing: snapshot.value))")
        guard let allPosts = snapshot.value as? [String: Any] else { return }
        let posts = allPosts.values.compactMap { postMetaData -> Post? in
          guard let postMetaData = postMetaData as? [String: Any] else { return nil }
          let post = Post(user: user, postDic: postMetaData)
          print("post image url: \(post.imageUrl)")
          return post
        }
        DispatchQueue.main.async {
          completion(posts)
        }
      }) { (error) in
        print("user profile fetch posts error: \(error)")
      }
    }

  static func fetchOrderedPosts(byChild child: String, user: User, completion: @escaping (Post) -> Void) {
    let postRef = Database.database().reference().child("Posts/\(user.uid)")
    postRef.queryOrdered(byChild: child).observe(.childAdded, with: { (snapshot) in
      guard let postDic = snapshot.value as? [String: Any] else { return }
      let post = Post(user: user, postDic: postDic)
      DispatchQueue.main.async {
        completion(post)
      }
    }) { (error) in
      print("user profile fetch posts error: \(error)")
    }
  }
  
}
