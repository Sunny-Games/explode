//
//  GameView.swift
//  Explode
//
//  Created by Qing Jiao on 11/4/17.
//  Copyright © 2017 Qing Jiao. All rights reserved.
//

import Foundation

let colorNumber: UInt32 = 81

class GameView: UIView {
  let numberOfRow = 9
  let numberOfColumns = 9
  let cardOffSetUp: CGFloat = 80
  let cardOffSetDown: CGFloat = 180
  
  var squareViews = [SquareButton]()
  let waterView = WaterView.shared
  
  var colorArray: [UIColor] = Array.init(repeating: UIColor.gray, count: Int(colorNumber))
  
  private var currentColor = UIColor.clear
  private var currentVolume: Float = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    resetGame()
  }
  
  func resetGame() {
    for index in 0...colorArray.count - 1 {
      colorArray[index] = UIColor.random()
    }
    
    currentColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    currentVolume = 0
    
    removeAllSubViews()
    
    for oneRow in 0...numberOfRow - 1 {
      for oneCol in 0...numberOfColumns - 1 {
        let iconId = Int(arc4random_uniform(colorNumber))
        let color = colorArray[iconId]
        
        let oneSquare = SquareButton(iconId: iconId, color: color, row: oneRow, column: oneCol)
        squareViews.append(oneSquare)
        addSubview(oneSquare)
        oneSquare.addTarget(self, action: #selector(squareDidClicked(sender:)), for: .touchUpInside)
      }
    }
    
    waterView.fill(to: 0.5)
    waterView.fillColor = UIColor.clear
    addSubview(waterView)
  }
  
  func squareDidClicked(sender: UIButton){
    guard let squareBtn = sender as? SquareButton else { return }
    
    let callBack: ExplodeCompletion = { complete in
      self.recaculateColor(colorId: squareBtn.iconId)
      self.currentVolume += 1
      self.waterView.fillColor = self.currentColor
    }
    
    SoundManager.sharedInstance.resetBallonSplashBreak()
    destoryBtn(row: squareBtn.row, column: squareBtn.column, iconId: squareBtn.iconId, callback: callBack)
  }
  
  func recaculateColor(colorId: Int) {
    let color = colorArray[colorId]
    guard currentVolume > 0 else {
      currentColor = color
      return
    }
    
    let nR = color.cgColor.components![0]
    let nG = color.cgColor.components![1]
    let nB = color.cgColor.components![2]
    
    let cR = currentColor.cgColor.components![0]
    let cG = currentColor.cgColor.components![1]
    let cB = currentColor.cgColor.components![2]
    
    let totalVolume: CGFloat = 2
    let r = (nR + cR) / totalVolume
    let g = (nG + cG) / totalVolume
    let b = (nB + cB) / totalVolume

    currentColor = UIColor(red: r, green: g, blue: b, alpha: 1)
  }
  
  func destoryBtn(row: Int, column: Int, iconId: Int, callback: ExplodeCompletion? = nil) {
    guard row >= 0 && column >= 0 else {  return }
    
    guard let btn = findBtn(with: row, column: column, iconId: iconId) else { return }
    btn.destroySelf(callback: callback)
    removeBtn(with: row, column: column)
    
    let deadlineTime = DispatchTime.now() + .milliseconds(100)
    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
      self.destoryBtn(row: row - 1, column: column, iconId: iconId, callback: callback)
      self.destoryBtn(row: row, column: column - 1, iconId: iconId, callback: callback)
      self.destoryBtn(row: row + 1, column: column, iconId: iconId, callback: callback)
      self.destoryBtn(row: row, column: column + 1, iconId: iconId, callback: callback)
    }
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
    let gameHeight = frame.size.height - cardOffSetUp - cardOffSetDown
    
    let oxSpacing: CGFloat = 2
    let oySpacing: CGFloat = 2
    let cardWidth = (gameWidth - CGFloat(numberOfColumns + 1) * oxSpacing) / CGFloat(numberOfColumns)
    let cardHeight = (gameHeight - CGFloat(numberOfRow + 1) * oxSpacing) / CGFloat(numberOfRow)
    
    var oneFrame = CGRect.zero
    for one in squareViews {
      oneFrame.origin.x = CGFloat(one.row) * (cardWidth + oxSpacing) + oxSpacing
      oneFrame.origin.y = CGFloat(one.column) * (cardHeight + oySpacing) + oySpacing + cardOffSetUp
      oneFrame.size.width = cardWidth
      oneFrame.size.height = cardHeight
      one.frame = oneFrame
    }
    
    var wfFrame = waterView.frame
    wfFrame.size.height = cardOffSetDown - 30
    wfFrame.size.width = frame.size.width
    wfFrame.origin.y = frame.size.height - wfFrame.size.height
    wfFrame.origin.x = 0
    waterView.frame = wfFrame
  }
}

