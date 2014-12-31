//
//  XAIScanVC.h
//  XAI
//
//  Created by office on 14-5-6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


#define XAIScanVC_SB_ID @"XAIScanVCID"

@interface MaskView : UIView

@property (nonatomic,assign) CGRect holeRect;

@end

@protocol XAIScanVCDelegate ;
@interface XAIScanVC : UIViewController <ZBarReaderViewDelegate>{

    ZBarReaderView *_readerView ;
    
    UIView* _ios7_view;
    
    BOOL _scanEnd;

}

@property (strong, nonatomic) IBOutlet MaskView *backView;
@property (nonatomic,strong) IBOutlet UIImageView* scanView;
@property (nonatomic,strong) IBOutlet UIButton* cancelBtn;
@property (nonatomic,strong) IBOutlet UIImageView* scanLine;
@property (nonatomic,weak)  id<XAIScanVCDelegate> delegate;

+ (XAIScanVC*)create;


- (IBAction)cancelBtnClick:(id)sender;

@end



@protocol XAIScanVCDelegate <NSObject>

- (void)scanVC:(XAIScanVC*)scanVC didReadSymbols:(ZBarSymbolSet *)symbols;
@optional
- (void)scanVC:(XAIScanVC*)scanVC closeWithCacncel:(BOOL)cancel;

@end


