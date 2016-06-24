//
//  ViewController.m
//  UITableView+NSTimer
//
//  Created by roctian on 16/6/24.
//  Copyright © 2016年 roctian. All rights reserved.
//

#import "ViewController.h"
#import "customCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)NSArray *data;
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)NSMutableArray *allLabelArray;
@property(strong,nonatomic)NSMutableArray *allDateArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _data = @[@"2016-06-25 13:56:50",@"2016-06-25 08:43:50",@"2016-06-25 09:23:45",@"2016-06-25 10:31:31",@"2016-06-25 11:34:43",@"2016-06-25 12:07:50",@"2016-06-25 14:56:50",@"2016-06-25 13:56:50",@"2016-06-25 08:43:50",@"2016-06-25 09:23:45",@"2016-06-25 10:31:31",@"2016-06-25 11:34:43",@"2016-06-25 12:07:50",@"2016-06-25 14:56:50",@"2016-06-25 13:56:50",@"2016-06-25 08:43:50",@"2016-06-25 09:23:45",@"2016-06-25 10:31:31",@"2016-06-25 11:34:43",@"2016-06-25 12:07:50",@"2016-06-25 14:56:50",@"2016-06-25 13:56:50",@"2016-06-25 08:43:50",@"2016-06-25 09:23:45",@"2016-06-25 10:31:31",@"2016-06-25 11:34:43",@"2016-06-25 12:07:50",@"2016-06-25 14:56:50"];
    
    [self prepareData];
    [self.view addSubview:self.tableView];
    
    [self initTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private method

-(void)prepareData{

    _allLabelArray = [NSMutableArray new];
    _allDateArray  = [NSMutableArray new];
    
    for (NSString *string in _data) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, self.view.frame.size.width-28, 96)];
        label.tag = 101;
        
        [_allLabelArray addObject:label];
        
        NSDateFormatter * dm = [[NSDateFormatter alloc]init];
        //指定输出的格式   这里格式必须是和上面定义字符串的格式相同，否则输出空
        [dm setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSDate * toDate = [dm dateFromString:string];
        
        NSString *timeString = [self getNSDateComponents:toDate];
        label.text = timeString;
        
        [_allDateArray addObject:toDate];
    }
}
-(void)initTimer{

    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    //How often to update the clock labels
    _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(myTimerAction) userInfo:nil repeats:YES];
    [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
    [runloop addTimer:_timer forMode:UITrackingRunLoopMode];

}

-(void)myTimerAction{

     NSArray *indexPaths  = [self.tableView indexPathsForVisibleRows];
    
    for (int i =0; i<indexPaths.count; i++) {
        
        NSIndexPath *path = indexPaths[i];
        
        NSString *timeString = [self getNSDateComponents:_allDateArray[path.row]];
        
        UILabel *label = _allLabelArray[path.row];
        label.text = timeString;
        
      
    }
    
}
-(NSString *)getNSDateComponents:(NSDate *)toDate{

    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *fromDate = [NSDate new];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:fromDate toDate:toDate options:0];
    
    NSString *string = [NSString stringWithFormat:@"%ld小时%02ld分%02ld秒",(long)[d hour],[d minute],[d second]];
//    int sec = [d hour]*3600+[d minute]*60+[d second];
//    NSLog(@"timeString:%@",string);

    return string;
}

#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _data.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 106;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

//    customCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
    
    UILabel *tempLabel = [cell.contentView viewWithTag:101];
    [tempLabel removeFromSuperview];
    
    UILabel *label = _allLabelArray[indexPath.row];
    [cell.contentView addSubview:label];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UILabel *label = _allLabelArray[indexPath.row];
//
//    if([label.text isEqualToString:@""]){
//        
//        NSLog(@"willDisplayText");
//        
//        NSString *timeString = [self getNSDateComponents:_allDateArray[indexPath.row]];
//        label.text = timeString;
//    }


}

#pragma mark getter

-(UITableView *)tableView{

    if(!_tableView){
    
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
        
//        [_tableView registerClass:[customCell class] forCellReuseIdentifier:@"customCell"];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"customCell"];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
