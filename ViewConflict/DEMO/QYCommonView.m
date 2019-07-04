//
//  QYCommonView.m
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/7/4.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "QYCommonView.h"

@implementation QYCommonView

//是否正在展示
-(BOOL)conflict_isShowing{
    if (self.isHidden || 0.0f == self.alpha || nil==self.superview) {
        return NO;
    }
    return YES;
}

//隐藏
-(void)conflict_hide:(QYConflictReason*)hideReason{
    
    self.hidden = YES;
}

//显示
-(void)conflict_show:(QYConflictReason*)hideReason{
    self.hidden = NO;
}

@end
