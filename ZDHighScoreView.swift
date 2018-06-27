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
    
    override convenience init(texture: SKTexture!, color: UIColor, size: CGSize) {
        self.init(theSize: size)
    }
    
    init(theSize: CGSize) {
        let aColor = Constants.HighScore.HighScoreColor()
        let aSize = theSize
        super.init(texture: nil, color: aColor, size: aSize)
        self.color = aColor
        self.size = aSize
        position = Constants.HighScore.HighScorePosition()
        isUserInteractionEnabled = true
        
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
        for (i, score) in (model.scores.enumerated()) {
            let nameLabel = SKLabelNode(fontNamed: Constants.HighScore.FontName())
            let scoreLabel = SKLabelNode(fontNamed: Constants.HighScore.FontName())
            nameLabel.name = "name" + String(i)
            nameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            nameLabel.text = score.name
            scoreLabel.text = String(score.score)
            nameLabel.fontSize = Constants.HighScore.FontSize()
            scoreLabel.fontSize = Constants.HighScore.FontSize()
            
            if currentHighScoreIndex == i {
                nameLabel.fontColor = Constants.HUD.MultiplierBarx8Color()
                scoreLabel.fontColor = Constants.HUD.MultiplierBarx8Color()
            }
            
            let y: CGFloat = Constants.HighScore.LabelYIndent() - Constants.HighScore.LabelPadding() * CGFloat(i)
            nameLabel.position = CGPoint(x: Constants.HighScore.NameLabelX(), y: y)
            scoreLabel.position = CGPoint(x: Constants.HighScore.ScoreLabelX(), y: y)
            addChild(nameLabel)
            addChild(scoreLabel)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let location = touch.location(in: self)
        let node = atPoint(location)
        
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
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        alert.textField(at: 0)!.placeholder = ZDGameModel.sharedInstance.playerName
        alert.show()
        print("Hello")
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        var input = alertView.textField(at: 0)!.text
        if input == "" {
            input = alertView.textField(at: 0)!.placeholder
        }
        ZDGameModel.sharedInstance.playerName = input!
        model.scores[currentHighScoreIndex!].name = input!
        update()
        // Just to be safe
        ZDGameModel.sharedInstance.save()
    }
    
    func transitionOutThen(_ f: @escaping () -> ()) {
        ZDGameModel.sharedInstance.save()
        let backdrop = SKSpriteNode(color: UIColor.black, size: Constants.screenSize)
        backdrop.position = CGPoint(x: 0, y: (Constants.screenSize.height - size.height) / 2)
        backdrop.zPosition = 4
        addChild(backdrop)
        
        backdrop.run(Constants.Animations.BlackOutAnimation(), completion: {
            f()
        }) 
    }
    
}
