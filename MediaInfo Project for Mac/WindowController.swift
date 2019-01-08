//
//  WindowController.swift
//  MediaInfo-Project-FM
//
//  Created by Icefires Chen on 2019/1/6.
//  Copyright © 2019 Icefires Chen. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBAction func openDocument(_ sender: AnyObject?) {
        let openPanel = NSOpenPanel()
        openPanel.showsHiddenFiles = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.beginSheetModal(for: window!) { response in
            guard response == NSApplication.ModalResponse.OK else {
                return
            }
            self.contentViewController?.representedObject = openPanel.url
        }
    }
}
