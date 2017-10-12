//
//  ZJViewController.m
//  交友卡片-Demo
//
//  Created by 张建 on 2017/5/3.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#import "ZJViewController.h"
#import "DragCardContainer.h"
#import "CardMacro.h"

@interface ZJViewController ()<DragCardContainerDelegate>

//数据源
@property (nonatomic,strong)NSMutableArray * dataSources;
//dragContainer
@property (nonatomic,strong)DragCardContainer * containerView;

//Like
@property (nonatomic,strong)UIButton * likeBtn;
//info
@property (nonatomic,strong)UIImageView * infoImgView;
//disLike
@property (nonatomic,strong)UIButton * disLikeBtn;

@end

@implementation ZJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"vc";
    self.view.backgroundColor = [UIColor orangeColor];
    
    //加载数据
    [self loadData];
    
    //加载视图
    [self loadUI];
}
- (NSMutableArray *)dataSources{
    
    if (!_dataSources) {
        
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
#pragma mark ---加载数据---
- (void)loadData{
    
    for (int i = 0; i < 9; i ++) {
        
        NSDictionary * dic = @{
                               @"image":[NSString stringWithFormat:@"image_%d.jpg",i + 1],
                               @"title":[NSString stringWithFormat:@"Page%d",i + 1]
                               };
        [self.dataSources addObject:dic];
    }
}

#pragma mark ---加载视图---
- (void)loadUI{
    
    //初始化
    _containerView = [[DragCardContainer alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenW)];
    _containerView.delegate = self;
    _containerView.dataSource = self.dataSources;
    [self.view addSubview:_containerView];
    //重启加载
    [_containerView reloadData];
    
    
    //Like
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame = CGRectMake(kScreenW / 2.0 - 100, kScreenH - 150, 50, 50);
    [_likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_likeBtn];
    
    //info
    _infoImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW - 30 )/ 2.0 , kScreenH - 140, 30, 30)];
    _infoImgView.image = [UIImage imageNamed:@"userInfo"];
    [self.view addSubview:_infoImgView];
    
    //disLike
    _disLikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _disLikeBtn.frame = CGRectMake(kScreenW / 2.0 + 50, kScreenH - 150, 50, 50);
    [_disLikeBtn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    [_disLikeBtn addTarget:self action:@selector(disLikeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_disLikeBtn];
   
}

#pragma mark ---点击like的事件---
- (void)likeBtnClick:(UIButton *)sender{
    
    NSLog(@"like");
    [_containerView removeCardWithDirection:DragDirectionLeft];
}

#pragma mark ---点击disLike的事件---
- (void)disLikeBtnClick:(UIButton *)sender{
    
    NSLog(@"disLike");
    [_containerView removeCardWithDirection:DragDirectionRight];
    
}

#pragma mark ---DragCardContainerDelegate---
//拖拽中
- (void)dragCardContainer:(DragCardContainer *)dragCardContainer DargDirection:(DragDirection)dragDicrection WidthRatio:(CGFloat)widthRatio HeightRadio:(CGFloat)heightRadio{
    
    CGFloat scale = 1 + ((kCardViewDisappearScale > fabs(widthRatio)) ? fabs(fabs(widthRatio)) : kCardViewDisappearScale) / 4;
    
    if (dragDicrection == DragDirectionLeft) {
        
        NSLog(@"disLike");
        _likeBtn.transform = CGAffineTransformMakeScale(scale, scale);
    }
    else if (dragDicrection == DragDirectionRight){
        
        NSLog(@"Like");
        _disLikeBtn.transform = CGAffineTransformMakeScale(scale, scale);
        
    }
}
//完成拖拽
- (void)dragCardContainer:(DragCardContainer *)dragCardContainer FinishedDragLastCard:(BOOL)finishedDragLastCard{
    
    [dragCardContainer reloadData];
    NSLog(@"最后一个也拖拽完了");
}
//点击card
- (void)dragCardContainer:(DragCardContainer *)dragCardContainer CardView:(CustomCardView *)cardView DidSelectIndex:(NSInteger)didSelectIndex{
    
     NSLog(@"点击了Tag为%ld的Card", (long)didSelectIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
