//
//  StadiumAdd.m
//  Soccer
//
//  Created by Andy on 14-9-27.
//  Copyright (c) 2014年 Xinyi Xu. All rights reserved.
//

#import "StadiumAdd.h"

@interface StadiumAdd ()
@property IBOutlet MKMapView *stadiumMapView;
@property IBOutlet UITextField *stadiumNameTextField;
@property IBOutlet UITextField *stadiumAddressTextField;
@property IBOutlet UITextField *stadiumPhoneTextField;
@property IBOutlet UITextField *stadiumPriceTextField;
@property IBOutlet UITextField *stadiumCommentTextField;
@property IBOutlet UIToolbar *actionBar;
@property IBOutlet UIBarButtonItem *saveButton;
@end

@implementation StadiumAdd{
    UITextField *firstResponseTextField;
    JSONConnect *connection;
}
@synthesize potentousStadium;
@synthesize stadiumMapView, stadiumNameTextField, stadiumAddressTextField, stadiumPhoneTextField, stadiumPriceTextField, stadiumCommentTextField, actionBar, saveButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(__bridge id)bgImage];
    [self setToolbarItems:actionBar.items];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    if (potentousStadium) {
        [stadiumMapView showAnnotations:@[potentousStadium] animated:NO];
        MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[stadiumMapView viewForAnnotation:potentousStadium];
        [pinAnnotationView setPinColor:MKPinAnnotationColorPurple];
        [stadiumNameTextField setText:potentousStadium.stadiumName];
        [stadiumAddressTextField setText:potentousStadium.address];
    }
    
    connection = [[JSONConnect alloc] initWithDelegate:self andBusyIndicatorDelegate:self.navigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = self.tableView.bounds.size.height - self.tableView.contentSize.height;
    CGRect frame = stadiumMapView.frame;
    frame.size.height = height;
    [stadiumMapView setFrame:frame];
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return stadiumMapView;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    firstResponseTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *potentousString = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([textField isEqual:stadiumPriceTextField]) {
        NSArray *stringArray = [potentousString componentsSeparatedByString:@"."];
        if (stringArray.count > 1) {
            return NO;
        }
    }
    else if ([textField isEqual:stadiumNameTextField]) {
        [saveButton setEnabled:(potentousString.length && [stadiumAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length)];
    }
    else if ([textField isEqual:stadiumAddressTextField]) {
        [saveButton setEnabled:([stadiumNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length && potentousString.length)];
    }
    return YES;
}

- (IBAction)dismissKeyboard:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (firstResponseTextField) {
        [firstResponseTextField resignFirstResponder];
        firstResponseTextField = nil;
    }
}

- (IBAction)saveButtonOnClicked:(id)sender {
    [potentousStadium setStadiumName:stadiumNameTextField.text];
    [potentousStadium setAddress:stadiumAddressTextField.text];
    [potentousStadium setPhoneNumber:stadiumPhoneTextField.text];
    [potentousStadium setPrice:stadiumPriceTextField.text.integerValue];
    [potentousStadium setComment:stadiumCommentTextField.text];
    [connection addStadium:potentousStadium];
}

- (void)addStadiumSuccessfully:(NSInteger)stadiumId {
    [potentousStadium setStadiumId:stadiumId];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
