//
//  Extensions.swift
//  Explode
//
//  Created by Qing Jiao on 29/5/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import Foundation


extension Array {
  mutating func shuffle() {
    if count < 2 { return }
    for i in 0..<(count - 1) {
      let j = Int(arc4random_uniform(UInt32(count - i))) + i
      let tmp = self[i]
      self[i] = self[j]
      self[j] = tmp
    }
  }
}


extension UIView {
  func removeAllSubViews() {
    let theSubViews = self.subviews
    for one in theSubViews {
      one.removeFromSuperview()
    }
  }
}


public extension UIImage {
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}

extension CGFloat {
  static func random() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
  }
}

extension UIColor {
  static func random() -> UIColor {
    return UIColor(red:   .random(),
                   green: .random(),
                   blue:  .random(),
                   alpha: 1.0)
  }
}
