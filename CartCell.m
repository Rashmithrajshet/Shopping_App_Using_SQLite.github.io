//
//  CartCell.m
//  SecondTry
//
//  Created by lcodeM2 on 03/10/23.
//

#import "CartCell.h"

@implementation CartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self addStyles:self.cellMainView];
}

-(void)addStyles:(UIView *)view{
    view.layer.cornerRadius=10.0;
    view.layer.borderWidth= 0.3;
    view.layer.borderColor=[UIColor blackColor].CGColor;
}

@end
