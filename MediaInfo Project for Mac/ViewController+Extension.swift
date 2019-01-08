//
//  ViewController+Extension.swift
//  MediaInfo Project for Mac
//
//  Created by Icefires Chen on 2019/1/8.
//  Copyright © 2019 Icefires Chen. All rights reserved.
//

import Cocoa

extension ViewController: NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return mediainfoList.count
    }
}

extension ViewController: NSTableViewDataSource {
    
}
