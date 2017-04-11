//
//  SquareButton.swift
//  Explode
//
//  Created by Qing Jiao on 11/4/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import Foundation


class SquareButton: UIButton {
  let iconId: Int
  let row: Int
  let column: Int
  
  init(iconId: Int, image: UIImage?, row: Int, column: Int) {
    self.iconId = iconId
    self.row = row
    self.column = column
    
    super.init(frame: CGRect.zero)
    
    setImage(image, for: .normal)
  }
  
  func destroySelf() {
    self.lp_explode(callback: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
