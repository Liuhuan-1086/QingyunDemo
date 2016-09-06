//
//  ViewController.m
//  二维码
//
//  Created by qingyun on 16/8/15.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *preView;
@property (weak, nonatomic) IBOutlet UIImageView *boardView;
@property (weak, nonatomic) IBOutlet UIImageView *animationView;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置UI效果
    UIImage *boardImage = [UIImage imageNamed:@"qrcode_border"];
    //调整为大小可变的图片
    UIImage *reBoardImage = [boardImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 26, 26)];
    self.boardView.image = reBoardImage;
    //添加动画的视图
    [self.boardView addSubview:self.animationView];
    UIImage *animationImage = [UIImage imageNamed:@"qrcode_scanline_qrcode"];
    self.animationView.image = animationImage;
    
    //剪切掉子视图,超出区域
    self.boardView.clipsToBounds = YES;
    
    //创建定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(changeAnimation:) userInfo:nil repeats:YES];
}

- (void)changeAnimation:(NSTimer *)timer {
    self.animationView.frame = CGRectOffset(self.animationView.frame, 0, 2);
    if (self.animationView.frame.origin.y >= self.boardView.frame.size.height) {
        self.animationView.frame = CGRectOffset(self.animationView.bounds, 0, -self.animationView.bounds.size.height);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startReading];
    self.animationView.frame = self.boardView.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRead];
}

//开启二维码
- (void)startReading {
    
    //首先得到device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建input
    NSError *error;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    //创建output
    self.output = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("myQueue",NULL);
    [self.output setMetadataObjectsDelegate:self queue:queue];
    //创建session
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //设置output的选择的输出类型
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    //创建预览layer
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [layer setFrame:self.view.layer.bounds];
    [self.preView.layer addSublayer:layer];
    //开启扫描
    [self.session startRunning];
}

//结束二维码
- (void)stopRead {
    //结束扫描
    [self.session stopRunning];
}

#pragma mark - metadata delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count == 0) return;
    //接收到二维码对象
    AVMetadataMachineReadableCodeObject *code = metadataObjects.firstObject;
    NSLog(@"code:%@", code.stringValue);
    //通知主线程,停止扫描
    [self performSelectorOnMainThread:@selector(stopRead) withObject:nil waitUntilDone:NO];
    [self.timer invalidate];
    SecondViewController *vcSecond = [[SecondViewController alloc] init];
    vcSecond.strCode = code.stringValue;
    [self.navigationController pushViewController:vcSecond animated:YES];
}

@end
