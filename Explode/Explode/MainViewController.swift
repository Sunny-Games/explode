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
  var waterView: WaterView?
  
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
    
    waterView = WaterView(frame: CGRect(x: 0, y: 400, width: view.frame.size.width, height: 100))
    waterView!.fill(to: 1)
    waterView!.fillColor = UIColor.yellow
    view.addSubview(waterView!)
    waterView!.startAnimation()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    var gameFrame = gameView.frame
    gameFrame.origin.x = 0
    gameFrame.origin.y = 120
    gameFrame.size.width = view.frame.size.width
    gameFrame.size.height = view.frame.size.width
    gameView.frame = gameFrame
    
    if let wv = waterView {
      wv.frame.origin.y = self.view.frame.size.height - wv.frame.size.height
    }
  }
}
