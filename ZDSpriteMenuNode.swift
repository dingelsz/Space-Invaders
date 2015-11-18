//
//  ZDSpriteMenuNode.swift
//  The Game
//
//  Created by Zach Dingels on 11/10/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import Foundation
import SpriteKit

class ZDSpriteMenuNode: SKSpriteNode {
    
    let playButton = FTButtonNode(normalTexture: SKTexture(imageNamed: "play.png"), selectedTexture: SKTexture(imageNamed: "playPressed.png"), disabledTexture: nil)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    override init() {
        super.init()
        self.color = Constants.Menu.backgroundColor
        self.size = Constants.Menu.backgroundSize
        self.position = Constants.Menu.backgroundPosition
        self.userInteractionEnabled = true
        self.zPosition = 1
        
        initPlayButton()
    }
    
    func initPlayButton() {
        playButton.position = Constants.Menu.playButtonPosition
        playButton.size = CGSizeMake(size.width, size.width * 0.13)
        playButton.name = "play"
        playButton.setButtonAction(self, triggerEvent: FTButtonNode.FTButtonActionType.TouchUp, action: "transitionOutThen")
        addChild(playButton)
    }
    
    func transitionOutThen() {
        let backdrop = SKSpriteNode(color: UIColor.blackColor(), size: Constants.screenSize)
        backdrop.position = CGPointMake(Constants.screenSize.width - size.width, 0)
        backdrop.zPosition = 4
        addChild(backdrop)
        backdrop.runAction(Constants.Animations.BlackOutAnimation()) {
            Constants.presentQuickPlayViewController()
        }
    }
    
}