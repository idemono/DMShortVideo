//
//  DMAllVideoDisplayViewController.m
//  DMShortVideo
//
//  Created by viziner on 16/2/29.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "DMAllVideoDisplayViewController.h"
#import "DMVideoAddCell.h"
#import "DMVideoDisplayCell.h"


@interface DMAllVideoDisplayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (strong, nonatomic)__block NSArray *dataModels;
@end

@implementation DMAllVideoDisplayViewController

- (instancetype)init{
    self = [super initWithNibName:NSStringFromClass([DMAllVideoDisplayViewController class])
                           bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self collectionInit];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _dataModels = [AllVideoDataModel getAllVideos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mainCollectionView reloadData];
        });
    });
}

#pragma mark - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return _dataModels.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _dataModels.count) {
        DMVideoDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMVideoDisplayCell class])
                                                                             forIndexPath:indexPath];
        AllVideoDataModel *dataModel = [_dataModels objectAtIndex:indexPath.row];
        cell.dataModel = dataModel;
        return cell;
    }
    else{
        DMVideoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DMVideoAddCell class])
                                                                             forIndexPath:indexPath];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(__WINDOW_WIDTH / 3.0 - 5, (__WINDOW_WIDTH / 3.0 - 3) * 3/4.0);
}

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _dataModels.count) {
        //跳转
        DMRecorderViewController *recorderViewController = [[DMRecorderViewController alloc] init];
        [self presentViewController:recorderViewController animated:NO completion:NULL];
    }
    else{
        AllVideoDataModel *dataModel = [_dataModels objectAtIndex:indexPath.row];
        MPMoviePlayerViewController* playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:dataModel.fileUrl];
        [self presentViewController:playerView animated:YES completion:NULL];

    }
    
}
- (void)collectionInit{
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMVideoDisplayCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([DMVideoDisplayCell class])];
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMVideoAddCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([DMVideoAddCell class])];
    
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    
}



@end
