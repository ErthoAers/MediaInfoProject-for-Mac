//
//  ColorConverter.swift
//  MediaInfo Project for Mac
//
//  Created by Icefires Chen on 2019/1/9.
//  Copyright © 2019 Icefires Chen. All rights reserved.
//

import Cocoa

public final class ColorConverter {
    static private let FormatDictionary: Dictionary<String, [String]> = [
        "Matroska": ["mkv", "mka", "mks"],
         "MPEG-4": ["mp4", "m4a", "m4a"]
    ]
    static private let VideoFormatDictionary: Dictionary<String, String> = [
        "x264": "AVC",
        "x265": "HEVC"
    ]
    
    class private func PatternString(_ pattern: String, _ str: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let res = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.count))
            return (str as NSString).substring(with: res.first?.range ?? NSRange(0..<0))
        } catch {
            return nil
        }
    }
    
    class public func BackGroundColorConverter(media: MediaInfo) -> NSColor {
        if !FormatDictionary[media.GeneralInfos.format]!.contains(media.fileURL.pathExtension) {
            return #colorLiteral(red: 1, green: 0.006752918009, blue: 0, alpha: 1)
        }
        
        var duration: [Int] = []
        duration.append(contentsOf: media.VideoInfos.map { return $0.duration })
        duration.append(contentsOf: media.AudioInfos.map { return $0.duration })
        
        if (duration.max() ?? 0) - (duration.min() ?? 0) > 600 {
            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        
        
        //if (filenameWidth != (media.VideoInfos.first?.width ?? 0)) {
        //    return #colorLiteral(red: 0.9389573336, green: 0.5146099329, blue: 0.9359354377, alpha: 1)
        //}
        
        if media.GeneralInfos.chapterCount != 0 && (media.GeneralInfos.chapterCount == 1 || media.GeneralInfos.chapterCount == -1 || (media.ChapterInfos.last!.timespan) > (duration.max() ?? 0) - 1100 || media.ChapterInfos.first!.timespan != 0) {
            return #colorLiteral(red: 0.9969360232, green: 0.9989752173, blue: 0, alpha: 1)
        }
        
        if media.GeneralInfos.audioCount > 2 {
            return #colorLiteral(red: 0.8009543419, green: 1, blue: 0.1958647668, alpha: 1)
        }
        
        var delay: [Bool] = [media.GeneralInfos.delay]
        delay.append(contentsOf: media.VideoInfos.map { return $0.delay })
        delay.append(contentsOf: media.AudioInfos.map { return $0.delay })
        
        if delay.contains(true) {
            return #colorLiteral(red: 0, green: 0.6483904719, blue: 0.6778650284, alpha: 1)
        }
        
        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    class public func FontColorConverter(media: MediaInfo) -> NSColor {
        if media.GeneralInfos.textCount > 0 {
            return #colorLiteral(red: 0.1522964537, green: 0.06655495614, blue: 1, alpha: 1)
        }
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
