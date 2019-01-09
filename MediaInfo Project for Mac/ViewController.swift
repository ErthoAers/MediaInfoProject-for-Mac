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
    @IBOutlet weak var loadTextFieldCell: NSTextFieldCell!
    
    @IBAction func clearTableView(_ sender: Any) {
    }
    
    var mediainfoList: [MediaInfo] = []
    var ascending: Bool = true
    var sortOrder: MediaInfo.order = .filename
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediainfoTableView.delegate = self
        mediainfoTableView.dataSource = self
    }

    override var representedObject: Any? {
        didSet {
            guard let url = representedObject as? URL else { return }
            let fileList = FileLoader.Load(file: url)
            for file in fileList {
                //DispatchQueue.global().async {
                    self.mediainfoList.append(MediaInfo(file: file))
                //}
            }
            reloadFileList()
            setColumnWidth()
        }
    }
    
}

