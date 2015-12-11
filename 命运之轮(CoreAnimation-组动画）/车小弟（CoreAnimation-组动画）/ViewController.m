//
//  ViewController.m
//  车小弟（CoreAnimation-组动画）
//
//  Created by 陈诚 on 15/12/10.
//  Copyright © 2015年 陈诚. All rights reserved.
//

#import "ViewController.h"
#import "OBShapedButton.h"//因为打开了circleImageView的user interface able，之后点击View上面的几个button的话只能监听到最后一个，点击前面两个也只能监听到最后一个,所以引入这么一个封装好了的类，来实现点击任意一个button实现监听，实现原理是改变透明度，具体可以自己点进去查看
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //添加三个扇形按钮
    
    for (int i = 0; i < 3; i ++) {
        //获取按钮图片名字
        NSString *imageName = [NSString stringWithFormat:@"circle%d",i+1];
        
        UIButton *btn = [OBShapedButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.circleImageView.bounds;
        [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.circleImageView addSubview:btn];
    }
    
    //添加中心按钮
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.bounds = CGRectMake(0, 0, 112, 112);
    [centerBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_dealer_had_bind"] forState:UIControlStateNormal];
    centerBtn.center = self.view.center;
    [centerBtn addTarget:self action:@selector(centerBrnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerBtn];
    
}

- (void)centerBrnClicked:(UIButton *)btn
{
    //当前透明度
    CGFloat currentAlpa = self.circleImageView.alpha;
    //1.先实现显示和隐藏
    if (self.circleImageView.alpha == 1) {
        //隐藏
        self.circleImageView.alpha = 0;
    }else{
    //显示
        self.circleImageView.alpha = 1;
    }
    //2创建组动画//透明度 缩放 旋转效果
    CAAnimationGroup *group = [CAAnimationGroup animation];
    //2.1透明度动画(图层的)
    CABasicAnimation *opacityAni = [CABasicAnimation animation];
    opacityAni.keyPath = @"opacity";
    
    //2.2缩放(超过两个值的变化，用CABasicAnimation就不行了)
    CAKeyframeAnimation *scaleAni = [CAKeyframeAnimation animation];
    scaleAni.keyPath = @"transform.scale";
    
    //2.3旋转
    CABasicAnimation *rotationAni = [CABasicAnimation animation];
    rotationAni.keyPath = @"transform.rotation";
    
    //如果由显示到看不见
    if (currentAlpa == 1) {//隐藏
        //透明度
        opacityAni.fromValue = @1;
        opacityAni.toValue = @0;
        //缩放
        scaleAni.values = @[@1,@1.4,@0];
        //旋转 - 原来的位置逆时针旋转了45°
        rotationAni.fromValue = @0;
        rotationAni.toValue = @(-M_PI);
    }else{//显示
        //透明度
        opacityAni.fromValue = @0;
        opacityAni.toValue = @1;
        //缩放
         scaleAni.values = @[@0,@1.4,@1];
        //旋转
        rotationAni.fromValue = @(-M_PI);
        rotationAni.toValue = @0;
    }
    group.animations = @[opacityAni,scaleAni,rotationAni];
    group.duration = 1.5;
    [self.circleImageView.layer addAnimation:group forKey:nil];
}
- (void)btnClicked:(UIButton *)btn
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
