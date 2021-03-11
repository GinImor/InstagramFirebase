//
//  UserProfileCell.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class UserProfileCell: PhotoSelectorCell {
  
  var post: Post! {
    didSet {
      fetchImage()
    }
  }
  
  private func fetchImage() {
     guard let post = self.post, let imageURL = URL(string: post.imageUrl) else { return }
     let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
       if let error = error {
         print("load image error: \(error)")
         return
       }
       guard let httpResponse = response as? HTTPURLResponse,
         (200...299).contains(httpResponse.statusCode) else {
           print("status error")
           return
       }
       if let data = data {
         DispatchQueue.main.async {
           self.imageView.image = UIImage(data: data)
         }
       }
     }
     task.resume()
   }
   
}
