//
//  QYPlayerViewConflictDefine.h
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QYPlayerViewConflictConstants.h"
NS_ASSUME_NONNULL_BEGIN

@protocol  QYPlayerViewConflictDelegate <NSObject>


@end

@protocol  QYPlayerViewConflictProtocol <NSObject>

@required

@property(nonatomic,strong)NSString* conflict_showPriority;

//是否正在展示
-(BOOL)conflict_isShowing;

//隐藏
-(void)conflict_hide;

//显示
-(void)conflict_show;

@end



NS_ASSUME_NONNULL_END
