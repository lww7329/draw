//
//  ViewController.m
//  myProject
//
//  Created by 刘伟伟 on 2018/11/28.
//  Copyright © 2018年 com.jrgc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIView *picView;
@property(nonatomic,strong)UIButton *startButton;
@property(nonatomic,strong)UIButton *stopButton;
@property(nonatomic,assign)int count;
@property(nonatomic,strong)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[NSDate date]);
    self.count=50;
    [self setupUI];
}
-(void)setupUI{
    [self.view addSubview:self.picView];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.stopButton];
    [self initPicView];
}

-(void)initPicView{
    CGFloat w=self.picView.frame.size.width/5;
    CGFloat h=self.picView.frame.size.height/10;
    for(int i=0;i<self.count;i++){
        UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(i%5*w, i/5*h, w, h)];
        view.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d",i%17+1]];
        view.userInteractionEnabled = YES;
        UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(0, h-20, w, 20)];
        lable.text=[NSString stringWithFormat:@"TAG-%d",i];
        lable.font=[UIFont boldSystemFontOfSize:13];
        lable.textAlignment=NSTextAlignmentRight;
        lable.textColor=[self randomColor];
        [view addSubview:lable];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePic:)];
        [view addGestureRecognizer:tapGesture];
        view.tag=10000+i;
        [self.picView addSubview:view];
    }
}

-(void)removePic:(UIGestureRecognizer *)gest{
    int tag=(int)gest.view.tag;
    [[self.picView viewWithTag:tag] removeFromSuperview];
    self.count--;
    [self sportPic];
}

-(UIColor*)randomColor{
    CGFloat hue = (arc4random() %256/256.0);
    CGFloat saturation = (arc4random() %128/256.0) +0.5;
    CGFloat brightness = (arc4random() %128/256.0) +0.5;
    UIColor*color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

-(void)sportPic{
    NSArray* randomArray=[self randomArray];
    CGFloat w=self.picView.frame.size.width/5;
    CGFloat h=self.picView.frame.size.height/10;
    for(int i=0;i<self.count;i++){
        UIView *view=[self.picView.subviews objectAtIndex:i];
        [UIView animateWithDuration:0.03 animations:^{
            int r=[[randomArray objectAtIndex:i] intValue];
            view.frame=CGRectMake(r%5*w, r/5*h, w, h);
        } completion:^(BOOL finished) {
            
        }];
    }
}


-(NSArray *)randomArray
{
    //随机数从这里边产生
    NSMutableArray *startArray=[[NSMutableArray alloc] init];
    for(int i=0;i<self.count;i++){
        [startArray addObject:@(i)];
    }
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
//    NSInteger m=8;
    for (int i=0; i<self.count; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}

-(void)start{
    [self.timer invalidate];
    self.timer=nil;
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.08 target:self selector:@selector(sportPic) userInfo:nil repeats:YES];
}
-(void)stop{
    [self.timer invalidate];
    self.timer=nil;
    for(int i=0;i<self.picView.subviews.count;i++){
        UIImageView *view=[self.picView.subviews objectAtIndex:i];
        if(view.frame.origin.x==0 && view.frame.origin.y==0){
            UILabel *label=[view.subviews objectAtIndex:0];
            UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"恭喜" message:label.text preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [controller addAction:action];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}
-(UIView *)picView{
    if(_picView==nil){
        _picView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    }
    return _picView;
}

-(UIButton *)startButton{
    if(_startButton==nil){
        _startButton=[[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width/2, 50)];
        [_startButton setTitle:@"Start" forState:UIControlStateNormal];
        [_startButton setBackgroundColor:[UIColor greenColor]];
        [_startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}
-(UIButton *)stopButton{
    if(_stopButton==nil){
        _stopButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height-50, self.view.frame.size.width/2, 50)];
        [_stopButton setTitle:@"Stop" forState:UIControlStateNormal];
        [_stopButton setBackgroundColor:[UIColor redColor]];
        [_stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}
@end
