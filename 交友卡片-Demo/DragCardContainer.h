//
//  DragCardContainer.h
//  交友卡片-Demo
//
//  Created by 张建 on 2017/5/3.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMacro.h"
#import "CustomCardView.h"

@class DragCardContainer;

@protocol DragCardContainerDelegate <NSObject>

//拖拽过程的回调
- (void)dragCardContainer:(DragCardContainer *)dragCardContainer
            DargDirection:(DragDirection)dragDicrection
               WidthRatio:(CGFloat)widthRatio
              HeightRadio:(CGFloat)heightRadio;

//拖拽完成的回调
- (void)dragCardContainer:(DragCardContainer *)dragCardContainer FinishedDragLastCard:(BOOL)finishedDragLastCard;

//点击卡片的手势
- (void)dragCardContainer:(DragCardContainer *)dragCardContainer CardView:(CustomCardView *)cardView DidSelectIndex:(NSInteger)didSelectIndex;

@end

@interface DragCardContainer : UIView

//代理
@property (nonatomic,weak)id<DragCardContainerDelegate>delegate;

//数据
@property (nonatomic,strong)NSMutableArray * dataSource;

//拖拽方向
@property (nonatomic,assign)DragDirection direction;

//刷新数据
- (void)reloadData;

//移除card的方法
- (void)removeCardWithDirection:(DragDirection)direction;

@end
