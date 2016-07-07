//
//  EventDetailVIewController.h
//  TheARM
//
//  Created by Mihail Karev on 12/2/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum EventViewState{
    VIEW,
    EDIT,
    CREATE
} EventViewState;

@interface ResourceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *resourceLabel;
@end

@interface DescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@end

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@end

@interface DatePickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@interface DateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@interface EventDetailVIewController : UITableViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate>{
    BOOL _isDateSelected;
    BOOL _isStartDateSelected;
    BOOL _isDatePickerLoaded;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property(strong, atomic) NSMutableDictionary *currentEvent;
@property (nonatomic, assign) EventViewState eventViewState;
@property(strong, atomic) NSDictionary *currentResource;


@end
