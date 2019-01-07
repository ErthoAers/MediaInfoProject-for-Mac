//
//  MediaInfoWrapper.m
//  MediaInfo Project for Mac
//
//  Created by Icefires Chen on 2019/1/7.
//  Copyright © 2019 Icefires Chen. All rights reserved.
//

#import "MediaInfoWrapper.h"

using namespace MediaInfoDLL;

@implementation MediaInfoWrapper

MediaInfo* MI = new MediaInfo;

- (stream_t)ConvertStream: (StreamKind)streamKind{
    stream_t streamKindCpp;
    switch (streamKind) {
        case General:
            streamKindCpp = Stream_General; break;
        case Video:
            streamKindCpp = Stream_Video; break;
        case Audio:
            streamKindCpp = Stream_Audio; break;
        case Menu:
            streamKindCpp = Stream_Menu; break;
        case Text:
            streamKindCpp = Stream_Text; break;
        default:
            streamKindCpp = Stream_Other; break;
    }
    return streamKindCpp;
}

- (info_t)ConvertInfo:(Info)info {
    info_t infoCpp;
    switch (info) {
        case InfoText:
            infoCpp = Info_Text; break;
        case InfoMax:
            infoCpp = Info_Max; break;
        case InfoName:
            infoCpp = Info_Name; break;
        case InfoHowTo:
            infoCpp = Info_HowTo; break;
        case InfoMeasure:
            infoCpp = Info_Measure_Text; break;
        case InfoOptions:
            infoCpp = Info_Options; break;
        case InfoNameText:
            infoCpp = Info_Name_Text; break;
        case InfoMeasureText:
            infoCpp = Info_Measure_Text; break;
    }
    return infoCpp;
}

- (void)Open:(NSString *)filename {
    String filenameCpp([filename UTF8String]);
    MI -> Open(filenameCpp);
}

- (NSString *)Get:(StreamKind)streamKind :(NSInteger)streamNumber :(NSString *)parameter {
    stream_t streamKindCpp = [self ConvertStream:streamKind];
    size_t streamNumberCpp = (size_t)streamNumber;
    String parameterCpp([parameter UTF8String]);
    
    String result = MI -> Get(streamKindCpp, streamNumberCpp, parameterCpp);
    return [NSString stringWithUTF8String: result.c_str()];
}

- (NSString *)Get:(StreamKind)streamKind :(NSInteger)streamNumber :(NSInteger)parameter :(Info)infoKind {
    stream_t streamKindCpp = [self ConvertStream:streamKind];
    size_t streamNumberCpp = (size_t)streamNumber;
    size_t parameterCpp = (size_t)parameter;
    info_t infoKindCpp = [self ConvertInfo:infoKind];
    
    String result = MI -> Get(streamKindCpp, streamNumberCpp, parameterCpp, infoKindCpp);
    return [NSString stringWithUTF8String: result.c_str()];
}

- (void)Option:(NSString*)option {
    MI -> Option([option UTF8String]);
}

- (NSString*)Inform {
    return [NSString stringWithUTF8String: (MI -> Inform()).c_str()];
}

- (void)Close {
    MI -> Close();
}

@end
