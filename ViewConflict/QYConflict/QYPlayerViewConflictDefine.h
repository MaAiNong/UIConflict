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

@class QYPlayerViewConflictManager;

//返回值代表是否 隐藏 显示, other 预留，暂时为nil
typedef BOOL (^QYConfictHandler)(QYView_ConflictAction conflictAction, NSDictionary* _Nullable   other);

////////////////////////////////////////////////////////////////////////////////////

@protocol  QYPlayerViewConflictProtocol <NSObject>

@required

@property(nonatomic,assign)QYView_ShowPriority conflict_showPriority;

@property(nonatomic,copy)QYConfictHandler confictHandler;

@end

NS_ASSUME_NONNULL_END
