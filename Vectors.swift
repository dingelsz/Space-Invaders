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
    
    class func norm(_ vector: CGVector) -> Double {
        return sqrt(Double(vector.dx * vector.dx + vector.dy * vector.dy))
    }
    
    class func normalize(_ vector: CGVector) -> CGVector {
        let x = CGFloat(Double(vector.dx) / norm(vector))
        let y = CGFloat(Double(vector.dy) / norm(vector))
        return CGVector(dx: x, dy: y)
    }
    
    class func multiply(_ vector: CGVector, scale: Double) -> CGVector {
        let x = CGFloat(Double(vector.dx) * scale)
        let y = CGFloat(Double(vector.dy) * scale)
        return CGVector(dx: x, dy: y)
    }
    
    class func add(_ vector1: CGVector, vector2: CGVector) -> CGVector {
        return CGVector(dx: vector1.dx + vector2.dx, dy: vector1.dy + vector2.dy)
    }
    
    class func subtract(_ vector1: CGVector, vector2: CGVector) -> CGVector {
        return CGVector(dx: vector1.dx - vector2.dx, dy: vector1.dy - vector2.dy)
    }
    
    class func angle(_ vector: CGVector) -> Double {
        let unit = normalize(vector)
        var angle: Double
        if unit.dx > 0 && unit.dy > 0 {
            angle = atan(Double(vector.dy / vector.dx))
        } else if unit.dx < 0 && unit.dy > 0 {
            angle = atan(Double(vector.dy / vector.dx)) + Double.pi
        } else if unit.dx < 0 && unit.dy < 0 {
            angle = atan(Double(vector.dy / vector.dx)) + Double.pi
        } else {
            angle = atan(Double(vector.dy / vector.dx)) +  2 * Double.pi
        }
        return angle
    }
    
    class func CGVectorFromPoint(_ point: CGPoint) -> CGVector {
        return CGVector(dx: point.x, dy: point.y)
    }
    
    class func CGVectorFromSize(_ size: CGSize) -> CGVector {
        return CGVector(dx: size.width, dy: size.height)
    }
    
    class func CGPointFromVector(_ vector: CGVector) -> CGPoint {
        return CGPoint(x: vector.dx, y: vector.dy)
    }
    
    class func CGVectorToString(_ vector: CGVector) -> String {
        return "<\(vector.dx), \(vector.dy)>"
    }
}
