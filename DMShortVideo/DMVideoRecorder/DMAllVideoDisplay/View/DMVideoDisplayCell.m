//
//  DMVideoDisplayCell.m
//  DMShortVideo
//
//  Created by viziner on 16/2/29.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "DMVideoDisplayCell.h"

@interface DMVideoDisplayCell ()
@property (strong, nonatomic)AllVideoDataModel *dataModel;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *deleteBgView;

//image constaint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraintRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraintBottom;

@end

@implementation DMVideoDisplayCell

- (void)awakeFromNib {
    // Initialization code
    _imageView.layer.cornerRadius = 5.0;
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _deleteBgView.layer.cornerRadius = CGRectGetWidth(_deleteBgView.frame) / 2.0;
    _deleteBgView.layer.masksToBounds = YES;
    _deleteBgView.hidden = YES;
    
}
- (IBAction)tapDeleteGesture:(id)sender {
    NSLog(@"删除");
    if ([_delegate respondsToSelector:@selector(deleteVideoUrl:)]) {
        [_delegate deleteVideoUrl:_dataModel.fileUrl];
    }
    
}

- (void)setDataModel:(AllVideoDataModel *)dataModel{
    _dataModel = dataModel;
    
    AVAsset *asset = [AVAsset assetWithURL:_dataModel.fileUrl];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:nil error:nil];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    _imageView.image = image;
}

- (void)setDataModel:(AllVideoDataModel *)dataModel isEditing:(BOOL)isEditing{
    self.dataModel = dataModel;
    
    if (isEditing) {
        _deleteBgView.hidden = NO;
        _imageViewConstraintTop.constant = 5;
        _imageViewConstraintLeft.constant = 5;
        _imageViewConstraintRight.constant = 5;
        _imageViewConstraintBottom.constant = 5;
    }
    else{
        _deleteBgView.hidden = YES;
        _imageViewConstraintTop.constant =0;
        _imageViewConstraintLeft.constant = 0;
        _imageViewConstraintRight.constant = 0;
        _imageViewConstraintBottom.constant = 0;
    }
    
}
@end
