//
//  CartViewController.h
//  SecondTry
//
//  Created by lcodeM2 on 03/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lblTotal;
- (IBAction)btnproceed:(id)sender;
- (IBAction)btnCalTotal:(id)sender;






@end

NS_ASSUME_NONNULL_END
