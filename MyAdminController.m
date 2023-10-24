
#import "MyAdminController.h"
#import "AdminProductCell.h"
#import "UserViewCell.h"
#import "ManageDatabase.h"
#import "FMDB.h"


@interface MyAdminController ()

@property (nonatomic, strong) UINib *currentNib;
@property (nonatomic, assign) BOOL isUserViewSelected;
@property (nonatomic, strong) NSArray *itemDataArray;
@property (nonatomic, strong) NSArray *userDataArray;


@end

@implementation MyAdminController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    self.currentNib = [UINib nibWithNibName:@"AdminProductCell" bundle:nil];
    [self.tableView registerNib:self.currentNib forCellReuseIdentifier:@"AdminProductCell"];
    
    UINib *nib2 = [UINib nibWithNibName:@"UserViewCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"UserViewCell"];

    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.itemDataArray = [self fetchDishData];
    self.userDataArray = [self fetchUserData];
    
    
    [[ManageDatabase sharedManager] setupDatabase];
}


- (NSArray *)fetchDishData {
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    NSMutableArray *dataArray = [NSMutableArray array];

    if (![database open]) {
        NSLog(@"Could not open the database.");
        return dataArray;
    }

    NSString *selectSQL = @"SELECT * FROM Dashs";
    FMResultSet *resultSet = [database executeQuery:selectSQL];

    while ([resultSet next]) {
        NSString *itemName = [resultSet stringForColumn:@"itemname"];
        NSString *itemBrand = [resultSet stringForColumn:@"itembrand"];
        NSString *base64ImageString = [resultSet stringForColumn:@"itemimg"];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64ImageString options:0];
        UIImage *itemImage = [UIImage imageWithData:imageData];
        double itemPrice = [resultSet doubleForColumn:@"itemprice"];
        int itemStatus = [resultSet intForColumn:@"hidden"];
        NSInteger itemId = [resultSet intForColumn:@"id"];

        NSDictionary *itemData = @{@"name": itemName, @"brand": itemBrand, @"itemimg": itemImage, @"itemprice": @(itemPrice), @"itemid": @(itemId),@"status":@(itemStatus)};
        [dataArray addObject:itemData];
    }
    
    [database close];
    return dataArray;
}






- (NSArray *)fetchUserData {
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    NSMutableArray *dataArray = [NSMutableArray array];

    if (![database open]) {
        NSLog(@"Could not open the database.");
        return dataArray;
    }

    NSString *selectSQL = @"SELECT * FROM Users";
    FMResultSet *resultSet = [database executeQuery:selectSQL];

    while ([resultSet next]) {
        NSString *userName = [resultSet stringForColumn:@"name"];
        NSString *userEmail = [resultSet stringForColumn:@"email"];
        NSInteger userId = [resultSet intForColumn:@"id"];

        NSDictionary *userData = @{@"name": userName, @"email":userEmail, @"id":@(userId)};
        [dataArray addObject:userData];
    }
    
    [database close];
    return dataArray;
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *cellIdentifier = self.isUserViewSelected ? @"UserViewCell" : @"AdminProductCell";
    if([cellIdentifier isEqualToString:@"UserViewCell"])
    {
        return self.userDataArray.count;
    }
    else
    {
        return self.itemDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = self.isUserViewSelected ? @"UserViewCell" : @"AdminProductCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[self.currentNib instantiateWithOwner:nil options:nil] firstObject];
    }
    
    if ([cellIdentifier isEqualToString:@"UserViewCell"]) {
        UserViewCell *userCell = (UserViewCell *)cell;
        if (indexPath.row < self.userDataArray.count) {
            NSDictionary *userData = self.userDataArray[indexPath.row];
            userCell.lblName.text = userData[@"name"];
            userCell.lblEmail.text = userData[@"email"];
            userCell.btnDelete.tag = [userData[@"id"]integerValue];
            [userCell.btnDelete addTarget:self action:@selector(DeleteUser:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    else if ([cellIdentifier isEqualToString:@"AdminProductCell"]) {
        AdminProductCell *adminCell = (AdminProductCell *)cell;
        if (indexPath.row < self.itemDataArray.count) {
            NSDictionary *itemData = self.itemDataArray[indexPath.row];
            adminCell.lblName.text = itemData[@"name"];
            adminCell.lblPrice.text = [NSString stringWithFormat:@"$%.2f", [itemData[@"itemprice"] doubleValue]];
            adminCell.MyImageView.image = itemData[@"itemimg"];
            adminCell.btnHold.tag = [itemData[@"itemid"]integerValue];
            [adminCell.btnHold addTarget:self action:@selector(DeleteItem:) forControlEvents:UIControlEventTouchUpInside];
            adminCell.btnToggleVisible.tag = [itemData[@"itemid"]integerValue];
            [adminCell.btnToggleVisible addTarget:self action:@selector(ToggleStatus:) forControlEvents:UIControlEventTouchUpInside];
            if ([itemData[@"status"] intValue] == 0) {
                adminCell.lblHiddenStatus.text = @"Product is visible";
            } else {
                adminCell.lblHiddenStatus.text = @"Product is not visible";
                
            }
            
            
        }
    }
    return cell;
}





 


- (IBAction)btnUserList:(id)sender {
    self.currentNib = [UINib nibWithNibName:@"UserViewCell" bundle:nil];
    self.isUserViewSelected = YES;
    [self.tableView reloadData];
}

- (IBAction)btnProdList:(id)sender {
    self.currentNib = [UINib nibWithNibName:@"AdminProductCell" bundle:nil];
    self.isUserViewSelected = NO;
    [self.tableView reloadData];
}

-(IBAction)DeleteUser:(UIButton *)sender
{
    NSInteger usernumber = sender.tag;
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];

    if(![database open])
    {
        NSLog(@"ERROR THE DATA HAS NOT BEEN DELETED");
        return;
    }
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Users WHERE id =%ld",(long)usernumber];
    BOOL success = [database executeUpdate:deleteSQL];
    if(!success)
    {
        NSLog(@"ERROR IN DELETING THE DATA");
    }
    [database close];
    self.userDataArray = [self fetchUserData];
    [self.tableView reloadData];

    
}

-(IBAction)DeleteItem:(UIButton *)sender
{
    NSInteger itemId = sender.tag;
    NSString *databasePath = [[ManageDatabase sharedManager]databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    if(![database open])
    {
        NSLog(@"ERROR IN LOADING THE DATA");
        return;
    }
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Dash WHERE id = %ld",(long)itemId];
    BOOL success = [database executeUpdate:deleteSQL];
    if(!success)
    {
        NSLog(@"DATA IS NOT DELETED");
    }
    [database close];
    self.itemDataArray = [self fetchDishData];
    [self.tableView reloadData];
}


-(IBAction)ToggleStatus:(UIButton *)sender
{
    
        NSInteger toggleId = sender.tag;
        NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
        if (![database open]) {
            NSLog(@"ERROR: THE DATABASE CANNOT BE OPENED");
            return;
        }
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT hidden FROM Dashs WHERE id = %ld", (long)toggleId];
        FMResultSet *resultSet = [database executeQuery:selectSQL];
        if ([resultSet next]) {
            int currentHiddenValue = [resultSet intForColumn:@"hidden"];
            int newHiddenValue = (currentHiddenValue == 1) ? 0 : 1;
            if(newHiddenValue == 1)
            {
                
            }
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE Dashs SET hidden = %d WHERE id = %ld", newHiddenValue, (long)toggleId];
            BOOL success = [database executeUpdate:updateSQL];
            
            if (success) {
                NSLog(@"Toggle successful for Dashs id %ld. New hidden value: %d", (long)toggleId, newHiddenValue);
            } else {
                NSLog(@"Toggle failed for Dashs id %ld", (long)toggleId);
            }
        } else {
            NSLog(@"No record found for id %ld", (long)toggleId);
        }
    
    NSString *select = [NSString stringWithFormat:@"SELECT * FROM Dashs WHERE id= %ld",(long)toggleId];
    FMResultSet *result = [database executeQuery:select];

    if ([result next]) {
        NSLog(@"Dashs values for id %ld:", (long)toggleId);
        NSLog(@"itemimg: %@", [result stringForColumn:@"itemimg"]);
        NSLog(@"itemname: %@", [result stringForColumn:@"itemname"]);
        NSLog(@"itemprice: %d", [result intForColumn:@"itemprice"]);
        NSLog(@"itembrand: %@", [result stringForColumn:@"itembrand"]);
        NSLog(@"hidden: %d", [result intForColumn:@"hidden"]);
    } else {
        NSLog(@"No data found for id %ld", (long)toggleId);
    }
    
    
        [database close];
        self.itemDataArray = [self fetchDishData];
        [self.tableView reloadData];
    }


   

@end


