//
//  ZDLevels.swift
//  The Game
//
//  Created by Zach Dingels on 10/20/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//
/** This class keeps track of all the different Levels for the game
Types:
    Level
        Holds two functions that take a double and return a double from
        0...1 named x and y.

Methods:
    randomLevel()
        Gives back a random level from from this class
    straightLevel
        Level that goes straight horizontally
    bentUpLevel
        Level that makes an upside down V shape
    bentDownLevel
        Level that makes a V shape
*/

import Foundation
import SpriteKit

class ZDLevels {
    
    struct Level {
        var x: (Double) -> Double = {t in return t}
        var y: (Double) -> Double = {t in return t}
        var length: Double = 0
    }
    
    class func randomLevel() -> Level {
        let allLevels = [straightLevel(), bentUpLevel(), bentDownLevel(), curveUp(), curveDown(), arcUp(), arcDown(), sinn(), doubleSin(), coss(), doubleCos(), sDown(), sUp(), halfSDown(), halfSUp(), accelStraight(), beginSinEndLevel(), beginLevelEndSin(), beginSinLevelEndSin(), cubedDown(), cubedUp()]
        let randomLevelIndex = Int(arc4random_uniform(UInt32(allLevels.count)))
        return allLevels[randomLevelIndex]
    }
    
    class func easyLevel() -> Level {
        let allLevels = [straightLevel(), bentUpLevel(), bentDownLevel(), curveUp(), curveDown(), arcUp(), arcDown(), accelStraight(), cubedDown(), cubedUp()]
        let randomLevelIndex = Int(arc4random_uniform(UInt32(allLevels.count)))
        return allLevels[randomLevelIndex]
    }
    
    
    
    class func fastLevel() -> Level {
        let allLevels = [accelStraight(), beginSinEndLevel(), cubedDown(), cubedUp(), sinn(), coss(), doubleSin(), doubleCos()]
        let randomLevelIndex = Int(arc4random_uniform(UInt32(allLevels.count)))
        return allLevels[randomLevelIndex]
    }
    
    
    
    class func aceLevel() -> Level {
        let allLevels = [sinn(), doubleSin(), coss(), doubleCos(), sDown(), sUp(), halfSDown(), halfSUp(), accelStraight(), beginSinEndLevel(), beginLevelEndSin(), beginSinLevelEndSin(), cubedDown(), cubedUp()]
        let randomLevelIndex = Int(arc4random_uniform(UInt32(allLevels.count)))
        return allLevels[randomLevelIndex]
    }
    
    class func straightLevel() -> Level {
        let y = (Double(arc4random_uniform(200)) / 100.0) - 1
        let length = 1.0
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return y
        }
        
        return Level(x: xFunc, y: yFunc, length: length)
    }
    
    class func bentUpLevel() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            if t < 0.5 {
                return t / 0.5
            } else {
                return (1 - t) / 0.5
            }
        }
        
        return Level(x: xFunc, y: yFunc, length: 2.23)
    }
    
    class func bentDownLevel() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            if t < 0.5 {
                return t / -0.5
            } else {
                return (1 - t) / -0.5
            }
        }
        
        return Level(x: xFunc, y: yFunc, length: 2.23)
    }
    
    class func curveUp() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return t * t
        }
        
        return Level(x: xFunc, y: yFunc, length: 1.48)
    }
    
    class func curveDown() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return -t * t
        }
        
        return Level(x: xFunc, y: yFunc, length: 1.48)
    }
    
    class func arcUp() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return 4 * ((-t * t) + t)
        }
        
        return Level(x: xFunc, y: yFunc, length: 2.32)
    }
    
    
    
    class func arcDown() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return -4 * ((-t * t) + t)
        }
        
        return Level(x: xFunc, y: yFunc, length: 2.32)
    }
    
    // Two nn because of sin function
    class func sinn() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return sin(t * 2 * M_PI)
        }
        
        return Level(x: xFunc, y: yFunc, length: 4.19)
    }
    
    class func doubleSin() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return sin(t * 4 * M_PI) * t * t
        }
        
        return Level(x: xFunc, y: yFunc, length: 8.11)
    }
    
    class func coss() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return cos(t * 2 * M_PI)
        }
        
        return Level(x: xFunc, y: yFunc, length: 4.19)
    }
    
    class func doubleCos() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return cos(t * 4 * M_PI)
        }
        
        return Level(x: xFunc, y: yFunc, length: 8.11)
    }
    
    class func sDown() -> Level {
        func xFunc(time t: Double) -> Double {
            return (-cos(t * 3 * M_PI) + 1) / 2
            
        }
        
        func yFunc(time t: Double) -> Double {
            return 1 - 2 * t
        }
        
        return Level(x: xFunc, y: yFunc, length: 3.73)
    }
    
    class func sUp() -> Level {
        func xFunc(time t: Double) -> Double {
            return (-cos(t * 3 * M_PI) + 1) / 2
            
        }
        
        func yFunc(time t: Double) -> Double {
            return 2 * t - 1
        }
        
        return Level(x: xFunc, y: yFunc, length: 3.73)
    }
    
    class func halfSDown() -> Level {
        func xFunc(time t: Double) -> Double {
            return (-cos(t * 3 * M_PI) + 1) / 2 * t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return 1 - (2 * t)
        }
        
        return Level(x: xFunc, y: yFunc, length: 2.8)
    }
    
    class func halfSUp() -> Level {
        func xFunc(time t: Double) -> Double {
            return (-cos(t * 3 * M_PI) + 1) / 2 * t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return 2 * t - 1
        }
        
        return Level(x: xFunc, y: yFunc, length: 2.8)
    }
    
    class func accelStraight() -> Level {
        let y = (Double(arc4random_uniform(200)) / 100.0) - 1
        func xFunc(time t: Double) -> Double {
            return t * t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return y
        }
        
        return Level(x: xFunc, y: yFunc, length: 1)
    }
    
    class func beginSinLevelEndSin() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return sin((2 * t - 0.8) * 4 * M_PI) * pow((2 * t - 1), 2)
        }
        
        return Level(x: xFunc, y: yFunc, length: 5.77)
    }
    
    class func beginLevelEndSin() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return sin(t * 4 * M_PI) * t * t
        }
        
        return Level(x: xFunc, y: yFunc, length: 3.11)
    }
    
    class func beginSinEndLevel() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return sin((t - 1) * 4 * M_PI) * pow(t - 1, 2)
        }
        
        return Level(x: xFunc, y: yFunc, length: 3.11)
    }
    
    class func cubedDown() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return -pow(2 * t - 1, 3)
        }
        
        return Level(x: xFunc, y: yFunc, length: 2.42)
    }
    
    class func cubedUp() -> Level {
        func xFunc(time t: Double) -> Double {
            return t
            
        }
        
        func yFunc(time t: Double) -> Double {
            return pow(2 * t - 1, 3)
        }
        return Level(x: xFunc, y: yFunc, length: 2.42)
    }
}