//
//  CGSize.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-17.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import Foundation
import UIKit
extension CGSize{
  //Calculate expected image height from the image size as per iphone screen size.
  func getimageAspectRatioHeightAccordingToWidth(imageSize: CGSize)->CGFloat {
    guard imageSize.width != 0 && imageSize.height != 0 else {
      return 0
    }
    var estimatedViewWidth : CGFloat{
      switch UIDevice.deviceType {
      case .ipad:
        return min((imageSize.width * 3), self.width)
      case .iphonex, .iphone8_8p, .iphone7ps , .iPhone6p_6ps, .iphone11promax:
        return min((imageSize.width * 2), self.width)
      case .iPhone5_5s,.iPhone4_4s:
        return min(imageSize.width, self.width)
      default:
        return imageSize.width
      }
    }
    let widthOffset = imageSize.width - estimatedViewWidth
    let widthOffsetPercentage = (widthOffset*100)/imageSize.width
    let heightOffset = (widthOffsetPercentage * imageSize.height)/100
    let effectiveHeight = imageSize.height - heightOffset
    return (abs(effectiveHeight))
  }
}
