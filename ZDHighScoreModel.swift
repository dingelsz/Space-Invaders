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
        name = aDecoder.decodeObject(forKey: Constants.HighScore.nameKey) as! String
        score = aDecoder.decodeInteger(forKey: Constants.HighScore.scoreKey)
    }
    
    func encode(with aCoder: NSCoder) {
        if (name.range(of: Constants.HighScore.editMessage) != nil) {
            name = name.replacingOccurrences(of: Constants.HighScore.editMessage, with: "", options: NSString.CompareOptions.literal, range: nil)
        }
        aCoder.encode(name, forKey: Constants.HighScore.nameKey)
        aCoder.encode(score, forKey: Constants.HighScore.scoreKey)
    }
}


class ZDHighScoreModel: NSObject {
    
    var scores = [HighScore(name: Constants.GameData.playerName, score: 0),
        HighScore(name: Constants.GameData.playerName, score: 0),
        HighScore(name: Constants.GameData.playerName, score: 0),
        HighScore(name: Constants.GameData.playerName, score: 0),
        HighScore(name: Constants.GameData.playerName, score: 0)]
    
    fileprivate var dataPath = Constants.HighScore.DataPath()
    
    override init() {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: dataPath) as? [HighScore]? {
            if data != nil {
                scores = data!
            }
        }
        super.init()
    }
    
    func save() {
        if NSKeyedArchiver.archiveRootObject(scores, toFile: dataPath) {
            print("Scores Saved")
        } else {
            print("Scores Not saved")
        }
    }
    
    func isHighScore(_ score: Int) -> Bool {
        return scores.filter{$0.score < score}.count > 0
    }
    
    func addScore(_ name: String, score n: Int) {
        let newScoreIndex = scores.filter{$0.score > n}.count
        scores.insert(HighScore(name: name + " " + Constants.HighScore.editMessage, score: n), at: newScoreIndex)
        scores.removeLast()
    }
    
}
