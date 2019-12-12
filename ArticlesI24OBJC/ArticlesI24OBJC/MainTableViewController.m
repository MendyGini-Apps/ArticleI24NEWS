//
//  MainTableViewController.m
//  ArticlesI24OBJC
//
//  Created by Menahem Barouk on 12/12/2019.
//  Copyright © 2019 Gini-Apps. All rights reserved.
//

#import "MainTableViewController.h"
#import "Article.h"
#import "ArticlesI24OBJC-Swift.h"

@interface MainTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *showArticlesButton;
@property (weak, nonatomic) IBOutlet UISwitch* arabicSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl* localeControls;
@property (weak, nonatomic) IBOutlet UIStepper* indexStepper;
@property (weak, nonatomic) IBOutlet UILabel* indexLabel;

@property (nonatomic) NSArray<Article *> *enArticles;
@property (nonatomic) NSArray<Article *> *arArticles;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.arabicSwitch sendActionsForControlEvents:UIControlEventValueChanged];
    [self.localeControls sendActionsForControlEvents:UIControlEventValueChanged];
    [self.indexStepper sendActionsForControlEvents:UIControlEventValueChanged];
    [self fetchArticles];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)fetchArticles
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *articleENURL = [NSBundle.mainBundle URLForResource:@"articlesEN" withExtension:@"json"];
        NSData *data = [NSData dataWithContentsOfURL:articleENURL options:NSDataReadingMappedIfSafe error:nil];
        NSArray *articlesENArr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.enArticles = [Article objectsWithDictionaries:articlesENArr];
        
        
        NSURL *articleARURL = [NSBundle.mainBundle URLForResource:@"articlesAR" withExtension:@"json"];
        data = [NSData dataWithContentsOfURL:articleARURL options:NSDataReadingMappedIfSafe error:nil];
        NSArray *articleArARURL = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.arArticles = [Article objectsWithDictionaries:articleArARURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showArticlesButton.enabled = YES;
        });
    });
}

- (IBAction)arabicSwitchValueChanged:(UISwitch *)sender
{
    [VersionManager.sharedInstance updateLanguage:sender.isOn ? VersionManagerLanguageAr : VersionManagerLanguageEn];
}

- (IBAction)localeControlsValueChanged:(UISegmentedControl *)sender
{
    
}

- (IBAction)indexStepperValueChanged:(UIStepper *)sender
{
    self.indexLabel.text = [NSString stringWithFormat:@"Indexed at: %ld", (long)sender.value];
}

- (IBAction)showArticlesAction:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Articles" bundle:nil];
    ArticlesPageViewController *articlesPageViewController = [storyboard instantiateInitialViewController];
    [articlesPageViewController bindData:VersionManager.sharedInstance.isArabic ? self.arArticles : self.enArticles at:(NSInteger)self.indexStepper.value];
    [self showViewController:articlesPageViewController sender:self];
}

@end
