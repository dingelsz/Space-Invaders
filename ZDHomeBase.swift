//
//  ZDHomeBase.swift
//  The Game
//
//  Created by Zach Dingels on 10/22/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import Foundation
import SpriteKit

class ZDHomeBase: SKSpriteNode {
    
    struct ProjectileType {
        var delegate: ZDHomeBase? = nil
        var earthDuration: Int = -1 {
            willSet {
                if newValue == 0 {
                    if delegate != nil {
                        Timer.scheduledTimer(timeInterval: 0, target: delegate!, selector: #selector(ZDHomeBase.updateEmitter), userInfo: nil, repeats: false)
                    }
                }
            }
        }
        
        var windDuration: Int = 0 {
            willSet {
                if newValue == 0 {
                    if delegate != nil {
                        Timer.scheduledTimer(timeInterval: 0, target: delegate!, selector: #selector(ZDHomeBase.updateEmitter), userInfo: nil, repeats: false)
                    }
                }
            }
        }
        var waterDuration: Int = 0 {
            willSet {
                if newValue == 0 {
                    if delegate != nil {
                        Timer.scheduledTimer(timeInterval: 0, target: delegate!, selector: #selector(ZDHomeBase.updateEmitter), userInfo: nil, repeats: false)
                    }
                }
            }
        }
        var fireDuration: Int = 0 {
            willSet {
                if newValue == 0 {
                    if delegate != nil {
                        Timer.scheduledTimer(timeInterval: 0, target: delegate!, selector: #selector(ZDHomeBase.updateEmitter), userInfo: nil, repeats: false)
                    }
                }
            }
        }
    }
    
    var location = CGPoint.zero
    
    var projectileType = ProjectileType()
    var projectileEmitterPath = Constants.defaultProjectileEmitterPath()
    
    var cannonEmitter = SKEmitterNode(fileNamed: Constants.defaultProjectileEmitterPath())
    
    var shotQueue = [[CGPoint]]()
    var timer = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required convenience init() {
        self.init(texture: nil, color: UIColor.white, size: CGSize(width: 0, height: 0))
        projectileType.delegate = self
    }
    
    required override init(texture: SKTexture!, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    func queueShotAt(_ point: CGPoint) {
        var shot = [[point]]
        
        if projectileType.waterDuration > 0 {
            let pointVector = VectorOperation.CGVectorFromPoint(point)
            let pointAngleFromBottom = VectorOperation.angle(pointVector)
            let perpendicularAngle = (pointAngleFromBottom + Double.pi / 2).truncatingRemainder(dividingBy: (Double.pi * 2))
            var perpendicular = CGVector(dx: CGFloat(cos(perpendicularAngle)), dy: CGFloat(sin(perpendicularAngle)))
            perpendicular = VectorOperation.multiply(perpendicular, scale: 100)
            
            let pointLeft = CGPoint(x: point.x - perpendicular.dx, y: point.y - perpendicular.dx)
            let pointRight = CGPoint(x: point.x + perpendicular.dx, y: point.y + perpendicular.dx)
            shot[0] = shot[0] + [pointLeft, pointRight]
        }
        shotQueue.append(contentsOf: shot)
    }
    
    func update(_ scene: SKScene) {
        if cannonEmitter?.parent != scene {
            scene.addChild(cannonEmitter!)
            cannonEmitter?.position = location
            cannonEmitter?.zPosition = 2
        }
        
        if timer == 0 {
            if !shotQueue.isEmpty {
                for point in shotQueue[0] {
                    launchProjectileTowards(point, scene: scene)
                }
                shotQueue.remove(at: 0)
            }
        } else {
            timer = (timer + 1) % 20
        }
        
        if projectileType.windDuration > 0 {
            projectileType.windDuration -= 1
        }
        
        if projectileType.waterDuration > 0 {
            projectileType.waterDuration -= 1
        }
        
        if projectileType.fireDuration > 0 {
            projectileType.fireDuration -= 1
        }
    }
    
    
    func updateProjectileEmitterPath() {
        projectileEmitterPath = "earth"
        
        if projectileType.windDuration > 0 {
            if !projectileEmitterPath.isEmpty {
                projectileEmitterPath += "-"
            }
            projectileEmitterPath += "wind"
        }
        if projectileType.waterDuration > 0 {
            if !projectileEmitterPath.isEmpty {
                projectileEmitterPath += "-"
            }
            projectileEmitterPath += "water"
        }
        if projectileType.fireDuration > 0 {
            if !projectileEmitterPath.isEmpty {
                projectileEmitterPath += "-"
            }
            projectileEmitterPath += "fire"
        }
        
        projectileEmitterPath += "Projectile.sks"
    }
    
    func launchProjectileTowards(_ point: CGPoint, scene: SKScene) {
        let projectile = createProjectile()
        
        // Create a vector starting from the projectile ending at the touch and make a norm of that vector
        let touchPositionVector = VectorOperation.CGVectorFromPoint(point)
        let projectilePositionVector = VectorOperation.CGVectorFromPoint(projectile.position)
        let touchToProjectileVector = VectorOperation.subtract(touchPositionVector, vector2: projectilePositionVector)
        let touchToProjectileVectorNorm = VectorOperation.normalize(touchToProjectileVector)
        
        // Create a vector from the projectiles initial spot to the corner of the window
        let projectileScreenCornerVector = VectorOperation.subtract(VectorOperation.CGVectorFromSize(Constants.screenSize), vector2: VectorOperation.CGVectorFromPoint(projectile.position))
        // Scale variable to store how much the norm of the touchProjectileVector needs to be multipled by to move it
        // off the screen
        var scale: CGFloat
        
        // If the projectile will hit the left or right side first then find out the how much the normal vector needs
        // to be multiplied by to hit the wall. If its the top or the bottom then find out how much
        if abs(touchToProjectileVectorNorm.dx) > VectorOperation.normalize(projectileScreenCornerVector).dx {
            scale = abs(Constants.screenSize.width / VectorOperation.normalize(touchToProjectileVectorNorm).dx)
        } else {
            scale = abs(Constants.screenSize.height / VectorOperation.normalize(touchToProjectileVectorNorm).dy)
        }
        
        // Multiply the normal vector of the touchProjectile by the scale to get the vector needed to move the
        // Projectile off the screen. To get a constant speed divide the scale by a constant.
        let finalVector = VectorOperation.multiply(touchToProjectileVectorNorm, scale: Double(scale))
        let speed = projectileType.windDuration > 0 ? Double(scale) / Constants.Projectile.SpeedConstant() / 2: Double(scale) / Constants.Projectile.SpeedConstant()
        
        // Move the projectile with the vector then remove it from the parent once it finishes.
        let moveAction = SKAction.move(by: finalVector, duration: speed)
        
        projectile.emissionAngle = CGFloat(VectorOperation.angle(finalVector) + M_PI)
        projectile.run(moveAction, completion: {
            projectile.removeFromParent()}) 
        
        scene.addChild(projectile)
        print("\(self.projectileType)")
        
    }
    
    func createProjectile() -> SKEmitterNode {
        let projectile = SKEmitterNode(fileNamed: projectileEmitterPath)
        
        projectile?.name = projectileEmitterPath.replacingOccurrences(of: "Projectile.sks", with: "", options: NSString.CompareOptions.literal, range: nil)
        projectile?.position = location
        projectile?.physicsBody = SKPhysicsBody(rectangleOf: Constants.Projectile.projectileSize())
        projectile?.physicsBody?.isDynamic = false
        projectile?.physicsBody?.categoryBitMask = Constants.Bitmask.projectileBitmask()
        projectile?.physicsBody?.contactTestBitMask = Constants.Bitmask.enemyBitmask() | Constants.Bitmask.shieldBitmask()
        
        return projectile!
    }
    
    func gainBonus(_ bonusType: ZDBonus.BonusType) {
        switch bonusType {
        case .wind:
            projectileType.windDuration += Constants.Bonus.bonusTime()
        case .water:
            projectileType.waterDuration += Constants.Bonus.bonusTime()
        case .fire:
            projectileType.fireDuration += Constants.Bonus.bonusTime()
        case .ammo:
            ZDGameModel.sharedInstance.gainAmmo(5)
        case .life:
            ZDGameModel.sharedInstance.gainLife()
            
        }
        updateEmitter()
    }
    
    func updateEmitter() {
        updateProjectileEmitterPath()
        let parent = cannonEmitter?.parent
        cannonEmitter?.removeFromParent()
        cannonEmitter = SKEmitterNode(fileNamed: projectileEmitterPath)
        parent?.addChild(cannonEmitter!)
        cannonEmitter?.position = location
    }

}
