//
//  ZDBonus.swift
//  The Game
//
//  Created by Zach Dingels on 10/30/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import Foundation
import SpriteKit

class ZDBonus: SKSpriteNode {
    enum BonusType {
        case Wind, Water, Fire, Ammo, Life
    }
    
    let type: BonusType
    let emitter = SKEmitterNode(fileNamed: Constants.Bonus.bonusEmitterPath())
    
    required init?(coder aDecoder: NSCoder) {
        type = BonusType.Wind
        super.init(coder: aDecoder)
    }
    
    required init(size: CGSize, type: BonusType) {
        
        self.type = type
        var image: UIImage
        switch type {
        case .Wind:
            image = UIImage(named: Constants.ImagePath.windBonusPath())!
            emitter.particleColor = UIColor.whiteColor()
        case .Water:
            image = UIImage(named: Constants.ImagePath.waterBonusPath())!
            emitter.particleColor = UIColor(red: 84/255.0, green: 164/255.0, blue: 255/255.0, alpha: 1)
        case .Fire:
            image = UIImage(named: Constants.ImagePath.fireBonusPath())!
            emitter.particleColor = UIColor.redColor()
            
        case .Ammo:
            image = UIImage(named: Constants.ImagePath.ammoBonusPath())!
            emitter.particleColor = UIColor.brownColor()
            
        case .Life:
            image = UIImage(named: Constants.ImagePath.lifeBonusPath())!
            emitter.particleColor = UIColor.greenColor()
            
        }
        emitter.particleSize = size
        
        super.init(texture: SKTexture(image: image), color: UIColor(), size: size)
        zPosition = 1
        
        fadeOut()
    }
    
    private func fadeOut() {
        let fade = SKAction.fadeAlphaTo(0, duration: 10)
        runAction(fade) {
            self.removeFromParent()
        }
        emitter.runAction(fade) {
            self.emitter.removeFromParent()
        }
    }
    
    func remove() {
        removeFromParent()
        emitter.removeFromParent()
    }
    
    class func maybeBonusFor(enemyType: ZDEnemyShip.EnemyType) -> ZDBonus? {
        let rndNum = Double(arc4random_uniform(100)) / 100.0
        let bonusSize = Constants.Bonus.bonusSize()
        
        switch enemyType {
        case .Tank:
            if rndNum < Constants.Bonus.waterBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.Water)
            }
            
        case .Speedster:
            if rndNum < Constants.Bonus.windBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.Wind)
            }
            
        case .Ace:
            if rndNum < Constants.Bonus.fireBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.Fire)
            }
            
        default:
            if rndNum < Constants.Bonus.lifeBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.Life)
                
            } else if rndNum < Constants.Bonus.ammoBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.Ammo)
            }
        }
        return nil
    }
    
}