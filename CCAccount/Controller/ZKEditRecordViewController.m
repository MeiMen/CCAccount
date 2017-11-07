//
//  ZKEditRecordViewController.m
//  CCAccount
//
//  Created by papa on 2017/11/6.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKEditRecordViewController.h"
#import "Records+CoreDataClass.h"


@interface ZKEditRecordViewController ()

@end

@implementation ZKEditRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.dataPicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged ];
    [self.dataPicker addTarget:self action:@selector(tapOnView:) forControlEvents:UIControlEventAllTouchEvents];
    [self dateChanged];
}

- (IBAction)saveAction:(id)sender {
    
    Records *record = [Records newRecords] ;
    record.purpose = self.purposeTF.text;
    record.desc = @"";
    record.amount = [self.amountTF.text floatValue];
    record.date = self.dataPicker.date;
    record.day = self.dateLab.text;
    record.month = [self formatDate:@"yyyy年MM月"];
    record.year = [self formatDate:@"yyyy年"];
    [record save];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)tapOnView:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

-(void)dateChanged{

    NSString *dateString = [self formatDate:@"yyyy年MM月dd日"];
    dateString = [dateString stringByAppendingString:[self getWeekDayFordate:self.dataPicker.date]];
    //打印显示日期时间
    self.dateLab.text = dateString;
}

- (NSString *)formatDate:(NSString *)formatString{
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.dataPicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateFormat:formatString];
    NSString *dateString = [pickerFormatter stringFromDate:pickerDate];
    return dateString;
}

- (NSString *)getWeekDayFordate:(NSDate*)date
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
