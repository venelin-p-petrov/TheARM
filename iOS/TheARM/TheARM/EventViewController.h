//
//  EventViewController.h
//  TheARM
//
//  Created by Mihail Karev on 11/15/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventViewController : UIViewController<UIPickerViewDelegate>

@property(strong, atomic) NSDictionary *currentEvent;

@end
