//
//  ViewController.m
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "ViewController.h"
#import "QYPlayerViewConflictPublic.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *rollControlButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseControl;
@property (weak, nonatomic) IBOutlet UIButton *commonControl;
@property (weak, nonatomic) IBOutlet UIButton *readyControl;

@end

@implementation ViewController{
    QYPlayerViewConflictManager* _conflictManager;
    UILabel* _vwRoll;
    UILabel* _vwPause;
    UILabel* _vwCommon;
    UILabel* _vwReadyBuy;
    UILabel* _vwReadyBuy2;
}


//如果一个view的显示隐藏完全受控于 这个系统中的view 可以使用
-(QYConfictHandler)defaultConflictHandler:(UIView*)view{
    if (!view) {
        return NULL;
    }
    __weak UIView* weakView = view;
    QYConfictHandler handler = ^ BOOL (QYView_ConflictAction conflictAction,NSDictionary* other)
    {
        switch (conflictAction) {
                       case QYViewConflictAction_Hide:{
                           weakView.hidden = YES;
                       }break;
                       case QYViewConflictAction_Show:{
                           weakView.hidden = NO;
                       }break;
                       case QYViewConflictAction_ShowState:{
                           return !weakView.isHidden;
                       }
                       default:break;
                   }
                   return !weakView.isHidden;
    };
    
    return handler;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册需要处理的View
    {
        UILabel* preadView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [preadView setText:@"贴片"];
        [self.view addSubview:preadView];preadView.backgroundColor = [UIColor redColor];
        preadView.conflict_showPriority = QYViewPriority_RollAD;//可以放在 QYPreadView 的初始化口里面
        _vwRoll = preadView;
        preadView.confictHandler = [self defaultConflictHandler:preadView];
    }
    
    //注册需要处理的View
    {
        UILabel* pause = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-100, 100, 100)];
        [self.view addSubview:pause];pause.backgroundColor = [UIColor orangeColor];
        pause.conflict_showPriority = QYViewPriority_PauseAD;//可以放在 QYPuaseView 的初始化口里面
        [pause setText:@"暂停"];
        _vwPause = pause;
        pause.confictHandler = [self defaultConflictHandler:pause];
    }
    
    {
        //注册需要处理的View
        UILabel* view= [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100, self.view.bounds.size.height-100, 100, 100)];
        [self.view addSubview:view];view.backgroundColor = [UIColor yellowColor];
        view.conflict_showPriority = QYViewPriority_CommonViewAD;//可以放在 QYCommonView 的初始化口里面
        [view setText:@"浮层"];
        _vwCommon = view;
        view.confictHandler = [self defaultConflictHandler:view];
    }
    
    {
        //注册需要处理的View
        UILabel* view= [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100,0, 100, 100)];
        [self.view addSubview:view];view.backgroundColor = [UIColor greenColor];
        view.conflict_showPriority = QYViewPriority_ReadyBuyOverlay;//可以放在 QYReadyBuyView 的初始化口里面
        [view setText:@"随视购"];
        _vwReadyBuy = view;
        _vwReadyBuy.confictHandler = [self defaultConflictHandler:_vwReadyBuy];
    }
    
    {
        //注册需要处理的View
        UILabel* view= [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100-50, self.view.bounds.size.height-100-50, 100, 100)];
        [self.view addSubview:view];view.backgroundColor = [UIColor greenColor];
        view.conflict_showPriority = QYViewPriority_ReadyBuyOverlay;//可以放在 QYReadyBuyView 的初始化口里面
        [view setText:@"随视购"];
        _vwReadyBuy2 = view;
        _vwReadyBuy2.confictHandler = [self defaultConflictHandler:_vwReadyBuy2];
    }
    
    //******************************必须保证1 2 3 顺序******************************
    //1 初始话冲突管理器
    _conflictManager = [[QYPlayerViewConflictManager alloc] init];
    //2 注册规则
    [_conflictManager registConflictConfiguration:[[QYConflictViewConfig sharedInstance] mainPlayerConflict]];
    
    //3 注册视图
    [_conflictManager registViews:@[_vwPause,_vwCommon,_vwReadyBuy2,_vwReadyBuy,_vwRoll]];
    
//    [_conflictManager registView:_vwPause];
//    [_conflictManager registView:_vwReadyBuy];
//    [_conflictManager registView:_vwReadyBuy2];
//    [_conflictManager registView:_vwRoll];
//    [_conflictManager registView:_vwCommon];
    
}

-(IBAction)didRollControlButtonClick:(id)sender{
    static BOOL isShow = YES;
    isShow = _vwRoll.isHidden;
    
    if(isShow){
        if ([_conflictManager canShowView:_vwRoll]) {
            _vwRoll.hidden = NO;
        }else{
            return;
        }
        
        if ([_conflictManager canShowView:_vwRoll]) {
            _vwRoll.hidden = NO;
        }else{
            _vwRoll.hidden = YES;
        }
        
    }
    else{
        _vwRoll.hidden = YES;
    }
    
    [_conflictManager notifyOtherViewsShowStatusChanged:_vwRoll];
    
}
-(IBAction)didPauseControlClick:(id)sender{
    static BOOL isShow = YES;
    isShow = _vwPause.isHidden;
    
    if(isShow){
        if ([_conflictManager canShowView:_vwPause]) {
            _vwPause.hidden = NO;
        }else{
            return;
        }
    }
    else{
        _vwPause.hidden = YES;
    }
    

    [_conflictManager notifyOtherViewsShowStatusChanged:_vwPause];
    
}
-(IBAction)didCommonControlClick:(id)sender{
    
    static BOOL isShow = YES;
    isShow = _vwCommon.isHidden;
    
    if(isShow){
        if ([_conflictManager canShowView:_vwCommon]) {
            _vwCommon.hidden = NO;
        }else{
            return;
        }
    }
    else{
        _vwCommon.hidden = YES;
    }
    

    [_conflictManager notifyOtherViewsShowStatusChanged:_vwCommon];
    
}

-(IBAction)didReadyControlClick:(id)sender{
    
    {
        static BOOL isShow = YES;
        isShow = [_vwReadyBuy isHidden];
        
        if(isShow){
            if ([_conflictManager canShowView:_vwReadyBuy]) {
                [_vwReadyBuy setHidden:NO];
            }else{
                return;
            }
        }
        else{
            [_vwReadyBuy setHidden:YES];
        }
        

        [_conflictManager notifyOtherViewsShowStatusChanged:_vwReadyBuy];
    }
    
    {
        static BOOL isShow = YES;
        isShow = [_vwReadyBuy2 isHidden];
        
        if(isShow){
            if ([_conflictManager canShowView:_vwReadyBuy2]) {
                [_vwReadyBuy2 setHidden:NO];
            }else{
                return;
            }
        }
        else{
            [_vwReadyBuy2 setHidden:YES];
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
