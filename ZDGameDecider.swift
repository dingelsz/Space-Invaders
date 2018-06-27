//
//  ZDGameDecider.swift
//  The Game
//
//  Created by Zach Dingels on 10/7/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//
/**
This class deals with launching enemies. It decides when to launch them, what type to launch and how they should move.

Variables:
    scene: GameScene
        The game scene that this class is created in so enemies can be added
    timer: Int 
        Holds the time for the class
    waitToLaunchTime: Int 
        The minimum amount of time required to wait before launching a new enemy
    launchChance: Int 
        Chance of generating a new enemy every time decide is called
    enemyLevelTime: Int 
        Speed of a level. This number is multiplied by a constant and subtracted
        from normal runtime.
    enemySize: CGSize 
        The size of an enemy, computed using the screen size.

Methods:
    decide()
        Does all the logic for launching an enemy. If the timer has passed the 
        waitToLaunchTime and if a random number between 0 and launchChance is 1 
        then create a new enemy with a random type and path, launch it and reset
        the timer. Then no matter what increment the timer.
*/

import Foundation
import SpriteKit

class ZDEnemyLauncher: NSObject {
    
    var scene: SKScene?
    
    var timer = 0

    func addScene(_ scene: SKScene) {
        self.scene = scene
    }
    
    func decide() {
        if timer > Constants.Enemy.minSpawnTime() {
            
            if shouldLaunchEnemy() || timer > Constants.Enemy.maxSpawnTime() {
                createEnemy()
                
                timer = 0
            }
        }
        timer += 1
    }
    
    func shouldLaunchEnemy() -> Bool {
        return arc4random_uniform(Constants.Enemy.SpawnRate()) == UInt32(1)
    }
    
    func createEnemy() {
        let enemy = ZDEnemyShip(size: Constants.Enemy.enemySize())
        let movementDuration = Constants.Enemy.movementDuration() / enemy.relativeSpeed
        
        let movement = SKAction.customAction(withDuration: movementDuration) { node, time in
            let startY = (self.scene!.size.height * (2/3.0))
            let range = (self.scene!.size.height - startY - enemy.size.height / 2)
            
            let timePercent = Double(time) / movementDuration
            let xPos = self.scene!.size.width - self.scene!.size.width * CGFloat(enemy.level.x(timePercent))
            let yPos = startY + range * CGFloat(enemy.level.y(timePercent))
            node.position = CGPoint(x: xPos, y: yPos)
        }
        
        enemy.run(movement, completion: {
            enemy.remove()
            if let gameScene = self.scene as? GameScene {
                gameScene.enemyEscaped()
            }
        }) 
        
        enemy.trailEmitter.run(movement, completion: {
            enemy.trailEmitter.removeFromParent()
        }) 
        
        enemy.shieldEmitter.run(movement, completion: {
            enemy.shieldEmitter.removeFromParent()
        }) 
        
        scene!.addChild(enemy.shieldEmitter)
        scene!.addChild(enemy.trailEmitter)
        scene!.addChild(enemy)
    }
    
}
