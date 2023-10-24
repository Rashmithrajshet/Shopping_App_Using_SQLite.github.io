//
//  newCollectionViewCell.h
//  SecondTry
//
//  Created by lcodeM2 on 03/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface newCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *MainView;

@property (weak, nonatomic) IBOutlet UILabel *lblItemName;
@property (weak, nonatomic) IBOutlet UILabel *lblItemPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblItemBrand;
@property (weak, nonatomic) IBOutlet UIView *imageHolder;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;






@property (weak, nonatomic) IBOutlet UIButton *btnCart;


@end

NS_ASSUME_NONNULL_END
