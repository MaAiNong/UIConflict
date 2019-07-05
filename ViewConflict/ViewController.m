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
@property (weak, nonatomic) IBOutlet UIButton *rollControlButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseControl;
@property (weak, nonatomic) IBOutlet UIButton *commonControl;
@property (weak, nonatomic) IBOutlet UIButton *readyControl;

@end

@implementation ViewController{
    QYPlayerViewConflictManager* _conflictManager;
    QYPreadView* _vwRoll;
    QYPuaseView* _vwPause;
    QYCommonView* _vwCommon;
    QYReadyBuyView* _vwReadyBuy;
    QYReadyBuyView* _vwReadyBuy2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册需要处理的View
    {
        QYPreadView* preadView = [[QYPreadView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [preadView setText:@"贴片"];
        [self.view addSubview:preadView];preadView.backgroundColor = [UIColor redColor];
        preadView.conflict_showPriority = QYViewPriority_RollAD;//可以放在 QYPreadView 的初始化口里面
        _vwRoll = preadView;
    }
    
    //注册需要处理的View
    {
        QYPuaseView* pause = [[QYPuaseView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-100, 100, 100)];
        [self.view addSubview:pause];pause.backgroundColor = [UIColor orangeColor];
        pause.conflict_showPriority = QYViewPriority_PauseAD;//可以放在 QYPuaseView 的初始化口里面
        [pause setText:@"暂停"];
        _vwPause = pause;
    }
    
    {
        //注册需要处理的View
        QYCommonView* view= [[QYCommonView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, self.view.bounds.size.height-100, 100, 100)];
        [self.view addSubview:view];view.backgroundColor = [UIColor yellowColor];
        view.conflict_showPriority = QYViewPriority_CommonViewAD;//可以放在 QYCommonView 的初始化口里面
        [view setText:@"浮层"];
        _vwCommon = view;
    }
    
    {
        //注册需要处理的View
        QYReadyBuyView* view= [[QYReadyBuyView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100,0, 100, 100)];
        [self.view addSubview:view];view.backgroundColor = [UIColor greenColor];
        view.conflict_showPriority = QYViewPriority_ReadyBuyOverlay;//可以放在 QYReadyBuyView 的初始化口里面
        [view setText:@"随视购"];
        _vwReadyBuy = view;
    }
    
    {
        //注册需要处理的View
        QYReadyBuyView* view= [[QYReadyBuyView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100-50, self.view.bounds.size.height-100-50, 100, 100)];
        [self.view addSubview:view];view.backgroundColor = [UIColor greenColor];
        view.conflict_showPriority = QYViewPriority_ReadyBuyOverlay;//可以放在 QYReadyBuyView 的初始化口里面
        [view setText:@"随视购"];
        _vwReadyBuy2 = view;
    }
    
    //******************************必须保证1 2 3 顺序******************************
    //1 初始话冲突管理器
    _conflictManager = [[QYPlayerViewConflictManager alloc] init];
    //2 注册规则
    [_conflictManager registConflictConfiguration:[[QYConflictViewConfig sharedInstance] mainPlayerConflict]];
    
    //3 注册视图
    [_conflictManager registViews:@[_vwPause,_vwCommon,_vwReadyBuy2,_vwReadyBuy,_vwRoll]];

//    [_conflictManager registView:_vwReadyBuy];
//    [_conflictManager registView:_vwRoll];
//    [_conflictManager registView:_vwPause];
//    [_conflictManager registView:_vwCommon];
//    [_conflictManager registView:_vwReadyBuy2];
    
}

-(IBAction)didRollControlButtonClick:(id)sender{
    static BOOL isShow = YES;
    isShow = ![_vwRoll conflict_isShowing];
    
    if(isShow){
        if ([_conflictManager canShowView:_vwRoll]) {
            [_vwRoll conflict_show:nil];
        }else{
            return;
        }
        
        if ([_conflictManager canShowView:_vwRoll]) {
            [_vwRoll conflict_show:nil];
        }else{
            [_vwRoll conflict_hide:nil];
        }
        
    }
    else{
        [_vwRoll conflict_hide:nil];
    }
    
    [_conflictManager notifyOtherViewsShowStatusChanged:_vwRoll];
    
}
-(IBAction)didPauseControlClick:(id)sender{
    static BOOL isShow = YES;
    isShow = ![_vwPause conflict_isShowing];
    
    if(isShow){
        if ([_conflictManager canShowView:_vwPause]) {
            [_vwPause conflict_show:nil];
        }else{
            return;
        }
    }
    else{
        [_vwPause conflict_hide:nil];
    }
    

    [_conflictManager notifyOtherViewsShowStatusChanged:_vwPause];
    
}
-(IBAction)didCommonControlClick:(id)sender{
    
    static BOOL isShow = YES;
    isShow = ![_vwCommon conflict_isShowing];
    
    if(isShow){
        if ([_conflictManager canShowView:_vwCommon]) {
            [_vwCommon conflict_show:nil];
        }else{
            return;
        }
    }
    else{
        [_vwCommon conflict_hide:nil];
    }
    

    [_conflictManager notifyOtherViewsShowStatusChanged:_vwCommon];
    
}

-(IBAction)didReadyControlClick:(id)sender{
    
    {
        static BOOL isShow = YES;
        isShow = ![_vwReadyBuy conflict_isShowing];
        
        if(isShow){
            if ([_conflictManager canShowView:_vwReadyBuy]) {
                [_vwReadyBuy conflict_show:nil];
            }else{
                return;
            }
        }
        else{
            [_vwReadyBuy conflict_hide:nil];
        }
        

        [_conflictManager notifyOtherViewsShowStatusChanged:_vwReadyBuy];
    }
    
    {
        static BOOL isShow = YES;
        isShow = ![_vwReadyBuy2 conflict_isShowing];
        
        if(isShow){
            if ([_conflictManager canShowView:_vwReadyBuy2]) {
                [_vwReadyBuy2 conflict_show:nil];
            }else{
                return;
            }
        }
        else{
            [_vwReadyBuy2 conflict_hide:nil];
        }
        
        
        [_conflictManager notifyOtherViewsShowStatusChanged:_vwReadyBuy2];
    }
}

-(IBAction)didReleasePauseClick:(id)sender{
    
    [_conflictManager deregistView:_vwPause];
    [_vwPause removeFromSuperview];
    _vwPause = nil;
}

@end
