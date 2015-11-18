//
//  Constants.swift
//  The Game
//
//  Created by Zach Dingels on 10/6/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import Foundation
import SpriteKit

class Constants {
    
    class var screenFrame: CGRect {
        get {
            return UIScreen.mainScreen().bounds
        }
    }
    
    class var screenSize: CGSize {
        get {
            return screenFrame.size
        }
    }
    
    class var screenCenter: CGPoint {
        get {
            return CGPointMake(screenSize.width / 2, screenSize.height / 2)
        }
    }
    
    class var rootViewController: ZDGameViewController {
        get {
            var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
            
            while (topController!.presentedViewController != nil) {
                topController = topController?.presentedViewController
            }
            
            return topController as ZDGameViewController
        }
    }
    
    class func presentQuickPlayViewController() {
        
        let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as GameViewController
        viewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        Constants.rootViewController.presentViewController(viewController, animated: false) {
            (viewController as GameViewController).playGame()
        }
    }
    
    class func presentMenuViewController() {
        
        let viewController: UIViewController = UIStoryboard(name: "GameMenu", bundle: nil).instantiateViewControllerWithIdentifier("ZViewController") as ZDGameMenuViewController
        
        Constants.rootViewController.presentViewController(viewController, animated: false, completion: nil)
    }
    
    class GameData {
        
        class var playerNameSaveKey: String {
            get {
                return "playerName"
            }
        }
        
        class var playerName: String {
            get {
                let defaults = NSUserDefaults.standardUserDefaults()
                return defaults.objectForKey("playerName") != nil ?  defaults.objectForKey(playerNameSaveKey) as String : "Player"
            }
        }
        
        class var beginningNumberOfLives: Int {
            get {
                return 10
            }
        }
        
        class var beginningAmmo: Int {
            get {
                return 10
            }
        }
        
        class var ammoUpdateFrequency: Int {
            get {
                return 60
            }
        }
        
        class var killStreakLevelDecrease: Double {
            get {
                return 15.0
            }
        }
        
        class func scoreMultiplier(killStreak: Int) -> Int {
            if killStreak < 40 {
                return Int(pow(Double(2), Double(killStreak / 10)))
            } else {
                return 8
            }
        }
        
        class func levelIncreasement(scoreMultiplier: Int) -> Double {
            switch scoreMultiplier {
            case 1:
                return 0.6
            case 2:
                return 1
            case 4:
                return 2
            case 8:
                return 4
            default:
                return 1
            }
        }
        
        class var maxNumberOfLifes: Int {
            get {
                return 99
            }
        }
        
        class var maxNumberOfAmmo: Int {
            get {
                return 999
            }
        }
    }
    
    class Menu {
        
        class var backgroundColor: UIColor {
            get {
                return UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
            }
        }
        
        class var backgroundSize: CGSize {
            get {
                return CGSizeMake(screenSize.width * 0.9, screenSize.height * 0.9)
            }
        }
        
        class var backgroundPosition: CGPoint {
            get {
                return CGPointMake(screenCenter.x - screenSize.width * 0.05, screenCenter.y)
            }
        }
        
        class var playShipSize: CGSize {
            get {
                return CGSizeMake(Constants.Enemy.enemySize().width * 2.5, Constants.Enemy.enemySize().height * 4)
            }
        }
        
        class var playShipPosition: CGPoint {
            get {
                let x = Constants.screenSize.width * 0.7
                let y = Constants.screenSize.height * 0.7
                return CGPointMake(x, y)
            }
        }
        
        class var playButtonPosition: CGPoint {
            get {
                return CGPointMake(0, backgroundSize.height * 0.3)
            }
        }
        
        class func playShipAction() -> SKAction {
            func xFunc(time t: Double) -> Double {
                return cos(t) / (pow(sin(t), 2) + 1)
                
            }
            
            func yFunc(time t: Double) -> Double {
                return (2.82 * cos(t) * sin(t)) / (pow(sin(t), 2) + 1)
            }
            
            let path = ZDLevels.Level(x: xFunc, y: yFunc, length: 1000)
            let xRange = Constants.screenSize.width * 0.1
            let yRange = Constants.screenSize.height * 0.2
            
            let action = SKAction.customActionWithDuration(M_PI * 2) { node, time in
                let t = Double(time)
                let x = self.playShipPosition.x + (CGFloat(xRange) * CGFloat(path.x(t)))
                let y = self.playShipPosition.y + (CGFloat(yRange) * CGFloat(path.y(t)))
                node.position = CGPointMake(x, y)
            }
            return SKAction.repeatActionForever(action)
        }
        
        class var invasionShipSize: CGSize {
            get {
                return CGSizeMake(Constants.Enemy.enemySize().width * 2.5, Constants.Enemy.enemySize().height * 4)
            }
        }
        
        class var invasionShipPosition: CGPoint {
            get {
                let x = Constants.screenSize.width * 0.65
                let y = Constants.screenSize.height * 0.2
                return CGPointMake(x, y)
            }
        }
        
        class var invasionButtonPosition: CGPoint {
            get {
                return CGPointMake(0, backgroundSize.height * 0.3)
            }
        }
        
        class func invasionShipAction() -> SKAction {
            func xFunc(time t: Double) -> Double {
                return cos(t)
                
            }
            
            func yFunc(time t: Double) -> Double {
                return sin(t)
            }
            
            let path = ZDLevels.Level(x: xFunc, y: yFunc, length: 1000)
            let xRange = Constants.screenSize.width * 0.2
            let yRange = Constants.screenSize.height * 0.1
            
            let action = SKAction.customActionWithDuration(M_PI * 2) { node, time in
                let t = Double(time)
                let x = self.invasionShipPosition.x + (CGFloat(xRange) * CGFloat(path.x(t)))
                let y = self.invasionShipPosition.y + (CGFloat(yRange) * CGFloat(path.y(t)))
                node.position = CGPointMake(x, y)
            }
            return SKAction.repeatActionForever(action)
        }
        
    }
    
    class Animations {
        
        class func FadeAnimationDuration() -> Double {
            return 2
        }
        
        class func BlackInAnimation() -> SKAction {
            return SKAction.customActionWithDuration(FadeAnimationDuration()) { node, time in
                let timePercent = Double(time) / self.FadeAnimationDuration()
                let timeSquared = timePercent * timePercent
                node.alpha = CGFloat(1 - timeSquared)
            }
        }
        
        class func BlackOutAnimation() -> SKAction {
            return SKAction.customActionWithDuration(FadeAnimationDuration()) { node, time in
                let timePercent = Double(time) / self.FadeAnimationDuration()
                let timeSquared = timePercent * timePercent
                node.alpha = CGFloat(timeSquared)
            }
        }
    }
    
    class HUD {
        
        class func MultiplierBarFrame() -> CGRect {
            return CGRectMake(0, (screenSize.height * -0.385), screenSize.width * 0.563, screenSize.height * 0.031)
        }
        
        class func MultiplierBarx1Color() -> UIColor {
            return UIColor.whiteColor()
        }
        
        class func MultiplierBarx2Color() -> UIColor {
            return UIColor.greenColor()
        }
        
        class func MultiplierBarx4Color() -> UIColor {
            return UIColor.redColor()
        }
        
        class func MultiplierBarx8Color() -> UIColor {
            return UIColor(red: 0, green: 222/255.0, blue: 1, alpha: 1)
        }
        
        class func FontName() -> String {
            return "Marion-Regular"
        }
        
        class func FontSize() -> CGFloat {
            return screenSize.height / 11.3
        }
        
        class func MultiplierFontSize() -> CGFloat {
            return screenSize.height / 7
        }
        
        class func FontColor() -> UIColor {
            return UIColor.whiteColor()
        }
        
        class func ScoreLabelText() -> String {
            return "Score: \(ZDGameModel.sharedInstance.score)"
        }
        
        class func LabelY() -> CGFloat {
            return screenSize.height * -0.49
        }
        
        class func ScoreLabelPosition() -> CGPoint {
            return CGPointMake(screenSize.width * -0.3, LabelY())
        }
        
        class func AmmoLabelText() -> String {
            return "\(ZDGameModel.sharedInstance.ammo)"
        }
        
        class func AmmoLabelPosition() -> CGPoint {
            return CGPointMake(screenSize.width * 0.055, LabelY())
        }
        
        class func LifeLabelText() -> String {
            return "\(ZDGameModel.sharedInstance.lifes)"
        }
        
        class func LifeLabelPosition() -> CGPoint {
            return CGPointMake(screenSize.width * 0.22, LabelY())
        }
        
        class func MultiplierLabelText() -> String {
            return "x\(ZDGameModel.sharedInstance.scoreMultiplier)"
        }
        
        class func MultiplierLabelPosition() -> CGPoint {
            return CGPointMake(screenSize.width * 0.365, screenSize.height * -0.4)
        }
        
        class func MultiplierTextColor() -> UIColor {
            switch ZDGameModel.sharedInstance.scoreMultiplier {
            case 1:
                return Constants.HUD.MultiplierBarx1Color()
            case 2:
                return Constants.HUD.MultiplierBarx2Color()
            case 4:
                return Constants.HUD.MultiplierBarx4Color()
            case 8:
                return Constants.HUD.MultiplierBarx8Color()
            default:
                return UIColor.whiteColor()
            }
        }
        
        class func ScrollUpDistance() -> CGFloat {
            return screenSize.height * 0.8
        }
        
        class func ScrollUpDistance() -> Double {
            return Double(screenSize.height) * 0.8
        }
        
        class func ScrollUpTime() -> Double {
            return 2.5
        }
        
    }
    
    class HighScore {
        
        class func FontName() -> String {
            return "Marion-Regular"
        }
        
        class func FontSize() -> CGFloat {
            return screenSize.height / 11
        }
        
        class func NameLabelX() -> CGFloat {
            return HUD.ScoreLabelPosition().x
        }
        
        class func ScoreLabelX() -> CGFloat {
            return HUD.LifeLabelPosition().x
        }
        
        class func LabelPadding() -> CGFloat {
            return screenSize.height * 0.14
        }
        
        // This is from the middle of the HighScore view so this is really 75%
        class func LabelYIndent() -> CGFloat {
            return screenSize.height * 0.25
        }
        
        class func HighScoreColor() -> UIColor {
            return UIColor(red: 00, green: 0, blue: 0, alpha: 0.8)
        }
        
        class func HighScoreSize() -> CGSize {
            return CGSizeMake(screenSize.width, HUD.ScrollUpDistance())
        }
        
        class func HighScorePosition() -> CGPoint {
            return CGPointMake(0, (-screenSize.height - HighScoreSize().height) * 0.5)
        }
        
        class func DataPath() -> String {
            let documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let documentDirectory = documentDirectories[0] as String
            return documentDirectory.stringByAppendingPathComponent("highScore.archive")
        }
        
        class var nameKey: String {
            get {
                return "name"
            }
        }
        
        class var scoreKey: String {
            get {
                return "score"
            }
        }
        
        class var editMessage: String {
            get {
                return "(Tap to Edit)"
            }
        }
        
        class func ReplayButtonSize() -> CGSize {
            return CGSizeMake(screenSize.height * 0.1 , screenSize.height * 0.1)
        }
        
        class func ReplayButtonLocation() -> CGPoint {
            return CGPointMake(screenSize.width * 0.46, screenSize.height * -0.33)
        }
        
        class func ReplayButtonName() -> String {
            return "replay"
        }
        
        class func HomeButtonSize() -> CGSize {
            return ReplayButtonSize()
        }
        
        class func HomeButtonLocation() -> CGPoint {
            return CGPointMake(screenSize.width * -0.46, ReplayButtonLocation().y)
        }
        
        class func HomeButtonName() -> String {
            return "home"
        }
        
    }
    
    class Bitmask {
    
        class func playerBitmask() -> UInt32 {
            return 0x1 << 0
        }
        
        class func projectileBitmask() -> UInt32 {
            return 0x1 << 1
        }
        
        class func enemyBitmask() -> UInt32 {
            return 0x1 << 2
        }
        
        class func shieldBitmask() -> UInt32 {
            return 0x1 << 3
        }
        
    }
    
    class Projectile {
    
        class func projectileSize() -> CGSize {
            return CGSizeMake(screenSize.height / 8, screenSize.height / 8)
        }
        
        class func SpeedConstant() -> Double {
            return Double(screenSize.width * 1.5) + (Double(ZDGameModel.sharedInstance.kills) * 0.0046)
        }
        
    }
    
    class Enemy {
        
        class func ScoutScore() -> Int {
            return 1
        }
        
        class func TankScore() -> Int {
            return 3
        }
        
        class func SpeedsterScore() -> Int {
            return 3
        }
        
        class func AceScore() -> Int {
            return 5
        }
        
        class func ScoutSpeed() -> Double {
            return 0.85
        }
        
        class func TankSpeed() -> Double {
            return 0.8
        }
        
        class func SpeedsterSpeed() -> Double {
            return 1.1
        }
        
        class func AceSpeed() -> Double {
            return 1
        }
    
        class func SpawnRate() -> UInt32 {
            let x = ZDGameModel.sharedInstance.level
            return UInt32(1000/x) + 30
        }
        
        class func enemySize() -> CGSize {
            return CGSizeMake(screenSize.height / 6, screenSize.height / 10)
        }
        
        class func movementDuration() -> Double {
            let x = Double(ZDGameModel.sharedInstance.level)
            if x < 171 {
                return (sin(x) / 2) - (x / 50) + 5
            }
            return 2 - ((Double(ZDGameModel.sharedInstance.level) - 171) * 0.01)

        }
        
        class func minSpawnTime() -> Int {
            return 20
        }
        
        class func maxSpawnTime() -> Int {
            let x = ZDGameModel.sharedInstance.level
            let spawn = Int(-30 * sin(x * (1 / (10 * M_PI)))) + 100
            return spawn
        }
        
        class func DestroyDuration() -> Double {
            return 3 / 32.0
        }
        
        class func DestroyAnimation() -> SKAction {
            return SKAction.customActionWithDuration(DestroyDuration()) { node, time in
                let timePercent = Double(time) / self.DestroyDuration()
                let timeSquared = timePercent * timePercent
                node.alpha = CGFloat(1.5 - timeSquared)
                node.setScale(CGFloat(1 - timeSquared))
            }
            //            let shrink = SKAction.scaleTo(0, duration: DestroyDuration())
            //            let fade = SKAction.fadeAlphaTo(0, duration: DestroyDuration())
            //            return SKAction.group([shrink, fade])
        }
    
    }
    
    class Cannon {
        class func cannonPosition(player: SKNode) -> CGPoint {
            return CGPointMake(screenSize.width  * 0.29, screenSize.height * 0.44)
        }
        
    }
    
    class ImagePath {
    
        class func scoutImagePath() -> String {
            return "scout.png"
        }
        
        class func tankImagePath() -> String {
            return "tank.png"
        }
        
        class func speedsterImagePath() -> String {
            return "speedster.png"
        }
        
        class func aceImagePath() -> String {
            return "ace.png"
        }
        
        class func windBonusPath() -> String {
            return "windBonus.png"
        }
        
        class func waterBonusPath() -> String {
            return "waterBonus.png"
        }
        
        class func fireBonusPath() -> String {
            return "fireBonus.png"
        }
        
        class func ammoBonusPath() -> String {
            return "ammoBonus.png"
        }
        
        class func lifeBonusPath() -> String {
            return "lifeBonus.png"
        }
        
        class func playerImagePath() -> String {
            return "bg.png"
        }
        
        class func HUDImagePath() -> String {
            return "hud.png"
        }
        
        class func HUDTopBarImagePath() -> String {
            return "wallTop.png"
        }
        
        class func ReplayImagePath() -> String {
            return "replay.png"
        }
        
        class func HomeImagePath() -> String {
            return "home.png"
        }
        
        class var menuBGPath: String {
            get {
                return "menuBG.png"
            }
        }
    }
    
    class Emitter {
        
        class func UFOTankEmitterPath() -> String {
            return "UFOTankEmitter"
        }
        
        class func UFOAceEmitterPath() -> String {
            return "UFOAceEmitter"
        }
        
        class func UFOTrailEmitterPath() -> String {
            return "UFOTrail"
        }
    }
    
    class Bonus {
    
        class func windBonusChance() -> Double {
            return 0.15
        }
        
        class func waterBonusChance() -> Double {
            return 0.15
        }
        
        class func fireBonusChance() -> Double {
            return 0.3
        }
        
        class func ammoBonusChance() -> Double {
            return 0.1
        }
        
        class func lifeBonusChance() -> Double {
            return 0.05
        }
        
        class func bonusSize() -> CGSize {
            return CGSizeMake(screenSize.height / 8, screenSize.height / 8)
        }
        
        class func bonusTime() -> Int {
            return 10 * 50
        }
        
        class func bonusEmitterPath() -> String {
            return "bonusEmitter"
        }
    
    }
    class func defaultProjectileEmitterPath() -> String {
        return "earthProjectile.sks"
    }
}