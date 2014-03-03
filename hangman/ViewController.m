//
//  ViewController.m
//  hangman
//
//  Created by yiqin on 3/1/14.
//  Copyright (c) 2014 purdue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (IBAction)initiateGame;
{
    NSLog(@"Initiate Game");
    
    // Setup the request.
    NSString *action = @"initiateGame";
    
    NSMutableString *myRequestString = [@"userId=" mutableCopy];
    [myRequestString appendString: _userId];
    [myRequestString appendString: @"&action="];
    [myRequestString appendString: action];
    
    // reset API call
    NSDictionary *responseData = resetAPICall(myRequestString);
    
    _secret = [responseData objectForKey:@"secret"];
    

}

- (IBAction) giveMeAWord
{
    NSLog(@"Give Me A Word");
    
    // Setup the request.
    
    NSString *action = @"nextWord";
    
    NSMutableString *myRequestString = [@"userId=" mutableCopy];
    [myRequestString appendString: _userId];
    [myRequestString appendString: @"&action="];
    [myRequestString appendString: action];
    [myRequestString appendString: @"&secret="];
    [myRequestString appendString: _secret];
    
    
    // reset API call
    NSDictionary *responseData = resetAPICall(myRequestString);
    
    self.word.text = [responseData objectForKey:@"word"];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _userId  = @"yiqin.mems@gmail.com";
    [self initiateGame];
    [self giveMeAWord];
    
    // Keyboard auto show and focus the first field.
    [_mainTextField becomeFirstResponder];
    
    // Multiple lines of text in UILabel
    _guessHistory.lineBreakMode = NSLineBreakByWordWrapping;
    _guessHistory.numberOfLines = 0;
    
}


- (IBAction)makeAGuess:(id)sender {
    NSLog(@"Make A Guess");
    
    // only accept CAPITAL Letter
    NSString *guessValue = [_mainTextField.text uppercaseString];
    
    NSLog(@"Guess: %@", guessValue);
    
    char inputChar = [guessValue characterAtIndex:0];
    if (('A' <= inputChar) && (inputChar <= 'Z')) {
        // NSLog(@"Guess: %@", guessValue);
        
        // split word.
        BOOL wordChar = YES;
        
        NSMutableArray *wordArray = [NSMutableArray array];
        NSString *wordList = [NSString stringWithString: self.word.text];
        
        for (int i = 0; i < [wordList length]; i++) {
            NSString *ch = [wordList substringWithRange:NSMakeRange(i, 1)];
            [wordArray addObject:ch];
        }
        
        for (int i=0; i < [wordArray count]; i++) {
            NSString *str2 = [wordArray objectAtIndex:i];
            // NSLog(@"array: %@", str2);
            
            if([str2 isEqualToString: guessValue]) {
                // NSLog(@"These strings are the same in the word");
                wordChar = NO;
            }
            else {
                // NSLog(@"These string are different in the word");
            }
        }
        
        

        BOOL newInputChar = YES;
        // two strings are need to store guess history.
        
        NSMutableString *guessHistoryList = [_guessHistory.text mutableCopy];
        NSMutableString *saveGuessHistory = [_guessHistory.text mutableCopy];
        
        if (wordChar) {
            // split guess history.
            NSArray *array = [guessHistoryList componentsSeparatedByString:@", "];
            
            for (int i=0; i < [array count]; i++) {
                NSString *str1 = [array objectAtIndex:i];
                // NSLog(@"array: %@", str1);
                if([str1 isEqualToString: guessValue]) {
                    // NSLog(@"These strings are the same");
                    newInputChar = NO;
                }
                else {
                    // NSLog(@"These string are different");
                }
            }
        }
        
        
        // Update guessHisotry if the input letter is a new one and not in the "word".
        if (newInputChar && wordChar){
            NSString *action = @"guessWord";
            NSMutableString *myRequestString = [@"userId=" mutableCopy];
            [myRequestString appendString: _userId];
            [myRequestString appendString: @"&action="];
            [myRequestString appendString: action];
            [myRequestString appendString: @"&secret="];
            [myRequestString appendString: _secret];
            [myRequestString appendString: @"&guess="];
            [myRequestString appendString: guessValue];
            
            // reset API call
            // return NSdictionary
            NSDictionary *responseData = resetAPICall(myRequestString);
            // NSLog(@"responseData is %@", responseData);
            
            NSDictionary *temp =[responseData objectForKey:@"data"];
            
            // NSLog(@"data is %@", temp);
            
            //
            
            _numberOfGuessAllowedForThisWord.text =[NSString stringWithFormat:@"%@", [temp objectForKey:@"numberOfGuessAllowedForThisWord"]];
            
            _numberOfWordsTried.text = [NSString stringWithFormat:@"%@", [temp objectForKey:@"numberOfWordsTried"]];


            
            //self.word.text = [responseData objectForKey:@"userId"];
            
            
            // new word.
            NSString *resturnWord =[responseData objectForKey:@"word"];
            // if new word is different from the old one, update word label.
            // if they are same, update guessHistory label.
            if(([resturnWord isEqualToString: wordList])) {
                [saveGuessHistory appendString: guessValue];
                [saveGuessHistory appendString: @", "];
                _guessHistory.text = saveGuessHistory;
                // NSLog(@"Good");
            }
            else {
                _word.text = [responseData objectForKey:@"word"];
                
            }
            
            
        }
          
    }

    // When numberOfGuessAllowedForThisWord is zero, get a new word.
    if(([_numberOfGuessAllowedForThisWord.text isEqualToString: @"0"])) {
        NSLog(@"Game is over.");
        [self giveMeAWord];
        [_guessHistory setText:@""];
        // intialize the instruction.
        [_numberOfGuessAllowedForThisWord setText:@"10"];
        NSInteger num = [_numberOfWordsTried.text integerValue];
        num = num + 1;
        _numberOfWordsTried.text =[NSString stringWithFormat:@"%li", (long) num];
    }

    [self eigtyIniateGame];
    
    // clear mainTextField
    // [_mainTextField setText:@""];
    _mainTextField.text = [NSString stringWithFormat:@""];

    
}


- (IBAction)newWord:(id)sender {
    [self giveMeAWord];
    [_guessHistory setText:@""];
    // intialize the instruction.
    [_numberOfGuessAllowedForThisWord setText:@"10"];
    NSInteger num = [_numberOfWordsTried.text integerValue];
    num = num + 1;
    _numberOfWordsTried.text =[NSString stringWithFormat:@"%li", (long)num];
    
    [self eigtyIniateGame];
    
}

// Finish 80 tries, restart the game.
- (IBAction) eigtyIniateGame {
    // 80, 80.
    if(([_numberOfWordsTried.text isEqualToString: @"81"])) {
        NSLog(@"Initiate Game.");
        [self initiateGame];
        [self giveMeAWord];
        [_guessHistory setText:@""];
        // intialize the instruction.
        [_numberOfGuessAllowedForThisWord setText:@"10"];
        NSInteger num = [_numberOfWordsTried.text integerValue];
        num = num + 1;
        _numberOfWordsTried.text =[NSString stringWithFormat:@"1"];
    }
}


- (IBAction)getTestResults:(id)sender {
    NSLog(@"Get Test Results");
    
    // Setup the request.
    
    NSString *action = @"getTestResults";
    
    NSMutableString *myRequestString = [@"userId=" mutableCopy];
    [myRequestString appendString: _userId];
    [myRequestString appendString: @"&action="];
    [myRequestString appendString: action];
    [myRequestString appendString: @"&secret="];
    [myRequestString appendString: _secret];
  
    // reset API call
    NSDictionary *responseData = resetAPICall(myRequestString);
    
    NSString *resultStatus = [NSString stringWithFormat:@"%@", [responseData objectForKey:@"status"]];
    NSString *resultMessage = [responseData objectForKey:@"message"];
    if([resultStatus isEqualToString: @"400"]) {
        // show the result.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Result"
                                                        message:[NSString stringWithFormat:@"%@", resultMessage]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([resultStatus isEqualToString: @"200"]){
        // show the result.
        // didn't change the UI interface.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation!"
                                                        message:[NSString stringWithFormat:@"%@", responseData]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert addButtonWithTitle:@"Submit"];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        NSLog(@"Button 1 was selected.");
    }
    else if([title isEqualToString:@"Submit"])
    {
        NSLog(@"Button 2 was selected.");
        NSLog(@"Submit Test Results");
        
        // Setup the request.
        
        NSString *action = @"submitTestResults";
        
        NSMutableString *myRequestString = [@"userId=" mutableCopy];
        [myRequestString appendString: _userId];
        [myRequestString appendString: @"&action="];
        [myRequestString appendString: action];
        [myRequestString appendString: @"&secret="];
        [myRequestString appendString: _secret];
        
        // reset API call
        NSDictionary *responseData = resetAPICall(myRequestString);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Submit Test Results!"
                                                        message:[NSString stringWithFormat:@"%@", responseData]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

NSDictionary *resetAPICall (NSMutableString *myRequestString)
{
    NSData *myRequestData = [ NSData dataWithBytes: [ myRequestString UTF8String ] length: [ myRequestString length ] ];
    NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: @"http://strikingly-interview-test.herokuapp.com/guess/process" ] ];
    [ request setHTTPMethod: @"POST" ];
    [ request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [ request setHTTPBody: myRequestData ];
    NSURLResponse *response;
    NSError *err;
    NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];
    // NSString *content = [NSString stringWithUTF8String:[returnData bytes]];
    // NSLog(@"responseData: %@", content);
    
    // Fetch repsonseData
    NSDictionary *resetAPICallResponseData = [NSJSONSerialization JSONObjectWithData:returnData
                                                             options:0
                                                               error:NULL];
    // // check status: 200 - OK, 400 - Bad Request, 401 - Unauthenticated
    // NSString *resetAPICallStatus = [resetAPICallResponseData objectForKey:@"status"];
    // NSLog(@"status: %@", resetAPICallStatus);
    
    return resetAPICallResponseData;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
