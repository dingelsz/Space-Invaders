//
//  GameScene.swift
//  The Game
//
//  Created by Zach Dingels on 10/6/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//
/** This game is all about shooting down incoming objects. The bottom of the 
    screen is the player, it shoots projectiles at enemies that are flying 
    above. Time in this game is kept track of with the number of times update is
    called in the timer. Update first calls a decider. The deciders job is to 
    decide which level to run and then if a level is running.

Variables:
    gameModel: ZDGameModel
        Holds the timer and data like ammo and lives left
    enemyLauncher: ZDEnemyLauncher 
        Launches all the enemies.
    player: SKSpriteNode
        SKSpriteNode for the player
    killLabel: SKLabelNode 
        Label to display the number of kills
    ammoLabel: SKLabelNode 
        Label to display how much ammo is left
    livesLabel: SKLabelNode 
        Label to display how many lives are left
    gameOverLabel: SKLabelNode 
        Label to be displayed when the game is over to let the player know so

Methods: 
    didMoveToView(view: SKView)
        Called when the scene is presented, basically a weak init
    initPlayer()
        Configures the player node
    initLabel(SKLabelNode, String, CGPoint)
        Configures the Label with the given text at the given point
    touchesBegan(NSSet, UIEvent)
        Called when a touch begins.
    touchesEnded(NSSet, UIEvent)
        Called when a touch ends. Creates a projectile.
    launchProjectile(CGPoint)
        Launhes a projectile from the player in the direction of the touch over 
        the distance of the screen
    createProjectile(): SKSPriteNode
        Creates a projectile.
    update(CFTimeInterval)
        Called every time the screen is updated. If the player still has lives 
        then the gameModel and deicder are updated and if not then the game ends
    didBeginContact(SKPhysicsContact)
        Gets called every time two nodes with come into contact with each other.
        If the node is a projectile and a enemy then the enemy should be 
        destroyed.
    destroyEnemy(SKNode)
        Removes the node from the view and updates the model.
    gameOver()
        Displays the endGameLabel


*/

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let gameModel = ZDGameModel.sharedInstance
    let enemyLauncher = ZDEnemyLauncher()
    let cannon = ZDHomeBase()
    
    
    let backdrop = SKSpriteNode(color: UIColor.blackColor(), size: Constants.screenSize)
    let background = SKSpriteNode(imageNamed: Constants.ImagePath.playerImagePath())
    let hud = ZDHud(size: Constants.screenSize)
    
    func playLoadingFade() {
        backdrop.position = Constants.screenCenter
        backdrop.zPosition = 4
        addChild(backdrop)
        
        backdrop.runAction(Constants.Animations.BlackInAnimation()) {
            self.backdrop.removeFromParent()
        }
    }

    override func didMoveToView(view: SKView) {
        playLoadingFade()
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        enemyLauncher.addScene(self)
        
        initPlayer()
        cannon.location = Constants.Cannon.cannonPosition(background)

        addChild(hud)
        
    }
    
    func initPlayer() {
        background.position = Constants.screenCenter
        background.size = Constants.screenFrame.size
        background.zPosition = -1
        
        addChild(background)
    }
    
    override func update(currentTime: CFTimeInterval) {
        if gameModel.outOfLifes() && !gameModel.isGameOver {
            gameOver()
        }
        
        cannon.update(self)
        hud.update()
        // Don't launch enemies or add ammo if the begining animation hasn't started yet
        if backdrop.parent != nil { return }
        gameModel.update()
        enemyLauncher.decide()
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
        if gameModel.hasAmmo() {
            cannon.queueShotAt(location)
            gameModel.shoot()
        }
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
                // Collision while in animation, ignore this it will add two kills
                if firstBody.node!.name!.rangeOfString("fire") != nil {
                    ship.takeHit()
                }
                
                ship.takeHit()
                
                if ship.isDestroyed() {
                    destroyEnemy(ship)
                } else {
                    // Emitter collision, destroy projectile
                    firstBody.node?.removeFromParent()
                }
            }
        }
        
    }
    
    func destroyEnemy(ship: ZDEnemyShip) {
        let bonus: ZDBonus? = ZDBonus.maybeBonusFor(ship.type)
        
        ship.destroy()
        
        if bonus != nil {
            bonus?.position = ship.position
            bonus?.emitter.position = ship.position
            addChild(bonus!.emitter)
            addChild(bonus!)
        }
        
    }
    
    func enemyEscaped() {
        gameModel.loseLife()
    }
    
    func gameOver() {
        if !gameModel.isGameOver {
            gameModel.isGameOver = true
            gameModel.addToHighScores()
            hud.scrollUp()
            hud.updatHighScores(gameModel.highScoreIndex())
        }
        
    }
}