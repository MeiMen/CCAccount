//
//  ZKEditRecordViewController.h
//  CCAccount
//
//  Created by papa on 2017/11/6.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKEditRecordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UITextField *purposeTF;
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;

@end
