//
//  EDGameScene.h
//  Edgy
//
//  Created by Amit Shah on 2015-05-22.
//  Copyright (c) 2015 Stanford. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>
#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "DelaunayEdge.h"
#import "DelaunayTriangle.h"
#import "VoronoiCell.h"

@class EDGameScene;

@interface EDGameScene : SKScene

@property (nonatomic, strong) DelaunayTriangulation *triangulation;

- (void)setupTriangles;

- (void)updatePosition;

@end

