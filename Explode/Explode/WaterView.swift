//
//  WaterView.swift
//  Explode
//
//  Created by Qing Jiao on 17/4/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import UIKit

class WaterView: BAFluidView {
  static let shared = WaterView(frame: CGRect(x: 0, y: 500, width: 100, height: 100))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
