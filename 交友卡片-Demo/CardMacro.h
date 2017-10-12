//
//  CardMacro.h
//  交友卡片-Demo
//
//  Created by 张建 on 2017/5/3.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#ifndef CardMacro_h
#define CardMacro_h

/**
 拽到方向枚举
 */
typedef NS_OPTIONS(NSInteger, DragDirection) {
    DragDirectionDefault     = 0,
    DragDirectionLeft        = 1 << 0,
    DragDirectionRight       = 1 << 1
};

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

//navBar
static const CGFloat kNavBarH = 64.0f;

//可见的数量
static const CGFloat kVisibleCount = 3;

//边缘距离
static const CGFloat kContainerEdage = 15.0f;
static const CGFloat kCardEdage = 15.0f;

//card的大小比例
static const CGFloat kFirstCardScale = 1.0f;
static const CGFloat kSecondCardScale = 0.95f;
static const CGFloat kThirtyCardScale = 0.9f;

//card消失或移除的比例
static const CGFloat kCardViewDisappearScale = 0.8f;

#endif 
