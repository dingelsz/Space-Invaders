//
//  GameScene.swift
//  The Game
//
//  Created by Zach Dingels on 10/6/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import SpriteKit

class MenuGameScene: SKScene, SKPhysicsContactDelegate {
    
    let cannon = ZDHomeBase()
    let background = SKSpriteNode(imageNamed: Constants.ImagePath.menuBGPath)
    
    let quickPlayShip = ZDEnemyShip(size: Constants.Menu.playShipSize, type: ZDEnemyShip.EnemyType.Scout)
    let invasionShip = ZDEnemyShip(size: Constants.Menu.invasionShipSize, type: ZDEnemyShip.EnemyType.Tank)
    
    func playLoadingFade() {
        let backdrop = SKSpriteNode(color: UIColor.blackColor(), size: Constants.screenSize)
        backdrop.position = Constants.screenCenter
        backdrop.zPosition = 4
        addChild(backdrop)
        
        backdrop.runAction(Constants.Animations.BlackInAnimation()) {
            backdrop.removeFromParent()
        }
    }
    
    override func didMoveToView(view: SKView) {
        playLoadingFade()
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        initBackground()
        cannon.location = Constants.Cannon.cannonPosition(background)
        
        quickPlayShip.texture = SKTexture(imageNamed: "quickPlay.png")
        quickPlayShip.position = Constants.Menu.playShipPosition
        quickPlayShip.name = "quickPlay"
        quickPlayShip.runAction(Constants.Menu.playShipAction())
        addChild(quickPlayShip)
        
        invasionShip.texture = SKTexture(imageNamed: "invasionPlay.png")
        invasionShip.position = Constants.Menu.invasionShipPosition
        invasionShip.name = "quickPlay"
        invasionShip.runAction(Constants.Menu.invasionShipAction())
        addChild(invasionShip)
        
    }
    
    func initBackground() {
        background.position = Constants.screenCenter
        background.size = Constants.screenFrame.size
        
        addChild(background)
    }
    
    override func update(currentTime: CFTimeInterval) {
        cannon.update(self)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch ends */
        for touch: AnyObject in touches {
            // Create the projectile and put it where the player is
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            
            // If the node is a bonus then gain it, if not shoot em'
            if let bonus = touchedNode as? ZDBonus {
                cannon.gainBonus(bonus.type)
                bonus.remove()
            } else {
                shootCannon(location)
            }
            
        }
    }
    
    func shootCannon(location: CGPoint) {
        cannon.queueShotAt(location)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // If the two nodes are projectile and enemy then destroy the enemy
        if (firstBody.categoryBitMask & Constants.Bitmask.projectileBitmask()) != 0 && (secondBody.categoryBitMask & Constants.Bitmask.enemyBitmask()) != 0 {
            if let ship = secondBody.node as? ZDEnemyShip {
                if ship.name == "quickPlay" {
                    transitionOutThen(Constants.presentQuickPlayViewController)
                    ship.destroy()
                }
            }
        }
    }
    
    func transitionOutThen(f: () -> ()) {
        let backdrop = SKSpriteNode(color: UIColor.blackColor(), size: Constants.screenSize)
        backdrop.position = Constants.screenCenter
        backdrop.zPosition = 4
        addChild(backdrop)
        backdrop.runAction(Constants.Animations.BlackOutAnimation()) {
            f()
        }
    }
}