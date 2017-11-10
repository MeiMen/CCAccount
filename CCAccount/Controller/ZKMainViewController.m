//
//  ViewController.m
//  CCAccount
//
//  Created by papa on 2017/11/6.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKMainViewController.h"
#import "ZKMainAccountSectionView.h"
#import "ZKCoreDataManager.h"
#import "Records+CoreDataClass.h"
#import "ZKMainAccountCell.h"
#import "ZKEditRecordViewController.h"
#import "ZKCoreDataManager.h"
@interface ZKMainViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (nonatomic,strong)NSFetchedResultsController *fetchedResultsController;/**< */
@property(nonatomic,assign)NSInteger groupStyle;
@property(nonatomic,strong)NSArray  * groupStyles;/**<  */
@property (nonatomic,strong) NSMutableArray *sectionAccounts;/**< */

@end

@implementation ZKMainViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKMainAccountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZKMainAccountCell"];
    self.tableView.tableFooterView = [UIView new];
    
    self.groupStyles = @[@"日",@"月",@"年"];
    [self.groupBtn setTitle:self.groupStyles[self.groupStyle] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveAction) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
}
- (void)saveAction{
    NSLog(@"昌吉");
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fetchedResultsController:@"day"];
}


#pragma mark - Acction
- (IBAction)groupStyleChanged:(id)sender {
    
 
    self.groupStyle += 1;
    self.groupStyle %=3;
    [self.groupBtn setTitle:self.groupStyles[self.groupStyle] forState:UIControlStateNormal];
    switch (self.groupStyle) {
        case 0:
            [self fetchedResultsController:@"day"];
            break;
        case 1:
             [self fetchedResultsController:@"month"];
            break;
        case 2:
             [self fetchedResultsController:@"year"];
            break;
            
        default:
            break;
    }
}

- (void)fetchSectionTitles{
    [self.sectionAccounts removeAllObjects];
    self.sectionAccounts = [NSMutableArray array];
    __block CGFloat account = 0;
    [self.fetchedResultsController.sections enumerateObjectsUsingBlock:
     ^(id<NSFetchedResultsSectionInfo>  _Nonnull section, NSUInteger idx, BOOL * _Nonnull stop) {
        __block CGFloat sum = 0;
        [section.objects enumerateObjectsUsingBlock:
         ^(Records*  record, NSUInteger idx, BOOL * _Nonnull stop) {
            sum += record.amount;
        }];
        NSString *title = [NSString stringWithFormat:
                           @"合计：%.2f",sum];
        account += sum;
        [self.sectionAccounts addObject:title];
    }];
    
    self.accountLabel.text =
    [NSString stringWithFormat:@"总计：%.2f",account];
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self fetchSectionTitles];
    [self.tableView reloadData];
   
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZKMainAccountCell *cell =[tableView dequeueReusableCellWithIdentifier:@"ZKMainAccountCell"];
    Records *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.purposeLabel.text = record.purpose;
    cell.amountLabel.text = [NSString stringWithFormat:@"%.2f",record.amount];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZKMainAccountSectionView *sectionView = (ZKMainAccountSectionView*)[[NSBundle mainBundle] loadNibNamed:@"ZKMainAccountSectionView" owner:nil options:nil].lastObject;
    sectionView.titleLabel.text = self.fetchedResultsController.sections[section].name;
    sectionView.accountLabel.text = self.sectionAccounts[section];

    return sectionView;

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除托管对象
        Records *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [record deleteObj];
    }
   
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZKEditRecordViewController *vc =  [self.storyboard  instantiateViewControllerWithIdentifier:@"ZKEditRecordViewController" ];
    vc.record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fetchedResultsController:(NSString *)sectionName{
    NSFetchRequest *fetchRequest = [Records fetchRequest];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ZKCoreDataManager shareInstance].managerContext sectionNameKeyPath:sectionName cacheName:nil];
    _fetchedResultsController.delegate = self;
    NSError *error = NULL;
    
    
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self fetchSectionTitles];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
