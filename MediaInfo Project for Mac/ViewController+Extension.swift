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
    
    fileprivate enum CellIdentifiers{
        static let filename =           "filenameID"
        static let format =             "formatID"
        static let videoFormat =        "videoFormatID"
        static let resolutionRatio =    "resolutionRatioID"
        static let bitDepth =           "bitDepthID"
        static let fps =                "fpsID"

        static let formatAudio1 =       "formatAudio1ID"
        static let bitDepthAudio1 =     "bitDepthAudio1ID"
        static let bitRateAudio1 =      "bitRateAudio1ID"
        static let languageAudio1 =     "languageAudio1ID"

        static let formatAudio2 =       "formatAudio2ID"
        static let bitDepthAudio2 =     "bitDepthAudio2ID"
        static let bitRateAudio2 =      "bitRateAudio2ID"
        static let languageAudio2 =     "languageAudio2ID"

        static let chapter =            "chapterID"
        static let fullPath =           "fullPathID"
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        
        let media = mediainfoList[row]
        
        switch tableColumn {
        case tableView.tableColumns[0]:
            text = media.GeneralInfos.filename; cellIdentifier = CellIdentifiers.filename
        case tableView.tableColumns[1]:
            text = media.GeneralInfos.format;   cellIdentifier = CellIdentifiers.format
        case tableView.tableColumns[14]:
            if media.GeneralInfos.chapterCount > 0 { text = "有" } else { text = "" }
            cellIdentifier = CellIdentifiers.chapter
        case tableView.tableColumns[15]:
            text = media.GeneralInfos.fullPath; cellIdentifier = CellIdentifiers.fullPath
        default:
            break
        }
        
        if media.VideoInfos.count > 0 {
            switch tableColumn {
            case tableView.tableColumns[2]:
                text = media.VideoInfos[0].format;          cellIdentifier = CellIdentifiers.videoFormat
            case tableView.tableColumns[3]:
                text = "\(media.VideoInfos[0].width)X\(media.VideoInfos[0].height)"
                cellIdentifier = CellIdentifiers.videoFormat
            case tableView.tableColumns[4]:
                text = "\(media.VideoInfos[0].bitDepth)";   cellIdentifier = CellIdentifiers.bitDepth
            case tableView.tableColumns[5]:
                text = "\(media.VideoInfos[0].bitRate)";    cellIdentifier = CellIdentifiers.fps
            default:
                break
            }
        } else {
            switch tableColumn {
            case tableView.tableColumns[2]:
                text = "";  cellIdentifier = CellIdentifiers.videoFormat
            case tableView.tableColumns[3]:
                text = "";  cellIdentifier = CellIdentifiers.videoFormat
            case tableView.tableColumns[4]:
                text = "";  cellIdentifier = CellIdentifiers.bitDepth
            case tableView.tableColumns[5]:
                text = "";  cellIdentifier = CellIdentifiers.fps
            default:
                break
            }
        }

        if media.AudioInfos.count > 0 {
            switch tableColumn {
            case tableView.tableColumns[6]:
                text = media.AudioInfos[0].format;          cellIdentifier = CellIdentifiers.formatAudio1
            case tableView.tableColumns[7]:
                text = "\(media.AudioInfos[0].bitDepth)";   cellIdentifier = CellIdentifiers.bitDepthAudio1
            case tableView.tableColumns[8]:
                text = "\(media.AudioInfos[0].bitRate)";    cellIdentifier = CellIdentifiers.bitRateAudio1
            case tableView.tableColumns[9]:
                text = media.AudioInfos[0].language;        cellIdentifier = CellIdentifiers.languageAudio1
            default:
                break
            }
        } else {
            switch tableColumn {
            case tableView.tableColumns[6]:
                text = "";  cellIdentifier = CellIdentifiers.formatAudio1
            case tableView.tableColumns[7]:
                text = "";  cellIdentifier = CellIdentifiers.bitDepthAudio1
            case tableView.tableColumns[8]:
                text = "";  cellIdentifier = CellIdentifiers.bitRateAudio1
            case tableView.tableColumns[9]:
                text = "";  cellIdentifier = CellIdentifiers.languageAudio1
            default:
                break
            }
        }

        if media.AudioInfos.count > 1 {
            switch tableColumn {
            case tableView.tableColumns[10]:
                text = media.AudioInfos[1].format;          cellIdentifier = CellIdentifiers.formatAudio2
            case tableView.tableColumns[11]:
                text = "\(media.AudioInfos[1].bitDepth)";   cellIdentifier = CellIdentifiers.bitDepthAudio2
            case tableView.tableColumns[12]:
                text = "\(media.AudioInfos[1].bitRate)";    cellIdentifier = CellIdentifiers.bitRateAudio2
            case tableView.tableColumns[13]:
                text = media.AudioInfos[1].language;        cellIdentifier = CellIdentifiers.languageAudio2
            default:
                break
            }
        } else {
            switch tableColumn {
            case tableView.tableColumns[10]:
                text = "";  cellIdentifier = CellIdentifiers.formatAudio2
            case tableView.tableColumns[11]:
                text = "";  cellIdentifier = CellIdentifiers.bitDepthAudio2
            case tableView.tableColumns[12]:
                text = "";  cellIdentifier = CellIdentifiers.bitRateAudio2
            case tableView.tableColumns[13]:
                text = "";  cellIdentifier = CellIdentifiers.languageAudio2
            default:
                break
            }
        }

        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView else { return nil }
        cell.textField?.stringValue = text
        return cell
    }

    func tableView(_ tableView: NSTableView, sizeToFitWidthOfColumn column: Int) -> CGFloat {
        let visibleRect: NSRect = tableView.visibleRect
        let rowRange: NSRange = tableView.rows(in: visibleRect)
        let numberOfRows = tableView.numberOfRows
        var minRow: Int = rowRange.location
        var maxRow: Int = rowRange.location + rowRange.length
        
        minRow = max(0, minRow - 50)
        maxRow = min(numberOfRows, maxRow + 50)
        
        let tableColumn = tableView.tableColumns[column]
        let minWidth: CGFloat = tableColumn.minWidth
        let maxWidth: CGFloat = tableColumn.maxWidth
        var width: CGFloat = minWidth
        
        for row in minRow..<maxRow {
            let tableCellView = tableView.view(atColumn: column, row: row, makeIfNecessary: true)
            let fittingWidth = (tableCellView as! NSTableCellView).textField!.fittingSize.width
            if fittingWidth > width { width = fittingWidth + 10 }
        }
        return min(maxWidth, width)
    }
}

extension ViewController {
    func reloadFileList() {
        mediainfoList.sort(by: MediaInfo.orderBy(sortOrder, ascending: ascending))
        mediainfoTableView.reloadData()
    }
    
    func setColumnWidth() {
        reloadFileList()
        for columnNum in 0..<16 {
            let column = mediainfoTableView.tableColumns[columnNum]
            column.width = self.tableView(mediainfoTableView, sizeToFitWidthOfColumn: columnNum)
        }
    }

}
