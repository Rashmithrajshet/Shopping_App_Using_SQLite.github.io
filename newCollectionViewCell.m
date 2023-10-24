//
//  newCollectionViewCell.m
//  SecondTry
//
//  Created by lcodeM2 on 03/10/23.
//

#import "newCollectionViewCell.h"

@implementation newCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self Styles:self.MainView];
}

-(void)Styles:(UIView *)view
{
    view.layer.cornerRadius=10.0;
    view.layer.borderColor=[UIColor grayColor].CGColor;
    view.layer.borderWidth=0.3;
}


@end
