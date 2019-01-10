//
//  FileLoader.swift
//  MediaInfo Project for Mac
//
//  Created by Icefires Chen on 2019/1/7.
//  Copyright © 2019 Icefires Chen. All rights reserved.
//

import Foundation

public final class FileLoader {
    static private let includeExtensions: [String] = ["mkv", "mka", "mks", "mp4", "m4a", "m4v"]
    
    class public func Load(file fileURL: URL) -> [URL] {
        if !fileURL.hasDirectoryPath { return [fileURL] }
        
        let enumerator = FileManager.default.enumerator(atPath: fileURL.path)
        let filterFiles = NSArray(array: enumerator?.allObjects as! [String]).pathsMatchingExtensions(FileLoader.includeExtensions)
        return filterFiles.map { (path: String) -> URL in
            return URL(fileURLWithPath: "\(fileURL.path)/\(path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)")
        }
    }
}
