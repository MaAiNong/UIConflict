//
//  ViewController.m
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "ViewController.h"
#import "QYPlayerViewConflictManager.h"
#import "QYPreadView.h"
#import "QYPuaseView.h"
#import "QYCommonView.h"
#import "QYReadyBuyView.h"

@interface ViewController ()

@end

@implementation ViewController{
    QYPlayerViewConflictManager* _conflictManager;
    UIView* vmglobal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始话冲突管理器
    _conflictManager = [[QYPlayerViewConflictManager alloc] init];
    
    //注册规则
    [_conflictManager registConflictConfiguration:[[QYConflictViewConfig sharedInstance] mainPlayerConflict]];
    
    //注册需要处理的View
    {
        QYPreadView* preadView = [[QYPreadView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self.view addSubview:preadView];preadView.backgroundColor = [UIColor redColor];
        preadView.conflict_showPriority = QYViewPriority_RollAD;//可以放在 QYPreadView 的初始化口里面
        
        [_conflictManager registView:preadView];
        [_conflictManager  updateShowHideStatusForView:preadView];
    }
    
    //注册需要处理的View
    {
        QYPuaseView* pause = [[QYPuaseView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-100, 100, 100)];
        [self.view addSubview:pause];pause.backgroundColor = [UIColor orangeColor];
        pause.conflict_showPriority = QYViewPriority_PauseAD;//可以放在 QYPuaseView 的初始化口里面
        [_conflictManager registView:pause];
        [_conflictManager  updateShowHideStatusForView:pause];
    }
    
    {
        //注册需要处理的View
        QYCommonView* view= [[QYCommonView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, self.view.bounds.size.height-100, 100, 100)];
        [self.view addSubview:view];view.backgroundColor = [UIColor yellowColor];
        view.conflict_showPriority = QYViewPriority_CommonViewAD;//可以放在 QYCommonView 的初始化口里面
        [_conflictManager registView:view];
        [_conflictManager  updateShowHideStatusForView:view];
    }
    
    {
        //注册需要处理的View
        QYReadyBuyView* view= [[QYReadyBuyView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100,0, 100, 100)];
        [self.view addSubview:view];view.backgroundColor = [UIColor greenColor];
        view.conflict_showPriority = QYViewPriority_ReadyBuyOverlay;//可以放在 QYReadyBuyView 的初始化口里面
        [_conflictManager registView:view];
        [_conflictManager  updateShowHideStatusForView:view];
    }
    
    
    
}
@end
