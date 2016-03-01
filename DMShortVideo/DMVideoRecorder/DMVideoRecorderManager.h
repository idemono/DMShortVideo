//
//  DMVideoRecorderManager.h
//  DMShortVideo
//
//  Created by viziner on 16/2/29.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#ifndef DMVideoRecorderManager_h
#define DMVideoRecorderManager_h

#import "DMVideoRecorder.h"
#import "DMRecorderViewController/DMRecorderViewController.h"
#import "DMAllVideoDisplayViewController.h"
#import "AllVideoDataModel.h"
#import <MediaPlayer/MediaPlayer.h>
#define VIDEO_PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"VideoCaches"]
#define __WINDOW [UIApplication sharedApplication].keyWindow
#define __WINDOW_WIDTH CGRectGetWidth(__WINDOW.bounds)

#endif /* DMVideoRecorderManager_h */
