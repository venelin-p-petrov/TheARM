//
//  ARMTextFieldCell.m
//  TheARM
//
//  Created by Mihail Karev on 7/11/16.
//  Copyright © 2016 Accedia. All rights reserved.
//

#import "ARMTextFieldCell.h"

@implementation ARMTextFieldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textField endEditing:YES];
}

@end
