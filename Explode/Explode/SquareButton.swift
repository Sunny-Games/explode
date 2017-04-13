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
  let explodeImg: UIImage?
  let row: Int
  let column: Int
  
  init(iconId: Int, image: UIImage?, explodeImage: UIImage?, row: Int, column: Int) {
    self.iconId = iconId
    self.row = row
    self.column = column
    self.explodeImg = explodeImage
    
    super.init(frame: CGRect.zero)
    
    setImage(image, for: .normal)
  }
  
  func destroySelf() {
    self.lp_explode(with: explodeImg, callback: nil)
    SoundManager.sharedInstance.playBallonSplashBreak()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
