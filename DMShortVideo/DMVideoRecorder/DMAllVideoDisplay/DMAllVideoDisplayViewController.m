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


#define DMVideoDisplayCellIDEN @"DMVideoDisplayCellIDEN"
#define DMVideoAddCellIDEN     @"DMVideoAddCellIDEN"

@interface DMAllVideoDisplayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DMVideoDisplayCellProtocol>
{
    BOOL isEditing;
}

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
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
    
    [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_editButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self collectionInit];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - normal methods

- (void)loadData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _dataModels = [AllVideoDataModel getAllVideos];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mainCollectionView reloadData];
        });
    });
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)editAction{
    isEditing = !isEditing;
    if (isEditing) {
        [_editButton setTitle:@"完成"
                     forState:UIControlStateNormal];
        _backButton.hidden = YES;
    }
    else{
        [_editButton setTitle:@"编辑"
                     forState:UIControlStateNormal];
        _backButton.hidden = NO;
    }
    [_mainCollectionView reloadData];
}

#pragma mark - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    if(isEditing){
        return _dataModels.count;
    }
    return _dataModels.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _dataModels.count) {
        DMVideoDisplayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DMVideoDisplayCellIDEN
                                                                             forIndexPath:indexPath];
        AllVideoDataModel *dataModel = [_dataModels objectAtIndex:indexPath.row];
        cell.delegate = self;
        [cell setDataModel:dataModel isEditing:isEditing];
        return cell;
    }
    else{
        DMVideoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DMVideoAddCellIDEN
                                                                             forIndexPath:indexPath];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(__WINDOW_WIDTH / 3.0 - 5, (__WINDOW_WIDTH / 3.0 - 3) * 3/4.0);
}

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(isEditing){
        return;
    }
    
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
- (void)deleteVideoUrl:(NSURL *)url{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtURL:url error:nil];
    [self loadData];
}

- (void)collectionInit{
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMVideoDisplayCell class]) bundle:nil] forCellWithReuseIdentifier:DMVideoDisplayCellIDEN];
    [_mainCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DMVideoAddCell class]) bundle:nil] forCellWithReuseIdentifier:DMVideoAddCellIDEN];
    
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    
}



@end
