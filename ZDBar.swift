//
//  ZDBar.swift
//  The Game
//
//  Created by Zach Dingels on 11/5/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import Foundation
import SpriteKit

class ZDBar: SKSpriteNode {
    
    var fillPercent: Double = 0.0 {
        willSet {
            self.size = CGSize(width: fullSize.width * CGFloat(newValue), height: fullSize.height)
        }
    }
    var fullSize = CGSize.zero
    
}
