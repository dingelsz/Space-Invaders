//
//  ZDEnemy.swift
//  The Game
//
//  Created by Zach Dingels on 10/19/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//
/** A ZDEnemy is a sublcass of SKSpriteNode and adds a health and relative speed property.
Types:
    EnemyType: Int
        All different types of ships

Variables:
    health: Int 
        Number of hits a ship can take
    relativeSpeed: Double
        Relative speed compared to fastest possible. ex: a tank moves at 1/2 
        speed

Methods:
    init(CGSize, Type)
        Creates a new ZDEnemyShip with the given size and type. The image, 
        health and relative speed are dependend on the type.
    takeHit()
        Deincrements the health

*/

import Foundation
import SpriteKit

class ZDEnemyShip: SKSpriteNode {
    
    enum EnemyType: Int {
        case Scout = 0, Tank, Speedster, Ace
    }
    
    var health: Int
    let relativeSpeed: Double
    
    let type: EnemyType
    let level: ZDLevels.Level
    
    let trailEmitter: SKEmitterNode
    var shieldEmitter: SKEmitterNode
    
    var destroyAnimation = []
    
    required init?(coder aDecoder: NSCoder) {
        health = 1
        relativeSpeed = 0.5
        type = EnemyType.Scout
        level = ZDLevels.straightLevel()
        shieldEmitter = SKEmitterNode()
        trailEmitter = SKEmitterNode()
        super.init(coder: aDecoder)
    }
    
    required init(size: CGSize, type: EnemyType) {
        shieldEmitter = SKEmitterNode()
        trailEmitter = SKEmitterNode()
        self.type = type
        var image: UIImage
        switch type {
        case .Tank:
            health = 2
            relativeSpeed = Constants.Enemy.TankSpeed()
            image = UIImage(named: Constants.ImagePath.tankImagePath())!
            level = ZDLevels.easyLevel()
            shieldEmitter = SKEmitterNode(fileNamed: Constants.Emitter.UFOTankEmitterPath())
        case .Speedster:
            health = 1
            relativeSpeed = Constants.Enemy.SpeedsterSpeed()
            image = UIImage(named: Constants.ImagePath.speedsterImagePath())!
            level = ZDLevels.fastLevel()
            trailEmitter = SKEmitterNode(fileNamed: Constants.Emitter.UFOTrailEmitterPath())
        case .Ace:
            health = 2
            relativeSpeed = Constants.Enemy.AceSpeed()
            image = UIImage(named: Constants.ImagePath.aceImagePath())!
            level = ZDLevels.aceLevel()
            shieldEmitter = SKEmitterNode(fileNamed: Constants.Emitter.UFOTankEmitterPath())
            shieldEmitter.particleColor = UIColor.whiteColor()
            trailEmitter = SKEmitterNode(fileNamed: Constants.Emitter.UFOTrailEmitterPath())
            trailEmitter.particleColor = UIColor.whiteColor()
        // Scout
        default:
            health = 1
            relativeSpeed = Constants.Enemy.ScoutSpeed()
            image = UIImage(named: Constants.ImagePath.scoutImagePath())!
            level = ZDLevels.easyLevel()
        }
        
        super.init(texture: SKTexture(image: image), color: UIColor(), size: size)
        
        self.zPosition = 0.5

        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = Constants.Bitmask.enemyBitmask()
        self.physicsBody?.contactTestBitMask = Constants.Bitmask.projectileBitmask()
        self.physicsBody?.collisionBitMask = Constants.Bitmask.projectileBitmask()
        
        initEmitter([shieldEmitter, trailEmitter])
    }
    
    func initEmitter(emitters: [SKEmitterNode]) {
        for emitter in emitters {
            emitter.zPosition = 0.5
            emitter.advanceSimulationTime(3)
        }
    }
    
    convenience init(size: CGSize) {
        var type: EnemyType
        let rnd = Int(arc4random() % 100)
        if rnd < 40 {
            type = EnemyType.Scout
        } else if rnd < 65 {
            type = EnemyType.Tank
        } else if rnd < 90 {
            type = EnemyType.Speedster
        } else {
            type = EnemyType.Ace
        }
        self.init(size: size, type: type)
        
    }
    
    func isDestroyed() -> Bool {
        return health < 1
    }
    
    func takeHit() {
        health--
        if health == 1 {
            shieldEmitter.removeFromParent()
        }
    }
    
    func destroy() {
        remove()
        ZDGameModel.sharedInstance.killEnemy(type)
    }
    
    func remove() {
        physicsBody?.dynamic = false
        runAction(Constants.Enemy.DestroyAnimation()) {
            self.removeFromParent()
        }
        trailEmitter.runAction(Constants.Enemy.DestroyAnimation()) {
            self.trailEmitter.removeFromParent()
        }
        shieldEmitter.runAction(Constants.Enemy.DestroyAnimation()) {
            self.shieldEmitter.removeFromParent()
        }
    }
    
}
