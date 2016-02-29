//
//  DMVideoDisplayCell.m
//  DMShortVideo
//
//  Created by viziner on 16/2/29.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "DMVideoDisplayCell.h"

@interface DMVideoDisplayCell ()

@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DMVideoDisplayCell

- (void)awakeFromNib {
    // Initialization code
    _imageBgView.layer.cornerRadius = 5.0;
    _imageBgView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)setDataModel:(AllVideoDataModel *)dataModel{
    _dataModel = dataModel;
    
    AVAsset *asset = [AVAsset assetWithURL:_dataModel.fileUrl];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:nil error:nil];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    _imageView.image = image;
}
@end
