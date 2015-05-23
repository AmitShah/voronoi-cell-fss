//
//  VoronoiCellSprite.h
//  Edgy
//
//  Created by Amit Shah on 2015-05-23.
//  Copyright (c) 2015 Stanford. All rights reserved.
//


//
//  VoronoiCell.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/21/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "VoronoiCell.h"

@interface VoronoiCellSprite : NSObject {
    
    VoronoiCell *cell;
    SKShapeNode *polyPath;
    
}

@property (nonatomic, strong) VoronoiCell *cell;
@property (nonatomic, strong) SKShapeNode *polyPath;

- (void)updateFill:(DelaunayPoint*)lightRay;

@end
