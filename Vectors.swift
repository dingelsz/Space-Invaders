//
//  Vectors.swift
//  The Game
//
//  Created by Zach Dingels on 10/6/14.
//  Copyright (c) 2014 Zach Dingels. All rights reserved.
//

import Foundation
import CoreGraphics

class VectorOperation {
    
    class func norm(vector: CGVector) -> Double {
        return sqrt(Double(vector.dx * vector.dx + vector.dy * vector.dy))
    }
    
    class func normalize(vector: CGVector) -> CGVector {
        let x = CGFloat(Double(vector.dx) / norm(vector))
        let y = CGFloat(Double(vector.dy) / norm(vector))
        return CGVectorMake(x, y)
    }
    
    class func multiply(vector: CGVector, scale: Double) -> CGVector {
        let x = CGFloat(Double(vector.dx) * scale)
        let y = CGFloat(Double(vector.dy) * scale)
        return CGVectorMake(x, y)
    }
    
    class func add(vector1: CGVector, vector2: CGVector) -> CGVector {
        return CGVectorMake(vector1.dx + vector2.dx, vector1.dy + vector2.dy)
    }
    
    class func subtract(vector1: CGVector, vector2: CGVector) -> CGVector {
        return CGVectorMake(vector1.dx - vector2.dx, vector1.dy - vector2.dy)
    }
    
    class func angle(vector: CGVector) -> Double {
        let unit = normalize(vector)
        var angle: Double
        if unit.dx > 0 && unit.dy > 0 {
            angle = atan(Double(vector.dy / vector.dx))
        } else if unit.dx < 0 && unit.dy > 0 {
            angle = atan(Double(vector.dy / vector.dx)) + M_PI
        } else if unit.dx < 0 && unit.dy < 0 {
            angle = atan(Double(vector.dy / vector.dx)) + M_PI
        } else {
            angle = atan(Double(vector.dy / vector.dx)) +  2 * M_PI
        }
        return angle
    }
    
    class func CGVectorFromPoint(point: CGPoint) -> CGVector {
        return CGVectorMake(point.x, point.y)
    }
    
    class func CGVectorFromSize(size: CGSize) -> CGVector {
        return CGVectorMake(size.width, size.height)
    }
    
    class func CGPointFromVector(vector: CGVector) -> CGPoint {
        return CGPointMake(vector.dx, vector.dy)
    }
    
    class func CGVectorToString(vector: CGVector) -> String {
        return "<\(vector.dx), \(vector.dy)>"
    }
}