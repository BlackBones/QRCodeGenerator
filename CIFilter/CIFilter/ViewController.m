//
//  ViewController.m
//  CIFilter
//
//  Created by 刘波 on 16/3/11.
//  Copyright © 2016年 Liu Bo. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeGenerator.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)xxxBtn:(id)sender {
    
    [_tf resignFirstResponder];
    
    /**
     *  黑白二维码
     */
//    self.imageView.image = [QRCodeGenerator QRCodeWithContent:_tf.text imageSize:300];
    
    /**
     *  简单自定义颜色
     */
    UIImage *codeImage = [QRCodeGenerator QRCodeWithContent:_tf.text imageSize:300.0 withRed:31.0 andGreen:42.0 andBlue:15.0];
    
    /**
     *  添加头像
     */
    self.imageView.image = [QRCodeGenerator QRCodeImage:codeImage withAvatarImage:[UIImage imageNamed:@"IMG_0559.JPG"]];
    
    //设置阴影
    self.imageView.layer.shadowOffset = CGSizeMake(0, 1);  // 设置阴影的偏移量
    self.imageView.layer.shadowRadius = 1;  // 设置阴影的半径
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
    self.imageView.layer.shadowOpacity = 0.3; // 设置阴影的不透明度
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
