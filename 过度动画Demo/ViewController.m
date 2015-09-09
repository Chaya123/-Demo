//
//  ViewController.m
//  过度动画Demo
//
//  Created by vera on 15/8/6.
//  Copyright (c) 2015年 vera. All rights reserved.
//

#import "ViewController.h"
#import "CATransitionView.h"

@interface ViewController ()
{
    NSInteger index;
    NSTimer *timer;
}

@property (nonatomic, strong) CATransitionView *transitionView;

@property(nonatomic,strong)CATransition *transition;

@end

@implementation ViewController

- (CATransition *)transition
{
    if (!_transition) {
        //过渡动画
        _transition = [CATransition animation];
        //设置类型
        _transition.type = @"cube";
        //动画时间
        _transition.duration = 2;
    }
    return _transition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    index = 1;
    
    
    [self.view addSubview:self.transitionView];
    [self addSwipeGestureRecognizer];
    
    [self createTimer];
}

- (void)createTimer
{
    self.transition.subtype = kCATransitionFromRight;
    timer =  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoSwip) userInfo:nil repeats:YES];
    

}

- (void)autoSwip
{
   
   index = index > 7 ? 1:++index;
    //添加动画到层
    [_transitionView.layer addAnimation:self.transition forKey:nil];
    
    NSLog(@"index = %ld",(long)index);
    
    //修改图片
    _transitionView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",index]];
    //self performSelector:<#(SEL)#> withObject:<#(id)#> afterDelay:<#(NSTimeInterval)#>
}

/**
 手势事件处理
 */
- (void)swipe:(UISwipeGestureRecognizer *)gesture
{
    [timer invalidate];
    timer = nil;
 
    //判断方向
    //向右滑
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        index = index < 2 ? 8:--index;
        //子类型
        self.transition.subtype =  kCATransitionFromLeft;
         NSLog(@"index = %ld",(long)index);
    }
    else
    {
        index = index > 7 ? 1:++index;
        
        self.transition.subtype =  kCATransitionFromRight;
         NSLog(@"index = %ld",(long)index);
    }
    
    //添加动画到层
    [_transitionView.layer addAnimation:self.transition forKey:nil];
    
    //修改图片
    _transitionView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",index]];
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createTimer];
        });
        
        
        return;
    }
    
    
}

//添加轻扫手势
- (void)addSwipeGestureRecognizer
{
    UISwipeGestureRecognizer *swipeForLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    //方向
    swipeForLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_transitionView addGestureRecognizer:swipeForLeft];
    
    UISwipeGestureRecognizer *swipeForRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeForRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_transitionView addGestureRecognizer:swipeForRight];
}

//返回transitionView
- (CATransitionView *)transitionView
{
    if (!_transitionView)
    {
        _transitionView = [[CATransitionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
        _transitionView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",index]];
        _transitionView.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    return _transitionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
