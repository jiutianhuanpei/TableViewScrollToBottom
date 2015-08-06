//
//  ViewController.m
//  Keyboard_inputView_Demo
//
//  Created by 沈红榜 on 15/8/5.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "SHBMessageInputView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, SHBMessageInputViewDelegate>
@property (weak, nonatomic)  UITextView *textView;
@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, assign) NSInteger         rowsNum;
@property (nonatomic, strong) SHBMessageInputView   *inputView;


@end

@implementation ViewController {
    
    __weak IBOutlet UIButton *_reBtn;
//    NSLayoutConstraint *_top;
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
    
    
    _inputView = [[SHBMessageInputView alloc] initWithFrame:CGRectZero];
    _inputView.delegate = self;
    [self.view addSubview:_inputView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width, height - _inputView.inputBarHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    
    
    
    
    [self.view bringSubviewToFront:_reBtn];
    [self.view insertSubview:_inputView belowSubview:_reBtn];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
    self.tableView.tableFooterView = [UIView new];

    

    
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}



- (void)scrollToBottom {
    if (_tableView.contentSize.height > _tableView.bounds.size.height) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark - SHBMessageInputViewDelegate
- (void)sendMessage:(NSString *)message {
    [_dataArray addObject:message];
    [_heghts addObject:[NSString stringWithFormat:@"%d", arc4random() % 100 + 40]];
    __weak typeof(self) SHB = self;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } completion:^(BOOL finished) {
        if (finished) {
            [SHB scrollToBottom];
        }
    }];

}

- (void)inputViewDidTop:(NSNotification *)info {
    CGRect keyBoardRect=[info.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    
    [UIView animateWithDuration:[info.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _tableView.frame = CGRectMake(0, deltaY, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - deltaY - _inputView.inputBarHeight);
    }];
    [self scrollToBottom];
}

- (void)inputViewDidBottom:(NSNotification *)info {
    [UIView animateWithDuration:[info.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - _inputView.inputBarHeight);
    }];
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            [self sendMessage:@"66666"];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)choosePhoto {
    
}

- (void)takePhoto {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)reStart:(id)sender {
    [_dataArray removeAllObjects];
    [_heghts removeAllObjects];
    [_tableView reloadData];
    
}

@end
