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
  
  enum DatabaseChild {
    case users(uid: String? = nil)
    case following(uid: String? = nil, followedUid: String? = nil)
    case posts(uid: String? = nil, needPostId: Bool = false)
    
    var path: DatabaseReference {
      switch self {
      case let .users(uid):
        return database.child("Users/\(uid ?? "")")
      case let .following(uid, followedUid):
        if uid == nil { return database.child("Followings") }
        else if followedUid == nil { return database.child("Followings/\(uid!)") }
        return database.child("Followings/\(uid!)/\(followedUid!)")
      case let .posts(uid, needPostId):
        if uid == nil { return database.child("Posts") }
        else if !needPostId { return database.child("Posts/\(uid!)") }
        return database.child("Posts/\(uid!)").childByAutoId()
      }
    }
  }
  
  enum StorageChild: String {
    case postImages = "post_images"
    case profileImages = "profile_images"
  }
  
  static var auth: Auth { Auth.auth() }
  static var currentUser: Firebase.User? { auth.currentUser }
  static var database: DatabaseReference { Database.database().reference() }
  static var storage: StorageReference { Storage.storage().reference() }
  
  static var hasCurrentUser: Bool {
    currentUser != nil
  }
  
  static func isCurrentUser(_ user: User?) -> Bool {
    currentUser?.uid == user?.uid && user?.uid != nil
  }
  
  static func isCurrentUserFollowing(
    _ user: User?,
    completion: @escaping (Bool?, Error?) -> Void)
  {
    guard let uid = currentUser?.uid, let followingUid = user?.uid else {
      completion(nil, NSError())
      return
    }
    DatabaseChild.following(
      uid: uid, followedUid: followingUid
    ).path.observeSingleEvent(of: .value, with: { (snapshot) in
      if let value = snapshot.value as? Int, value == 1 {
        completion(true, nil)
      } else {
        completion(false, nil)
      }
    }) { (error) in
      completion(nil, error)
    }
  }
  
  static func pathString(_ child: String, subChilds: [String]) -> String{
    var pathString = child
    let subPathString = subChilds.joined(separator: "/")
    if subPathString != "" {
      pathString += "/\(subPathString)"
    }
    return pathString
  }
  
  static func pathForSTOChild(_ child: StorageChild, subChilds: String...) -> StorageReference {
    return storage.child(pathString(child.rawValue, subChilds: subChilds))
  }
  
  static func configure() {
    FirebaseApp.configure()
  }
  
  static func signIn(withEmail email: String?, password: String?, completion: @escaping () -> Void) {
    guard let email = email, let password = password else { return }
    Auth.auth().signIn(withEmail: email, password: password) { (dataResult, error) in
      guard error == nil else {
        print("sign in error: \(String(describing: error))")
        return
      }
      guard let _ = dataResult else { return }
      completion()
    }
  }
  
  static func signOutCurrentUser(completion: () -> Void) {
    do {
      try auth.signOut()
      completion()
    } catch {
      print("sing out error", error)
    }
  }
  
  static func fetchCurrentUser(completion: @escaping (User) -> Void) {
    fetchUserWithUid(nil, completion: completion)
  }
  
  static func fetchPostsForCurrentUserAndFollowings(completion: @escaping (([Post]?) -> Void)) {
    guard let currentUserUid = currentUser?.uid else { return }
    fetchPostsForUid(currentUserUid) { (posts) in
      completion(posts)
    }
    DatabaseChild.following(uid: currentUserUid).path.observe(.value, with: { (snapshot) in
      guard let followingsUids = (snapshot.value as? [String: Any])?.keys else { return }
      for uid in followingsUids {
        fetchPostsForUid(uid) { (posts) in
          completion(posts)
        }
      }
    }) { (error) in
      print("fetch following error", error)
    }
  }
  
  static func fetchPostsForUid(_ uid: String, completion: @escaping (([Post]?) -> Void)) {
    fetchUserWithUid(uid) { (user) in
      fetchPostsForUser(user) { (posts) in
        completion(posts)
      }
    }
  }
  
  static func fetchUserWithUid(_ uid: String?, completion: @escaping (User) -> Void) {
    guard let uid = uid ?? currentUser?.uid else { return }
    DatabaseChild.users(uid: uid).path.observeSingleEvent(of: .value, with: { snapshot in
      print("snapshot: \(snapshot.value ?? "")")
      guard let user = User(uid: uid, dic: snapshot.value) else { return }
      completion(user)
    }) { (error) in
      print("error happen: \(error)")
    }
  }
  
  static func fetchAllUsersButCurrent(completion: @escaping ([User]) -> Void) {
    DatabaseChild.users(uid: nil).path.observeSingleEvent(of: .value, with: { (snapshot) in
      guard let userDics = snapshot.value as? [String: Any] else { return }
      let users = userDics.compactMap { (uid, userDic) -> User? in
        guard uid != currentUser?.uid else { return nil}
        return User(uid: uid, dic: userDic)
      }
      completion(users)
    }) { (error) in
      print("fetch all users error", error)
    }
  }
  
  static func fetchPostsForUser(_ user: User, completion: @escaping ([Post]?) -> Void) {
    let postRef = DatabaseChild.posts(uid: user.uid, needPostId: false).path
      postRef.observeSingleEvent(of: .value, with: { (snapshot) in
        print("user post snapshot value: \(String(describing: snapshot.value))")
        guard let allPosts = snapshot.value as? [String: Any] else { return }
        let posts = allPosts.values.compactMap { postMetaData -> Post? in
          guard let postMetaData = postMetaData as? [String: Any] else { return nil }
          let post = Post(user: user, postDic: postMetaData)
          print("post image url: \(post.imageUrl)")
          return post
        }
        completion(posts)
      }) { (error) in
        print("user profile fetch posts error: \(error)")
      }
    }

  static func fetchOrderedPosts(byChild child: String, user: User, completion: @escaping (Post) -> Void) {
    let postRef = DatabaseChild.posts(uid: user.uid, needPostId: false).path
    postRef.queryOrdered(byChild: child).observe(.childAdded, with: { (snapshot) in
      guard let postDic = snapshot.value as? [String: Any] else { return }
      let post = Post(user: user, postDic: postDic)
      completion(post)
    }) { (error) in
      print("user profile fetch posts error: \(error)")
    }
  }
  
  static func createUser(
    withEmail email: String,
    username: String,
    password: String,
    profileImageDataProvider: @escaping () -> Data?,
    completion: @escaping (Error?) -> Void)
  {
    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
      guard error == nil else {
        print("create user error: \(String(describing: error))")
        completion(error)
        return
      }
      guard let uid = authResult?.user.uid,
        let imageData = profileImageDataProvider() else {
          completion(NSError())
          return
      }
      
      storeImageData(imageData, forChild: .profileImages) { imageUrl, error in
        guard error == nil else {
          completion(error)
          return
        }
        storeMetaData(
          forChild: DatabaseChild.users(uid: uid),
          metaDataProvider: {
            return ["username": username, "profileImageUrl": imageUrl!]
          },
          completion: { error in
            completion(error)
          }
        )
      }
    }
  }
  
  static func follow(_ aboutToFollow: Bool, user: User, completion: @escaping (Error?) -> Void) {
    if aboutToFollow {
      follow(user: user, completion: completion)
    } else {
      unfollow(user: user, completion: completion)
    }
  }
  
  static func follow(user: User, completion: @escaping (Error?) -> Void) {
    guard let uid = currentUser?.uid else {
      completion(NSError())
      return
    }
    let followingUsersMetaData = [user.uid: 1]
    let path = DatabaseChild.following(uid: uid, followedUid: nil).path
    path.updateChildValues(followingUsersMetaData) { (error, _) in
      guard error == nil else {
        completion(error)
        return
      }
      completion(nil)
    }
  }
  
  static func unfollow(user: User, completion: @escaping (Error?) -> Void) {
    guard let uid = currentUser?.uid else {
      completion(NSError())
      return
    }
    DatabaseChild.following(uid: uid, followedUid: user.uid).path.removeValue { (error, _) in
      completion(error)
    }
  }
  
  static func post(
    caption: String,
    imageSize: CGSize,
    postImageDataProvider: @escaping () -> Data?,
    completion: @escaping (Error?) -> Void)
  {
    guard let uid = currentUser?.uid,
      let imageData = postImageDataProvider() else { completion(NSError()); return }
    
    storeImageData(imageData, forChild: .postImages) { (imageUrl, error) in
      guard error == nil else {
        completion(error)
        return
      }
      storeMetaData(
        forChild: .posts(uid: uid, needPostId: true),
        metaDataProvider: {
          return [
            "imageUrl": imageUrl!,
            "caption": caption,
            "creationDate": Date().timeIntervalSince1970,
            "imageWidth": imageSize.width,
            "imageHeight": imageSize.height
          ]
        },
        completion: { error in
          completion(error)
        }
      )
    }
  }
  
  static func storeImageData(
    _ imageData: Data,
    forChild child: StorageChild,
    completion: @escaping (String?, Error?) -> Void)
  {
    let fileName = NSUUID().uuidString
    let ref = pathForSTOChild(child, subChilds: fileName)
    ref.putData(imageData, metadata: nil) { (_, error) in
      if let error = error {
        print("put data error: \(error)")
        completion(nil, error)
      }
      ref.downloadURL(completion: { (url, error) in
        if let error = error {
          print("download url error: \(error)")
          completion(nil, error)
          return
        }
        
        guard let imageUrl = url?.absoluteString else {
          completion(nil, NSError())
          return
        }
        completion(imageUrl, nil)
      })
    }
  }
  
  static func storeMetaData(
    forChild child: DatabaseChild,
    metaDataProvider: () -> [String: Any],
    completion: @escaping (Error?) -> Void)
  {
    let metaData = metaDataProvider()
    child.path.updateChildValues(metaData) { (error, ref) in
      guard error == nil else {
        print("update chile values error: \(String(describing: error))")
        completion(error)
        return
      }
      completion(nil)
    }
  }
  
}
