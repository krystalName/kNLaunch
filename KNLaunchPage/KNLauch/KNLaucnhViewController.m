//
//  KNLauchViewController.m
//  KNLaunchPage
//
//  Created by 刘凡 on 2018/8/15.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import "KNLaunchViewController.h"
#import "KNLaunchImage.h"


@interface KNLaunchViewController ()

@property(nonatomic, strong) KNLaunchImage * launchImage;


@end

@implementation KNLaunchViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.launchImage.timer && self.launchImage.timerNumber > 0 && self.launchImage.isClick) {
        dispatch_resume(self.launchImage.timer);
    }
    self.launchImage.isClick = NO;
  
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    if(self.launchImage.timer && self.launchImage.timerNumber > 0 && self.launchImage.isClick)
    {
        dispatch_suspend(self.launchImage.timer);
    }
}


+(void)showWithFrame:(CGRect)imageFrame ImageURL:(NSString *)imageURL timeSecond:(NSInteger)timeSecond hideSkip:(BOOL)hideSkip ImageLoadingOver:(ImageLoadingOver)imageloadingBlock clickLauchImage:(ClickLauchImage)ClickLauch theAdEnds:(TheAdEnds)theAdEnds
{
    if (!imageURL || timeSecond == 0 || [imageURL isEqualToString:@""]) {
        if (theAdEnds) {
            theAdEnds();
        }
    }
    
    KNLaunchViewController *KNLaunchVC = [[KNLaunchViewController alloc]init];
    KNLaunchVC.launchImage = [KNLaunchImage initLaunchImageWithFrame:imageFrame imageURL:imageURL timeSecond:timeSecond hideSkip:hideSkip LaunchCallBack:^(UIImage *image, NSString *imageURL) {
        if (imageloadingBlock) {
            imageloadingBlock(image,imageURL);
        }
    } ImageClick:^{
        if (ClickLauch) {
            ClickLauch(KNLaunchVC);
        }
    } endPlays:^{
        if (theAdEnds) {
            theAdEnds();
            return ;
        }
    }];
    
    [KNLaunchVC.view addSubview:KNLaunchVC.launchImage];
    [[UIApplication sharedApplication].delegate window].rootViewController = KNLaunchVC;
    
}



@end
