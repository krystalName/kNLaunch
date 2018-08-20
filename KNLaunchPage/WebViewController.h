//
//  WebViewController.h
//  KNLaunchPage
//
//  Created by 刘凡 on 2018/8/20.
//  Copyright © 2018年 leesang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WebBack)(void);

@interface WebViewController : UIViewController

@property (nonatomic,copy)NSString *urlStr;

@property (nonatomic,assign)int AppDelegateSele;

@property (nonatomic,copy) WebBack WebBack;

@end
