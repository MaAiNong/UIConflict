//
//  QYPlayerViewConflictConstants.h
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#ifndef QYPlayerViewConflictConstants_h
#define QYPlayerViewConflictConstants_h

typedef enum {
    
    QYPlayerConflictType_Exclusion,
    QYPlayerConflictType_Intersection,
    
}QYPlayerConflictType;


//最上面的优先级最高
typedef enum {
    
    QYViewPriority_ControlMain,//主播控
    QYViewPriority_PauseAD,//暂停
    QYViewPriority_CommonViewAD,//通用浮层
    
}QYView_ShowPriority;

#endif /* QYPlayerViewConflictConstants_h */
