

#import "CheckoutViewController.h"
#import "ManageDatabase.h"
#import "ViewController.h"

@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomStyles:self.CardView];
    [[ManageDatabase sharedManager] setupDatabase];
    [self fetchTotalData];
    self.btndone.layer.cornerRadius = 10.0;
    self.btnPayNow.layer.cornerRadius = 10.0;
}


- (NSArray *)fetchTotalData {
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    NSMutableArray *dataArray = [NSMutableArray array];

    if (![database open]) {
        NSLog(@"Could not open the database.");
        return dataArray;
    }
    NSInteger userId = [[ManageDatabase sharedManager].userID integerValue];
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM MyTotal WHERE userid = %ld",(long)userId];
    FMResultSet *resultSet = [database executeQuery:selectSQL];
    while ([resultSet next]) {
    self.txtPayableAmt.text = [NSString stringWithFormat:@"%d", [resultSet intForColumn:@"total"]];
    self.lblTotalAmount.text = [NSString stringWithFormat:@"%d", [resultSet intForColumn:@"total"]];

    }
    [database close];
    return dataArray;
}




-(void)addCustomStyles:(UIView *)view
{
    view.layer.borderWidth = 0.2;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.cornerRadius=15.0;
}

- (IBAction)btnPayNow:(id)sender {
    ViewController *popup = [[ViewController alloc]init];
    [self presentViewController:popup animated:YES completion:nil];
}





- (IBAction)btnDone:(id)sender {
    self.lblValidTill.text = self.txtExpDate.text;
    self.lblcardNumber.text = self.txtCardNumber.text;
    self.lblHolderName.text = self.txtCardHolderName.text;
}
@end

