//
//  GameView.swift
//  Explode
//
//  Created by Qing Jiao on 11/4/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import Foundation

let numberOfRow = 9
let numberOfColumns = 9


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
    
    SoundManager.sharedInstance.resetGlassBreak()
    destoryBtn(row: squareBtn.row, column: squareBtn.column, iconId: squareBtn.iconId)
    
  }
  
  func destoryBtn(row: Int, column: Int, iconId: Int) {
    guard row >= 0 && column >= 0 else {  return }

    guard let btn = findBtn(with: row, column: column, iconId: iconId) else { return }
    btn.destroySelf()
    removeBtn(with: row, column: column)
    
//    let deadlineTime = DispatchTime.now() + .milliseconds(100)
//    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
//      self.destoryBtn(row: row - 1, column: column, iconId: iconId)
//      self.destoryBtn(row: row, column: column - 1, iconId: iconId)
//      self.destoryBtn(row: row + 1, column: column, iconId: iconId)
//      self.destoryBtn(row: row, column: column + 1, iconId: iconId)
//    }
  }
  
  func findBtn(with row: Int, column: Int, iconId: Int) -> SquareButton? {
    guard row >= 0 && column >= 0 else {  return nil }
    for one in squareViews {
      if one.row == row && one.column == column && one.iconId == iconId {
        return one
      }
    }
    return nil
  }
  
  func removeBtn(with row: Int, column: Int) {
    var tmp:[SquareButton] = []
    for one in squareViews {
      if one.row != row || one.column != column {
        tmp.append(one)
      }
    }
    squareViews = tmp
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

