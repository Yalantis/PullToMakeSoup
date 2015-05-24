//
//  PocketSVG+Extension.swift
//  PullToMakeSoup
//
//  Created by Anastasiya Gorban on 4/21/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

public extension PocketSVG {
    class func pathFromSVGFileNamed(
        named: String,
        origin: CGPoint,
        mirrorX: Bool,
        mirrorY: Bool,
        scale: CGFloat) -> CGPath {
            
        let path = PocketSVG.pathFromSVGFileNamed(named)
        
        let bezierPath = UIBezierPath(CGPath: path.takeUnretainedValue())
        
        bezierPath.applyTransform(CGAffineTransformMakeScale(scale, scale))
        
        if mirrorX {
            let mirrorOverXOrigin = CGAffineTransformMakeScale(-1.0, 1.0)
            bezierPath.applyTransform(mirrorOverXOrigin)
        }
            
        if mirrorY {
            let mirrorOverYOrigin = CGAffineTransformMakeScale(1.0, -1.0)
            bezierPath.applyTransform(mirrorOverYOrigin)
        }
        
        let translate = CGAffineTransformMakeTranslation(origin.x - bezierPath.bounds.origin.x, origin.y - bezierPath.bounds.origin.y)
        bezierPath.applyTransform(translate)
        
        return bezierPath.CGPath
    }
}
