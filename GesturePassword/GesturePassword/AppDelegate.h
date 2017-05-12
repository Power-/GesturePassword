//
//  AppDelegate.h
//  GesturePassword
//
//  Created by 孟祥冬 on 2017/5/12.
//  Copyright © 2017年 organizationName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

