//
//  PullToMakeSoup.swift
//  PullToMakeSoup
//
//  Created by Anastasiya Gorban on 4/14/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//


import Foundation
import UIKit

public class PullToMakeSoup: PullToRefresh {
    public convenience init() {
        
        let refreshView =  NSBundle(identifier: "Yalantis.PullToMakeSoup")!.loadNibNamed("SoupView", owner: nil, options: nil).first as! SoupView
        let animator =  SoupAnimator(refreshView: refreshView)
        self.init(refreshView: refreshView, animator: animator)
    }
}

class SoupView: UIView {
    @IBOutlet
    private var pan: UIImageView!
    @IBOutlet
    private var cover: UIImageView!
    @IBOutlet
    private var potato: UIImageView!
    @IBOutlet
    private var leftPea: UIImageView!
    @IBOutlet
    private var rightPea: UIImageView!
    @IBOutlet
    private var carrot: UIImageView!
    @IBOutlet
    private var circle: UIImageView!
    @IBOutlet
    private var water: UIImageView!
    @IBOutlet
    private var flame: UIImageView!
    @IBOutlet
    private var shadow: UIImageView!
}

class SoupAnimator: NSObject, RefreshViewAnimator {
    
    private let refreshView: SoupView
    private let refreshViewHeight: CGFloat

    private var bubbleTimer: NSTimer?
    
    private let animationDuration = 0.3
    
    init(refreshView: SoupView) {
        self.refreshView = refreshView
        self.refreshViewHeight = refreshView.frame.size.height
    }
    
    func animateState(state: State) {
        switch state {
        case .Inital:
            initalLayout()
        case .Releasing(let progress):
            releasingAnimation(progress)
        case .Loading:
            startLoading()
        case .Finished:
            bubbleTimer?.invalidate()
        }
    }
    
    // MARK: - Helpers
    
    func initalLayout() {
        let centerX = refreshView.frame.size.width / 2
        
        // Circle
        refreshView.circle.center = CGPointMake(centerX, refreshViewHeight / 2)
        
        // Carrot
        refreshView.carrot.removeAllAnimations()
        
        refreshView.carrot.addAnimation(
            CAKeyframeAnimation.animationPosition(
                PocketSVG.pathFromSVGFileNamed("carrot-path-only",
                    origin: CGPointMake(centerX + 11, 10),
                    mirrorX: true,
                    mirrorY: false,
                    scale: 0.5),
                duration: animationDuration,
                timingFunction:TimingFunction.EaseIn,
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
        
        refreshView.pan.center = CGPointMake(centerX, refreshView.pan.center.y)
        refreshView.pan.addAnimation(CAKeyframeAnimation.animationWith(
            AnimationType.TranslationY,
            values: [-200, 0],
            keyTimes: [0, 0.5],
            duration: animationDuration,
            beginTime:0))
        refreshView.shadow.alpha = 0
        refreshView.shadow.center = CGPointMake(centerX + 11, refreshView.shadow.center.y)
        refreshView.pan.layer.timeOffset = 0.0
        
        // Water
        
        refreshView.water.center = CGPointMake(centerX, refreshView.water.center.y)
        refreshView.water.layer.anchorPoint = CGPointMake(0.5, 1.0)
        refreshView.water.transform = CGAffineTransformMakeScale(1, 0.00001);
        
        // Potato
        refreshView.potato.removeAllAnimations()
        
        refreshView.potato.addAnimation(
            CAKeyframeAnimation.animationPosition(
                PocketSVG.pathFromSVGFileNamed("potato-path-only",
                    origin: CGPointMake(centerX - 65, 5),
                    mirrorX: true,
                    mirrorY: false,
                    scale: 1),
                duration: animationDuration,
                timingFunction:TimingFunction.EaseIn,
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
                    origin: CGPointMake(centerX - 80, 12),
                    mirrorX: false,
                    mirrorY: false,
                    scale: 1),
                duration: animationDuration,
                timingFunction:TimingFunction.EaseIn,
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
                    origin: CGPointMake(centerX - 10, -13),
                    mirrorX: true,
                    mirrorY: false,
                    scale: 1),
                duration: animationDuration,
                timingFunction:TimingFunction.EaseIn,
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
        
        refreshView.flame.center = CGPointMake(refreshView.frame.size.width / 2, refreshView.flame.center.y)
        refreshView.flame.image = nil
        refreshView.flame.stopAnimating()
        refreshView.flame.animationImages = nil
        
        // Cover
        
        refreshView.cover.layer.anchorPoint = CGPointMake(1, 0.5)        
        refreshView.cover.center = CGPointMake(refreshView.frame.size.width / 2 + refreshView.cover.frame.size.width/2, refreshView.cover.center.y)
        
        refreshView.cover.removeAllAnimations()
        
        refreshView.cover.addAnimation(
            CAKeyframeAnimation.animationPosition(
                PocketSVG.pathFromSVGFileNamed("cover-path-only",
                    origin: CGPointMake(refreshView.pan.center.x + 34, -51),
                    mirrorX: true,
                    mirrorY: true,
                    scale: 0.5),
                duration: animationDuration,
                timingFunction:TimingFunction.EaseIn,
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
        refreshView.circle.center = CGPointMake(refreshView.frame.size.width / 2, refreshView.frame.size.height / 2)
        refreshView.carrot.layer.timeOffset = animationDuration
        refreshView.pan.layer.timeOffset = animationDuration
        refreshView.potato.layer.timeOffset = animationDuration
        refreshView.leftPea.layer.timeOffset = animationDuration
        refreshView.rightPea.layer.timeOffset = animationDuration
        refreshView.cover.layer.timeOffset = animationDuration
        
        // Water & Cover
        refreshView.water.center = CGPointMake(refreshView.water.center.x, refreshView.pan.center.y + 22)
        refreshView.water.clipsToBounds = true
    
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.refreshView.shadow.alpha = 1
            self.refreshView.water.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: { completed in
                self.refreshView.cover.layer.anchorPoint = CGPointMake(0.5, 0.5)
                self.refreshView.cover.center = CGPointMake(self.refreshView.cover.center.x - self.refreshView.cover.frame.size.width/2, self.refreshView.cover.center.y)
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
                
                self.refreshView.cover.layer.addAnimation(animationGroup, forKey: "group")
                self.refreshView.cover.layer.speed = 1
        })
        
        // Bubbles
        
        bubbleTimer = NSTimer.scheduledTimerWithTimeInterval(0.12, target: self, selector: "addBubble", userInfo: nil, repeats: true)
        
        // Flame
        
        var lightsImages = [UIImage]()
        for i in 1...11 {
            let imageName = NSString(format: "Flames%.4d", i)
            let image = UIImage(named: imageName as String, inBundle: NSBundle(identifier: "Yalantis.PullToMakeSoup"), compatibleWithTraitCollection: nil)
            lightsImages.append(image!)
        }
        refreshView.flame.animationImages = lightsImages
       refreshView.flame.animationDuration = 0.7
        refreshView.flame.startAnimating()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.7 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            var lightsImages = [UIImage]()
            for i in 11...68 {
                let imageName = NSString(format: "Flames%.4d", i)
                let image = UIImage(named: imageName as String, inBundle: NSBundle(identifier: "Yalantis.PullToMakeSoup"), compatibleWithTraitCollection: nil)
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
        let circle = UIView(frame: CGRectMake(x, self.refreshView.water.frame.size.height, 2*radius, 2*radius))
        circle.layer.cornerRadius = radius
        circle.layer.borderWidth = 1
        circle.layer.masksToBounds = true
        circle.layer.borderColor = UIColor.whiteColor().CGColor
        self.refreshView.water.addSubview(circle)
        UIView.animateWithDuration(1.3, animations: {
            let radius:CGFloat = 4
            circle.layer.frame = CGRectMake(x, -20, 2*radius, 2*radius)
            circle.layer.cornerRadius = radius
            }) { _ in
                circle.removeFromSuperview()
        }
    }
    
    func releasingAnimation(progress: CGFloat) {
        let speed: CGFloat = 1.5
        
        let speededProgress: CGFloat = progress * speed > 1 ? 1 : progress * speed
        
        refreshView.circle.alpha = progress
        refreshView.circle.transform = CGAffineTransformScale(CGAffineTransformIdentity, speededProgress, speededProgress);
        refreshView.circle.center = CGPointMake(refreshView.frame.size.width / 2, refreshViewHeight / 2 + refreshViewHeight - (refreshViewHeight * progress))
        
        let progressWithOffset: (Double, Double) -> Double = {offset, progress in
            return progress < offset ? 0 : Double((progress - offset) * 1/(1 - offset))
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
