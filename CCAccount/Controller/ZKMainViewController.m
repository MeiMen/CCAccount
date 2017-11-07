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


@interface ZKMainViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *groupBtn;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;/**< */
@property(nonatomic,assign)NSInteger groupStyle;
@property(nonatomic,strong)NSArray  * groupStyles;/**< <#description#> */

@end

@implementation ZKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKMainAccountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZKMainAccountCell"];
    self.groupStyles = @[@"日",@"月",@"年"];
    [self.groupBtn setTitle:self.groupStyles[self.groupStyle] forState:UIControlStateNormal];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",[[ZKCoreDataManager shareInstance] query]);
}
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}
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
    sectionView.titleLabel.text = [self.fetchedResultsController sections][section].name;
    return sectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
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
    [self.tableView reloadData];
}


- (NSFetchedResultsController *)fetchedResultsController{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [Records fetchRequest];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[ZKCoreDataManager shareInstance].managerContext sectionNameKeyPath:@"day" cacheName:nil];
    _fetchedResultsController.delegate = self;
    NSError *error = NULL;
    
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
