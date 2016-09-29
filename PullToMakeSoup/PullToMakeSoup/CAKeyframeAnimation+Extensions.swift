//
//  Created by Anastasiya Gorban on 4/20/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/PullToMakeSoup
//

import CoreGraphics

enum AnimationType: String {
    case Rotation = "transform.rotation.z"
    case Opacity = "opacity"
    case TranslationX = "transform.translation.x"
    case TranslationY = "transform.translation.y"
}

enum TimingFunction {
    case linear, easeIn, easeOut, easeInEaseOut
}

func mediaTimingFunction(_ function: TimingFunction) -> CAMediaTimingFunction {
    switch function {
    case .linear: return CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    case .easeIn: return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
    case .easeOut: return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    case .easeInEaseOut: return CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    }
}


extension CAKeyframeAnimation {
    class func animationWith(
        _ type: AnimationType,
        values:[Double],
        keyTimes:[Double],
        duration: Double,
        beginTime: Double) -> CAKeyframeAnimation {
                        
        let animation = CAKeyframeAnimation(keyPath: type.rawValue)
        animation.values = values
        animation.keyTimes = keyTimes as [NSNumber]?
        animation.duration = duration
        animation.beginTime = beginTime
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            
        return animation
    }
    
    class func animationPosition(_ path: CGPath, duration: Double, timingFunction: TimingFunction, beginTime: Double) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path
        animation.duration = duration
        animation.beginTime = beginTime
        animation.timingFunction = mediaTimingFunction(timingFunction)
        return animation
    }
}

extension UIView {
    func addAnimation(_ animation: CAKeyframeAnimation) {
        layer.add(animation, forKey: description + animation.keyPath!)
        layer.speed = 0
    }
    
    func removeAllAnimations() {
        layer.removeAllAnimations()
    }
}
