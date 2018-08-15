//
//  KNLauchViewController.h
//  KNLaunchPage
//
//  Created by 刘凡 on 2018/8/15.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import <UIKit/UIKit.h>

///
typedef void(^ImageLoadingOver)(UIImage *,NSString *);

typedef void(^ClickLauchImage)(UIViewController *);

typedef void(^TheAdEnds)(void);

@interface KNLaunchViewController : UIViewController


///图片加载完成的回调
@property(nonatomic, strong)ImageLoadingOver imageloadingBlock;

///图片点击
@property(nonatomic, strong)ClickLauchImage imageClickBlock;

///时间结束
@property(nonatomic, strong)TheAdEnds theAdEnds;



/**
 KNLauchViewController

 @param imageFrame imageFrame
 @param imageURL 图片URL
 @param timeSecond 显示时间
 @param hideSkip 时候显示跳过的按钮
 @param imageloadingBlock 广告图片加载完成
 @param ClickLauch 点击广告
 @param theAdEnds 创建失败
 */
+(void)showWithFrame:(CGRect )imageFrame ImageURL:(NSString *)imageURL timeSecond:(NSInteger)timeSecond hideSkip:(BOOL)hideSkip ImageLoadingOver:(ImageLoadingOver)imageloadingBlock clickLauchImage:(ClickLauchImage)ClickLauch theAdEnds:(TheAdEnds)theAdEnds;

@end
