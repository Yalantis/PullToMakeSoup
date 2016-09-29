//
//  Created by Anastasiya Gorban on 4/14/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at https://github.com/Yalantis/PullToMakeSoup
//

import Foundation
import UIKit
import PullToRefresh

open class PullToMakeSoup: PullToRefresh {
    
    public convenience init(at position: Position = .top) {
        let refreshView = Bundle(for: type(of: self)).loadNibNamed("SoupView", owner: nil, options: nil)!.first as! SoupView
        let animator =  SoupAnimator(refreshView: refreshView)
        self.init(refreshView: refreshView, animator: animator, height : refreshView.frame.size.height, position : position)
    }
}

class SoupView: UIView {
    @IBOutlet
    fileprivate var pan: UIImageView!
    @IBOutlet
    fileprivate var cover: UIImageView!
    @IBOutlet
    fileprivate var potato: UIImageView!
    @IBOutlet
    fileprivate var leftPea: UIImageView!
    @IBOutlet
    fileprivate var rightPea: UIImageView!
    @IBOutlet
    fileprivate var carrot: UIImageView!
    @IBOutlet
    fileprivate var circle: UIImageView!
    @IBOutlet
    fileprivate var water: UIImageView!
    @IBOutlet
    fileprivate var flame: UIImageView!
    @IBOutlet
    fileprivate var shadow: UIImageView!
}

class SoupAnimator: NSObject, RefreshViewAnimator {
    
    fileprivate let refreshView: SoupView
    fileprivate let refreshViewHeight: CGFloat

    fileprivate var bubbleTimer: Timer?
    
    fileprivate let animationDuration = 0.3
    
    init(refreshView: SoupView) {
        self.refreshView = refreshView
        self.refreshViewHeight = refreshView.frame.size.height
    }
    
    public func animate(_ state: State) {
        switch state {
        case .initial:
            initalLayout()
        case .releasing(let progress):
            releasingAnimation(progress)
        case .loading:
            startLoading()
        case .finished:
            bubbleTimer?.invalidate()
        }
    }
    
    // MARK: - Helpers
    
    func initalLayout() {
        let centerX = refreshView.frame.size.width / 2
        
        // Circle
        refreshView.circle.center = CGPoint(x: centerX, y: refreshViewHeight / 2)
        
        // Carrot
        refreshView.carrot.removeAllAnimations()
        
        refreshView.carrot.addAnimation(
            CAKeyframeAnimation.animationPosition(
                PocketSVG.pathFromSVGFileNamed("carrot-path-only",
                    origin: CGPoint(x: centerX + 11, y: 10),
                    mirrorX: true,
                    mirrorY: false,
                    scale: 0.5),
                duration: animationDuration,
                timingFunction:TimingFunction.easeIn,
                beginTime:0)
        )
        
        refreshView.carrot.addAnimation(CAKeyframeAnimation.animationWith(
            AnimationType.Rotation,
            values: [4.131, 5.149, 6.294],
            keyTimes: [0, 0.5, 1],
            duration: animationDuration,
            beginTime:0))
        refreshView.carrot.addAnimation(CAKeyframeAnimation.animationWith(
            AnimationType.Opacity,
            values: [0, 1],
            keyTimes: [0, 1],
            duration: animationDuration,
            beginTime: 0))
        
        refreshView.carrot.layer.timeOffset = 0.0
        
        // Pan
        refreshView.pan.removeAllAnimations()
        
        refreshView.pan.center = CGPoint(x: centerX, y: refreshView.pan.center.y)
        refreshView.pan.addAnimation(CAKeyframeAnimation.animationWith(
            AnimationType.TranslationY,
            values: [-200, 0],
            keyTimes: [0, 0.5],
            duration: animationDuration,
            beginTime:0))
        refreshView.shadow.alpha = 0
        refreshView.shadow.center = CGPoint(x: centerX + 11, y: refreshView.shadow.center.y)
        refreshView.pan.layer.timeOffset = 0.0
        
        // Water
        
        refreshView.water.center = CGPoint(x: centerX, y: refreshView.water.center.y)
        refreshView.water.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        refreshView.water.transform = CGAffineTransform(scaleX: 1, y: 0.00001);
        
        // Potato
        refreshView.potato.removeAllAnimations()
        
        refreshView.potato.addAnimation(
            CAKeyframeAnimation.animationPosition(
                PocketSVG.pathFromSVGFileNamed("potato-path-only",
                    origin: CGPoint(x: centerX - 65, y: 5),
                    mirrorX: true,
                    mirrorY: false,
                    scale: 1),
                duration: animationDuration,
                timingFunction:TimingFunction.easeIn,
                beginTime:0)
        )
        
        refreshView.potato.addAnimation(
            CAKeyframeAnimation.animationWith(
                AnimationType.Opacity,
                values: [0, 1],
                keyTimes: [0, 1],
                duration: animationDuration,
                beginTime:0)
        )
        
        refreshView.potato.addAnimation(CAKeyframeAnimation.animationWith(
            AnimationType.Rotation,
            values: [5.663, 4.836, 3.578],
            keyTimes: [0, 0.5, 1],
            duration: animationDuration,
            beginTime:0))
        
        refreshView.potato.layer.timeOffset = 0.0
        
        // Left pea
        refreshView.leftPea.removeAllAnimations()
        
        refreshView.leftPea.addAnimation(
            CAKeyframeAnimation.animationPosition(
                PocketSVG.pathFromSVGFileNamed("pea-from-left-path-only",
                    origin: CGPoint(x: centerX - 80, y: 12),
                    mirrorX: false,
                    mirrorY: false,
                    scale: 1),
                duration: animationDuration,
                timingFunction:TimingFunction.easeIn,
                beginTime:0)
        )
        
        refreshView.leftPea.addAnimation(
            CAKeyframeAnimation.animationWith(
                AnimationType.Opacity,
                values: [0, 1],
                keyTimes: [0, 1],
                duration: animationDuration,
                beginTime:0)
        )
        
        refreshView.leftPea.layer.timeOffset = 0.0
        
        // Right pea
        refreshView.rightPea.removeAllAnimations()
        
        refreshView.rightPea.addAnimation(
            CAKeyframeAnimation.animationPosition(
                PocketSVG.pathFromSVGFileNamed("pea-from-right-path-only",
                    origin: CGPoint(x: centerX - 10, y: -13),
                    mirrorX: true,
                    mirrorY: false,
                    scale: 1),
                duration: animationDuration,
                timingFunction:TimingFunction.easeIn,
                beginTime:0)
        )
        
        refreshView.rightPea.addAnimation(
            CAKeyframeAnimation.animationWith(
                AnimationType.Opacity,
                values: [0, 1],
                keyTimes: [0, 1],
                duration: animationDuration,
                beginTime:0)
        )
        
        refreshView.rightPea.layer.timeOffset = 0.0
        
        // Flame
        
        refreshView.flame.center = CGPoint(x: refreshView.frame.size.width / 2, y: refreshView.flame.center.y)
        refreshView.flame.image = nil
        refreshView.flame.stopAnimating()
        refreshView.flame.animationImages = nil
        
        // Cover
        
        refreshView.cover.layer.anchorPoint = CGPoint(x: 1, y: 0.5)        
        refreshView.cover.center = CGPoint(x: refreshView.frame.size.width / 2 + refreshView.cover.frame.size.width/2, y: refreshView.cover.center.y)
        
        refreshView.cover.removeAllAnimations()
        
        refreshView.cover.addAnimation(
            CAKeyframeAnimation.animationPosition(
                PocketSVG.pathFromSVGFileNamed("cover-path-only",
                    origin: CGPoint(x: refreshView.pan.center.x + 34, y: -51),
                    mirrorX: true,
                    mirrorY: true,
                    scale: 0.5),
                duration: animationDuration,
                timingFunction:TimingFunction.easeIn,
                beginTime:0)
        )
        
        refreshView.cover.addAnimation(
            CAKeyframeAnimation.animationWith(
                AnimationType.Rotation,
                values: [2.009, 0],
                keyTimes: [0, 1],
                duration: animationDuration,
                beginTime:0)
        )
        
        refreshView.cover.layer.timeOffset = 0.0
    }
    
    func startLoading() {
        refreshView.circle.center = CGPoint(x: refreshView.frame.size.width / 2, y: refreshView.frame.size.height / 2)
        refreshView.carrot.layer.timeOffset = animationDuration
        refreshView.pan.layer.timeOffset = animationDuration
        refreshView.potato.layer.timeOffset = animationDuration
        refreshView.leftPea.layer.timeOffset = animationDuration
        refreshView.rightPea.layer.timeOffset = animationDuration
        refreshView.cover.layer.timeOffset = animationDuration
        
        // Water & Cover
        refreshView.water.center = CGPoint(x: refreshView.water.center.x, y: refreshView.pan.center.y + 22)
        refreshView.water.clipsToBounds = true
    
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.refreshView.shadow.alpha = 1
            self.refreshView.water.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { completed in
                self.refreshView.cover.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.refreshView.cover.center = CGPoint(x: self.refreshView.cover.center.x - self.refreshView.cover.frame.size.width/2, y: self.refreshView.cover.center.y)
                let coverRotationAnimation = CAKeyframeAnimation.animationWith(
                    AnimationType.Rotation,
                    values: [0.05, 0, -0.05, 0, 0.07, -0.03, 0],
                    keyTimes: [0, 0.2, 0.4, 0.6, 0.8, 0.9, 1],
                    duration: 0.5,
                    beginTime:0
                )
                
                let coverPositionAnimation = CAKeyframeAnimation.animationWith(
                    AnimationType.TranslationY,
                    values: [-2, 0, -2, 1, -3, 0],
                    keyTimes: [0, 0.3, 0.5, 0.7, 0.9, 1],
                    duration: 0.5,
                    beginTime: 0)
                
                let animationGroup = CAAnimationGroup()
                animationGroup.duration = 1;
                animationGroup.repeatCount = FLT_MAX;
                
                animationGroup.animations = [coverRotationAnimation, coverPositionAnimation];
                
                self.refreshView.cover.layer.add(animationGroup, forKey: "group")
                self.refreshView.cover.layer.speed = 1
        })
        
        // Bubbles
        
        bubbleTimer = Timer.scheduledTimer(timeInterval: 0.12, target: self, selector: #selector(SoupAnimator.addBubble), userInfo: nil, repeats: true)
        
        // Flame
        
        var lightsImages = [UIImage]()
        for i in 1...11 {
            let imageName = NSString(format: "Flames%.4d", i)
            let image = UIImage(named: imageName as String, in: Bundle(for: type(of: self)), compatibleWith: nil)
            lightsImages.append(image!)
        }
        refreshView.flame.animationImages = lightsImages
       refreshView.flame.animationDuration = 0.7
        refreshView.flame.startAnimating()
        
        let delayTime = DispatchTime.now() + Double(Int64(0.7 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            var lightsImages = [UIImage]()
            for i in 11...68 {
                let imageName = NSString(format: "Flames%.4d", i)
                let image = UIImage(named: imageName as String, in: Bundle(for: type(of: self)), compatibleWith: nil)
                lightsImages.append(image!)
            }
            
            self.refreshView.flame.animationImages = lightsImages
            self.refreshView.flame.animationDuration = 2
            self.refreshView.flame.animationRepeatCount = 0
            self.refreshView.flame.startAnimating()
        }
    }
    
    func addBubble() {
        let radius: CGFloat = 1
        let x = CGFloat(arc4random_uniform(UInt32(self.refreshView.water.frame.size.width)))
        let circle = UIView(frame: CGRect(x: x, y: self.refreshView.water.frame.size.height, width: 2*radius, height: 2*radius))
        circle.layer.cornerRadius = radius
        circle.layer.borderWidth = 1
        circle.layer.masksToBounds = true
        circle.layer.borderColor = UIColor.white.cgColor
        self.refreshView.water.addSubview(circle)
        UIView.animate(withDuration: 1.3, animations: {
            let radius:CGFloat = 4
            circle.layer.frame = CGRect(x: x, y: -20, width: 2*radius, height: 2*radius)
            circle.layer.cornerRadius = radius
            }, completion: { _ in
                circle.removeFromSuperview()
        }) 
    }
    
    func releasingAnimation(_ progress: CGFloat) {
        let speed: CGFloat = 1.5
        
        let speededProgress: CGFloat = progress * speed > 1 ? 1 : progress * speed
        
        refreshView.circle.alpha = progress
        refreshView.circle.transform = CGAffineTransform.identity.scaledBy(x: speededProgress, y: speededProgress);
        refreshView.circle.center = CGPoint(x: refreshView.frame.size.width / 2, y: refreshViewHeight / 2 + refreshViewHeight - (refreshViewHeight * progress))
        
        func progressWithOffset(_ offset: Double, _ progress: Double) -> Double {
            return progress < offset ? 0 : (progress - offset) * 1/(1 - offset)
        }
        
        refreshView.pan.alpha = progress
        refreshView.pan.layer.timeOffset = Double(speededProgress) * animationDuration
        refreshView.cover.layer.timeOffset = animationDuration * progressWithOffset(0.9, Double(progress))

        refreshView.carrot.layer.timeOffset = animationDuration * progressWithOffset(0.5, Double(progress))
        
        refreshView.potato.layer.timeOffset = animationDuration * progressWithOffset(0.8, Double(progress))
        refreshView.leftPea.layer.timeOffset = animationDuration * progressWithOffset(0.5, Double(progress))
        refreshView.rightPea.layer.timeOffset = animationDuration * progressWithOffset(0.8, Double(progress))
    }
}
