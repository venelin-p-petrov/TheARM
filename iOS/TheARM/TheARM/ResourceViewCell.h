//
//  ResourceViewCell.h
//  TheARM
//
//  Created by JGeorgiev on 11/1/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetWorking/UIImageView+AFNetworking.h>

@interface ResourceViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;

@end
