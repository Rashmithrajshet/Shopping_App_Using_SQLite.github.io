//
//  DashboardController.h
//  SecondTry
//
//  Created by lcodeM2 on 03/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashboardController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)btnCart:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *btnHolder;

- (IBAction)btnSortToggle:(id)sender;

- (IBAction)btnHighToLow:(id)sender;

- (IBAction)btnLowToHigh:(id)sender;

- (IBAction)btnSearch:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtSearchField;

- (void)SearchDataBase;

@property (weak, nonatomic) IBOutlet UIView *CartcountView;
@property (weak, nonatomic) IBOutlet UILabel *lblCartCount;




@end

NS_ASSUME_NONNULL_END
