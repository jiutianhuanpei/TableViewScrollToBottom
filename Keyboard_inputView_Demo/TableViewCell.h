//
//  TableViewCell.h
//  Keyboard_inputView_Demo
//
//  Created by 沈红榜 on 15/8/5.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) NSString *count;

+ (CGFloat)height:(NSString *)count;

@end
