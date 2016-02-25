//
//  DMVideoRecorder.h
//  DMShortVideo
//
//  Created by viziner on 16/2/25.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface DMVideoRecorder : NSObject
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preLayer;//布局
@property (nonatomic, strong) AVCaptureSession *captureSession;//会话
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieFileOutput;//movie文件输出

- (void)startRecorderMovieFileOutUrl:(NSURL *)url;
- (void)stopRecord;
@end
