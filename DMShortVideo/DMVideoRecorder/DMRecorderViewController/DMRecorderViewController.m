//
//  DMRecorderViewController.m
//  DMShortVideo
//
//  Created by viziner on 16/2/29.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "DMRecorderViewController.h"


#define RECORDER_TIME 10
#define REFRESH_TIME  0.01

@interface DMRecorderViewController ()<DMVideoRecorderProtocol>
{
    NSTimer *time;
    CGFloat progressValue;
    
}
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *recorderView;
@property (weak, nonatomic) IBOutlet UIView *recorderButtonBg;
@property (weak, nonatomic) IBOutlet UIButton *recorderButton;

@property (strong, nonatomic)DMVideoRecorder *videoRecorder;

//进度条
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressLeft;
@property (weak, nonatomic) IBOutlet UIProgressView *progressRight;
@property (weak, nonatomic) IBOutlet UIView *cancelRecordView;

@end

@implementation DMRecorderViewController

- (instancetype)init{
    self = [super initWithNibName:NSStringFromClass([DMRecorderViewController class])
                           bundle:nil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self dm_initView];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.videoRecorder.preLayer.frame = _recorderView.bounds;
}

#pragma mark - Delegate

- (void)recordDidFinishOutFileAtUrl:(NSURL *)outFileUrl{
    NSLog(@"%@",outFileUrl.absoluteString);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)recordDidTimeShort{
    NSLog(@"录制时间太短");
}
#pragma mark - normal Actions

- (void)cancelAction:(UIButton *)button{
    [self.videoRecorder cancelRecorderMovie];
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void)recorderTouchDown:(UIButton *)button{
    NSLog(@"recorder 按下");
    _recorderButtonBg.hidden = YES;
    [self startRecorder];
}

- (void)recorderTouchCandel:(UIButton *)button{
    NSLog(@"recorder 取消");
    _recorderButtonBg.hidden = NO;
    [self hiddenProgress];
}

- (void)recorderTouchUp:(UIButton *)button{
    NSLog(@"recorder 完成");
    _recorderButtonBg.hidden = NO;
    [self hiddenProgress];
}

+ (NSURL *)getNewRecorderUrl{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *basePath = VIDEO_PATH;
    if (![fileManager fileExistsAtPath:basePath]) {
        [fileManager createDirectoryAtPath:basePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSURL *url = [NSURL fileURLWithPath:[basePath stringByAppendingPathComponent:[DMRecorderViewController getRecorderName]]];
    return url;
}

+ (NSString *)getRecorderName{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *name = [NSString stringWithFormat:@"%@.mov",[formater stringFromDate:[NSDate date]]];
    return name;
}
//进度条
- (void)startRecorder{
    [self.videoRecorder startRecorderMovieFileOutUrl:[DMRecorderViewController getNewRecorderUrl]];
    progressValue = 1;
    time = [NSTimer scheduledTimerWithTimeInterval:REFRESH_TIME
                                             target:self
                                           selector:@selector(setProgress)
                                           userInfo:nil
                                            repeats:YES];
    [time fire];
}

- (void)setProgress{
    progressValue -= REFRESH_TIME / RECORDER_TIME;
    [self progressValue:progressValue];
}

- (void)progressValue:(CGFloat)progress{
    if (progressValue>=1) {
        progressValue = 1;
    }
    if (progressValue<=0) {
        progressValue = 0;
        [self recorderTouchUp:nil];
    }
    _progressView.hidden = NO;
    _cancelRecordView.hidden = NO;
    _progressLeft.progress = _progressRight.progress = progress;
}
- (void)hiddenProgress{
    [self.videoRecorder stopRecord];
    _progressLeft.transform = CGAffineTransformMakeRotation(M_PI);
    _progressLeft.progress = _progressRight.progress = 0;
    _progressView.hidden = YES;
    _cancelRecordView.hidden = YES;
    if (time.valid) {
        [time invalidate];
    }
}


#pragma mark - init
- (void)dm_initView{
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_recorderButton setTitle:@"按住拍" forState:UIControlStateNormal];
    _recorderButtonBg.layer.cornerRadius = CGRectGetWidth(_recorderButtonBg.frame) / 2.0;
    _recorderButtonBg.layer.masksToBounds = YES;
    _recorderButtonBg.layer.borderWidth = 3.0;
    _recorderButtonBg.layer.borderColor = [UIColor colorWithRed:127/225.0 green:235/255.0 blue:55/255.0 alpha:1.0].CGColor;
    
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_recorderButton addTarget:self action:@selector(recorderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_recorderButton addTarget:self action:@selector(recorderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [_recorderButton addTarget:self action:@selector(recorderTouchCandel:) forControlEvents:UIControlEventTouchCancel];
    [_recorderButton addTarget:self action:@selector(recorderTouchCandel:) forControlEvents:UIControlEventTouchDragOutside];

    
    self.videoRecorder.preLayer.frame = _recorderView.bounds;
    [_recorderView.layer addSublayer:self.videoRecorder.preLayer];
    
    [self hiddenProgress];
    
}

- (DMVideoRecorder *)videoRecorder{
    if (_videoRecorder) {
        return _videoRecorder;
    }
    _videoRecorder = [[DMVideoRecorder alloc] init];
    _videoRecorder.delegate = self;
    return _videoRecorder;
}

@end
