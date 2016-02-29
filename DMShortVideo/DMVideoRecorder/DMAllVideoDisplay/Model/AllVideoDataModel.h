//
//  AllVideoDataModel.h
//  DMShortVideo
//
//  Created by viziner on 16/2/29.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMVideoRecorderManager.h"
@interface AllVideoDataModel : NSObject
@property (strong, nonatomic)NSURL *fileUrl;

+ (NSArray *)getAllVideos;
@end
