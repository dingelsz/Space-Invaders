//
//  ZDHighScoreModel.swift
//  The Game
//
//  Created by Zach Dingels on 11/7/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import Foundation

class HighScore: NSObject, NSCoding {
    var name: String
    var score: Int
    
    init(name aName: String, score aScore: Int) {
        name = aName
        score = aScore
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey(Constants.HighScore.nameKey) as String
        score = aDecoder.decodeIntegerForKey(Constants.HighScore.scoreKey)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if (name.rangeOfString(Constants.HighScore.editMessage) != nil) {
            name = name.stringByReplacingOccurrencesOfString(Constants.HighScore.editMessage, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        aCoder.encodeObject(name, forKey: Constants.HighScore.nameKey)
        aCoder.encodeInteger(score, forKey: Constants.HighScore.scoreKey)
    }
}


class ZDHighScoreModel: NSObject {
    
    var scores = [HighScore(name: Constants.GameData.playerName, score: 0),
        HighScore(name: Constants.GameData.playerName, score: 0),
        HighScore(name: Constants.GameData.playerName, score: 0),
        HighScore(name: Constants.GameData.playerName, score: 0),
        HighScore(name: Constants.GameData.playerName, score: 0)]
    
    private var dataPath = Constants.HighScore.DataPath()
    
    override init() {
        if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(dataPath) as? [HighScore]? {
            if data != nil {
                scores = data!
            }
        }
        super.init()
    }
    
    func save() {
        if NSKeyedArchiver.archiveRootObject(scores, toFile: dataPath) {
            println("Scores Saved")
        } else {
            println("Scores Not saved")
        }
    }
    
    func isHighScore(score: Int) -> Bool {
        return scores.filter{$0.score < score}.count > 0
    }
    
    func addScore(name: String, score n: Int) {
        let newScoreIndex = scores.filter{$0.score > n}.count
        scores.insert(HighScore(name: name + " " + Constants.HighScore.editMessage, score: n), atIndex: newScoreIndex)
        scores.removeLast()
    }
    
}