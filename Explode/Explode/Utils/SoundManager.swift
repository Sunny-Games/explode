//
//  SoundManager.swift
//  ColourMemory
//
//  Created by jiao qing on 27/7/16.
//  Copyright © 2016 jiao qing. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class SoundManager: NSObject {
  fileprivate let glassBreakSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "glass_break", ofType: "mp3")!)
  fileprivate let explodeSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "explode", ofType: "wav")!)

  var glassBreakSound : AVAudioPlayer?
  var explodeSound : AVAudioPlayer?
  
  static let sharedInstance = SoundManager()
  
  override init() {
    super.init()
    
    do {
      glassBreakSound = try AVAudioPlayer(contentsOf: glassBreakSoundURL)
      glassBreakSound!.prepareToPlay()
      
      explodeSound = try AVAudioPlayer(contentsOf: explodeSoundURL)
      explodeSound!.prepareToPlay()
    } catch {
      // couldn't load file :(
    }
    
  }
  
  func resetGlassBreak() {
    guard let glassSound = glassBreakSound else { return }
    glassSound.currentTime = 0
  }
  
  func playGlassBreak() {
    guard let glassSound = glassBreakSound else { return }
    glassSound.play()
  }
  
  func playExplode(){
    guard let explodeSound = explodeSound else { return }
    explodeSound.currentTime = 0
    explodeSound.play()
  }
}
