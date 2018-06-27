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
    
    convenience init() {
        let aColor = Constants.Menu.backgroundColor
        let aSize = Constants.Menu.backgroundSize
        self.init(texture: nil, color: aColor, size: aSize)
        
        self.color = aColor
        self.size = aSize
        self.position = Constants.Menu.backgroundPosition
        self.isUserInteractionEnabled = true
        self.zPosition = 1
        
        initPlayButton()
    }
    
    func initPlayButton() {
        playButton.position = Constants.Menu.playButtonPosition
        playButton.size = CGSize(width: size.width, height: size.width * 0.13)
        playButton.name = "play"
        playButton.setButtonAction(self, triggerEvent: FTButtonNode.FTButtonActionType.touchUp, action: #selector(ZDSpriteMenuNode.transitionOutThen))
        addChild(playButton)
    }
    
    func transitionOutThen() {
        let backdrop = SKSpriteNode(color: UIColor.black, size: Constants.screenSize)
        backdrop.position = CGPoint(x: Constants.screenSize.width - size.width, y: 0)
        backdrop.zPosition = 4
        addChild(backdrop)
        backdrop.run(Constants.Animations.BlackOutAnimation(), completion: {
            Constants.presentQuickPlayViewController()
        }) 
    }
    
}
