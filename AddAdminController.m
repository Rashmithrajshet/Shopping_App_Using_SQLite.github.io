
#import "AddAdminController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ManageDatabase.h"


@interface AddAdminController ()
@property (nonatomic, strong) NSData *selectedImageData;
@property(nonatomic,strong)NSString *databasePath;
@property (nonatomic, strong) NSString *convertedBase64ImageString;
@end

@implementation AddAdminController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tblViewHolder.hidden=YES;
    self.tableView.hidden=YES;
    UINib *nib = [UINib nibWithNibName:@"ProductViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ProductViewCell"];
    [[ManageDatabase sharedManager]setupDatabase];
    self.navigationController.navigationBar.hidden = NO;
    [self addPopAnimation:self.addProductView];
    [self addCustomStyles:self.addProductView];

}


- (IBAction)btnToggleProductTable:(id)sender {
    self.tblViewHolder.hidden = !self.tblViewHolder.hidden;
    self.tableView.hidden = !self.tableView.hidden;
}

- (IBAction)btnSave:(id)sender {
    
       NSString *productName = self.txtProductName.text;
       NSString *productBrand = self.txtProductBrand.text;
       NSString *productImg = self.txtProductImg.text;
       NSString *productPrice = self.txtProductPrice.text;
       NSString *ImageBase64 = self.convertedBase64ImageString;

       if ([productName isEqualToString:@""] || [productBrand isEqualToString:@""] || [productImg isEqualToString:@""] || [productPrice isEqualToString:@""]) {
           [self displayAlertWithTitle:@"Error" message:@"Please enter all required information."];
           return;
       }

       NSString *databasePath = [[ManageDatabase sharedManager] databasePath];
       FMDatabase *database = [FMDatabase databaseWithPath:databasePath];

       if (![database open]) {
           NSLog(@"Could not open the database");
           return;
       }

       NSString *insertSQL = @"INSERT INTO Dashs(itemimg, itemname, itemprice, itembrand) VALUES(?, ?, ?, ?)";

       BOOL success = [database executeUpdate:insertSQL, ImageBase64, productName, productPrice, productBrand];

       if (success) {
           NSLog(@"Data inserted successfully.");
       } else {
           NSLog(@"Failed to insert data.");
       }

       [database close];

}

- (IBAction)btnUploadImg:(id)sender {
        UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeImage] inMode:UIDocumentPickerModeImport];
        documentPicker.delegate = self;
        [self presentViewController:documentPicker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    if (urls.count > 0) {
            NSURL *url = urls[0];
            self.selectedImageData = [NSData dataWithContentsOfURL:url];
            UIImage *selectedImage = [UIImage imageWithData:self.selectedImageData];
            NSString *base64ImageString = [self base64StringFromImage:selectedImage];
            self.convertedBase64ImageString = base64ImageString;
            self.txtProductImg.text = [url lastPathComponent];
        }
}

- (NSString *)base64StringFromImage:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *base64String = [imageData base64EncodedStringWithOptions:0];
    return base64String;
}


- (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnViewUser:(id)sender {
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [self.view endEditing:true];
    return YES;

}

- (void)deleteAllDataFromDashTable {
    NSString *databasePath = [[ManageDatabase sharedManager]databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    if (![database open]) {
        NSLog(@"Could not open the database.");
        return;
    }

    NSString *deleteSQL = @"DELETE FROM Dashs";
    BOOL success = [database executeUpdate:deleteSQL];

    if (success) {
        NSLog(@"All data deleted from Dish table.");
    } else {
        NSLog(@"Error: Could not delete data from Dish table.");
    }

    [database close];
}



-(void)DisplayAllData {
    NSString *databasePath = [[ManageDatabase sharedManager]databasePath];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];

    if (![database open]) {
        NSLog(@"COULD NOT LOAD THE DATA DUE TO DATABASE ERROR");
        return;
    }

    NSString *selectQuery = @"SELECT * FROM Dash";
    FMResultSet *resultSet = [database executeQuery:selectQuery];

    while ([resultSet next]) {
        NSString *itemImg = [resultSet stringForColumn:@"itemimg"];
        NSString *itemName = [resultSet stringForColumn:@"itemname"];
        NSString *itemPrice = [resultSet stringForColumn:@"itemprice"];
        NSString *itemBrand = [resultSet stringForColumn:@"itembrand"];

        NSLog(@"Item Image: %@, Item Name: %@, Item Price: %@, Item Brand: %@", itemImg, itemName, itemPrice, itemBrand);
    }

    [database close];
}


- (void)addPopAnimation:(UIView *)view {
    view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    view.center = CGPointMake(CGRectGetWidth(self.view.frame) / 2, CGRectGetHeight(self.view.frame) / 2);
    CGFloat originalAlpha = view.alpha;
    view.alpha = 0.0;

    [UIView animateWithDuration:0.8
                          delay:0.1
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         view.transform = CGAffineTransformIdentity;
                         view.center = CGPointMake(200, 200);
                         view.alpha = originalAlpha;
                     }
                     completion:nil];
}





-(void)addCustomStyles:(UIView *)view
{
    view.layer.borderWidth = 0.5;
    view.layer.borderColor=[UIColor whiteColor].CGColor;
    view.layer.cornerRadius=10.0;
}


@end


