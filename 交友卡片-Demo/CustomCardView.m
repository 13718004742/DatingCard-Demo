//
//  CustomCardView.m
//  交友卡片-Demo
//
//  Created by 张建 on 2017/5/3.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#import "CustomCardView.h"

@interface CustomCardView ()

//img
@property (nonatomic,strong)UIImageView * imgView;
//title
@property (nonatomic,strong)UILabel * titleLabel;

@end

@implementation CustomCardView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        [self loadUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadUI];
    }
    return self;
}
- (void)loadUI{
    
    //背景颜色
    CGFloat backColor = 245.0f / 255.0f;
    self.backgroundColor = [UIColor colorWithRed:backColor green:backColor blue:backColor alpha:1];
    
    //corner
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    
    //border
    CGFloat borderColor = 176.0f / 255.0f;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor colorWithRed:borderColor green:borderColor blue:borderColor alpha:1.0].CGColor;
 
    
    //img
    _imgView = [[UIImageView alloc] init];
    
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    _imgView.layer.masksToBounds = YES;
    [self addSubview:_imgView];
    
    //title
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
}
//frame
- (void)layoutFrame{
    
    _imgView.frame = CGRectMake(0, 0,self.bounds.size.width,self.bounds.size.height - 64);
    
    _titleLabel.frame = CGRectMake(0, self.bounds.size.height - 64, self.bounds.size.width, 64);

}

#pragma mark ---刷新数据---
//刷新数据
- (void)refreshDataWithDic:(NSDictionary *)dic{
    
    //img
    _imgView.image = [UIImage imageNamed:dic[@"image"]];
    
    //title
    _titleLabel.text = dic[@"title"];
    
}

@end
