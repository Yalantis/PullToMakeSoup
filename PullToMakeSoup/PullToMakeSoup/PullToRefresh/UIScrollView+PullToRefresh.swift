//
//  UIScrollView+PullToRefresh.swift
//  CookingPullToRefresh
//
//  Created by Anastasiya Gorban on 4/14/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

private var associatedObjectHandle: UInt8 = 0

public extension UIScrollView {
    private(set) var pullToRefresh: PullToRefresh? {
        get {
            return objc_getAssociatedObject(self, &associatedObjectHandle) as? PullToRefresh
        }
        set {
            objc_setAssociatedObject(self, &associatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func addPullToRefresh(pullToRefresh: PullToRefresh, action:()->()) {
        if self.pullToRefresh != nil {
            self.removePullToRefresh(self.pullToRefresh!)
        }
        
        self.pullToRefresh = pullToRefresh
        pullToRefresh.scrollView = self
        pullToRefresh.action = action
        
        let view = pullToRefresh.refreshView
        view.frame = CGRectMake(0, -view.frame.size.height, self.frame.size.width, view.frame.size.height)
        self.addSubview(view)
        self.sendSubviewToBack(view)
    }
    
    func removePullToRefresh(pullToRefresh: PullToRefresh) {
        self.pullToRefresh?.refreshView.removeFromSuperview()
        self.pullToRefresh = nil
    }
    
    func startRefreshing() {
        pullToRefresh?.startRefreshing()
    }
    
    func endRefresing() {
        pullToRefresh?.endRefreshing()
    }
}
