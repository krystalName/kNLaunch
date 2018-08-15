//
//  KNLaunchImage.m
//  KNLaunchPage
//
//  Created by 刘凡 on 2018/8/9.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import "KNLaunchImage.h"
#import <SDWebImage/UIImage+GIF.h>
#import <SDWebImage/UIImageView+WebCache.h>

NSString *const timerSender = @"5";

@interface KNLaunchImage()

///广告的图片
@property(nonatomic, strong)UIImageView *launchImageView;

///跳过按钮
@property(nonatomic, strong)UIButton *skipBtn;

@end


@implementation KNLaunchImage

-(instancetype)initWithFrame:(CGRect)frame TimeInteger:(NSInteger)timerInteger
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.launchImageFrame = frame;
        self.timerNumber = timerInteger;
        self.frame = [UIScreen mainScreen].bounds;
        [self addSubview:self.launchImageView];
        [self addSubview:self.launchImage];
        
    }
    return self;
}




///获取自己的LaunchImage
-(UIImage *)getLaunchImage
{
    UIImage *imageP = [self launchImageWithType:@"Portrait"];
    if(imageP) return imageP;
    UIImage *imageL = [self launchImageWithType:@"Landscape"];
    if(imageL) return imageL;
    NSLog(@"获取LaunchImage失败!请检查是否添加启动图,或者规格是否有误.");
    return nil;
}

-(UIImage *)launchImageWithType:(NSString *)type
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = type;
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if([viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            if([dict[@"UILaunchImageOrientation"] isEqualToString:@"Landscape"])
            {
                imageSize = CGSizeMake(imageSize.height, imageSize.width);
            }
            if(CGSizeEqualToSize(imageSize, viewSize))
            {
                launchImageName = dict[@"UILaunchImageName"];
                UIImage *image = [UIImage imageNamed:launchImageName];
                return image;
            }
        }
    }
    return nil;
}


-(UIImageView *)launchImageView
{
    if (!_launchImageView) {
        _launchImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _launchImageView.backgroundColor = [UIColor whiteColor];
        _launchImageView.image = [self getLaunchImage];
    }
    return _launchImageView;
}

-(UIImageView *)launchImage
{
    if (!_launchImage) {
        _launchImage = [[UIImageView alloc]initWithFrame:self.launchImageFrame];
        _launchImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(launchImageClick:)];
        [_launchImage addGestureRecognizer:tag];
        _launchImage.backgroundColor = [UIColor clearColor];
    }
    return _launchImage;
}

///初始化按钮
- (UIButton *)skipBtn{
    
    if(!_skipBtn){
        
        _skipBtn = [[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-70, 30, 60, 30)];
        [_skipBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        _skipBtn.layer.cornerRadius = 15;
        _skipBtn.layer.masksToBounds = YES;
        NSInteger duration = [timerSender integerValue];
        if(self.timerNumber) duration = self.timerNumber;
        [_skipBtn setTitle:[NSString stringWithFormat:@"%ld 跳过",duration] forState:UIControlStateNormal];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_skipBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _skipBtn;
}

-(void)startNoDataDispath_timer{
    
    NSTimeInterval  period = 1.0;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    _noDataTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_noDataTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    
    __block NSInteger duration = 3;
    dispatch_source_set_event_handler(_noDataTimer, ^{
       
        dispatch_async(dispatch_get_main_queue(), ^{
            if (duration == 0) {
                dispatch_source_cancel(self->_noDataTimer);
                [self removeView];
            }
            duration--;
        });
        
    });
    
    dispatch_resume(_noDataTimer);
    
}


-(void)dispath_timer{
    
    if (_noDataTimer) dispatch_source_cancel(_noDataTimer);
    
    NSTimeInterval period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    
    
   __block NSInteger duration = [timerSender integerValue];
    if(self.timerNumber) duration = self.timerNumber;
    dispatch_source_set_event_handler(_timer, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_skipBtn setTitle:[NSString stringWithFormat:@"%ld 跳过",duration] forState:UIControlStateNormal];
            if(duration==0)
            {
                dispatch_source_cancel(self->_timer);
                
                [self removeView];
            }
            duration--;
            
        });
    });
    dispatch_resume(_timer);
}


+ (instancetype)initLaunchImageWithFrame:(CGRect)frame imageURL:(NSString *)imageURL timeSecond:(NSInteger)timeSecond hideSkip:(BOOL)hideSkip LaunchCallBack:(LaunchCallback)LaunchCallback ImageClick:(LaunchClick)ImageClick endPlays:(EndPlays)endPlays

{
    KNLaunchImage *launchImage = [[KNLaunchImage alloc]initWithFrame:frame TimeInteger:timeSecond];
    launchImage.clickLaunch = NO;
    
    __weak typeof(launchImage) weakLauchImage = launchImage;
    
    [launchImage.launchImage sd_setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(!error){
            if(imageURL){
                if(LaunchCallback){
                    LaunchCallback(image,[NSString stringWithFormat:@"%@",imageURL]);
                }
                [weakLauchImage addSubview:launchImage.skipBtn];
                weakLauchImage.hiddenSkip = hideSkip;
                [weakLauchImage dispath_timer];
            }
        }else{
            [weakLauchImage skipAction];
        }
    }];
    launchImage.ImageClick = ^(){
        
        if(ImageClick){
            ImageClick();
            weakLauchImage.clickLaunch = YES;
        }
        
    };
    launchImage.endPlays =^(){
        if(endPlays){
            endPlays();
        }
    };
    
    return launchImage;
}

- (void)animateEnd{
    
    CGFloat duration = [timerSender floatValue];
    if(_timerNumber)duration = self.timerNumber;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeView];
    });
}


///广告栏点击
-(void)launchImageClick:(UITapGestureRecognizer *)sender{
    
    if (self.ImageClick) {
        self.isClick = YES;
        self.ImageClick();
    }
}

-(void)setHiddenSkip:(BOOL)hiddenSkip{
    
    _hiddenSkip = hiddenSkip;
    
    if(_hiddenSkip){
        [self.skipBtn removeFromSuperview];
    }
    
}

- (void)skipAction{
    if(_noDataTimer) dispatch_source_cancel(_noDataTimer);
    
    self.isClick = NO;
    if (_timer) dispatch_source_cancel(_timer);
    [self removeView];
}


- (void)removeView{
    
    if(self.endPlays){
        if(self.clickLaunch == NO){
            self.endPlays();
        }
        
    }
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
