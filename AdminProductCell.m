//
//  AdminProductCell.m
//  SecondTry
//
//  Created by lcodeM2 on 09/10/23.
//

#import "AdminProductCell.h"

@implementation AdminProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self CellStyle:self.cellMainView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)CellStyle:(UIView *)view
{
    view.layer.borderColor=[UIColor whiteColor].CGColor;
    view.layer.borderWidth=0.3;
    view.layer.cornerRadius=10.0;
}

@end
