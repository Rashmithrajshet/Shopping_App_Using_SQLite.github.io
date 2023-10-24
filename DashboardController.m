
#import "DashboardController.h"
#import "newCollectionViewCell.h"
#import "CartViewController.h"
#import "ManageDatabase.h"

@interface DashboardController ()

@property (nonatomic, strong) NSString *databasePath;
@property (nonatomic, strong) NSArray *itemDataArray;

@end

@implementation DashboardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.btnHolder.hidden = TRUE;
    [self.collectionView registerNib:[UINib nibWithNibName:@"newCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"newCollectionViewCell"];
    [[ManageDatabase sharedManager] setupDatabase];
    self.itemDataArray = [self fetchDishData];
    self.CartcountView.layer.cornerRadius = self.CartcountView.frame.size.width/2;
    self.CartcountView.layer.borderWidth=0.2;
    self.lblCartCount.layer.borderColor = [UIColor blackColor].CGColor;
    self.lblCartCount.layer.cornerRadius = self.lblCartCount.frame.size.width/2;
    [self CartItemCount];
    self.itemDataArray = [self fetchDishData];
    self.navigationController.navigationBar.hidden = NO;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemDataArray.count;
}

- (NSArray *)fetchDishData {
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    NSMutableArray *dataArray = [NSMutableArray array];

    if (![database open]) {
        NSLog(@"Could not open the database.");
        return dataArray;
    }
    NSString *selectSQL = @"SELECT * FROM Dashs WHERE hidden = 0";
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

        NSDictionary *itemData = @{@"name": itemName, @"brand": itemBrand, @"itemimg": itemImage, @"itemprice": @(itemPrice), @"itemid": @(itemId), @"status": @(itemStatus)};
        [dataArray addObject:itemData];
    }
    [database close];
    return dataArray;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    newCollectionViewCell *cell = (newCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"newCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *itemData = self.itemDataArray[indexPath.row];
    cell.lblItemName.text = itemData[@"name"];
    cell.lblItemPrice.text = [NSString stringWithFormat:@"$%.2f", [itemData[@"itemprice"] doubleValue]];
    cell.lblItemBrand.text = itemData[@"brand"];
    cell.imageView.image = itemData[@"itemimg"];
    cell.btnCart.tag = [itemData[@"itemid"]integerValue];
    [cell.btnCart addTarget:self action:@selector(AddToCart:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}






-(IBAction)AddToCart:(UIButton *)sender {
    NSInteger itemId = sender.tag;
    NSLog(@"the id is %ld", (long)itemId);
    
    [UIView animateWithDuration:0.1 animations:^{
            sender.transform = CGAffineTransformMakeScale(0.7, 0.7);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                sender.transform = CGAffineTransformIdentity;
            }];
        }];
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    if (![database open]) {
        NSLog(@"Could not open the database.");
        return;
    }
    
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM Dashs WHERE id = %ld", (long)itemId];
    FMResultSet *resultSet = [database executeQuery:selectSQL];
    
    while ([resultSet next]) {
        NSString *itemName = [resultSet stringForColumn:@"itemname"];
        double itemPrice = [resultSet doubleForColumn:@"itemprice"];
        NSString *itemImg = [resultSet stringForColumn:@"itemimg"];
        NSInteger userID = [[ManageDatabase sharedManager].userID intValue];
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO MyCarts (cartitemname, cartitemprice, cartimg, userid) VALUES ('%@', %.2f, '%@', %ld)", itemName, itemPrice, itemImg, (long)userID];
        
        NSLog(@"Insert SQL: %@", insertSQL);
        NSString *insertQueryLog = [NSString stringWithFormat:@"INSERT INTO MyCarts(cartitemname, cartitemprice, cartimg, userid) VALUES ('%@', %.2f, '%@', %ld)", itemName, itemPrice, itemImg, userID];
        NSLog(@"Insert Query with Values: %@", insertQueryLog);
        
        if (![database executeUpdate:insertSQL]) {
            NSLog(@"Failed to insert data into cart table.");
        } else {
            NSLog(@"Data successfully inserted into cart table.");
        }
    }
    
    [database close];
    [self CartItemCount];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionViewWidth = collectionView.bounds.size.width;
    CGFloat cellWidth = (collectionViewWidth - 3 * 10) / 2;
    return CGSizeMake(cellWidth, 200);
}

- (IBAction)btnCart:(id)sender {
    [self animateButtonClickForButton:sender];
    CartViewController *cart = [[CartViewController alloc] init];
    [self.navigationController pushViewController:cart animated:YES];
}

- (IBAction)btnSearch:(id)sender {
    [self animateButtonClickForButton:sender];
    [self SearchDataBase];
}


- (IBAction)btnSortToggle:(id)sender
{
    self.btnHolder.hidden = !self.btnHolder.hidden;
}

- (IBAction)btnLowToHigh:(id)sender {
    self.itemDataArray = [self fetchDishDataWithSortOrder:@"ASC"];
    [self.collectionView reloadData];
}

- (IBAction)btnHighToLow:(id)sender {
    self.itemDataArray = [self fetchDishDataWithSortOrder:@"DESC"];
    [self.collectionView reloadData];
}

- (NSArray *)fetchDishDataWithSortOrder:(NSString *)sortOrder {
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    NSMutableArray *dataArray = [NSMutableArray array];

    if (![database open]) {
        NSLog(@"Could not open the database.");
        return dataArray;
    }

    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM Dashs ORDER BY itemprice %@", sortOrder];
    FMResultSet *resultSet = [database executeQuery:selectSQL];

    while ([resultSet next]) {
        NSString *itemName = [resultSet stringForColumn:@"itemname"];
        NSString *itemBrand = [resultSet stringForColumn:@"itembrand"];
        NSString *base64ImageString = [resultSet stringForColumn:@"itemimg"];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64ImageString options:0];
        UIImage *itemImage = [UIImage imageWithData:imageData];
        double itemPrice = [resultSet doubleForColumn:@"itemprice"];
        NSInteger itemId = [resultSet intForColumn:@"id"];

        NSDictionary *itemData = @{@"name": itemName, @"brand": itemBrand, @"itemimg": itemImage, @"itemprice": @(itemPrice), @"itemid": @(itemId)};
        [dataArray addObject:itemData];
    }

    [database close];
    return dataArray;
}


-(void)SearchDataBase{
    NSString *searchDataBase = self.txtSearchField.text;
    self.itemDataArray = [self fetchDishDataWithSearchQuery:searchDataBase sortOrder:@"ASC"];
    [self.collectionView reloadData];
}
- (NSArray *)fetchDishDataWithSearchQuery:(NSString *)searchQuery sortOrder:(NSString *)sortOrder {
    NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    NSMutableArray *dataArray = [NSMutableArray array];
    
    if (![database open]) {
        NSLog(@"Could not open the database.");
        return dataArray;
    }
    NSString *searchDataBase = self.txtSearchField.text;
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM Dashs WHERE itemname LIKE '%%%@%%' ORDER BY itemprice %@",searchDataBase, sortOrder];

    FMResultSet *resultSet = [database executeQuery:selectSQL];
    
    while ([resultSet next]) {
        NSString *itemName = [resultSet stringForColumn:@"itemname"];
        NSString *itemBrand = [resultSet stringForColumn:@"itembrand"];
        NSString *itemImage = [resultSet stringForColumn:@"itemimg"];
        double itemPrice = [resultSet doubleForColumn:@"itemprice"];
        NSInteger itemId = [resultSet intForColumn:@"id"];
        
        NSDictionary *itemData = @{@"name": itemName, @"brand": itemBrand, @"itemimg": itemImage, @"itemprice": @(itemPrice), @"itemid": @(itemId)};
        [dataArray addObject:itemData];
    }
    
    [database close];
    return dataArray;
}


- (void)animateButtonClickForButton:(UIButton *)button {
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(0.7, 0.7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            button.transform = CGAffineTransformIdentity;
        }];
    }];
}

-(void)CartItemCount
{
    NSInteger userID = [[ManageDatabase sharedManager].userID intValue];
        NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];

        if (![database open]) {
            NSLog(@"Error loading the database.");
            return;
        }

        NSString *countQuery = [NSString stringWithFormat:@"SELECT COUNT(*) AS CARTCOUNT FROM MyCarts WHERE userid = %ld", (long)userID];

        FMResultSet *countResult = [database executeQuery:countQuery];
        if ([countResult next]) {
            NSInteger cartCount = [countResult intForColumn:@"CARTCOUNT"];
            NSLog(@"Cart count for user ID %ld: %ld", (long)userID, (long)cartCount);
            self.lblCartCount.text = [NSString stringWithFormat:@"%ld", (long)cartCount];
        } else {
            NSLog(@"Failed to retrieve cart count.");
        }

        [database close];

}

@end




