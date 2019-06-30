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


@end


@interface QYPlayerConflictViewMessage : NSObject

@property(nonatomic,weak)UIView* currentView;
@property(nonatomic,assign)QYPlayerView_ShowPriority viewPriority;

//唯一初始化方法
-(id)init;

@end


NS_ASSUME_NONNULL_END
