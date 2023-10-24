//
//  ClientViewController.h
//  SecondTry
//
//  Created by lcodeM2 on 10/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClientViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnSignup:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *signupMainView;

- (IBAction)btnAlreadySignup:(id)sender;
@end

NS_ASSUME_NONNULL_END
