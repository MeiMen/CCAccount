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
@property (nonatomic,strong) UILabel *tip;/**< */
@property (nonatomic,strong) UIView *tipView;/**< */
@end

@implementation ZKEditRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.dataPicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged ];
    [self.dataPicker addTarget:self action:@selector(tapOnView:) forControlEvents:UIControlEventAllTouchEvents];
    [self dateChanged];
    [self setTipView];
    [self setInitialData];
}

- (void)setInitialData{
    
    if (!self.record) {
        return;
    }
    self.purposeTF.text = self.record.purpose;
    self.amountTF.text = [NSString stringWithFormat:@"%.2f",self.record.amount];
    self.dataPicker.date = self.record.date;
    self.dateLab.text = self.record.day;
   
}
- (IBAction)saveAction:(id)sender {

    if (self.purposeTF.text.length<=0) {
        [self showTipViewWithTips:@"这笔巨款 \"用途\" 还没记哟"];
        return;
    }
    if (self.amountTF.text.length<=0) {
        [self showTipViewWithTips:@"巨款再巨也有个数吧"];
        return;
    }
    
    Records *record ;
    if (self.record) {
        record = self.record;
    }else{
         //如果不是编辑，生成record
        record = [Records newRecords];
    }
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


- (void)setTipView{
    UIView *tipView = [UIView new];
    tipView.frame = CGRectMake(0, 0, 230,70);
    
    tipView.backgroundColor = [UIColor clearColor];
    tipView.layer.cornerRadius = 5;
    tipView.clipsToBounds = YES;
    
    UIView *bgView = [[UIView alloc] initWithFrame:tipView.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [tipView addSubview:bgView];
    
    UILabel *tip = [UILabel new];
    tip.textColor = [UIColor whiteColor];
    tip.font = [UIFont systemFontOfSize:16];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.backgroundColor = [UIColor clearColor];
    tip.frame = tipView.bounds;
    [tipView addSubview:tip];
    
    self.tip = tip;
    self.tipView = tipView;
    tipView.center = CGPointMake(self.view.center.x, self.view.center.y-self.navigationController.navigationBar.frame.size.height-40);
    
}

- (void)showTipViewWithTips:(NSString *)tips{
    self.tip.text = tips;
    [self.view addSubview:self.tipView];
    [UIView animateWithDuration:0.5 animations:^{
        self.tipView.alpha = 1;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.tipView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.tipView removeFromSuperview];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
