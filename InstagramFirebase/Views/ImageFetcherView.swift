//
//  ImageFetcherView.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

class ImageFetchView: UIImageView {
  
  var currentImageURL: URL?
  
  func fetchImage(withUrl url: String?) {
    guard let imageUrl = url, imageUrl != "", let imageURL = URL(string: imageUrl)
      else { return }
    currentImageURL = imageURL
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
       if let data = data, imageURL == self.currentImageURL {
          DispatchQueue.main.async {
            self.image = UIImage(data: data)
          }
        }
      }
      task.resume()
    }
    
}
