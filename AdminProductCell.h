//
//  AdminProductCell.h
//  SecondTry
//
//  Created by lcodeM2 on 09/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdminProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *MyImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnHold;
@property (weak, nonatomic) IBOutlet UIView *cellMainView;
@property (weak, nonatomic) IBOutlet UIButton *btnToggleVisible;
@property (weak, nonatomic) IBOutlet UILabel *lblHiddenStatus;










@end

NS_ASSUME_NONNULL_END
