//
//  DMVideoDisplayCell.h
//  DMShortVideo
//
//  Created by viziner on 16/2/29.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMVideoRecorderManager.h"

@protocol DMVideoDisplayCellProtocol <NSObject>

- (void)deleteVideoUrl:(NSURL *)url;

@end

@interface DMVideoDisplayCell : UICollectionViewCell

@property (strong, nonatomic)id<DMVideoDisplayCellProtocol>delegate;
- (void)setDataModel:(AllVideoDataModel *)dataModel isEditing:(BOOL)isEditing;
@end
