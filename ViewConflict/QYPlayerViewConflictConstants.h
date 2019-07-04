//
//  QYPlayerViewConflictConstants.h
//  ViewConflict
//
//  Created by xukaitiankevin on 2019/6/30.
//  Copyright © 2019 xukaitian. All rights reserved.
//

#ifndef QYPlayerViewConflictConstants_h
#define QYPlayerViewConflictConstants_h

#define KEY_PRIORITY @"KEY_PRIORITY"
#define KEY_CONFLICT @"KEY_CONFLICT"

typedef enum {
    QYViewConflictType_Unknown=-1,
    QYViewConflictType_Exclusion,//逻辑互斥
    QYViewConflictType_Intersection,//UI交错1
    
}QYView_ConflictType;


//按照显示优先级排列，由上到下，优先级递减
typedef enum {

    QYViewPriority_RollAD,//贴片
    QYViewPriority_PauseAD,//暂停
    QYViewPriority_CommonViewAD,//通用浮层
    QYViewPriority_ReadyBuyOverlay,//随视购小浮层
    
}QYView_ShowPriority;

#endif /* QYPlayerViewConflictConstants_h */
