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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.addPullToRefresh(PullToMakeSoup(at: .top))  {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.tableView.endRefreshing(at: .top)
            }
        }
    }

    @IBAction fileprivate func refresh() {
        tableView.startRefreshing(at: .top)
    }
}

