//
//  ZDHud.swift
//  The Game
//
//  Created by Zach Dingels on 11/6/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import Foundation
import SpriteKit

class ZDHud: SKSpriteNode {
    
    let multiplierBar = ZDBar(color: UIColor.whiteColor(), size: CGSizeZero)
    
    let scoreLabel = SKLabelNode(fontNamed: Constants.HUD.FontName())
    let ammoLabel = SKLabelNode(fontNamed: Constants.HUD.FontName())
    let lifesLabel = SKLabelNode(fontNamed: Constants.HUD.FontName())
    let multiplierLabel = SKLabelNode(fontNamed: Constants.HUD.FontName())
    let highScoreView = ZDHighScoreView(size: Constants.HighScore.HighScoreSize())
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(size: CGSize) {
        super.init(texture: SKTexture(imageNamed: Constants.ImagePath.HUDImagePath()), color: UIColor(), size: size)
        
        position = Constants.screenCenter
        zPosition = 1
        
        multiplierBar.fullSize = Constants.HUD.MultiplierBarFrame().size
        multiplierBar.position = Constants.HUD.MultiplierBarFrame().origin
        multiplierBar.fillPercent = 0
        multiplierBar.zPosition = 2
        addChild(multiplierBar)
        addChild(highScoreView)
        
        initLabels()
        initHighScoreBackground()
    }
    
    func initLabels() {
        scoreLabel.fontColor = Constants.HUD.FontColor()
        scoreLabel.fontSize = Constants.HUD.FontSize()
        scoreLabel.position = Constants.HUD.ScoreLabelPosition()
        scoreLabel.zPosition = 2
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        addChild(scoreLabel)
        
        ammoLabel.fontColor = Constants.HUD.FontColor()
        ammoLabel.fontSize = Constants.HUD.FontSize()
        ammoLabel.position = Constants.HUD.AmmoLabelPosition()
        ammoLabel.zPosition = 2
        ammoLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        addChild(ammoLabel)
        
        lifesLabel.fontColor = Constants.HUD.FontColor()
        lifesLabel.fontSize = Constants.HUD.FontSize()
        lifesLabel.position = Constants.HUD.LifeLabelPosition()
        lifesLabel.zPosition = 2
        lifesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        addChild(lifesLabel)
        
        multiplierLabel.fontColor = Constants.HUD.FontColor()
        multiplierLabel.fontSize = Constants.HUD.MultiplierFontSize()
        multiplierLabel.position = Constants.HUD.MultiplierLabelPosition()
        multiplierLabel.zPosition = 2
        multiplierLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        addChild(multiplierLabel)
    }
    
    func initHighScoreBackground() {
        //highScoreView.position = Constants.HUD.HighScorePosition()
        //addChild(highScoreView)
    }
    
    func updateLabels() {
        scoreLabel.text = Constants.HUD.ScoreLabelText()
        ammoLabel.text = Constants.HUD.AmmoLabelText()
        lifesLabel.text = Constants.HUD.LifeLabelText()
        multiplierLabel.fontColor = Constants.HUD.MultiplierTextColor()
        multiplierLabel.text = Constants.HUD.MultiplierLabelText()
    }
    
    func updateBar() {
        multiplierBar.fillPercent = ZDGameModel.sharedInstance.killStreak < 39 ? (Double(ZDGameModel.sharedInstance.killStreak % 10)) / 10.0: 1
        
        switch ZDGameModel.sharedInstance.scoreMultiplier {
        case 1:
            multiplierBar.color = Constants.HUD.MultiplierBarx1Color()
        case 2:
            multiplierBar.color = Constants.HUD.MultiplierBarx2Color()
        case 4:
            multiplierBar.color = Constants.HUD.MultiplierBarx4Color()
        case 8:
            multiplierBar.color = Constants.HUD.MultiplierBarx8Color()
        default:
            multiplierBar.color = UIColor.whiteColor()
        }
    }
    
    func update() {
        updateBar()
        updateLabels()
    }
    
    func scrollUp() {
        let moveByY: CGFloat = Constants.HUD.ScrollUpDistance()
        let initialY = position.y
        let rampScrollAction = SKAction.customActionWithDuration(Constants.HUD.ScrollUpTime()) { node, time in
            let timePercent = Double(time) / Constants.HUD.ScrollUpTime()
            let displacement = CGFloat(sqrt(pow(timePercent, 5)) * Double(moveByY))
            node.position = CGPointMake(node.position.x, initialY + displacement)
        }
        
        self.runAction(rampScrollAction)
        
        multiplierLabel.hidden = true
    }
    
    func updatHighScores(index: Int?) {
        highScoreView.currentHighScoreIndex = index
        highScoreView.update()
    }
}