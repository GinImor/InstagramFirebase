//
//  InstagramFileManager.swift
//  InstagramFirebase
//
//  Created by Gin Imor on 3/11/21.
//  Copyright © 2021 Brevity. All rights reserved.
//

import UIKit

struct InstagramFileManager {
  
  static var `default` = InstagramFileManager()
  
  private var helper: FileManager { FileManager.default }
  private var cachesDir: URL? {
    try? helper.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
  }
  
  func cacheImage(_ image: UIImage?, forURL url: URL) {
    guard let cachesDir = self.cachesDir,
      let imageData = image?.jpegData(compressionQuality: 1.0)  else { return }
    do {
      try imageData.write(to: cachesDir.appendingPathComponent(url.lastPathComponent))
    } catch {
      print("write data error", error)
    }
  }
  
  func cachedImage(forURL url: URL) -> UIImage? {
    guard let cachesDir = self.cachesDir else { return nil}
    do {
      let imageData = try Data(contentsOf: cachesDir.appendingPathComponent(url.lastPathComponent))
      return UIImage(data: imageData)
    } catch {
      print("load data error", error)
    }
    return nil
  }
}
