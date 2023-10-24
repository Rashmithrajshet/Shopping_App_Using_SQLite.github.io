
#import "CartViewController.h"
#import "CartCell.h"
#import "ManageDatabase.h"
#import "FMDB.h"
#import "CheckoutViewController.h"

@interface CartViewController ()
@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, strong) NSArray *cartArray;
@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPriceToActual];
    UINib *nib = [UINib nibWithNibName:@"CartCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CartCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [[ManageDatabase sharedManager] setupDatabase];
    self.cartArray = [self fetchCartData];
    NSLog(@"Fetched Cart Data: %@", self.cartArray);
    self.lblTotal.text=@"0.00";
    self.navigationController.navigationBar.hidden = NO;
}

- (NSArray *)fetchCartData {
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    NSMutableArray *dataArray = [NSMutableArray array];

    if (![database open]) {
        NSLog(@"Could not open the database.");
        return dataArray;
    }

    NSString *userID = [ManageDatabase sharedManager].userID;
    NSLog(@"userID is %@", userID);

    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM MyCarts WHERE userid = %@", userID];
    FMResultSet *resultSet = [database executeQuery:selectSQL];

    while ([resultSet next]) {
        NSString *itemName = [resultSet stringForColumn:@"cartitemname"];
        double itemPrice = [resultSet doubleForColumn:@"cartitemprice"];
        double itemupdPrice = [resultSet doubleForColumn:@"cartupdprice"];
        NSString *base64ImageString = [resultSet stringForColumn:@"cartimg"];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64ImageString options:0];
        UIImage *cartImg = [UIImage imageWithData:imageData];
        NSInteger cartID = [resultSet intForColumn:@"id"];
        NSInteger cartQty = [resultSet intForColumn:@"cartquantity"];
        NSDictionary *itemData = @{@"name": itemName, @"price": @(itemPrice),@"itemupdPrice":@(itemupdPrice), @"img": cartImg, @"cartId": @(cartID),@"cartQty":@(cartQty)};
        [dataArray addObject:itemData];
    }

    [database close];
    return dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cartArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CartCell" forIndexPath:indexPath];
    NSDictionary *cartData = self.cartArray[indexPath.row];
    cell.lblItemName.text = cartData[@"name"];

    cell.lblItemPrice.text = [NSString stringWithFormat:@"%@", cartData[@"itemupdPrice"]];

    cell.lblQty.text = [NSString stringWithFormat:@"%@", cartData[@"cartQty"]];

    cell.AddQyt.tag = [cartData[@"cartId"]integerValue];

    [cell.AddQyt addTarget:self action:@selector(IncQty:) forControlEvents:UIControlEventTouchUpInside];

    cell.RemoveQty.tag = [cartData[@"cartId"]integerValue];

    [cell.RemoveQty addTarget:self action:@selector(decQty:) forControlEvents:UIControlEventTouchUpInside];

    cell.btnDelete.tag = [cartData[@"cartId"]integerValue];

    [cell.btnDelete addTarget:self action:@selector(deleteCart:) forControlEvents:UIControlEventTouchUpInside];
    cell.imageView.image = cartData[@"img"];

    return cell;
}

  



-(IBAction)IncQty:(UIButton *)sender
{

    NSInteger cartId = sender.tag;
        NSLog(@"CART ID IS %ld", (long)cartId);

        NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];

    [UIView animateWithDuration:0.1 animations:^{
            sender.transform = CGAffineTransformMakeScale(0.7, 0.7);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                sender.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
            }];
        }];

    [UIView animateWithDuration:0.1 animations:^{
            sender.transform = CGAffineTransformMakeScale(0.7, 0.7);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                sender.transform = CGAffineTransformIdentity;
            }];
        }];

        if (![database open]) {
            NSLog(@"ERROR: COULDN'T OPEN THE DATABASE");
            return;
        }

        NSString *selectPriceQuery = [NSString stringWithFormat:@"SELECT cartitemprice, cartquantity FROM MyCarts WHERE id = %ld", (long)cartId];
        FMResultSet *result = [database executeQuery:selectPriceQuery];
        NSInteger cartItemPrice = 0;
        NSInteger cartQuantity = 0;

        if ([result next]) {
            cartItemPrice = [result intForColumn:@"cartitemprice"];
            cartQuantity = [result intForColumn:@"cartquantity"] + 1;
        }
        [result close];

        NSInteger newCartItemPrice = cartItemPrice * cartQuantity;
        NSString *updateCartTable = [NSString stringWithFormat:@"UPDATE MyCarts SET cartquantity = %ld, cartupdprice = %ld WHERE id = %ld", (long)cartQuantity, (long)newCartItemPrice, (long)cartId];
        BOOL success = [database executeUpdate:updateCartTable];

        if (!success) {
            NSLog(@"Error updating cart quantity and updated price for cartId: %ld", (long)cartId);
        }
        [database close];

        [self calculateTotalSum];
        self.cartArray = [self fetchCartData];
        [self.tableView reloadData];
}

-(IBAction)decQty:(UIButton *)sender
{
    NSInteger cartId = sender.tag;
        NSLog(@"CART ID IS %ld", (long)cartId);

        NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];


        if (![database open]) {
            NSLog(@"ERROR: COULDN'T OPEN THE DATABASE");
            return;
        }

        NSString *selectPriceQuery = [NSString stringWithFormat:@"SELECT cartitemprice, cartquantity FROM MyCarts WHERE id = %ld", (long)cartId];
        FMResultSet *result = [database executeQuery:selectPriceQuery];
        NSInteger cartItemPrice = 0;
        NSInteger cartQuantity = 0;

        if ([result next]) {
            cartItemPrice = [result intForColumn:@"cartitemprice"];
            cartQuantity = [result intForColumn:@"cartquantity"];
            cartQuantity = MAX(cartQuantity - 1, 1);
        }
        [result close];

        NSInteger newCartItemPrice = cartItemPrice * cartQuantity;
        NSString *updateCartTable = [NSString stringWithFormat:@"UPDATE MyCarts SET cartquantity = %ld, cartupdprice = %ld WHERE id = %ld", (long)cartQuantity, (long)newCartItemPrice, (long)cartId];
        BOOL success = [database executeUpdate:updateCartTable];

        if (!success) {
            NSLog(@"Error updating cart quantity and updated price for cartId: %ld", (long)cartId);
        }
        [database close];

    [self calculateTotalSum];
        self.cartArray = [self fetchCartData];
        [self.tableView reloadData];
   
    }



-(IBAction)deleteCart:(UIButton *)sender
{
    NSInteger cartId = sender.tag;
    NSLog(@"id is %ld",cartId);
    NSString *databasePath = [[ManageDatabase sharedManager]databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];

    if(![database open])
    {
        NSLog(@"ERROR CONNECTING TO DATABASE");
        return;
    }
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM MyCarts WHERE id =%ld",(long)cartId];
    BOOL success = [database executeUpdate:deleteQuery];
    if(!success)
    {
        NSLog(@"Error updating database");
    }
    [database close];
    [self calculateTotalSum];
    self.cartArray = [self fetchCartData];
    [self.tableView reloadData];
}

-(void)calculateTotalSum{
    NSInteger userId = [[ManageDatabase sharedManager].userID integerValue];
    NSLog(@"THE USER ID IS %ld", userId);
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    if(![database open]) {
        NSLog(@"Error could not open the database");
        return;
    }
    
    NSString *calculateTotal = [NSString stringWithFormat:@"SELECT SUM(CAST(cartupdprice AS REAL)) AS total FROM MyCarts WHERE userid = %ld",(long)userId];
    NSLog(@"SQL Query: %@", calculateTotal);
    
    FMResultSet *result = [database executeQuery:calculateTotal];
    
    if ([result next]) {
        double totalAmount = [result doubleForColumn:@"total"];
        NSLog(@"Total Amount from Database: %.2f", totalAmount);
        NSString *totalAmountString = [NSString stringWithFormat:@"%.2f", totalAmount];
        self.lblTotal.text = totalAmountString;
    } else {
        NSLog(@"Error calculating total");
    }
    
    [result close];
    [database close];
    self.cartArray = [self fetchCartData];
    [self.tableView reloadData];
}




- (IBAction)btnCalTotal:(id)sender {
    [self calculateTotalSum];
    
}

- (IBAction)btnproceed:(id)sender {
        [self calculateTotalSum];
        NSInteger total = [self.lblTotal.text integerValue];
        NSInteger userId = [[ManageDatabase sharedManager].userID integerValue  ];

        NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
        if (![database open]) {
            NSLog(@"COULD NOT OPEN THE DATABASE");
            return;
        }

        NSString *selectQuery = [NSString stringWithFormat:@"SELECT * FROM MyTotal WHERE userid = %ld", (long)userId];
        FMResultSet *resultSet = [database executeQuery:selectQuery];

        if ([resultSet next]) {
            NSString *updateTotal = [NSString stringWithFormat:@"UPDATE MyTotal SET total = %ld WHERE userid = %ld", (long)total, (long)userId];
            BOOL success = [database executeUpdate:updateTotal];

            if (success) {
                NSLog(@"DATABASE UPDATED");
            } else {
                NSLog(@"DATABASE NOT UPDATED");
            }
        } else {
            NSString *insertTotal = [NSString stringWithFormat:@"INSERT INTO MyTotal (userid, total) VALUES (%ld, %ld)", (long)userId, (long)total];
            BOOL success = [database executeUpdate:insertTotal];

            if (success) {
                NSLog(@"DATABASE UPDATED");
            } else {
                NSLog(@"DATABASE NOT UPDATED");
            }
        }

        [database close];

        CheckoutViewController *checkout = [[CheckoutViewController alloc] initWithNibName:@"CheckoutViewController" bundle:nil];
        [self.navigationController pushViewController:checkout animated:YES];
}



-(void)setPriceToActual{
        NSString *databasePath = [[ManageDatabase sharedManager]databasePath];
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
        if(![database open])
        {
            NSLog(@"THE DATABASE CANNOT BE OPENED");
            return;
        }

        NSString *setPriceToUp = [NSString stringWithFormat:@"UPDATE MyCarts SET cartupdprice = cartitemprice WHERE cartupdprice = 1"];
        BOOL success = [database executeUpdate:setPriceToUp];
        if(!success)
        {
            NSLog(@"PRICE NOT SET TO ITEMPRICE");
        }
        else
        {
            NSLog(@"QUERY UPDATED SUCCESSFULLY");
        }

        [database close];
        self.cartArray = [self fetchCartData];
        [self.tableView reloadData];
    }
@end

