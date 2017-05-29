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
    
    let bgIV2 = UIImageView()
    bgIV2.image = UIImage(named: "BG_splash")
    bgIV2.contentMode = .scaleAspectFit
    view.addSubview(bgIV2)
    bgIV2.snp.makeConstraints{ make in
      make.left.width.bottom.equalTo(self.view)
      make.height.equalTo(300)
    }
    
    view.addSubview(gameView)
    gameView.snp.makeConstraints{ make in
      make.left.right.width.equalTo(self.view)
      make.top.equalTo(100)
    }
    
  }
  
  
}
