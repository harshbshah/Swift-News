//
//  UIDevice.swift
//  Swift News
//
//  Created by Harsh Shah on 2020-06-17.
//  Copyright © 2020 Pineapple Inc. All rights reserved.
//

import Foundation
import UIKit
extension UIDevice {
  enum DeviceTypes {
    case iPhone4_4s
    case iPhone5_5s
    case iPhone6_6s
    case iPhone6p_6ps
    case iphone8_8p
    case iphone7ps
    case iphonex
    case iphone11promax
    case ipad
  }
  static var deviceType : DeviceTypes {
    switch UIScreen.main.bounds.size.height {
    case 480.0:
      return .iPhone4_4s
    case 568.0:
      return .iPhone5_5s
    case 667.0:
      return .iPhone6_6s
    case 736.0:
      return .iPhone6p_6ps
    case 736:
      return .iphone7ps
    case 812.0:
      return .iphonex
    case 896.0:
      return .iphone11promax
    default:
      return .ipad
    }
  }
}
extension CGFloat{
  var fontSize : CGFloat {
    var deltaSize : CGFloat = 0;
    switch (UIDevice.deviceType) {
    case .iPhone4_4s,
       .iPhone5_5s :
      deltaSize = -1
    case .iPhone6_6s :
      deltaSize = 1
    case .iPhone6p_6ps,.iphone7ps :
      deltaSize = 1
    case .iphone8_8p:
      deltaSize = 1
    case .iphonex,.iphone11promax:
      deltaSize = 1.5
    case .ipad:
      deltaSize = 2
    }
    let selfValue = self;
    return CGFloat(selfValue) + deltaSize;
  }
}

