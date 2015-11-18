//
//  ZDGameModel.swift
//  The Game
//
//  Created by Zach Dingels on 10/13/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//  
/** This class keeps track of all the data for the game
Variables:
    timer: Int
        Keep track of the amount of time, private readonly
    lives: Int
        Number of lives left
    ammo: Int 
        Amount of ammo left
    ammoUpdateInterval: Int 
        How often ammo should be added
    enemiesKilled: Int 
        Number of enemies killed

Methods:
    init() 
        Nothing yet
    update()
        Updates the timer and increments the ammo if the it's time to
    hasLives(): Bool 
        Returns true if there are lives left
    outOfLives(): Bool 
        True if lives are less than or equal to 0
    getTime(): Int 
        Getter for the timer
    killEnemy() 
        Increments the enemiesKilled
    hasAmmo() 
        True if ammo is greater than 0

*/

import Foundation
import SpriteKit

class ZDGameModel: NSObject {
    
    // Allows the class to be a singleton so it doesn't have to be passed around
    class var sharedInstance : ZDGameModel {
        struct Singleton {
            static let instance = ZDGameModel()
        }
        return Singleton.instance
    }
    
    private var timer = 0
    
    var lifes: Int = Constants.GameData.beginningNumberOfLives {
        willSet {
            if newValue < lifes {
                killStreak = 0
                if level > Constants.GameData.killStreakLevelDecrease + 1 {
                    level -= Constants.GameData.killStreakLevelDecrease
                } else {
                    level = 1
                }
            }
        }
    }
    
    var score: Int = 0
    var scoreMultiplier: Int {
        get {
            return Constants.GameData.scoreMultiplier(killStreak)
        }
    }
    var ammo: Int = Constants.GameData.beginningAmmo
    var kills: Int = 0 {
        willSet {
            killStreak++
        }
    }
    var killStreak: Int = 0 {
        willSet {
            level += Constants.GameData.levelIncreasement(scoreMultiplier)
        }
    }
    var level: Double = 1
    var isGameOver = false
    let highScores = ZDHighScoreModel()
    var playerName = Constants.GameData.playerName
    
    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(playerName, forKey: Constants.GameData.playerNameSaveKey)
        
        defaults.synchronize()
        highScores.save()
    }
    
    func restart() {
        timer = 0
        score = 0
        ammo = Constants.GameData.beginningAmmo
        lifes = Constants.GameData.beginningNumberOfLives
        kills = 0
        killStreak = 0
        level = 1
        isGameOver = false
    }
    
    func update() {
        if timer % Constants.GameData.ammoUpdateFrequency == 0 {
            gainAmmo(1)
        }
        
        timer++
    }
    
    func loseLife() {
        if isGameOver {return}
        if hasLives() {
            lifes--
        }
    }
    
    func gainLife() {
        if isGameOver {return}
        if lifes > Constants.GameData.maxNumberOfLifes {
            lifes = Constants.GameData.maxNumberOfLifes
        }
    }
    
    func hasLives() -> Bool {
        return lifes > 0
    }
    
    func outOfLifes() -> Bool {
        return lifes <= 0
    }
    
    func getTime() -> Int {
        return timer
    }
    
    func killEnemy(enemyType: ZDEnemyShip.EnemyType) {
        if isGameOver {return}
        if hasLives() {
            kills++
        }
        
        switch enemyType {
        case .Scout:
            score += Constants.Enemy.ScoutScore() * scoreMultiplier
        case .Tank:
            score += Constants.Enemy.TankScore() * scoreMultiplier
        case .Speedster:
            score += Constants.Enemy.SpeedsterScore() * scoreMultiplier
        case .Ace:
            score += Constants.Enemy.AceScore() * scoreMultiplier
        }
    }
    
    func hasAmmo() -> Bool {
        return ammo > 0
    }
    
    func shoot() {
        if isGameOver {return}
        ammo--
    }
    
    func gainAmmo(n: Int) {
        if isGameOver {return}
        if ammo + n > Constants.GameData.maxNumberOfAmmo {
            ammo = Constants.GameData.maxNumberOfAmmo - n
        }
        ammo += n
    }
    
    func hasHighScore() -> Bool {
        return highScores.isHighScore(score)
    }
    
    func addToHighScores() {
        highScores.addScore(playerName ,score: score)
    }
    
    func highScoreIndex() -> Int? {
        let index = highScores.scores.filter{$0.score > self.score}.count
        return index < highScores.scores.count ? index : nil
    }

}