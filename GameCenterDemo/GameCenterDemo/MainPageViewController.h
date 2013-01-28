//
//  MainPageViewController.h
//  GameCenterDemo
//
//  Created by Valenti on 26/01/13.
//  Copyright (c) 2013 Biapum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "PlayerModel.h"

@interface MainPageViewController : UIViewController <GKLeaderboardViewControllerDelegate,GKAchievementViewControllerDelegate>
{
    //UI
    UITextField     *textFieldL1;
    UITextField     *textFieldL2;
    
    //Gamecenter
    uint64_t context;
    IBOutlet UIButton *showLeaderboardButton;
    IBOutlet UIButton *showAchievementsButton;
}

//UI
//UI
@property (nonatomic,strong) IBOutlet UITextField     *textFieldL1;
@property (nonatomic,strong) IBOutlet UITextField     *textFieldL2;

//Gamecenter
// This assists in caching game center data until
@property (readwrite, retain) PlayerModel * player;

//
- (IBAction)pushShowLeaderboard1:(id)sender;
- (IBAction)pushShowLeaderboard2:(id)sender;

- (IBAction)pushAchievements:(id)sender;
- (IBAction)pushSubmitL1:(id)sender;
- (IBAction)pushSubmitL2:(id)sender;

- (IBAction)pushAchievement1:(id)sender;
- (IBAction)pushAchievement2:(id)sender;

- (IBAction) resetAchievements;


// present the leaderboard as a modal window
- (void)showLeaderboard:(NSString *)leaderboard ;

// An example of how to use Current time as a score
- (void)insertCurrentTimeIntoLeaderboard:(NSString*)leaderboard;

// Disable all GameCenter functionality.
- (void)enableGameCenter:(BOOL)enableGameCenter ;


//Submit
- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category;
- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent title:(NSString*)title_ andMessage:(NSString*)message_;
- (void) showBannerWithTitle:(NSString*)title_ andMessage:(NSString*)message_;
@end
