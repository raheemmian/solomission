//
//  GameScene.swift
//  Solo Mission
//
//  Created by Raheem Mian on 2019-01-21.
//  Copyright © 2019 Raheem Mian. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate  {
    
    let player = SKSpriteNode(imageNamed: "playerShip")
    let bulletSound = SKAction.playSoundFileNamed("bullet_whizzing_by-Mike_Koenig-2005433595.wav", waitForCompletion: false)
    
    func random() -> CGFloat {
        /*the hex number equals 2^32 - 1 therefore this function only returns values between 0 and 1*/
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min:CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    // game area stuff
   let gameArea: CGRect
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        /*function definition: stuff happens right as the scene is presented*/
        let background = SKSpriteNode(imageNamed: "background")/*image object: spriteNode*/
        background.size = self.size /*background is the same size as the scene "self"*/
        background.position = CGPoint(x: self.size.width/2, y:self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
       
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height/5)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody!.affectedByGravity = false
        self.addChild(player)
        startNewLevel()
    }

    func fireBullet() {
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    func spawnEnemy(){
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX,max: gameArea.maxX)
        let startPoint = CGPoint(x: randomXStart,y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        enemy.run(enemySequence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy,dx)
        enemy.zRotation = amountToRotate
        
    }
    
    func startNewLevel(){
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 1)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }
 
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            player.position.x = player.position.x  + amountDragged
            
            /*if we go to far left or right, bump the player back into the game area*/
        
            if player.position.x > gameArea.maxX - player.size.width / 2{
                player.position.x = gameArea.maxX - player.size.width / 2
            }
            if player.position.x < gameArea.minX + player.size.width / 2{
                player.position.x = gameArea.minX + player.size.width / 2
            }
        }
    }


}
