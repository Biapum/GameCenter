//
//  AppDelegate.h
//  GameCenterDemo
//
//  Created by Valenti on 26/01/13.
//  Copyright (c) 2013 Biapum. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GameKit/GameKit.h>

@class MainPageViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MainPageViewController *mainPageVC;
}

@property (strong, nonatomic) MainPageViewController    *mainPageVC;
@property (strong, nonatomic) UIWindow                  *window;


// Gamecenter
-(void) initGameCenter;

// currentPlayerID is the value of the playerID last time we authenticated.
@property (retain,readwrite) NSString * currentPlayerID;

// isGameCenterAuthenticationComplete is set after authentication, and authenticateWithCompletionHandler's completionHandler block has been run. It is unset when the application is backgrounded.
@property (readwrite, getter=isGameCenterAuthenticationComplete) BOOL gameCenterAuthenticationComplete;

@end
