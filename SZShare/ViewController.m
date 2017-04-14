//
//  ViewController.m
//  SZShare
//
//  Created by cnbs_01 on 17/4/5.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "ViewController.h"
#import "SZShareHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [SZShareSheet shareToPlatformsWithMessage:nil onShareStateChanged:^(SZShareState state) {
        switch (state) {
            case SZShareStateWithOutSupportPlatform:
                NSLog(@"no platforms has exist!");
                break;
            case SZShareStateSuccess:
                break;
            case SZShareStateFailure:
                break;
            case SZShareStateCancel:
                break;
            default:
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
