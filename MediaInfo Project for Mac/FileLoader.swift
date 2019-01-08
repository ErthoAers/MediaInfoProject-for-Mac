//
//  FileLoader.swift
//  MediaInfo Project for Mac
//
//  Created by Icefires Chen on 2019/1/7.
//  Copyright © 2019 Icefires Chen. All rights reserved.
//

import Foundation

public final class FileLoader {
    static private let excludeDirectories: [String] = ["CDs", "Scans"]
    static private let excludeExtensions: [String] = ["mkv", "mp4"]
    
    class public func Load(file fileURL: URL) -> [URL] {
        if !fileURL.hasDirectoryPath { return [fileURL] }
        
        let enumerator = FileManager.default.enumerator(atPath: fileURL.path)
        let filterFiles = NSArray(array: enumerator?.allObjects as! [String]).pathsMatchingExtensions(FileLoader.excludeExtensions)
        return filterFiles.map { (path: String) -> URL in
            return URL(fileURLWithPath: "\(fileURL.path)/\(path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)")
        }
    }
}
