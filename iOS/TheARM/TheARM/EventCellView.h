//
//  EventCellView.h
//  TheARM
//
//  Created by Mihail Karev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EventCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPeople;
@property (weak, nonatomic) IBOutlet UIImageView *resourceImage;
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;

@end
