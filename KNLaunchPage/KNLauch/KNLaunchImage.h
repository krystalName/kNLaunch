//
//  KNLaunchImage.h
//  KNLaunchPage
//
//  Created by 刘凡 on 2018/8/9.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import <UIKit/UIKit.h>

///点击广告的
typedef void(^LaunchClick)(void);
///广告加载完之后
typedef void(^LaunchCallback)(UIImage *image, NSString *imageURL);
///广告播放结束
typedef void(^EndPlays)(void);

@interface KNLaunchImage : UIView

///是否可以点击按钮
@property(nonatomic, assign)BOOL isClick;

@property(nonatomic, copy)dispatch_source_t timer;

@property(nonatomic, copy)dispatch_source_t noDataTimer;

///广告显示时间
@property(nonatomic, assign)NSInteger timerNumber;

///广告图
@property(nonatomic, strong)UIImageView *launchImage;

///广告的frame
@property(nonatomic, assign)CGRect launchImageFrame;

///是否显示跳过按钮
@property(nonatomic, assign)BOOL hiddenSkip;

///是否点击广告
@property(nonatomic, assign)BOOL clickLaunch;

/// 点击广告图
@property (nonatomic, copy) LaunchClick ImageClick;

/// 广告加载完
@property (nonatomic, copy) LaunchCallback launchImageCallback;

/// 广告播放结束
@property (nonatomic, copy) EndPlays endPlays;



/**
 创建这个View的初始化方法

 @param frame      广告图片的大小位置
 @param imageURL   广告图片的URL，可以是图片，可以是gif
 @param timeSecond 广告时长
 @param hideSkip   是否隐藏“跳过按钮” YES隐藏  NO显示
 @param LaunchCallback 广告图片加载完回调
 @param ImageClick 点击广告回调
 @param endPlays 广告播放结束回调
 @return KNLaunchImage
 */
+ (instancetype)initLaunchImageWithFrame:(CGRect)frame imageURL:(NSString *)imageURL timeSecond:(NSInteger )timeSecond hideSkip:(BOOL)hideSkip LaunchCallBack:(LaunchCallback)LaunchCallback ImageClick:(LaunchClick)ImageClick endPlays:(EndPlays)endPlays;





@end
