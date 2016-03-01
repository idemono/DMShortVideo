//
//  DMVideoRecorder.m
//  DMShortVideo
//
//  Created by viziner on 16/2/25.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "DMVideoRecorder.h"
#import "SDAVAssetExportSession.h"
#define MIN_TIME 3
@interface DMVideoRecorder ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) AVCaptureDeviceInput *audioDeviceInput;

@end

@implementation DMVideoRecorder
//1.录制
//2.压缩
- (instancetype)init{
    self = [super init];
    if (self){
        [self initCaputre];
    }
    return self;
}

- (void)initCaputre{
    //获取可用设备
    AVCaptureDevice *frontCameraDevice = nil;
    AVCaptureDevice *backCameraDevice = nil;
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionFront ) {
            frontCameraDevice = device;
        }
        else{
            backCameraDevice = device;
        }
    }
    
    //初始化input
    if (backCameraDevice) {
        self.videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCameraDevice error:nil];
    }
    else{
        self.videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCameraDevice error:nil];
    }
    
    self.audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    if ([self.captureSession canAddInput:self.videoDeviceInput]) {
        [self.captureSession addInput:self.videoDeviceInput];
    }
    if ([self.captureSession canAddInput:self.audioDeviceInput]) {
        [self.captureSession addInput:self.audioDeviceInput];
    }
    if ([self.captureSession canAddOutput:self.movieFileOutput]) {
        [self.captureSession addOutput:self.movieFileOutput];
    }
    //画质
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    self.preLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    //开始
    [self.captureSession startRunning];
}


- (void)startRecorderMovieFileOutUrl:(NSURL *)url{
    if(self.movieFileOutput.recording){
        [self.movieFileOutput stopRecording];
    }
    [self.movieFileOutput startRecordingToOutputFileURL:url recordingDelegate:self];
}

- (void)stopRecord{
    [self.movieFileOutput stopRecording];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"录制完成");
    [self compressVideoUrl:outputFileURL];
}

#pragma mark - compress 压缩

- (void)compressVideoUrl:(NSURL *)url{
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    if (asset.duration.value / asset.duration.timescale < MIN_TIME){
        if ([_delegate respondsToSelector:@selector(recordDidTimeShort)]) {
            [_delegate recordDidTimeShort];
        }

        //删除文件
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtURL:url error:nil];
        
        return;
    }
    
    AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    CGFloat minValue = MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
    
    CGSize renderSize = CGSizeMake(minValue,minValue * 3 / 4  );

    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
        NSError *audioError;
        NSError *videoError;
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                        ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] firstObject]
                         atTime:kCMTimeZero
                          error:&audioError];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                        ofTrack:assetTrack
                         atTime:kCMTimeZero
                          error:&videoError];
    
        
    AVMutableVideoCompositionLayerInstruction *layerInst = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    
    CGFloat rate = 1.0;
    
    CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty );
    layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影响
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称


    
    [layerInst setTransform:layerTransform atTime:kCMTimeZero];
    [layerInst setOpacity:0.0 atTime:asset.duration];
    
    
    AVMutableVideoCompositionInstruction *mainInst = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInst.layerInstructions = @[layerInst];
    mainInst.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);

    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.instructions = @[mainInst];
    videoComposition.renderSize = renderSize;
    videoComposition.frameDuration = CMTimeMake(1, 30);
    

    //系统的
//    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
//    exportSession.videoComposition = videoComposition;
//    exportSession.outputFileType = AVFileTypeMPEG4;
//    NSURL *outFileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",[url.relativePath stringByReplacingOccurrencesOfString:@"mov" withString:@"mp4"]]];
//    exportSession.outputURL = outFileUrl;
//    [exportSession exportAsynchronouslyWithCompletionHandler:^{
//       
//        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
//            NSLog(@"压缩成功啦~~");
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            [fileManager removeItemAtURL:url error:nil];
//            
//            if ([_delegate respondsToSelector:@selector(recordDidFinishOutFileAtUrl:)]) {
//                [_delegate recordDidFinishOutFileAtUrl:exportSession.outputURL];
//            }
//
//        }
//        else{
//            NSLog(@"压缩失败 %@",exportSession.error);
//        }
//        
//    }];
    //第三方的
    SDAVAssetExportSession *session = [SDAVAssetExportSession exportSessionWithAsset:mixComposition];
    session.videoComposition = videoComposition;
    session.outputFileType = AVFileTypeMPEG4;
    session.outputURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@",[url.relativePath stringByReplacingOccurrencesOfString:@"mov" withString:@"mp4"]]];;
    //    session.delegate = self;
    session.videoSettings = @{
                              AVVideoCodecKey:AVVideoCodecH264,
                              AVVideoWidthKey:@1000,//[NSNumber numberWithInteger:CGRectGetWidth(_bgView.frame)],
                              AVVideoHeightKey:@750,//[NSNumber numberWithInteger:CGRectGetHeight(_bgView.frame)],
                              AVVideoCompressionPropertiesKey:@{
                                      AVVideoAverageBitRateKey:@1000000,
                                      AVVideoProfileLevelKey:AVVideoProfileLevelH264High41
                                      }
                              };
    
    session.audioSettings = @{
                              AVFormatIDKey:@(kAudioFormatMPEG4AAC),
                              AVNumberOfChannelsKey:@2,
                              AVSampleRateKey:@16000,
                              AVEncoderBitRateKey:@64000,
                              };
    
    [session exportAsynchronouslyWithCompletionHandler:^{
        
        if (AVAssetExportSessionStatusCompleted == session.status) {
            NSLog(@"压缩成功啦~~");
            dispatch_async(dispatch_get_main_queue(), ^{

                if ([_delegate respondsToSelector:@selector(recordDidFinishOutFileAtUrl:)]) {
                    [_delegate recordDidFinishOutFileAtUrl:session.outputURL];
                }
            });
            
        }
        else{
            NSLog(@"压缩失败 %@",session.error);
        }
    }];
}
#pragma mark - init attribute
- (AVCaptureSession *)captureSession{
    if (_captureSession) {
        return _captureSession;
    }
    _captureSession = [[AVCaptureSession alloc] init];
    return _captureSession;
}

- (AVCaptureMovieFileOutput *)movieFileOutput{
    if (_movieFileOutput) {
        return _movieFileOutput;
    }
    _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    return _movieFileOutput;
}

@end
