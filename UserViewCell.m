//
//  UserViewCell.m
//  SecondTry
//
//  Created by lcodeM2 on 10/10/23.
//

#import "UserViewCell.h"

@implementation UserViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self AddCustomStyles:self.userMainView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)AddCustomStyles:(UIView *)view
{
    view.layer.borderColor =[UIColor whiteColor].CGColor;
    view.layer.borderWidth =0.3;
    view.layer.cornerRadius = 10.0;
}

@end
