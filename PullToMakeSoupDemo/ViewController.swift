//
//  ViewController.swift
//  PullToMakeSoupDemo
//
//  Created by Anastasiya Gorban on 5/22/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import PullToMakeSoup

class ViewController: UITableViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.addPullToRefresh(PullToMakeSoup(), action: {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), {[unowned self] in
                self.tableView.endRefresing()
                })
        })
    }

    @IBAction
    private func refresh() {
        tableView.startRefreshing()
    }    
}

