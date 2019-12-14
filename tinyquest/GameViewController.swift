//
//  GameViewController.swift
//  tinyquest
//
//  Created by 中道忠和 on 2019/12/14.
//  Copyright © 2019 tadakazu nakamichi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            //タイトル画面へ遷移
            let scene = TitleScene()
            scene.size = view.frame.size
            scene.scaleMode = SKSceneScaleMode.aspectFill
            view.presentScene(scene)
 
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
