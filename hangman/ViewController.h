//
//  ViewController.h
//  hangman
//
//  Created by yiqin on 3/1/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSString *userId;
// @property (nonatomic, strong) NSValue *status;
@property (nonatomic, strong) NSString *secret;

@property (nonatomic, strong) IBOutlet UILabel *word;

@property (strong, nonatomic) IBOutlet UILabel *guessHistory;

@property (weak, nonatomic) IBOutlet UITextField *mainTextField;

@property (strong, nonatomic) IBOutlet UILabel *numberOfGuessAllowedForThisWord;

@property (strong, nonatomic) IBOutlet UILabel *numberOfWordsTried;

- (IBAction)initiateGame;
- (IBAction)giveMeAWord;
- (IBAction)eigtyIniateGame;


@end
