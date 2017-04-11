//
//  GameView.swift
//  Explode
//
//  Created by Qing Jiao on 11/4/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import Foundation

let numberOfRow = 8
let numberOfColumns = 8


struct SquareImage {
  static func getImageWithId(id: Int) -> UIImage? {
    switch id {
    case 0:
      return UIImage(named: "Square_Blue")
    case 1:
      return UIImage(named: "Square_Green")
    case 2:
      return UIImage(named: "Square_Yellow")
    default:
      return UIImage(named: "Square_Red")
    }
  }
}


class GameView: UIView {
  var squareViews = [SquareButton]()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    for oneRow in 0...numberOfRow - 1 {
      for oneCol in 0...numberOfColumns - 1 {
        let iconId = Int(arc4random_uniform(4))
        
        let oneSquare = SquareButton(iconId: iconId, image: SquareImage.getImageWithId(id: iconId), row: oneRow, column: oneCol)
        squareViews.append(oneSquare)
        addSubview(oneSquare)
        oneSquare.addTarget(self, action: #selector(squareDidClicked(sender:)), for: .touchUpInside)
      }
    }
  }
  
  func squareDidClicked(sender: UIButton){
    guard let squareBtn = sender as? SquareButton else { return }
    SoundManager.sharedInstance.playGlassBreak()
    squareBtn.destroySelf()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let gameWidth = frame.size.width
    let gameHeight = frame.size.height
    
    let oxSpacing: CGFloat = 2
    let oySpacing: CGFloat = 2
    let cardWidth = (gameWidth - CGFloat(numberOfColumns + 1) * oxSpacing) / CGFloat(numberOfColumns)
    let cardHeight = (gameHeight - CGFloat(numberOfRow + 1) * oxSpacing) / CGFloat(numberOfRow)
    
    var oneFrame = CGRect.zero
    for one in squareViews {
      oneFrame.origin.x = CGFloat(one.row) * (cardWidth + oxSpacing) + oxSpacing
      oneFrame.origin.y = CGFloat(one.column) * (cardHeight + oySpacing) + oySpacing
      oneFrame.size.width = cardWidth
      oneFrame.size.height = cardHeight
      one.frame = oneFrame
    }

  }
}

