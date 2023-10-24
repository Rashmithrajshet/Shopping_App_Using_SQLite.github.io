//
//  SignupController.h
//  SecondTry
//
//  Created by lcodeM2 on 03/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignupController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnSignup:(id)sender;

- (IBAction)btnAlreadySignup:(id)sender;
- (IBAction)btnClintSignup:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *SignupMainView;


@end

NS_ASSUME_NONNULL_END
