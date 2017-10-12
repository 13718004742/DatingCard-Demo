//
//  CustomCardView.h
//  交友卡片-Demo
//
//  Created by 张建 on 2017/5/3.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCardView : UIView

@property (nonatomic) CGAffineTransform originalTransform;

//frame
- (void)layoutFrame;

//刷新数据
- (void)refreshDataWithDic:(NSDictionary *)dic;

@end
