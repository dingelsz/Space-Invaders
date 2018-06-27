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
        case wind, water, fire, ammo, life
    }
    
    let type: BonusType
    let emitter = SKEmitterNode(fileNamed: Constants.Bonus.bonusEmitterPath())
    
    required init?(coder aDecoder: NSCoder) {
        type = BonusType.wind
        super.init(coder: aDecoder)
    }
    
    required init(size: CGSize, type: BonusType) {
        
        self.type = type
        var image: UIImage
        switch type {
        case .wind:
            image = UIImage(named: Constants.ImagePath.windBonusPath())!
            emitter?.particleColor = UIColor.white
        case .water:
            image = UIImage(named: Constants.ImagePath.waterBonusPath())!
            emitter?.particleColor = UIColor(red: 84/255.0, green: 164/255.0, blue: 255/255.0, alpha: 1)
        case .fire:
            image = UIImage(named: Constants.ImagePath.fireBonusPath())!
            emitter?.particleColor = UIColor.red
            
        case .ammo:
            image = UIImage(named: Constants.ImagePath.ammoBonusPath())!
            emitter?.particleColor = UIColor.brown
            
        case .life:
            image = UIImage(named: Constants.ImagePath.lifeBonusPath())!
            emitter?.particleColor = UIColor.green
            
        }
        emitter?.particleSize = size
        
        super.init(texture: SKTexture(image: image), color: UIColor(), size: size)
        zPosition = 1
        
        fadeOut()
    }
    
    fileprivate func fadeOut() {
        let fade = SKAction.fadeAlpha(to: 0, duration: 10)
        run(fade, completion: {
            self.removeFromParent()
        }) 
        emitter?.run(fade) {
            self.emitter?.removeFromParent()
        }
    }
    
    func remove() {
        removeFromParent()
        emitter?.removeFromParent()
    }
    
    class func maybeBonusFor(_ enemyType: ZDEnemyShip.EnemyType) -> ZDBonus? {
        let rndNum = Double(arc4random_uniform(100)) / 100.0
        let bonusSize = Constants.Bonus.bonusSize()
        
        switch enemyType {
        case .tank:
            if rndNum < Constants.Bonus.waterBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.water)
            }
            
        case .speedster:
            if rndNum < Constants.Bonus.windBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.wind)
            }
            
        case .ace:
            if rndNum < Constants.Bonus.fireBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.fire)
            }
            
        default:
            if rndNum < Constants.Bonus.lifeBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.life)
                
            } else if rndNum < Constants.Bonus.ammoBonusChance() {
                return ZDBonus(size: bonusSize, type: BonusType.ammo)
            }
        }
        return nil
    }
    
}
