//
//  AppDelegate.m
//  Bicy-Convenience Map
//
//  Created by Chen Defore on 2016/12/13.
//  Copyright © 2016年 Chen Defore. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate () {
    BMKMapManager* _mapManager;
    UINavigationController *navigationController;
}
@property (nonatomic,strong) NSMutableArray *accessFinished;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BAIDU_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    // Add the navigation controller's view to the window and display.
    self.accessFinished = [[NSMutableArray alloc] init];
    [self addObserver:self
           forKeyPath:@"accessFinished"
              options:NSKeyValueObservingOptionNew
              context:NULL];
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"accessFinished"]) {
        // 当授权和联网同时完成的情况下，通知根视图，退出HUD并开启百度相关功能操作
        if ((self.accessFinished.count == 2) && (self.accessCompleteBlk != nil)) {
            if ([self.accessFinished[0] isEqualToString: @"SUCCESS"] && [self.accessFinished[1] isEqualToString:@"SUCCESS"]) {
                self.accessCompleteBlk(YES);
            } else {
                self.accessCompleteBlk(NO);
            }
        }
    }
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

#pragma mark 百度地图代理
- (void)onGetNetworkState:(int)iError {
    if (0 == iError){
        NSLog(@"联网成功");
        [[self mutableArrayValueForKey:@"accessFinished"] addObject:@"SUCCESS"];
    } else {
        NSLog(@"onGetNetworkState %d",iError);
        [[self mutableArrayValueForKey:@"accessFinished"] addObject:@"联网失败"];
    }
}

- (void)onGetPermissionState:(int)iError {
    if (0 == iError){
        NSLog(@"授权成功");
        [[self mutableArrayValueForKey:@"accessFinished"] addObject:@"SUCCESS"];
    } else {
        NSLog(@"onGetNetworkState %d",iError);
        [[self mutableArrayValueForKey:@"accessFinished"] addObject:@"授权失败"];
    }
}

@end
