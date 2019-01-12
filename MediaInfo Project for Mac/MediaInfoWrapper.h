//
//  MediaInfoWrapper.h
//  MediaInfo Project for Mac
//
//  Created by Icefires Chen on 2019/1/7.
//  Copyright © 2019 Icefires Chen. All rights reserved.
//

#ifndef MediaInfoWrapper_h
#define MediaInfoWrapper_h

#import <Foundation/Foundation.h>
#import "MediaInfoDLL/MediaInfoDLL_Static.h"

@interface MediaInfoWrapper : NSObject

typedef enum  {
    General,
    Video,
    Audio,
    Menu,
    Text,
} StreamKind;

typedef enum {
    InfoText,
    InfoMax,
    InfoName,
    InfoHowTo,
    InfoMeasure,
    InfoOptions,
    InfoNameText,
    InfoMeasureText,
} Info;

- (void)Open:(NSString*)filename;
- (NSString *)Get:(StreamKind)streamKind :(NSInteger)streamNumber :(NSString*)parameter;
- (NSString *)Get:(StreamKind)streamKind :(NSInteger)streamNumber :(NSInteger)parameter :(Info)infoKind;
- (void)Option:(NSString*)option;
- (NSString *)Inform;
- (void)Close;

@end

#endif /* MediaInfoWrapper_h */
