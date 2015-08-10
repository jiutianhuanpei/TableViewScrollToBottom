//
//  TableViewCell.m
//  Keyboard_inputView_Demo
//
//  Created by 沈红榜 on 15/8/5.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell {
    UILabel *_title;
    UIView *_line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.translatesAutoresizingMaskIntoConstraints = false;
        _title.font = [UIFont systemFontOfSize:14];
        _title.numberOfLines = 0;
        [self addSubview:_title];
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.translatesAutoresizingMaskIntoConstraints = false;
        _line.backgroundColor = [UIColor grayColor];
        [self addSubview:_line];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_title, _line);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_title]-10-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_line]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_title]-[_line(3)]|" options:0 metrics:nil views:views]];
        
        
    }
    return self;
}

+ (CGFloat)height:(NSString *)count {
    CGSize contentSize = [count boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 0) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
    return contentSize.height + 20;
}

- (void)setCount:(NSString *)count {
    _title.text = count;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
