//
//  EventDetailVIewController.h
//  TheARM
//
//  Created by Mihail Karev on 12/2/15.
//  Copyright © 2015 Accedia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum EventViewState{
    JOIN,
    LEAVE,
    EDIT,
    CREATE
} EventViewState;

@interface ResourceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *resourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *resourceImageView;
@end

@interface DescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@end

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *participientsNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *participientsListTextView;

@end

@interface DatePickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@interface PickerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;
@end

@interface DateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@end

@interface FooterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@end


@interface EventDetailVIewController : UITableViewController<UITableViewDataSource, UITableViewDelegate,UITextViewDelegate, UIAlertViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>{
    BOOL _isDateSelected;
    BOOL _isDurationSelected;
    BOOL _isDatePickerLoaded;
    BOOL _isParticipientsSelected;
    
}

@property(strong, atomic) NSMutableDictionary *currentEvent;
@property (nonatomic, assign) EventViewState eventViewState;
@property(strong, atomic) NSDictionary *currentResource;


@end
