//
//  TitleScene.swift
//  tinyquest
//
//  Created by 中道忠和 on 2019/12/14.
//  Copyright © 2019 tadakazu nakamichi. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    
    private var titleLabel : SKLabelNode?
    private var label2: SKLabelNode?
    
    override func didMove(to view: SKView){
        
        //タイトル
        let titleLabel = SKLabelNode(fontNamed: "ArialRoundedMyBold")
        titleLabel.text = "Tiny Quest"
        titleLabel.fontSize = 80
        titleLabel.fontColor = UIColor.white
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        titleLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(titleLabel)
        
        //TOUCH SCREEN
        let label2 = SKLabelNode()
        label2.text = "Touch Screen"
        label2.fontSize = 40
        label2.fontColor = UIColor.white
        label2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label2.position = CGPoint(x:self.frame.midX, y:self.frame.midY-200)
        self.addChild(label2)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //ゲーム画面へ遷移
        if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.view!.presentScene(scene)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
}
