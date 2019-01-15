//
//  MediaInfo.swift
//  MediaInfo Project for Mac
//
//  Created by Icefires Chen on 2019/1/7.
//  Copyright © 2019 Icefires Chen. All rights reserved.
//

import Foundation

final public class MediaInfo {
    public static let MI = MediaInfoWrapper()
    
    public struct GeneralInfo {
        let filename: String
        let fullPath: String
        let format: String
        let bitRate: Int
        let videoCount: Int
        let audioCount: Int
        let textCount: Int
        let chapterCount: Int
        let delay: Bool
    }
    
    public struct VideoInfo {
        let format: String
        let formatProfile: String
        let fps: String
        let bitRate: Int
        let bitDepth: Int
        let duration: Int
        let height: Int
        let width: Int
        let language: String
        let delay: Bool
    }
    
    public struct AudioInfo {
        let format: String
        let bitRate: Int
        let bitDepth: Int
        let duration: Int
        let language: String
        let delay: Bool
    }
    
    public struct ChapterInfo {
        let timespan: Int
        let language: String
        let name: String
    }
    
    public let fileURL: URL
    public let Summary: String
    public var GeneralInfos: GeneralInfo
    public var VideoInfos: [VideoInfo] = []
    public var AudioInfos: [AudioInfo] = []
    public var ChapterInfos: [ChapterInfo] = []
    
    init(file fileURL: URL) {
        self.fileURL = fileURL
        MediaInfo.MI.open(fileURL.path.removingPercentEncoding!)
        
        MediaInfo.MI.option("Complete")
        Summary = MediaInfo.MI.inform()
        
        var chapterCountVar: Int {
            get {
                switch Int(MediaInfo.MI.get(General, 0, "MenuCount")) ?? 0 {
                case 0:
                    return 0
                case 1:
                    return (Int(MediaInfo.MI.get(Menu, 0, "Chapters_Pos_End")) ?? 0) - (Int(MediaInfo.MI.get(Menu, 0, "Chapters_Pos_Begin")) ?? 0)
                default:
                    return -1
                }
            }
        }
        GeneralInfos = GeneralInfo(
            filename:   fileURL.lastPathComponent.removingPercentEncoding!,
            fullPath:   fileURL.path.removingPercentEncoding!,
            format:     MediaInfo.MI.get(General, 0, "Format"),
            bitRate:    (Int(MediaInfo.MI.get(General, 0, "OverallBitRate")) ?? 0) / 1000,
            videoCount: Int(MediaInfo.MI.get(General, 0, "VideoCount")) ?? 0,
            audioCount: Int(MediaInfo.MI.get(General, 0, "AudioCount")) ?? 0,
            textCount:  Int(MediaInfo.MI.get(General, 0, "TextCount")) ?? 0,
            chapterCount: chapterCountVar,
            delay:      (MediaInfo.MI.get(Video, 0, "Delay") == "" || MediaInfo.MI.get(Video, 0, "Delay") == "0") ? false : true)
        for i in 0..<GeneralInfos.videoCount {
            VideoInfos.append(
                VideoInfo(
                    format:         MediaInfo.MI.get(Video, i, "Format"),
                    formatProfile:  MediaInfo.MI.get(Video, i, "Format_Profile"),
                    fps:            MediaInfo.MI.get(Video, i, "FrameRate/String")!.replacingOccurrences(of: " FPS", with: ""),
                    bitRate:        (Int(MediaInfo.MI.get(Video, i, "BitRate")) ?? 0) / 1000,
                    bitDepth:       Int(MediaInfo.MI.get(Video, i, "BitDepth")) ?? 0,
                    duration:       Int(Double(MediaInfo.MI.get(Video, i, "Duration")) ?? 0),
                    height:         Int(MediaInfo.MI.get(Video, i, "Height")) ?? 0,
                    width:          Int(MediaInfo.MI.get(Video, i, "Width")) ?? 0,
                    language:       MediaInfo.MI.get(Video, i, "Language/String3").uppercased(),
                    delay:          MediaInfo.MI.get(Video, i, "Delay") != "" && MediaInfo.MI.get(Video, i, "Delay") != "0"))
        }
        
        for i in 0..<GeneralInfos.audioCount {
            AudioInfos.append(
                AudioInfo(
                    format:     MediaInfo.MI.get(Audio, i, "Format"),
                    bitRate:    (Int(MediaInfo.MI.get(Audio, i, "BitRate")) ?? 0) / 1000,
                    bitDepth:   Int(MediaInfo.MI.get(Audio, i, "BitDepth")) ?? 0,
                    duration:   Int(Double(MediaInfo.MI.get(Audio, i, "Duration")) ?? 0),
                    language:   MediaInfo.MI.get(Audio, i, "Language/String3").uppercased(),
                    delay:      MediaInfo.MI.get(Audio, i, "Delay") != "" && MediaInfo.MI.get(Audio, i, "Delay") != "0"))
        }
        
        let chapterBlock = { (i: Int) -> [Substring] in
            return self.GeneralInfos.format == "Matroska" ? MediaInfo.MI.get(Menu, 0, i, InfoText)!.split(separator: ":", maxSplits: Int.max, omittingEmptySubsequences: false) : ["", Substring(MediaInfo.MI.get(Menu, 0, i, InfoText))]
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        let startTime = dateFormatter.date(from: "00:00:00.000")!
        if GeneralInfos.chapterCount > 0 {
            for i in Int(MediaInfo.MI.get(Menu, 0, "Chapters_Pos_Begin"))! ..< Int(MediaInfo.MI.get(Menu, 0, "Chapters_Pos_End"))! {
                let chapterinfo = chapterBlock(i)
                ChapterInfos.append(
                    ChapterInfo(
                        timespan:   Int((dateFormatter.date(from: MediaInfo.MI.get(Menu, 0, i, InfoName))!.timeIntervalSince(startTime)) * 1000),
                        language:   String(chapterinfo[0]),
                        name:       String(chapterinfo[1])))
            }
        }
        
        MediaInfo.MI.close()
    }
    
}

extension MediaInfo {
    public enum order: String {
        case filename
        case format
        case videoFormat
        case resolutionRatio
        case bitDepth
        case fps
        case formatAudio1
        case bitDepthAudio1
        case bitRateAudio1
        case languageAudio1
        case formatAudio2
        case bitDepthAudio2
        case bitRateAudio2
        case languageAudio2
        case chapter
        case fullPath
    }

    public class func orderBy(_ orderedBy: MediaInfo.order, ascending: Bool) -> (MediaInfo, MediaInfo) -> Bool {
        switch orderedBy {
        
        case .filename:
            return { self.sortItem($0.GeneralInfos.filename,   $1.GeneralInfos.filename,   ascending: ascending) }
        case .format:
            return { self.sortItem($0.GeneralInfos.format,     $1.GeneralInfos.format,     ascending: ascending) }
        case .videoFormat:
            return { self.sortItem($0.VideoInfos[0].format,    $1.VideoInfos[0].format,    ascending: ascending) }
        case .resolutionRatio:
            return { self.sortItem($0.VideoInfos[0].height,    $1.VideoInfos[0].height,    ascending: ascending) }
        case .bitDepth:
            return { self.sortItem($0.VideoInfos[0].bitDepth,  $1.VideoInfos[0].bitDepth,  ascending: ascending) }
        case .fps:
            return { self.sortItem($0.VideoInfos[0].fps,       $1.VideoInfos[0].fps,       ascending: ascending) }
            
        case .formatAudio1:
            return {
                if $0.GeneralInfos.audioCount > 0 && $1.GeneralInfos.audioCount > 0 {
                    return self.sortItem($0.AudioInfos[0].format,   $1.AudioInfos[0].format,    ascending: ascending)
                } else {
                    return false
                }
            }
        case .bitDepthAudio1:
            return {
                if $0.GeneralInfos.audioCount > 0 && $1.GeneralInfos.audioCount > 0 {
                    return self.sortItem($0.AudioInfos[0].bitDepth, $1.AudioInfos[0].bitDepth,    ascending: ascending)
                } else {
                    return false
                }
            }
        case .bitRateAudio1:
            return {
                if $0.GeneralInfos.audioCount > 0 && $1.GeneralInfos.audioCount > 0 {
                    return self.sortItem($0.AudioInfos[0].bitRate,  $1.AudioInfos[0].bitRate,    ascending: ascending)
                } else {
                    return false
                }
            }
        case .languageAudio1:
            return {
                if $0.GeneralInfos.audioCount > 0 && $1.GeneralInfos.audioCount > 0 {
                    return self.sortItem($0.AudioInfos[0].language, $1.AudioInfos[0].language,    ascending: ascending)
                } else {
                    return false
                }
            }

        case .formatAudio2:
            return {
                if $0.GeneralInfos.audioCount > 1 && $1.GeneralInfos.audioCount > 1 {
                    return self.sortItem($0.AudioInfos[1].format,   $1.AudioInfos[1].format,    ascending: ascending)
                } else {
                    return false
                }
            }
        case .bitDepthAudio2:
            return {
                if $0.GeneralInfos.audioCount > 1 && $1.GeneralInfos.audioCount > 1 {
                    return self.sortItem($0.AudioInfos[1].bitDepth, $1.AudioInfos[1].bitDepth,    ascending: ascending)
                } else {
                    return false
                }
            }
        case .bitRateAudio2:
            return {
                if $0.GeneralInfos.audioCount > 1 && $1.GeneralInfos.audioCount > 1 {
                    return self.sortItem($0.AudioInfos[1].bitRate,  $1.AudioInfos[1].bitRate,    ascending: ascending)
                } else {
                    return false
                }
            }
        case .languageAudio2:
            return {
                if $0.GeneralInfos.audioCount > 1 && $1.GeneralInfos.audioCount > 1 {
                    return self.sortItem($0.AudioInfos[1].language, $1.AudioInfos[1].language,    ascending: ascending)
                } else {
                    return false
                }
            }

        case .chapter:
            return { self.sortItem($0.GeneralInfos.chapterCount, $1.GeneralInfos.chapterCount, ascending: ascending) }
        case .fullPath:
            return { self.sortItem($0.GeneralInfos.fullPath,   $1.GeneralInfos.fullPath,   ascending: ascending) }
        }
    }

    class func sortItem(_ lhs: String, _ rhs: String, ascending: Bool) -> Bool {
        return ascending ? (lhs < rhs) : (rhs > lhs)
    }

    class func sortItem(_ lhs: Int, _ rhs: Int, ascending: Bool) -> Bool {
        return ascending ? (lhs < rhs) : (rhs > lhs)
    }
}
