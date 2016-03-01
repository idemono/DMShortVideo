//
//  ViewController.m
//  DMShortVideo
//
//  Created by viziner on 16/2/25.
//  Copyright © 2016年 idemonolater. All rights reserved.
//

#import "ViewController.h"
#import "DMVideoRecorderManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self performSelector:@selector(recorderAction:) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)recorderAction:(id)sender {
    DMAllVideoDisplayViewController *recorderViewController = [[DMAllVideoDisplayViewController alloc] init];
    [self presentViewController:recorderViewController animated:NO completion:NULL];
}

@end
