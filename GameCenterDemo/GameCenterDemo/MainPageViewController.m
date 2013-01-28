//
//  MainPageViewController.m
//  GameCenterDemo
//
//  Created by Valenti on 26/01/13.
//  Copyright (c) 2013 Biapum. All rights reserved.
//

#import "MainPageViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController
@synthesize textFieldL1,textFieldL2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**************************************
 GAMECENTER
 ***************************************/

#pragma mark - Gamecenter Enabled
// Disable GameCenter options from view
- (void)enableGameCenter:(BOOL)enableGameCenter
{
    [showLeaderboardButton setEnabled:enableGameCenter];
    [showAchievementsButton setEnabled:enableGameCenter];
}

#pragma mark - Gamecenter Actions

- (IBAction)pushShowLeaderboard1:(id)sender
{
    NSString *leaderboardCategory = @"leaderboard1";
    
    // The intent here is to show the leaderboard and then submit a score. If we try to submit the score first there is no guarentee
    // the server will have recieved the score when retreiving the current list
    [self showLeaderboard:leaderboardCategory];
    [self insertCurrentTimeIntoLeaderboard:leaderboardCategory];
}

- (IBAction)pushShowLeaderboard2:(id)sender
{
    NSString *leaderboardCategory = @"leaderboard2";
    
    // The intent here is to show the leaderboard and then submit a score. If we try to submit the score first there is no guarentee
    // the server will have recieved the score when retreiving the current list
    [self showLeaderboard:leaderboardCategory];
    [self insertCurrentTimeIntoLeaderboard:leaderboardCategory];

}

- (IBAction)pushAchievements:(id)sender
{
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != nil)
    {
        achievements.achievementDelegate = self;
        [self presentViewController: achievements animated: YES completion:nil];
    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -
#pragma mark Example of a score to be inserted

// Using time as as an int of seconds from 1970 gives us a good rolling number to test against
- (void)insertCurrentTimeIntoLeaderboard:(NSString*)leaderboard
{
    NSDate *today = [NSDate date];
    int64_t score = [today timeIntervalSince1970];
    GKScore * submitScore = [[GKScore alloc] initWithCategory:leaderboard];
    [submitScore setValue:score];
    
    // New feature in iOS5 tells GameCenter which leaderboard is the default per user.
    // This can be used to show a user's favorite course/track associated leaderboard, or just show the latest score submitted.
    [submitScore setShouldSetDefaultLeaderboard:YES];
    
    // New feature in iOS5 allows you to set the context to which the score was sent. For instance this will set the context to be
    //the count of the button press per run time. Information stored in context isn't accessable in standard GKLeaderboardViewController,
    //instead it's accessable from GKLeaderboard's loadScoresWithCompletionHandler:
    [submitScore setContext:context++];
    
    [self.player submitScore:submitScore];
}

// Example of how to bring up a specific leaderboard
- (void)showLeaderboard:(NSString *)leaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        leaderboardController.timeScope = GKLeaderboardTimeScopeToday;
        leaderboardController.category = leaderboard;
        [self presentViewController:leaderboardController animated: YES completion:nil];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Gamecenter Submit Actions

- (IBAction)pushSubmitL1:(id)sender
{
    [self reportScore:[self.textFieldL1.text intValue] forLeaderboardID:@"leaderboard1"];
}

- (IBAction)pushSubmitL2:(id)sender
{
    [self reportScore:[self.textFieldL2.text intValue] forLeaderboardID:@"leaderboard2"];
}

- (IBAction)pushAchievement1:(id)sender
{
    [self reportAchievementIdentifier:@"Achievement1" percentComplete:100 title:@"Win" andMessage:@"Achievement unlocked"];
}

- (IBAction)pushAchievement2:(id)sender
{
    
}


#pragma mark - Gamecenter Submitions

- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        NSLog(@"error:%@",error);
        // Do something interesting here.
    }];
    
    [self showBannerWithTitle:@"New Record" andMessage:[NSString stringWithFormat:@"for %@",category]];
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent title:(NSString*)title_ andMessage:(NSString*)message_
{
    [self showBannerWithTitle:title_ andMessage:message_];
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    if (achievement)
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"Error in reporting achievements: %@", error);
             }
         }];
    }
}

- (void) showBannerWithTitle:(NSString*)title_ andMessage:(NSString*)message_
{
    [GKNotificationBanner showBannerWithTitle: title_ message: message_
                            completionHandler:^{
                                NSLog(@"Finish!!");
                            }];
}



#pragma mark - reset

- (IBAction) resetAchievements
{
    // Clear all progress saved on Game Center
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil)
         {
             // handle errors
             }
     }];
}




@end
