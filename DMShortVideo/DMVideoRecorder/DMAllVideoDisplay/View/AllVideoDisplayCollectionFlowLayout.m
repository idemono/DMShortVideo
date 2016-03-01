//
//  AllVideoDisplayCollectionFlowLayout.m
//  DMShortVideo
//
//  Created by viziner on 16/3/1.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "AllVideoDisplayCollectionFlowLayout.h"

@implementation AllVideoDisplayCollectionFlowLayout
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        [self setMinimumInteritemSpacing:1];
        [self setMinimumLineSpacing:5];
        
    }
    return self;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        [self setMinimumInteritemSpacing:1];
        [self setMinimumLineSpacing:5];
        
    }
    return self;
}
@end
