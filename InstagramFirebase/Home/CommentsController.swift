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
    collectionView.backgroundColor = .red
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
  }
  
  @objc func sendComment() {
    InstagramFirebaseService.sendCommentForPostWithId(post?.id, content: commentTextField.text) { (error) in
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
  
}
