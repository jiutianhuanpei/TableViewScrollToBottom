//
//  ViewController.m
//  Keyboard_inputView_Demo
//
//  Created by 沈红榜 on 15/8/5.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic)  UITextView *textView;
@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, strong) UITextField       *inputView;
@property (nonatomic, assign) NSInteger         rowsNum;
@end

@implementation ViewController {
    
    NSLayoutConstraint *_top;
    NSMutableArray      *_dataArray;
    NSMutableArray      *_heghts;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    _dataArray  = [[NSMutableArray alloc] initWithCapacity:0];
    _heghts  = [[NSMutableArray alloc] initWithCapacity:0];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    
    
    _inputView = [[UITextField alloc] initWithFrame:CGRectMake(0, height - 44, width, 44)];
    _inputView.translatesAutoresizingMaskIntoConstraints = NO;
    _inputView.text = @"输入文字";
    _inputView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_inputView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:@"Send" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(self.view.frame.size.width - 50, 0, 50, 44);
    [self.view addSubview:btn];
    
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView, _inputView, btn);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_inputView][btn(50)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tableView]-10-[_inputView(44)]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[btn(44)]" options:0 metrics:nil views:views]];
    _top = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:_top];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_inputView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class]) forIndexPath:indexPath];
    cell.count = _dataArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_heghts[indexPath.row] integerValue];
}



- (void)sendMessage {
    NSString *title = [NSString stringWithFormat:@"yy%d", arc4random() % 1000];
    [_dataArray addObject:title];
    [_heghts addObject:[NSString stringWithFormat:@"%d", arc4random() % 100 + 40]];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self scrollToBottom];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}



- (void)scrollToBottom {
    if (_tableView.contentSize.height > _tableView.bounds.size.height) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;

    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _top.constant = deltaY;
        self.view.transform=CGAffineTransformMakeTranslation(0, -deltaY);
    }];
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.rowsNum - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToBottom];
    });
}

-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        _top.constant = 0;
//        _tableView.frame = self.view.frame;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToBottom];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
