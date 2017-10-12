//
//  DragCardContainer.m
//  交友卡片-Demo
//
//  Created by 张建 on 2017/5/3.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#import "DragCardContainer.h"

@interface DragCardContainer ()

//加载下标
@property (nonatomic,assign)NSInteger loadIndex;
//移动方向
@property (nonatomic,assign)BOOL moving;
//初始化第一个card的frame
@property (nonatomic,assign)CGRect firstCardFrame;
//初始化最后一个card的frame
@property (nonatomic,assign)CGRect lastCradFrame;
//初始化时最后一个Card的transform
@property (nonatomic) CGAffineTransform lastCardTransform;

//卡片的中点
@property (nonatomic,assign)CGPoint cardCenter;
//卡片的数组
@property (nonatomic,strong)NSMutableArray * currentCardsArr;


@end

@implementation DragCardContainer

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor brownColor];
    }
    
    return self;
}
- (NSMutableArray *)currentCardsArr{
    
    if (!_currentCardsArr) {
        
        _currentCardsArr = [NSMutableArray array];
    }
    return _currentCardsArr;
}
#pragma mark ---刷新数据---
- (void)reloadData{
    
    //默认配置
    [self defaultConfig];
    
    //初始化item
    [self initItem];
    
    //重置可视的card
    [self resetVisibleCards];
}

#pragma mark ---默认配置---
- (void)defaultConfig{
    
    //默认下标
    _loadIndex = 0;
    //是否移动
    _moving = NO;
    //方向默认
    _direction = DragDirectionDefault;
}

#pragma mark ---初始化item--
- (void)initItem{
    
    //最多显示4个
    if (self.dataSource) {
        
        //总数量
        NSInteger totalCount = self.dataSource.count;
        //可见的数量
        NSInteger visibleCount = totalCount <= kVisibleCount ? totalCount : kVisibleCount;
        
        /*
         在此需添加当前Card是否移动的状态A
         如果A为YES, 则执行当且仅当一次installItem, 用条件限制
         */
        if (self.loadIndex < totalCount) {
            
            //没移动就是3个，如果移动就是4个
            for (int i = (int)self.currentCardsArr.count; i < (self.moving ? visibleCount + 1 : visibleCount); i ++) {
                
                //卡片视图
                CustomCardView * cardView = [[CustomCardView alloc] initWithFrame:self.bounds];
                [cardView refreshDataWithDic:[self.dataSource objectAtIndex:self.loadIndex]];
                cardView.frame = [self defaultCardViewFrame];
                [cardView layoutFrame];
                
                NSLog(@"loadIndex:%ld",(long)self.loadIndex);
                if (self.loadIndex >= 3) {
                    
                    cardView.frame = self.lastCradFrame;
                }
                else {
                    
                    CGRect frame = cardView.frame;
                    if (CGRectIsEmpty(self.firstCardFrame)) {
                        self.firstCardFrame = frame;
                        self.cardCenter = cardView.center;
                    }
                }
                
                //tag
                cardView.tag = self.loadIndex;
                
                [self addSubview:cardView];
                // addSubview后添加sendSubviewToBack, 使Card的显示顺序倒置
                [self sendSubviewToBack:cardView];
                
                //添加到数组
                [self.currentCardsArr addObject:cardView];
                
                // 总数indexs, 计算以及加载到了第几个index
                self.loadIndex += 1;
                
                // 添加拖拽手势
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
                [cardView addGestureRecognizer:pan];

                // 点击卡片的手势
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
                [cardView addGestureRecognizer:tap];

            }
        }

    }else {
        
        NSAssert(self.dataSource, @"CCDraggableContainerDataSource can't nil");
    }
}

//默认卡片的frame
- (CGRect)defaultCardViewFrame{
    
    //self
    CGFloat s_W = CGRectGetWidth(self.frame);
    CGFloat s_H = CGRectGetHeight(self.frame);
    
    //card
    CGFloat c_H = s_H - kContainerEdage * 2 - kCardEdage * 2;
    CGFloat c_W = s_W - kContainerEdage * 2;
    
    return CGRectMake(kContainerEdage, kContainerEdage / 2.0, c_W, c_H);
}

#pragma mark ---重置可视的卡片---
- (void)resetVisibleCards{
    
    __weak DragCardContainer * weakSelf = self;
    
    //****这个动画-会影响手势滑动的快慢***
    [UIView animateWithDuration:.2
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        
                         //重置卡片的位置
                         [weakSelf originalLayout];
        
    } completion:^(BOOL finished) {
        
        //用户移除最后一个CardView的方法
        if (weakSelf.currentCardsArr.count == 0) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(dragCardContainer:FinishedDragLastCard:)]) {
                
                [_delegate dragCardContainer:self FinishedDragLastCard:YES];
            }
        }
        
    }];
    
}
//重置卡片的位置
- (void)originalLayout{
    
    if (_delegate && [_delegate respondsToSelector:@selector(dragCardContainer:DargDirection:WidthRatio:HeightRadio:)]) {
        
        [_delegate dragCardContainer:self DargDirection:_direction WidthRatio:0 HeightRadio:0];
    }
    
    
    for (int i = 0; i < self.currentCardsArr.count; i ++) {
        
        CustomCardView * cardView = [self.currentCardsArr objectAtIndex:i];
        cardView.transform = CGAffineTransformIdentity;
        CGRect frame = self.firstCardFrame;
        
        switch (i) {
            case 0:
            {
                cardView.frame = frame;
                NSLog(@"第一个Card的Y：%f", CGRectGetMinY(cardView.frame));
            }
                break;
            case 1:
            {
                frame.origin.y = frame.origin.y + kCardEdage;
                cardView.frame = frame;
                cardView.transform = CGAffineTransformMakeScale(kSecondCardScale, 1);
            }
                break;
            case 2:
            {
                frame.origin.y = frame.origin.y + kCardEdage * 2;
                cardView.frame = frame;
                cardView.transform = CGAffineTransformMakeScale(kThirtyCardScale, 1);
                
                if (CGRectIsEmpty(self.lastCradFrame)) {
                    self.lastCradFrame = frame;
                    self.lastCardTransform = cardView.transform;
                }
            }
                break;
            default:
                break;
        }
        //存的是原比列
         cardView.originalTransform = cardView.transform;
    }
}

#pragma mark ---添加拖拽收拾的事件---
- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture{
    
    //开始拖拽
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        //Coding...
    }
    //拖拽change
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CustomCardView * cardView = (CustomCardView *)gesture.view;
        
        // translation: 平移 获取相对坐标原点的坐标
        CGPoint point = [gesture translationInView:self];
        NSLog(@"x:%f y:%f",gesture.view.center.x,point.y);
        CGPoint movePoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        cardView.center = movePoint;
        
        // translation: 旋转
        cardView.transform = CGAffineTransformRotate(cardView.originalTransform, ((gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x) * (M_PI_4 / 12));
        
        //设置坐标原点上一次的位置
        [gesture setTranslation:CGPointZero inView:self];
        
        //拖拽过程的回调
        if (_delegate && [_delegate respondsToSelector:@selector(dragCardContainer:DargDirection:WidthRatio:HeightRadio:)]) {
            
            /*
                 做比例：总长度(0~self.cardCenter.x),已知滑动的长度（gesture.view.center.x - self.center.x）
                 ratio用来判断是否显示图片中的"Like"或"DisLike"状态，开发者限定多少比例显示或设置透明度
             */
            CGFloat w_Ratio = (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x;
            CGFloat h_Ratio = (gesture.view.center.y - self.cardCenter.y) / self.cardCenter.y;
            
            //Moving-判断移动状态
            [self judgeMovingState:w_Ratio];
            
            //左右的判断方法:只要w_Radio > 0就是right
            if (w_Ratio > 0) {
                
                self.direction = DragDirectionRight;
            }
            else if (w_Ratio < 0){
                
                self.direction = DragDirectionLeft;
            }
            else {
                
                self.direction = DragDirectionDefault;
            }
            
            //回调
            [_delegate dragCardContainer:self DargDirection:self.direction WidthRatio:w_Ratio HeightRadio:h_Ratio];
        }
    }
    //拖拽结束
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        //随着滑动的方向消失或还原
        CGFloat w_Radio = (gesture.view.center.x - self.cardCenter.x) / self.cardCenter.x;
        CGFloat move_W = (gesture.view.center.x - self.cardCenter.x);
        CGFloat move_H = (gesture.view.center.y - self.cardCenter.y);
        
        //拖拽结束-随着滑动的方向消失或还原
        [self finishedPanGesture:gesture.view Direction:self.direction Scale:(move_W / move_H) Disappear:fabs(w_Radio) > kCardViewDisappearScale];
        
    }
}
// 判断移动状态
- (void)judgeMovingState:(CGFloat)scale{
    
    //如果之前没有移动-变成移动
    if (!self.moving) {
        
        self.moving = YES;
        //添加item
        [self initItem];
    }
    //如果之前有移动
    else {
        
        //下一个视图上移并放大
        [self movingVisibleCards:scale];
    }
}
- (void)movingVisibleCards:(CGFloat)scale{
    
    scale = fabs(scale) >= kCardViewDisappearScale ? kCardViewDisappearScale : fabs(scale);
    //相邻两个cardscale的差值
    CGFloat sPoor = kSecondCardScale - kThirtyCardScale;
    //transform x差的值
    CGFloat tPoor = sPoor / (kCardViewDisappearScale / scale);
    //frame y差值
    CGFloat yPoor = kCardEdage / (kCardViewDisappearScale / scale);
    
    for (int i = 1; i < self.currentCardsArr.count; i ++) {
        
        CustomCardView * cardView = [self.currentCardsArr objectAtIndex:i];
        
        switch (i) {
            case 1:
            {
                // 改变tran
                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + kSecondCardScale, 1);
                // 改变frame
                CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
                cardView.transform = translate;
            }
                break;
            case 2:
            {
                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + kThirtyCardScale, 1);
                CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
                cardView.transform = translate;
            }
                break;
            case 3:
            {
                cardView.transform = self.lastCardTransform;
            }
                break;
            default:
                break;
        }
    }
    
}

//拖拽结束-随着滑动的方向消失或还原
- (void)finishedPanGesture:(UIView *)cardView Direction:(DragDirection)direction Scale:(CGFloat)scale Disappear:(BOOL)disappear{
    
    //1.还原Orifinal坐标
    //2.移除最底层的card
    if (!disappear) {
        
        if (self.dataSource) {
            
            //当数量大于3事，移除第3位的card
            if (self.moving && self.currentCardsArr.count > kVisibleCount) {
                
                UIView * lastView = [self.currentCardsArr lastObject];
                [lastView removeFromSuperview];
                [self.currentCardsArr removeObject:lastView];
                self.loadIndex = lastView.tag;
            }
            //由移动置为不移动
            self.moving = NO;
            [self resetVisibleCards];
        }
    }
    else {
        
        //移除屏幕后:1.删除移除屏幕的card 2.重新布局剩下的card
        NSInteger flag = direction == DragDirectionLeft ? -1 : 2;
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             cardView.center = CGPointMake(kScreenW * flag, kScreenW * flag / scale + self.cardCenter.y);
                             
                         } completion:^(BOOL finished) {
                             
                             [cardView removeFromSuperview];
                             
                         }];
        [self.currentCardsArr removeObject:cardView];
        self.moving = NO;
        [self resetVisibleCards];
        
    }
}

#pragma mark ---点击卡片的手势---
- (void)tapGestureHandle:(UITapGestureRecognizer *)tap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(dragCardContainer:CardView:DidSelectIndex:)]) {
        
        [_delegate dragCardContainer:self CardView:(CustomCardView *)tap.view DidSelectIndex:tap.view.tag];
    }
}

#pragma mark ---移除card的事件---
- (void)removeCardWithDirection:(DragDirection)direction{
    
    if (self.moving) {
        
        return;
    }
    else {
        
        CGPoint cardCenter = CGPointZero;
        CGFloat flag = 0;
        
        switch (direction) {
            case DragDirectionLeft:
            {
                cardCenter = CGPointMake(- kScreenW / 2, self.cardCenter.y);
                flag = -1;
                
            }
                break;
            case DragDirectionRight:
            {
                cardCenter = CGPointMake(kScreenW * 1.5, self.cardCenter.y);
                flag = 1;
                
            }
                break;
            default:
                break;
        }
        
        //取到第一个card
        UIView *firstView = [self.currentCardsArr firstObject];
        
        //移除动画
        [UIView animateWithDuration:0.35 animations:^{
            
            CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, flag * 20, 0);
            firstView.transform = CGAffineTransformRotate(translate, flag * M_PI_4 / 4);
            firstView.center = cardCenter;
            
        } completion:^(BOOL finished) {
            
            [firstView removeFromSuperview];
            [self.currentCardsArr removeObject:firstView];
            
            [self initItem];
            [self resetVisibleCards];
            
        }];
    }
    
    
}

@end
