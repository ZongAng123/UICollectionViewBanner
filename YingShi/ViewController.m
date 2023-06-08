//
//  ViewController.m
//  YingShi
//
//  Created by 纵昂 on 2023/6/6.
//

#import "ViewController.h"
#import "YYCell.h"
#import "YYNews.h"

#define  YYIDCell @"cell"
#define YYMaxSections 100

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic , strong) NSMutableArray *newses;
@property (nonatomic , strong) NSTimer *timer;

@end

@implementation ViewController

-(NSArray *)newses{
    if (_newses == nil) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path =[bundle pathForResource:@"resource.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        
        _newses=[NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            [_newses addObject: [YYNews newsWithDict:dict]];
        }
        
    }
    
    return  _newses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    [self initView];
}

- (void)initView{
//    [super initView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 200);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 200) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor redColor];
    [self.view addSubview:collectionView];
    
    _collectionView=collectionView;
    
    [self.collectionView registerClass:[YYCell class] forCellWithReuseIdentifier:YYIDCell];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:YYMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.center = CGPointMake(SCREEN_WIDTH*0.5, 160+60);
    pageControl.bounds = CGRectMake(0, 0, 150, 40);
    pageControl.pageIndicatorTintColor = [UIColor greenColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    pageControl.enabled = NO;
    pageControl.numberOfPages = _newses.count;
    
    [self.view addSubview:pageControl];
    
    _pageControl=pageControl;
    
    
//    [self addTimer];
    
}

#pragma mark 添加定时器
//-(void) addTimer{
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//    self.timer = timer ;
//
//}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self nextpage];
}

#pragma mark 删除定时器
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void) nextpage{
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:YYMaxSections/2];
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.newses.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];

    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return YYMaxSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.newses.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YYCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YYIDCell forIndexPath:indexPath];
    if(!cell){
        cell = [[YYCell alloc] init];
    }
    cell.news=self.newses[indexPath.item];
    return cell;
}


-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    [self addTimer];
    
}

#pragma mark 设置页码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.newses.count;
    self.pageControl.currentPage =page;
}

-(NSString *)controllerTitle{
    return @"无限轮播";
}

@end
