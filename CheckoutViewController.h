//
//  CheckoutViewController.h
//  SecondTry
//
//  Created by lcodeM2 on 08/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckoutViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *CardView;
@property (weak, nonatomic) IBOutlet UILabel *lblcardNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblValidTill;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblHolderName;


@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtExpDate;
@property (weak, nonatomic) IBOutlet UITextField *txtCardHolderName;
@property (weak, nonatomic) IBOutlet UITextField *txtCardCvv;
@property (weak, nonatomic) IBOutlet UITextField *txtPayableAmt;

@property (weak, nonatomic) IBOutlet UIButton *btnPayNow;

- (IBAction)btnPayNow:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btndone;
- (IBAction)btnDone:(id)sender;



@end

NS_ASSUME_NONNULL_END

