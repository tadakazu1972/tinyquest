//
//  GameScene.swift
//  tinyquest
//
//  Created by 中道忠和 on 2019/12/14.
//  Copyright © 2019 tadakazu nakamichi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //player
    var texture_player:[SKTexture] = []
    var playerNode : SKSpriteNode?
    //map
    var mapTexture :[SKTexture] = []
    var mapNode : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        //重力の設定
        self.physicsWorld.gravity = CGVector(dx:0, dy:0)
        //衝突判定の委託
        self.physicsWorld.contactDelegate = self
        //プレイヤー画像ロード
        let playerAtlas = SKTextureAtlas(named:"player")
        for i in 1...8 {
            texture_player.append(playerAtlas.textureNamed("zakk0"+String(i)))
        }
        //アニメーションのための上下左右の組セット
        let animation_player_set1:[SKTexture] = [ texture_player[0], texture_player[1] ]
        let animation_player_set2:[SKTexture] = [ texture_player[2], texture_player[3] ]
        let animation_player_set3:[SKTexture] = [ texture_player[4], texture_player[5] ]
        let animation_player_set4:[SKTexture] = [ texture_player[6], texture_player[7] ]
        //後で使いやすくするため配列に格納
        let animation_player_set = [animation_player_set1, animation_player_set2, animation_player_set3, animation_player_set4]
        //初期画像セット
        self.playerNode = SKSpriteNode(texture: texture_player[0])
        //アニメーション設定
        let animation_player = SKAction.animate(with: animation_player_set[0], timePerFrame: 0.2)
        //プレイヤー描画
        if let playerNode = self.playerNode {
            //衝突時処理の判別のため名付け
            playerNode.name="player"
            playerNode.setScale(2.0)
            playerNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
            playerNode.run(SKAction.repeatForever(animation_player))
            //当たり判定範囲
            playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.frame.size)
            //カテゴリ
            playerNode.physicsBody?.categoryBitMask = 0x1 << 1
            //衝突
            playerNode.physicsBody?.collisionBitMask = 0x1 << 0
            //衝突検知設定
            playerNode.physicsBody?.contactTestBitMask = 0x1 << 0
            //衝突時回転禁止
            playerNode.physicsBody?.allowsRotation = false
            self.addChild(playerNode)
        }
        
        //マップ画像
        let mapAtlas = SKTextureAtlas(named:"map")
        mapTexture.append(mapAtlas.textureNamed("tree"))
        self.mapNode = SKSpriteNode(texture: mapTexture[0])
        if let mapNode = self.mapNode {
            mapNode.setScale(2.0)
            mapNode.position = CGPoint(x:200, y:400)
            //当たり判定範囲
            mapNode.physicsBody = SKPhysicsBody(rectangleOf: mapNode.frame.size)
            //カテゴリ
            mapNode.physicsBody?.categoryBitMask = 0x1 << 0
            //衝突マスク
            mapNode.physicsBody?.collisionBitMask = 0x1 << 2
            //動かない
            mapNode.physicsBody?.isDynamic = false
            self.addChild(mapNode)
        }
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.2),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    //衝突時にコール
    func didBegin(_ contact: SKPhysicsContact){
        print("call didBegin")
        if contact.bodyA.node?.name == "player" || contact.bodyB.node?.name == "player" {
            self.playerNode?.removeAction(forKey: "move")
            if let n = self.spinnyNode?.copy() as! SKShapeNode? {
                n.position = self.playerNode!.position
                n.strokeColor = SKColor.red
                self.addChild(n)
            }
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        
        /*//タイトル画面へ遷移
        let scene = TitleScene(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view!.presentScene(scene)*/
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //タッチ座標取得
        let location = touches.first!.location(in: self)
        //タッチした位置まで移動するアクション作成
        let action = SKAction.move(to: CGPoint(x:location.x, y:location.y), duration:1.0)
        //アクション実行
        self.playerNode?.run(action, withKey:"move")
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
