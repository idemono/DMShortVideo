//
//  DMVideoAddCell.m
//  DMShortVideo
//
//  Created by viziner on 16/2/29.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "DMVideoAddCell.h"

@interface DMVideoAddCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;

@end

@implementation DMVideoAddCell

- (void)awakeFromNib {
    _bgView.layer.cornerRadius = 5.0;
    _bgView.layer.masksToBounds = YES;
    
}

@end
