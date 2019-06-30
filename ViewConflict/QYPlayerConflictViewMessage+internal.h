//
//  QYPlayerConflictViewMessage+internal.h
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#import "QYPlayerViewConflictDefine.h"

NS_ASSUME_NONNULL_BEGIN

@class QYPlayerConflictViewMessage;

@protocol QYPlayerConflictViewMessageDelegate <NSObject>

-(void)viewDidReleased:(QYPlayerConflictViewMessage*)message;

@end

@interface QYPlayerConflictViewMessage ()

@property(nonatomic,weak)id<QYPlayerConflictViewMessageDelegate> deleagte;

@end

NS_ASSUME_NONNULL_END
