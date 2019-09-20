//
//  UIView+QYUIConflict.h
//  ViewConflict
//
//  Created by xukaitian on 2019/9/20.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYPlayerViewConflictDefine.h"
NS_ASSUME_NONNULL_BEGIN


@interface UIView (QYUIConflict)<QYPlayerViewConflictProtocol>

@property(nonatomic,assign)QYView_ShowPriority conflict_showPriority;
@property(nonatomic,copy)QYConfictHandler confictHandler;

@end

NS_ASSUME_NONNULL_END
