//
//  ViewController.swift
//
//  Created by jiao qing on 11/04/17.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
  let gameView = GameView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bgIV = UIImageView()
    bgIV.image = UIImage(named: "BG")
    view.addSubview(bgIV)
    bgIV.snp.makeConstraints{ make in
      make.top.left.width.height.equalTo(self.view)
    }
    
    view.addSubview(gameView)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    var gameFrame = gameView.frame
    gameFrame.origin.x = 0
    gameFrame.origin.y = 120
    gameFrame.size.width = view.frame.size.width
    gameFrame.size.height = view.frame.size.width
    gameView.frame = gameFrame
  }
}
