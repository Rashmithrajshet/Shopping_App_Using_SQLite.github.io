//
//  MyAdminController.h
//  SecondTry
//
//  Created by lcodeM2 on 09/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAdminController : UIViewController <UITableViewDelegate,UITableViewDataSource>

- (IBAction)btnProdList:(id)sender;
- (IBAction)btnUserList:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

NS_ASSUME_NONNULL_END
