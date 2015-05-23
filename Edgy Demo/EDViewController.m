//
//  EDViewController.m
//  Edgy Demo
//
//  Created by Mike Rotondo on 6/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//
#import "EDGameScene.h"
#import "EDViewController.h"
#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "EDDiagnosticView.h"
#import <UIKit/UIKit.h>


@interface EDViewController ()

@end

@implementation EDViewController
{
    //IBOutlet EDDiagnosticView *_diagnosticView;
    EDGameScene * scene;
    DelaunayTriangulation *_triangulation;
    NSTimeInterval _touchTimeThreshold;
    NSDate *_lastTouchTime;
    UIColor *_currentColor;
    time_t start;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _touchTimeThreshold = 0.05;
    _lastTouchTime = [NSDate distantPast];
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    scene = [EDGameScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [self reset];
    // Present the scene.
    [skView presentScene:scene];
    
    [scene setupTriangles];
    
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)reset
{
    CGRect triangulationRect = CGRectInset(self.view.bounds, 0, 0);
    _triangulation = [DelaunayTriangulation triangulationWithRect:triangulationRect];
    scene.triangulation = _triangulation;
    
    DelaunayPoint *seedPoint = [DelaunayPoint pointAtX:1 andY:1];
    [_triangulation addPoint:seedPoint withColor:nil];

    for (int i = 0; i < 100; i++)
    {
        CGPoint loc = CGPointMake(self.view.bounds.size.width * (arc4random() / (float)0x100000000),
                                  self.view.bounds.size.height * (arc4random() / (float)0x100000000));
        DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
        [_triangulation addPoint:newPoint withColor:nil];
    }
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = (UITouch *)[touches anyObject];
//    CGPoint loc = [touch locationInView:self.view];
//    DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
//    _triangulation.lightPoint = newPoint;
//    [_diagnosticView setNeedsDisplay];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([[NSDate date] timeIntervalSinceDate:_lastTouchTime] < _touchTimeThreshold)
//    {
//        return;
//    }
//    else
//    {
//        _lastTouchTime = [NSDate date];
//    }
//    
//    UITouch *touch = (UITouch *)[touches anyObject];
//    CGPoint loc = [touch locationInView:self.view];
//    DelaunayPoint *newPoint = [DelaunayPoint pointAtX:loc.x andY:loc.y];
////    newPoint.color = _currentColor;
////    [_triangulation addPoint:newPoint withColor:nil];
//    _triangulation.lightPoint = newPoint;
//    [_diagnosticView setNeedsDisplay];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
