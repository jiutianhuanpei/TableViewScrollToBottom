//
//  SHBMessageInputView.m
//  Keyboard_inputView_Demo
//
//  Created by 沈红榜 on 15/8/5.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import "SHBMessageInputView.h"
#import "UIColor+Theme.h"


static  CGFloat const inputBarH = 51;
static  CGFloat const inputContentH = 200;
static  NSString *const yuyin = @"yuyin";
static  NSString *const keyboard = @"keyboard";
static  NSString *const addKeychain = @"addKeyChain";

static NSString *const takePhoto = @"takePhoto";
static NSString *const choosePhoto = @"choosePhoto";

@interface SHBMessageInputView ()<UITextFieldDelegate, UITextViewDelegate>

@end

@implementation SHBMessageInputView {
    UIView      *_firstLine;
    UIView      *_secondLine;
    
    UIView      *_inputView;
    UIView      *_contentView;
    
    UIButton    *_leftBtn;
    UIButton    *_rightBtn;
    
//    UITextField *_inputField;
    UITextView  *_inputTextView;
    UIButton    *_audioBt;
    
    BOOL        _first;
    
    UIButton    *_choosePhotoBtn;
    UIButton    *_takePhotoBtn;
    
    void(^inputTextToNil)();
    
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _first = YES;
        _state = SHBInputBottom;
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        _firstLine = [[UIView alloc] initWithFrame:CGRectZero];
        _firstLine.backgroundColor = [UIColor appSecondaryColor];
        [self addSubview:_firstLine];
        
        _inputView  = [[UIView alloc] initWithFrame:CGRectZero];
        _inputView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:_inputView];
        
        _secondLine = [[UIView alloc] initWithFrame:CGRectZero];
        _secondLine.backgroundColor = [UIColor appSecondaryColor];
        [self addSubview:_secondLine];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setImage:[UIImage imageNamed:yuyin] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_inputView addSubview:_leftBtn];
        
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setImage:[UIImage imageNamed:addKeychain] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(unfold:) forControlEvents:UIControlEventTouchUpInside];
        [_inputView addSubview:_rightBtn];
        
        //  输入栏
        
//        _inputField = [[UITextField alloc] initWithFrame:CGRectZero];
//        _inputField.placeholder = @"请输入...";
//        _inputField.backgroundColor = [UIColor whiteColor];
//        _inputField.font = [UIFont systemFontOfSize:14];
//        _inputField.layer.cornerRadius = 2;
//        _inputField.layer.masksToBounds = YES;
//        _inputField.delegate = self;
//        _inputField.returnKeyType = UIReturnKeySend;
//        [_inputView addSubview:_inputField];
        
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _inputTextView.backgroundColor = [UIColor whiteColor];
        _inputTextView.font = [UIFont systemFontOfSize:14];
        _inputTextView.layer.cornerRadius = 2;
        _inputTextView.layer.masksToBounds = true;
        _inputTextView.delegate = self;
        _inputTextView.returnKeyType = UIReturnKeySend;
        [_inputView addSubview:_inputTextView];
        
        
        
        
        _audioBt = [[UIButton alloc]initWithFrame:CGRectZero];
        [_audioBt setTitle:@"按住说话" forState:UIControlStateNormal];
        [_audioBt setTitle:@"松开结束" forState:UIControlStateSelected];
        [_audioBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _audioBt.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _audioBt.layer.cornerRadius = 2;
        _audioBt.layer.masksToBounds = YES;
        _audioBt.backgroundColor = [UIColor whiteColor];
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(audionRecord:)];
        [_audioBt addGestureRecognizer:longPress];
        
        _choosePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_choosePhotoBtn setImage:[UIImage imageNamed:choosePhoto] forState:UIControlStateNormal];
        [_choosePhotoBtn addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_choosePhotoBtn];
        
        _takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePhotoBtn setImage:[UIImage imageNamed:takePhoto] forState:UIControlStateNormal];
        [_takePhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_takePhotoBtn];
        
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat lineH = 0.5;
        CGFloat rightBtnW = 50;
        CGFloat leftBtnW = 50;
        CGFloat space = 0;
        
        CGFloat photoW = 60;
        
        _firstLine.frame = CGRectMake(0, 0, width, lineH);
        _inputView.frame = CGRectMake(0, lineH, width, 50);
        

//        _inputField.frame = CGRectMake(leftBtnW + space, 10, width - leftBtnW - space - rightBtnW - space, 30);
//        _audioBt.frame = _inputField.frame;
        
        _inputTextView.frame = CGRectMake(leftBtnW + space, 10, width - leftBtnW - space - rightBtnW - space, 30);
        _audioBt.frame = _inputTextView.frame;
        
        _leftBtn.frame = CGRectMake(0, 0, leftBtnW, 50);
        _rightBtn.frame = CGRectMake(width - rightBtnW, 0, rightBtnW, 50);
        _secondLine.frame = CGRectMake(0, CGRectGetMaxY(_inputView.frame), width, lineH);
        _contentView.frame = CGRectMake(0, CGRectGetMaxY(_secondLine.frame), width, 0);
        
        _choosePhotoBtn.frame = CGRectMake(20, 20, photoW, photoW);
        _takePhotoBtn.frame = CGRectMake(CGRectGetMaxX(_choosePhotoBtn.frame) + 20, CGRectGetMinY(_choosePhotoBtn.frame), photoW, photoW);
        
        [self addObserver];
        
        
    }
    return self;
}

- (void)choosePhoto:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(choosePhoto)]) {
        [_delegate choosePhoto];
    }
}

- (void)takePhoto:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(takePhoto)]) {
        [_delegate takePhoto];
    }
}

-(void)keyboardShow:(NSNotification *)note {
    UIView *superView = self.superview;
    CGFloat width = self.frame.size.width;
    
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        if (_contentView.frame.size.height) {
            _contentView.frame = CGRectMake(0, CGRectGetMaxY(_secondLine.frame), width, 0);
            self.frame = CGRectMake(0, CGRectGetHeight(superView.frame) - inputBarH, CGRectGetWidth(superView.frame), inputBarH);
        }
        
        superView.transform=CGAffineTransformMakeTranslation(0, -deltaY);
        _state = SHBInputTop;
        [superView layoutIfNeeded];
        if ([_delegate respondsToSelector:@selector(inputViewDidTop:)]) {
            [_delegate inputViewDidTop:note];
        }
    }];
}

-(void)keyboardHide:(NSNotification *)note {
    UIView *superView = self.superview;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        superView.transform = CGAffineTransformIdentity;
        [superView layoutIfNeeded];
        _state = SHBInputBottom;
        if ([_delegate respondsToSelector:@selector(inputViewDidBottom:)]) {
            [_delegate inputViewDidBottom:note];
        }
    }];
}


- (void)leftBtn:(UIButton *)btn {
    if (_audioBt.superview) {
        [_audioBt removeFromSuperview];
//        [_inputView addSubview:_inputField];
        [_inputView addSubview:_inputTextView];
        [_leftBtn setImage:[UIImage imageNamed:yuyin] forState:UIControlStateNormal];
    } else {
//        [_inputField removeFromSuperview];
        [_inputTextView removeFromSuperview];
        [_inputView addSubview:_audioBt];
        [_leftBtn setImage:[UIImage imageNamed:keyboard] forState:UIControlStateNormal];
    }
}

- (void)audionRecord:(UILongPressGestureRecognizer *)longPress {
    
    
    if ([_delegate respondsToSelector:@selector(longPress:)]) {
        [self.delegate longPress:longPress];
    }
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([_delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        [_delegate textFieldShouldReturn:textField];
    }
    if ([_delegate respondsToSelector:@selector(sendMessage:)]) {
        if (!textField.text.length) {
            return YES;
        }
        [self.delegate sendMessage:textField.text];
        textField.text = nil;
    }
    
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    CGRect frame = _inputTextView.frame;
    frame.size.height = [textView.text boundingRectWithSize:CGSizeMake(_inputTextView.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : _inputTextView.font} context:nil].size.height;
    if (frame.size.height < 30) {
        frame.size.height = 30;
        return true;
    }
    _inputTextView.frame = frame;
    _inputView.frame = CGRectMake(0, 0, CGRectGetWidth(_inputView.frame), _inputTextView.contentSize.height + 20);
    
    UIView *superView = self.superview;
    [superView layoutIfNeeded];
    NSLog(@"%s", __FUNCTION__);
    return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%s", __FUNCTION__);

    if ([textView.text hasSuffix:@"\n"] && [_delegate respondsToSelector:@selector(sendMessage:)]) {
        [_delegate sendMessage:[textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        _inputTextView.text = nil;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    NSLog(@"%s", __FUNCTION__);
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSLog(@"%s", __FUNCTION__);
    return true;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    NSLog(@"%s", __FUNCTION__);
    return true;
}

- (void)unfold:(UIButton *)btn {
    UIView *superView = self.superview;
    CGFloat width = self.frame.size.width;
    [UIView animateWithDuration:0.25 animations:^{
        if (_contentView.frame.size.height) {
            _contentView.frame = CGRectMake(0, CGRectGetMaxY(_secondLine.frame), width, 0);
            self.frame = CGRectMake(0, CGRectGetHeight(superView.frame) - inputBarH, CGRectGetWidth(superView.frame), inputBarH);
            _state = SHBInputBottom;
        } else {
            [_inputTextView resignFirstResponder];
            _contentView.frame = CGRectMake(0, CGRectGetMaxY(_secondLine.frame), width, inputContentH);
            self.frame = CGRectMake(0, CGRectGetHeight(superView.frame) - inputBarH - inputContentH, CGRectGetWidth(superView.frame), inputBarH + inputContentH);
            _state = SHBInputUnfold;
        }
        [superView layoutIfNeeded];
    }];
}

- (void)layoutSubviews {
    UIView *superView = self.superview;
    if (_first) {
        self.frame = CGRectMake(0, CGRectGetHeight(superView.frame) - inputBarH, CGRectGetWidth(superView.frame), inputBarH);
        _first = false;
    }
//    else {
//        self.frame = CGRectMake(0, CGRectGetHeight(superView.frame) - _inputView.frame.size.height, CGRectGetWidth(superView.frame), _inputView.frame.size.height);
//        
//    }
    [superView layoutIfNeeded];
}

- (CGRect)changeMinYTo:(CGFloat)MinY withFrame:(CGRect)frame {
    CGRect rect = frame;
    rect.origin.y = MinY;
    return rect;
}

- (CGFloat)inputBarHeight {
    return inputBarH;
}

#pragma mark - 观察者
- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:nil name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:nil name:UIKeyboardWillHideNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
