//
//  SHBMessageInputView.h
//  Keyboard_inputView_Demo
//
//  Created by 沈红榜 on 15/8/5.
//  Copyright (c) 2015年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SHBInputViewState) {
    SHBInputTop,
    SHBInputBottom,
    SHBInputUnfold,
};

@protocol SHBMessageInputViewDelegate <NSObject>

- (void)sendMessage:(NSString *)message;
- (void)choosePhoto;
- (void)takePhoto;

@optional
- (void)longPress:(UILongPressGestureRecognizer *)longPress;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)inputViewDidTop:(NSNotification *)info;
- (void)inputViewDidBottom:(NSNotification *)info;
- (void)inputViewDidUnfold;

@end

@interface SHBMessageInputView : UIView

@property (nonatomic, assign) id<SHBMessageInputViewDelegate> delegate;

@property (nonatomic, assign, readonly) CGFloat inputBarHeight;
@property (nonatomic, assign, readonly) CGFloat inputMinY;
@property (nonatomic, assign, readonly) SHBInputViewState state;

@end
