//
//  LoginController.m
//  SecondTry
//
//  Created by lcodeM2 on 03/10/23.
//

#import "LoginController.h"
#import "DashboardController.h"
#import "ManageDatabase.h"
#import "AddAdminController.h"
#import "SignupController.h"
#import "MyAdminController.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ManageDatabase sharedManager]setupDatabase];
    [self addPopAnimation:self.loginMainView];
    [self addCustomStyles:self.loginMainView];
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)btnSig:(id)sender {
    SignupController *sign = [[SignupController alloc]initWithNibName:@"SignupController" bundle:nil];
    [self.navigationController pushViewController:sign animated:YES];
}

- (IBAction)btnLogin:(id)sender {
    NSString *email = self.txtEmail.text;
        NSString *password = self.txtPassword.text;

        if (email.length == 0 || password.length == 0) {
            [self showAlertWithMessage:@"Please enter email and password."];
            return;
        }

        NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
        if (![database open]) {
            [self showAlertWithMessage:@"Could not open the database."];
            return;
        }

        NSString *query = @"SELECT * FROM Users WHERE email = ?";
        FMResultSet *resultSet = [database executeQuery:query, email];

        if ([resultSet next]) {
            ManageDatabase *userData = [ManageDatabase sharedManager];
            userData.userID = [resultSet stringForColumn:@"id"];
            NSString *userPassword = [resultSet stringForColumn:@"password"];
            if ([userPassword isEqualToString:password]) {
                NSString *userType = [resultSet stringForColumn:@"usertype"];
                if ([userType isEqualToString:@"user"]) {
                    DashboardController *dashboard = [[DashboardController alloc] init];
                    [self.navigationController pushViewController:dashboard animated:YES];
                } else if ([userType isEqualToString:@"customer"]) {
                    AddAdminController *adminController = [[AddAdminController alloc] init];
                    [self.navigationController pushViewController:adminController animated:YES];
                }else if ([userType isEqualToString:@"admin"]){
                    MyAdminController *myadmin = [[MyAdminController alloc]init];
                    [self.navigationController pushViewController:myadmin animated:YES];
                }
            } else {
                [self showAlertWithMessage:@"Incorrect password. Please try again."];
            }
        } else {
            SignupController *signup = [[SignupController alloc]init];
            [self.navigationController pushViewController:signup animated:YES];
        }

        [database close];
    
//    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
//    FMDatabase *database =[FMDatabase databaseWithPath:databasePath];
//    if(![database open])
//    {
//        NSLog(@"ERROR LOADING THE DATABASE");
//        return;
//    }
//    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM MyCarts"];
//    BOOL success = [database executeUpdate:deleteQuery];
//    if(success)
//    {
//        NSLog(@"DATA DELETED FROM CART");
//    }
//    else{
//        NSLog(@"DATA NOT DELETED FROM DATABASE");
//    }

}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addPopAnimation:(UIView *)view {
    view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    view.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
    
    // Save the original alpha and set it to 0 for animation
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
