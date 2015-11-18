//
//  ZDHighScoreVIew.swift
//  The Game
//
//  Created by Zach Dingels on 11/6/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import Foundation
import SpriteKit

class ZDHighScoreView: SKSpriteNode, UIAlertViewDelegate {
    
    let model = ZDGameModel.sharedInstance.highScores
    let replayButton = SKSpriteNode(imageNamed: Constants.ImagePath.ReplayImagePath())
    let homeButton = SKSpriteNode(imageNamed: Constants.ImagePath.HomeImagePath())
    var currentHighScoreIndex: Int?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(size: CGSize) {
        super.init()
        self.color = Constants.HighScore.HighScoreColor()
        self.size = size
        self.position = Constants.HighScore.HighScorePosition()
        self.userInteractionEnabled = true
        
        update()
        initButtons()
    }
    
    func initButtons() {
        replayButton.size = Constants.HighScore.ReplayButtonSize()
        replayButton.position = Constants.HighScore.ReplayButtonLocation()
        replayButton.name = Constants.HighScore.ReplayButtonName()
        
        homeButton.size = Constants.HighScore.HomeButtonSize()
        homeButton.position = Constants.HighScore.HomeButtonLocation()
        homeButton.name = Constants.HighScore.HomeButtonName()
    }
    
    func update() {
        removeAllChildren()
        addChild(replayButton)
        addChild(homeButton)
        for (i, score) in enumerate(model.scores) {
            let nameLabel = SKLabelNode(fontNamed: Constants.HighScore.FontName())
            let scoreLabel = SKLabelNode(fontNamed: Constants.HighScore.FontName())
            nameLabel.name = "name" + String(i)
            nameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            nameLabel.text = score.name
            scoreLabel.text = String(score.score)
            nameLabel.fontSize = Constants.HighScore.FontSize()
            scoreLabel.fontSize = Constants.HighScore.FontSize()
            
            if currentHighScoreIndex == i {
                nameLabel.fontColor = Constants.HUD.MultiplierBarx8Color()
                scoreLabel.fontColor = Constants.HUD.MultiplierBarx8Color()
            }
            
            let y: CGFloat = Constants.HighScore.LabelYIndent() - Constants.HighScore.LabelPadding() * CGFloat(i)
            nameLabel.position = CGPointMake(Constants.HighScore.NameLabelX(), y)
            scoreLabel.position = CGPointMake(Constants.HighScore.ScoreLabelX(), y)
            addChild(nameLabel)
            addChild(scoreLabel)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch: AnyObject? = touches.anyObject()
        let location = touch?.locationInNode(self)
        let node = nodeAtPoint(location!)
        
        if (node.name == replayButton.name) {
            transitionOutThen(Constants.rootViewController.playGame)
        }
        
        if (node.name == homeButton.name) {
            transitionOutThen(Constants.presentMenuViewController)
        }
        
        if currentHighScoreIndex != nil {
            if node.name == "name" + String(currentHighScoreIndex!) {
                popUpInput()
            }
        }
    }
    
    func popUpInput() {
        let alert = UIAlertView(title: "Edit High Score", message: "Enter a new name:", delegate: self, cancelButtonTitle: "Enter")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.textFieldAtIndex(0)!.placeholder = ZDGameModel.sharedInstance.playerName
        alert.show()
        println("Hello")
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        var input = alertView.textFieldAtIndex(0)!.text
        if input == "" {
            input = alertView.textFieldAtIndex(0)!.placeholder
        }
        ZDGameModel.sharedInstance.playerName = input
        model.scores[currentHighScoreIndex!].name = input
        update()
        // Just to be safe
        ZDGameModel.sharedInstance.save()
    }
    
    func transitionOutThen(f: () -> ()) {
        ZDGameModel.sharedInstance.save()
        let backdrop = SKSpriteNode(color: UIColor.blackColor(), size: Constants.screenSize)
        backdrop.position = CGPointMake(0, (Constants.screenSize.height - size.height) / 2)
        backdrop.zPosition = 4
        addChild(backdrop)
        
        backdrop.runAction(Constants.Animations.BlackOutAnimation()) {
            f()
        }
    }
    
}