//
//  AllVideoDataModel.m
//  DMShortVideo
//
//  Created by viziner on 16/2/29.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "AllVideoDataModel.h"

@implementation AllVideoDataModel
+ (NSArray *)getAllVideos{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:VIDEO_PATH error:nil];
    if (!files || files.count == 0) {
        return @[];
    }

    NSMutableArray *videos = [NSMutableArray array];
    for (NSString *videoName in files) {
        if (![videoName.pathExtension isEqualToString:@"mp4"]) {
            continue;
        }
        AllVideoDataModel *dataModel = [[AllVideoDataModel alloc] init];
        dataModel.fileUrl = [NSURL fileURLWithPath:[VIDEO_PATH stringByAppendingPathComponent:videoName]];
        [videos addObject:dataModel];
    }
    

    
    return videos;
}
@end
