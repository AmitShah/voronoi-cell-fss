//
//  VoronoiCell.m
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/21/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "VoronoiCell.h"
#import "DelaunayPoint.h"

@implementation VoronoiCell
@synthesize site;
@synthesize nodes;

+ (VoronoiCell *)voronoiCellAtSite:(DelaunayPoint *)site withNodes:(NSArray *)nodes
{
    VoronoiCell *cell = [[self alloc] init];
    
    cell.site = site;
    cell.nodes = nodes;
    
    return cell;
}


- (void)drawInContext:(CGContextRef)ctx
{
    NSValue *prevPoint = [self.nodes lastObject];
    CGPoint p = [prevPoint CGPointValue];
    CGContextMoveToPoint(ctx, p.x, p.y);
    for ( NSValue *point in self.nodes)
    {
        CGPoint p = [point CGPointValue];
        CGContextAddLineToPoint(ctx, p.x, p.y);        
    }
}

- (float)area
{
    float xys = 0.0;
    float yxs = 0.0;
    
    NSValue *prevPoint = [self.nodes objectAtIndex:0];
    CGPoint prevP = [prevPoint CGPointValue];
    for ( NSValue *point in [self.nodes reverseObjectEnumerator])
    {
        CGPoint p = [point CGPointValue];
        xys += prevP.x * p.y;
        yxs += prevP.y * p.x;
        prevP = p;
    }
    
    return (xys - yxs) * 0.5;
}

- (NSArray*) normal
{
    // illuminance = FSS.Vector3.dot(triangle.normal, light.ray);
    
//    FSS.Vector3.subtractVectors(this.u, this.b.position, this.a.position);
//    FSS.Vector3.subtractVectors(this.v, this.c.position, this.a.position);
//    FSS.Vector3.crossVectors(this.normal, this.u, this.v);
//    FSS.Vector3.normalise(this.normal);
//    return this;
//crossVectors: function(target, a, b) {
//    target[0] = a[1]*b[2] - a[2]*b[1];
//    target[1] = a[2]*b[0] - a[0]*b[2];
//    target[2] = a[0]*b[1] - a[1]*b[0];
//    return this;
//},
//subtractVectors: function(target, a, b) {
//    target[0] = a[0] - b[0];
//    target[1] = a[1] - b[1];
//    target[2] = a[2] - b[2];
//    return this;
//},
    
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithInteger:0],
            [NSNumber numberWithInteger:0],
            [NSNumber numberWithInteger:1], nil];
    float xys = 0.0;
    float yxs = 0.0;
    
    NSValue *prevPoint = [self.nodes objectAtIndex:0];
    CGPoint prevP = [prevPoint CGPointValue];
    for ( NSValue *point in [self.nodes reverseObjectEnumerator])
    {
        CGPoint p = [point CGPointValue];
        xys += prevP.x * p.y;
        yxs += prevP.y * p.x;
        prevP = p;
    }
    float length = sqrt(pow(xys,2) + pow(yxs,2));
    
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:xys/length],[NSNumber numberWithFloat:yxs/length],nil];
}


@end
