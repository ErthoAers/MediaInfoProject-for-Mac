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
    }
    
    public struct AudioInfo {
        let format: String
        let bitRate: Int
        let bitDepth: Int
        let duration: Int
        let language: String
    }
    
    public struct ChapterInfo {
        let timespan: String
        let language: String
        let name: String
    }
    
    public let Summary: String
    public var GeneralInfos: GeneralInfo
    public var VideoInfos: [VideoInfo] = []
    public var AudioInfos: [AudioInfo] = []
    public var ChapterInfos: [ChapterInfo] = []
    
    init(file fileURL: URL) {
        MediaInfo.MI.open(fileURL.path.removingPercentEncoding!)
        
        MediaInfo.MI.option("Complete")
        Summary = MediaInfo.MI.inform()
        
        var chapterCountVar: Int {
            get {
                switch Int(MediaInfo.MI.get(General, 0, "MenuCount")) ?? 0 {
                case 0:
                    return 0
                case 1:
                    return Int(MediaInfo.MI.get(General, 0, "Chapters_Pos_End"))! - Int(MediaInfo.MI.get(General, 0, "Chapters_Pos_Begin"))!
                default:
                    return -1
                }
            }
        }
        GeneralInfos = GeneralInfo(
            filename: fileURL.lastPathComponent.removingPercentEncoding!,
            fullPath: fileURL.path.removingPercentEncoding!,
            format: MediaInfo.MI.get(General, 0, "Format"),
            bitRate: Int(MediaInfo.MI.get(General, 0, "OverallBitRate")) ?? 0,
            videoCount: Int(MediaInfo.MI.get(General, 0, "VideoCount")) ?? 0,
            audioCount: Int(MediaInfo.MI.get(General, 0, "AudioCount")) ?? 0,
            textCount: Int(MediaInfo.MI.get(General, 0, "TextCount")) ?? 0,
            chapterCount: chapterCountVar)
        
        for i in 0..<GeneralInfos.videoCount {
            VideoInfos.append(
                VideoInfo(
                    format: MediaInfo.MI.get(Video, i, "Format"),
                    formatProfile: MediaInfo.MI.get(Video, i, "Format_Profile"),
                    fps: MediaInfo.MI.get(Video, i, "FrameRate/String")!.replacingOccurrences(of: " FPS", with: ""),
                    bitRate: Int(MediaInfo.MI.get(Video, i, "BitRate")) ?? 0,
                    bitDepth: Int(MediaInfo.MI.get(Video, i, "BitDepth")) ?? 0,
                    duration: Int(MediaInfo.MI.get(Video, i, "Duration")) ?? 0,
                    height: Int(MediaInfo.MI.get(Video, i, "Height")) ?? 0,
                    width: Int(MediaInfo.MI.get(Video, i, "Width")) ?? 0,
                    language: MediaInfo.MI.get(Video, i, "Language/String3")))
        }
        
        for i in 0..<GeneralInfos.audioCount {
            AudioInfos.append(
                AudioInfo(
                    format: MediaInfo.MI.get(Audio, i, "Format"),
                    bitRate: Int(MediaInfo.MI.get(Audio, i, "BitRate")) ?? 0,
                    bitDepth: Int(MediaInfo.MI.get(Audio, i, "BitDepth")) ?? 0,
                    duration: Int(MediaInfo.MI.get(Audio, i, "Duration")) ?? 0,
                    language: MediaInfo.MI.get(Audio, i, "Language/String3")))
        }
        
        let chapterBlock = { (i: Int) -> [Substring] in
            if self.GeneralInfos.format == "Matroska" { return ((MediaInfo.MI.get(Menu, 0, i, InfoText)!.split(separator: ":"))) }
            else { return ["", Substring(MediaInfo.MI.get(Menu, 0, i, InfoText))] }
        }
        if GeneralInfos.chapterCount > 0 {
            for i in Int(MediaInfo.MI.get(Menu, 0, "Chapters_Pos_Begin"))! ..< Int(MediaInfo.MI.get(Menu, 0, "Chapters_Pos_End"))! {
                let chapterinfo = chapterBlock(i)
                ChapterInfos.append(
                ChapterInfo(timespan: MediaInfo.MI.get(Menu, 0, i, InfoName),
                            language: String(chapterinfo[0]),
                            name: String(chapterinfo[1])))
            }
        }
        
        MediaInfo.MI.close()
    }
    
}


