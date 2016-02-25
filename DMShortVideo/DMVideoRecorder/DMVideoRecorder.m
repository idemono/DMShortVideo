//
//  DMVideoRecorder.m
//  DMShortVideo
//
//  Created by viziner on 16/2/25.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "DMVideoRecorder.h"

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
