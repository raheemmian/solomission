//
//  GameScene.swift
//  Solo Mission
//
//  Created by Raheem Mian on 2019-01-21.
//  Copyright © 2019 Raheem Mian. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
 let player = SKSpriteNode(imageNamed: "playerShip")
 let bulletSound = SKAction.playSoundFileNamed("bullet_whizzing_by-Mike_Koenig-2005433595.wav", waitForCompletion: false)
    override func didMove(to view: SKView) {
        /*function definition: stuff happens right as the scene is presented*/
        let background = SKSpriteNode(imageNamed: "background")/*image object: spriteNode*/
        background.size = self.size /*background is the same size as the scene "self"*/
        background.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
       
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/5)
        player.zPosition = 2
        self.addChild(player)
    }

    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }



}
