//
//  QYCommonView.h
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/7/4.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYPlayerViewConflictConstants.h"
#import "QYPlayerViewConflictDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface QYCommonView : UILabel<QYPlayerViewConflictProtocol>
@property(nonatomic,assign)QYView_ShowPriority conflict_showPriority;

//是否正在展示
-(BOOL)conflict_isShowing;

//隐藏
-(void)conflict_hide:(QYConflictReason*)hideReason;

//显示
-(void)conflict_show:(QYConflictReason*)hideReason;
@end

NS_ASSUME_NONNULL_END
