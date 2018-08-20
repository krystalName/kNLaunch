//
//  AppDelegate.m
//  KNLaunchPage
//
//  Created by 刘凡 on 2018/8/15.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import "AppDelegate.h"
#import "KNLaunchViewController.h"
#import "ViewController.h"
#import "WebViewController.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSString *gifImageURL = @"http://pic1.win4000.com/mobile/5/57ad5c46cd49f.gif";
    
    
    
    __weak __typeof (self)weakSelf = self;
    [KNLaunchViewController showWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [[UIScreen mainScreen] bounds].size.height-150) ImageURL:gifImageURL timeSecond:5 hideSkip:NO ImageLoadingOver:^(UIImage *image, NSString *imageURL) {
        
        NSLog(@"imageUrl ----- %@",imageURL);
        
    } clickLauchImage:^(UIViewController *vc) {
        
        __strong __typeof (weakSelf)strongSelf  = weakSelf;
        
        WebViewController *VC = [[WebViewController alloc] init];
        VC.urlStr = @"http://www.baidu.com";
        VC.title = @"广告";
        VC.AppDelegateSele = -1;
        
        VC.WebBack= ^(){
            //广告展示完成回调,设置window根控制器
            
            ViewController *vc = [[ViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            
            strongSelf.window.rootViewController = nav;
        };
        
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
        [vc presentViewController:nav animated:YES completion:nil];
        
    } theAdEnds:^{
        
        //广告展示完成回调,设置window根控制器
        
        ViewController *vc = [[ViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        self.window.rootViewController = nav;
        
        
    }];
    

    [self.window makeKeyAndVisible];

    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
