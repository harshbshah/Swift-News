//
//  NewsFeedModel.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-16.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import Foundation
import UIKit
struct NewsFeedModel{
  var articleTitle : String
  var articleBody : String
  var articleThumbUrl : String?
  var articleImageURL : String?
  var articleThumbnailHeight : CGFloat
  var articleThumbnailbWidth : CGFloat
  //MARK: Initailise objects from JSON
  init(jsonData : [String:Any]) {
    let jsonObj = jsonData["data"] as? [String:Any] ?? [:]
    articleTitle = jsonObj["title"] as? String ?? ""
    articleBody = jsonObj["selftext"] as? String ?? ""
    let thumbUrlString : String = jsonObj["thumbnail"] as? String ?? ""
    articleThumbUrl = thumbUrlString.contains("https") ? thumbUrlString : ""
    articleImageURL = jsonObj["url"] as? String ?? ""
    articleThumbnailHeight = jsonObj["thumbnail_height"] as? CGFloat ?? 0
    articleThumbnailbWidth = jsonObj["thumbnail_width"] as? CGFloat ?? 0
  }
}
