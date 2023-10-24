//
//  ClientViewController.m
//  SecondTry
//
//  Created by lcodeM2 on 10/10/23.
//

#import "ClientViewController.h"
#import "SignupController.h"
#import "LoginController.h"
#import "ManageDatabase.h"
#import "FMDB.h"
#import "ClientViewController.h"


@interface ClientViewController ()
@property(nonatomic,strong)NSString *databasePath;
@end

@implementation ClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ManageDatabase sharedManager]setupDatabase];
    [self addPopAnimation:self.signupMainView];
    [self addCustomStyles:self.signupMainView];
    self.navigationController.navigationBar.hidden = YES;
}


- (void)SaveSignupData {
    NSString *name = self.txtName.text;
    NSString *email = self.txtEmail.text;
    NSString *password = self.txtPassword.text;
    NSString *userType = @"customer";
    
    if (name.length == 0 || email.length == 0 || password.length == 0) {
        NSLog(@"Please enter all required information.");
        return;
    }
    
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    if (![database open]) {
        NSLog(@"Could not open the database.");
        return;
    }
    
    NSString *insertSQL = @"INSERT INTO Users (name, email, password, usertype) VALUES (?, ?, ?, ?)";
    BOOL success = [database executeUpdate:insertSQL, name, email, password, userType];
    
    if (success) {
        NSLog(@"Data saved successfully.");
        FMResultSet *result = [database executeQuery:@"SELECT * FROM Users WHERE name = ?", name];
        while ([result next]) {
            NSString *insertedName = [result stringForColumn:@"name"];
            NSString *insertedEmail = [result stringForColumn:@"email"];
            NSString *insertedPassword = [result stringForColumn:@"password"];
            NSString *insertedUserType = [result stringForColumn:@"usertype"];
            
            NSLog(@"Inserted Data - Name: %@, Email: %@, Password: %@, UserType: %@", insertedName, insertedEmail, insertedPassword, insertedUserType);
        }
    } else {
        NSLog(@"Error: Data not saved to database.");
    }
    
    [database close];
}



- (IBAction)btnAlreadySignup:(id)sender {
    LoginController *log = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    [self.navigationController pushViewController:log animated:YES];
}

- (IBAction)btnSignup:(id)sender {
    NSString *name = self.txtName.text;
       NSString *email = self.txtEmail.text;
       NSString *password = self.txtPassword.text;
       
       if (name.length == 0 || email.length == 0 || password.length == 0) {
           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                          message:@"Please enter all required information."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
           [alert addAction:okAction];
           [self presentViewController:alert animated:YES completion:nil];
           return;
       }
       

       [self SaveSignupData];
       LoginController *log = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
       [self.navigationController pushViewController:log animated:YES];
}


- (void)addPopAnimation:(UIView *)view {
    view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    view.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
    
    CGFloat originalAlpha = view.alpha;
    view.alpha = 0.0;
    
    [UIView animateWithDuration:0.8
                          delay:0.1
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         view.transform = CGAffineTransformIdentity;
                         view.center = CGPointMake(200, 200);
                         view.alpha = originalAlpha;
                     }
                     completion:nil];
}





-(void)addCustomStyles:(UIView *)view
{
    view.layer.borderWidth = 0.5;
    view.layer.borderColor=[UIColor whiteColor].CGColor;
}


@end
