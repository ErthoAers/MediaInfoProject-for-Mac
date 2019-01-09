//
//  ViewController.swift
//  MediaInfo Project for Mac
//
//  Created by Icefires Chen on 2019/1/7.
//  Copyright © 2019 Icefires Chen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var mediainfoTableView: NSTableView!
    @IBOutlet var mediainfoTextView: NSTextView!
    @IBOutlet weak var mediainfoScrollView: NSScrollView!
    @IBOutlet weak var numberTextFieldCell: NSTextFieldCell!
    @IBOutlet weak var loadTextFieldCell: NSTextFieldCell!
    
    @IBAction func clearTableView(_ sender: Any) {
        mediainfoList = []
        mediainfoTextView.string = ""
        mediainfoTableView.reloadData()
    }
    
    var mediainfoList: [MediaInfo] = []
    var sortAscending: Bool = true
    var sortOrder: MediaInfo.order = .filename
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOrderDescriptor()
        mediainfoScrollView.hasHorizontalScroller = true
        mediainfoTextView.font = NSFont(name: "Menlo", size: 10.0)
        
        mediainfoTableView.delegate = self
        mediainfoTableView.dataSource = self
        mediainfoTableView.target = self
        mediainfoTableView.action = #selector(click)
    }

    override var representedObject: Any? {
        didSet {
            guard let url = representedObject as? URL else { return }
            let fileList = FileLoader.Load(file: url)
            let queue = DispatchQueue(label: "fileloader")
            let group = DispatchGroup()
            
            
            for file in fileList {
                queue.async(group: group) {
                    self.mediainfoList.append(MediaInfo(file: file))
                    DispatchQueue.main.async {
                        self.loadTextFieldCell.stringValue = "Loading \(self.mediainfoList.last!.GeneralInfos.filename)"
                    }
                }
            }
            
            group.notify(queue: queue) {
                DispatchQueue.main.async {
                    self.reloadFileList()
                    self.setColumnWidth()
                    self.loadTextFieldCell.stringValue = "Loaded \(self.mediainfoList.count) files."
                }
            }
        }
    }
    
}

