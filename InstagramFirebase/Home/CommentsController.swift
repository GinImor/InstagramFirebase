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
  var comments: [Comment] = []
  
  private var commentTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Enter Comment"
    return textField
  }()
  
  lazy var containerView: UIView = {
    let containerView = UIView()
    containerView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 50)
    containerView.backgroundColor = .white
    
    let sendButton = UIButton(type: .system)
    sendButton.setTitle("Send", for: .normal)
    sendButton.setTitleColor(.black, for: .normal)
    sendButton.addTarget(self, action: #selector(sendComment), for: .touchUpInside)
    sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 260), for: .horizontal)
    sendButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 760), for: .horizontal)
    
    let stackView = UIStackView(arrangedSubviews: [commentTextField, sendButton])
    stackView.spacing = UIStackView.spacingUseDefault
    stackView.pinToSuperviewEdges(
      edgeInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8),
      pinnedView: containerView)
    
    return containerView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    fetchComments()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = .systemBackground
    collectionView.alwaysBounceVertical = true
    collectionView.keyboardDismissMode = .onDrag
    collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CellID.commentCell)
    setupLayout()
  }
  
  private func setupLayout() {
    guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
    flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: 50)
  }
  
  private func fetchComments() {
    InstagramFirebaseService.fetchCommentsOfPost(post, nextCommentHandler: { (comment) in
      print("comment content", comment.content)
      self.comments.append(comment)
      self.collectionView.reloadData()
    }) { (error) in
      if error != nil {
        print("fetch comments error:", error!)
        return
      }
     print("successfully fetch comments")
    }
  }
  
  @objc func sendComment() {
    InstagramFirebaseService.sendCommentForPost(post, content: commentTextField.text) { (error) in
      if error != nil {
        print("can't upload comment due to error \(String(describing: error))")
        return
      }
      print("successfully upload comment")
    }
  }
  
  override var inputAccessoryView: UIView? {
    get { containerView }
  }
  
  override var canBecomeFirstResponder: Bool { true }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20//comments.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.commentCell, for: indexPath) as! CommentCell
//    cell.comment = comments[indexPath.item]
    return cell
  }
}
