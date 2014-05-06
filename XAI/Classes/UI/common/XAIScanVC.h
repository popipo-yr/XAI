//
//  XAIScanVC.h
//  XAI
//
//  Created by office on 14-5-6.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XAIScanVCDelegate ;
@interface XAIScanVC : UIViewController <ZBarReaderViewDelegate>{

    ZBarReaderView *_readerView ;

}

@property (nonatomic,strong) IBOutlet UIImageView* scanView;
@property (nonatomic,weak)  id<XAIScanVCDelegate> delegate;


- (IBAction)cancelBtnClick:(id)sender;

@end



@protocol XAIScanVCDelegate <NSObject>

- (void)scanVC:(XAIScanVC*)scanVC didReadSymbols:(ZBarSymbolSet *)symbols;

@end