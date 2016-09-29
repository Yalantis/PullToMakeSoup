//
//  Created by Anastasiya Gorban on 4/21/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/PullToMakeSoup
//

public extension PocketSVG {
    
    class func pathFromSVGFileNamed(
        _ named: String,
        origin: CGPoint,
        mirrorX: Bool,
        mirrorY: Bool,
        scale: CGFloat) -> CGPath {
            
        let path = PocketSVG.path(fromSVGFileNamed: named)
        
        let bezierPath = UIBezierPath(cgPath: (path?.takeUnretainedValue())!)
        
        bezierPath.apply(CGAffineTransform(scaleX: scale, y: scale))
        
        if mirrorX {
            let mirrorOverXOrigin = CGAffineTransform(scaleX: -1.0, y: 1.0)
            bezierPath.apply(mirrorOverXOrigin)
        }
            
        if mirrorY {
            let mirrorOverYOrigin = CGAffineTransform(scaleX: 1.0, y: -1.0)
            bezierPath.apply(mirrorOverYOrigin)
        }
        
        let translate = CGAffineTransform(translationX: origin.x - bezierPath.bounds.origin.x, y: origin.y - bezierPath.bounds.origin.y)
        bezierPath.apply(translate)
        
        return bezierPath.cgPath
    }
}
