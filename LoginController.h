//
//  LoginController.h
//  SecondTry
//
//  Created by lcodeM2 on 03/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
- (IBAction)btnLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *loginMainView;

- (IBAction)btnSig:(id)sender;


@end

NS_ASSUME_NONNULL_END
