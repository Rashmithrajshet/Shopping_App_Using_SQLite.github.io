//
//  AddAdminController.h
//  SecondTry
//
//  Created by lcodeM2 on 05/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddAdminController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIDocumentPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtProductName;

@property (weak, nonatomic) IBOutlet UITextField *txtProductBrand;

@property (weak, nonatomic) IBOutlet UIView *addProductView;


@property (weak, nonatomic) IBOutlet UITextField *txtProductPrice;


@property (weak, nonatomic) IBOutlet UITextField *txtProductImg;


- (IBAction)btnUploadImg:(id)sender;
- (IBAction)btnSave:(id)sender;



- (IBAction)btnToggleProductTable:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *tblViewHolder;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


- (IBAction)btnViewUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *SecondtableHolder;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;







@end

NS_ASSUME_NONNULL_END
