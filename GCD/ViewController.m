//
//  ViewController.m
//  GCD
//
//  Created by mac on 2017/3/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic ,strong) NSMutableArray *arr;
@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self asyncChuan];
    
    
}
#pragma mark- 同步 + 并发 ：不会开线程，串行执行
-(void)syncBin{
      NSLog(@"----%@",[NSThread currentThread] );
    //1,创建队列
    /*参数1，C语言的字符串，标签
     参数2，队列类型
     DISPATCH_QUEUE_CONCURRENT 并发
     DISPATCH_QUEUE_SERIAL 串行
     */
//    dispatch_queue_t queue = dispatch_queue_create("fff", DISPATCH_QUEUE_CONCURRENT);
    //获得全局并发队列，参数1，优先级
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"start");
    //2,同步函数把任务添加到队列
    dispatch_sync(queue, ^{
        NSLog(@"download1---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3---%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}
#pragma mark- 异步 + 并发 ：会开多条线程，队列任务异步执行
-(void)asyncBin {
    NSLog(@"----%@",[NSThread currentThread] );
    //1,获取并发队列，
     dispatch_queue_t queue = dispatch_queue_create("fff", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"start");
    //2,异步函数把任务添加到队列
    dispatch_async(queue, ^{
        NSLog(@"download1---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download2---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download3---%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}
//**************************
#pragma mark- 同步 + 串行 ：不会开线程，串行执行
-(void)syncChuan{
    NSLog(@"----%@",[NSThread currentThread] );
    //1,获取并发队列，
    dispatch_queue_t queue = dispatch_queue_create("fff", DISPATCH_QUEUE_SERIAL);
    NSLog(@"start");
    //2,同步函数把任务添加到队列
    dispatch_sync(queue, ^{
        NSLog(@"download1---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3---%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}
#pragma mark- 异步 + 串行 ：会开一条线程，串行执行
-(void)asyncChuan {
    NSLog(@"----%@",[NSThread currentThread] );
    //1,获取并发队列，
  dispatch_queue_t queue = dispatch_queue_create("fff", DISPATCH_QUEUE_SERIAL);
    NSLog(@"start");
    //2,异步函数把任务添加到队列
    dispatch_async(queue, ^{
        NSLog(@"download1---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download2---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download3---%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}
//*************************
/*
 主队列：只要队列中有任务，就会安排任务到主线程中执行。
 但是如若主队列发现主线程在执行任务，那么主队列会暂停调度队列中的任务，直到主线程空闲为止。
 同步函数：要求立马执行，我要是不执行，大家都别想执行。
 所以当主线程中执行同步函数,并且这个同步函数的任务又是添加到了主队列时，主线程执行同步函数，主队列则等着把同步函数的第一个任务交给主线程执行，产生死锁。
 */
#pragma mark- 同步 + 主线程 ：死锁
-(void)syncMain {
    NSLog(@"----%@",[NSThread currentThread] );
    //1,获取并发队列，
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"start");
    //2,同步函数把任务添加到队列
    dispatch_sync(queue, ^{
        NSLog(@"download1---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3---%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}
#pragma mark- 异步 + 主线程：所有任务都在主线程中进行，不会开线程
-(void)asyncMain {
    NSLog(@"----%@",[NSThread currentThread] );
    //1,获取并发队列，
    dispatch_queue_t queue = dispatch_get_main_queue();
    NSLog(@"start");
    //2,异步函数把任务添加到队列
    dispatch_async(queue, ^{
        NSLog(@"download1---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download2---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download3---%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}
//*********************
/*
 同步和异步：
 同步：嚣张跋扈，立刻马上执行，如果我没执行完，大家都别执行
 异步：谦虚礼让，我没有执行，其他人可以执行
 */
#pragma mark- 同步 + 并发 ：不会开线程，任务串行执行
-(void)syncCurrent {
      NSLog(@"----%@",[NSThread currentThread] );
    //1,获取并发队列，
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"start");
    //2,同步函数把任务添加到队列
    dispatch_sync(queue, ^{
        NSLog(@"download1---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download2---%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"download3---%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}
#pragma mark- 异步 + 并发 ：开多条线程，队列任务并发执行
-(void)asyncCurrent {
      NSLog(@"----%@",[NSThread currentThread] );
    //1,获取并发队列，
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    NSLog(@"start");
    //2,异步函数把任务添加到队列
    dispatch_async(queue, ^{
        NSLog(@"download1---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download2---%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"download3---%@",[NSThread currentThread]);
    });
    NSLog(@"end");
}
#pragma mark-下载图片
-(void)downLoad {
    /*
     1.创建子线程下载图片
     */
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //1,确定url
        NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490442169210&di=f1fce36b60c73a6eb7cae4eb9fe733dd&imgtype=0&src=http%3A%2F%2Fimg15.3lian.com%2F2015%2Ff1%2F191%2Fd%2F24.jpg"];
        
        //2,下载二进制数据到本地
        NSData *data = [NSData dataWithContentsOfURL:url];
        //转图片
        UIImage *image= [UIImage imageWithData:data];
        NSLog(@"程序执行---%@",[NSThread currentThread] );
        //3,更新UI
        //这里可以使用同步函数更新，也可以使用异步函数，因为本程序在子线程执行，同步函数在子线程执行不会死锁，在主线程会死锁
        //         dispatch_async异步函数
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            self.imageView.image = image;
        //            NSLog(@"--%@",[NSThread currentThread] );
        //
        //        });
        
        //dispatch_sync同步函数，
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"下载图片--%@",[NSThread currentThread] );
            
        });
        
    });

}
#pragma mark- 延迟
- (void)delay {
    NSLog(@"%@--延迟",[NSThread currentThread]);
    //GCD 延迟
    //获取主队列
    //dispatch_queue_t queue= dispatch_get_main_queue();
    //并发队列
    /*
     参数1，DISPATCH_TIME_NOW 从现在开始计算时间
     参数2，延迟的时间，2秒，GCD的时间单位是纳秒
     参数3，队列，当queue为主线程的时候，GCD的block在主线程执行，为并发队列的时候，在子线程执行。
     */
    dispatch_queue_t queue= dispatch_get_global_queue(0, 0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"%@--延迟",[NSThread currentThread]);
    });
}
#pragma mark - 一次性
- (void)once {
    //一次性：整个应用中只会调用一次
    /*onceToken被static修饰。
     凡是用static修饰的都是全局变量，代表整个应用程序的生命周期。
     当声明了onceToken这个变量，会在内存分配一块空间，用来保存onceToken这个变量。
     这个变量永远不会被释放，只有程序结束，才会释放。
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    NSLog(@"%@--一次性",[NSThread currentThread]);
        
    });
    //注意：一次性代码不能放在懒加载里
    //懒加载也是只执行一次
}
-(NSMutableArray *)arr {
    NSLog(@"ff");
    if (!_arr) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSLog(@"%@--一次性",[NSThread currentThread]);
//            self.arr = [NSMutableArray array];
            
          
             self.arr = [@[@"335" , @"553335"] mutableCopy];
            NSLog(@"^^^^^%@", _arr);
            
        });
    }
    return _arr;
}
@end
