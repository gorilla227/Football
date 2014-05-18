//
//  Captain_WarmupMatch_UpdateAnnouncement.m
//  Football
//
//  Created by Andy Xu on 14-5-18.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "Captain_WarmupMatch_UpdateAnnouncement.h"

@implementation Captain_WarmupMatch_UpdateAnnouncement
@synthesize delegate, announcementTextView, saveButton, announcementText;

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
    // Do any additional setup after loading the view.
    [announcementTextView setText:announcementText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveButtonOnClicked:(id)sender
{
    [delegate updateAnnouncement:announcementTextView.text];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textViewDidChange:(UITextView *)textView
{
    [saveButton setEnabled:(![announcementTextView.text isEqualToString:announcementText] && [announcementTextView hasText])];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [announcementTextView resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
