//
//  EDGameScene.m
//  Edgy
//
//  Created by Amit Shah on 2015-05-23.
//  Copyright (c) 2015 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EDGameScene.h"
#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "DelaunayEdge.h"
#import "DelaunayTriangle.h"
#import "VoronoiCell.h"


@interface EDGameScene ()
@property (nonatomic, strong) SKTexture *trianglesTexture;
@property (nonatomic, strong) SKNode *canvasNode;
@property (nonatomic, strong) NSMutableArray* skshapes;
@end

@implementation EDGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
    }
    return self;
}

- (void)setupTriangles
{
    self.canvasNode = [SKNode node];
    self.skshapes =[[NSMutableArray alloc]init];
    [self redrawTriangles];
}

- (void)redrawTriangles
{
    NSDictionary *voronoiCells = [self.triangulation voronoiCells];
    for (VoronoiCell *cell in [voronoiCells objectEnumerator])
    {
        
            NSValue *prevPoint = [cell.nodes lastObject];
            CGPoint p = [prevPoint CGPointValue];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, p.x, p.y);
        
            for ( NSValue *point in cell.nodes)
            {
                CGPoint pp = [point CGPointValue];
                CGPathAddLineToPoint(path,NULL, pp.x, pp.y);
            }
        CGPathCloseSubpath(path);
        SKShapeNode *poly = [SKShapeNode node];
        poly.path = path;
        
        DelaunayPoint *site = cell.site;
        NSArray* lightRay = [[NSArray alloc] initWithObjects:
                             [NSNumber numberWithFloat:(self.triangulation.lightPoint.x - site.x)],
                             [NSNumber numberWithFloat:(self.triangulation.lightPoint.y-site.y)],
                             [NSNumber numberWithFloat:60],
                             nil];
        
        float length = sqrt(pow([lightRay[0] floatValue],2) + pow([lightRay[1] floatValue],2) + pow([lightRay[2] floatValue],2));
        
        float normX = [lightRay[0] floatValue]/length;
        float normY = [lightRay[1] floatValue]/length;
        float normZ =[lightRay[2] floatValue]/length;
        NSArray* normalizeRay= [[NSArray alloc] initWithObjects:
                                [NSNumber numberWithFloat:normX ],
                                [NSNumber numberWithFloat:normY ],
                                [NSNumber numberWithFloat:normZ ],nil];
        
        NSArray* cellNormal = cell.normal;
        
        float illuminance = [cellNormal[0] floatValue]*[normalizeRay[0] floatValue]+
        [cellNormal[1] floatValue]*[normalizeRay[1] floatValue]+
        [cellNormal[2] floatValue]*[normalizeRay[2] floatValue];
        
        
        NSArray* materialAmbientColor = [[NSArray alloc] initWithObjects:
                                         [NSNumber numberWithFloat:1],
                                         [NSNumber numberWithFloat:1],
                                         [NSNumber numberWithFloat:1],
                                         [NSNumber numberWithFloat:1],
                                         nil];
        NSArray* materialDiffuseColor = [[NSArray alloc] initWithObjects:
                                         [NSNumber numberWithFloat:1],
                                         [NSNumber numberWithFloat:1],
                                         [NSNumber numberWithFloat:1],
                                         [NSNumber numberWithFloat:1],
                                         nil];
        NSArray* lightAmbientColor =[[NSArray alloc] initWithObjects:
                                     [NSNumber numberWithFloat:0.06666667014360428],
                                     [NSNumber numberWithFloat:0.06666667014360428],
                                     [NSNumber numberWithFloat:0.13333334028720856],
                                     [NSNumber numberWithFloat:1],
                                     nil];
        NSArray* lightDiffuseColor =[[NSArray alloc] initWithObjects:
                                     [NSNumber numberWithFloat:1],
                                     [NSNumber numberWithFloat:0],
                                     [NSNumber numberWithFloat:0.13333334028720856],
                                     [NSNumber numberWithFloat:1],
                                     nil];
        
        //Ambient Light
        NSArray* materialSlaveRGB = [[NSArray alloc] initWithObjects:
                                     [NSNumber numberWithFloat:[materialAmbientColor[0] floatValue]*[lightAmbientColor[0] floatValue]],
                                     [NSNumber numberWithFloat:[materialAmbientColor[1] floatValue]*[lightAmbientColor[1] floatValue]],
                                     [NSNumber numberWithFloat:[materialAmbientColor[2] floatValue]*[lightAmbientColor[2] floatValue]],
                                     [NSNumber numberWithFloat:[materialAmbientColor[3] floatValue]*[lightAmbientColor[3] floatValue]],
                                     nil];
        
        NSArray* triangleColorInit =[[NSArray alloc] initWithObjects:
                                     [NSNumber numberWithFloat:[materialSlaveRGB[0] floatValue]],
                                     [NSNumber numberWithFloat:[materialSlaveRGB[1] floatValue]],
                                     [NSNumber numberWithFloat:[materialSlaveRGB[2] floatValue]],
                                     [NSNumber numberWithFloat:[materialSlaveRGB[3] floatValue]],
                                     nil];
        
        //Calculate Diffuse Light
        
        NSArray* triangleColor =[[NSArray alloc] initWithObjects:
                                 [NSNumber numberWithFloat:
                                  (illuminance * [materialDiffuseColor[0] floatValue] * [lightDiffuseColor[0] floatValue]) + [triangleColorInit[0] floatValue]],
                                 [NSNumber numberWithFloat:
                                  (illuminance * [materialDiffuseColor[1] floatValue] * [lightDiffuseColor[1] floatValue]) + [triangleColorInit[1] floatValue]],
                                 [NSNumber numberWithFloat:
                                  (illuminance * [materialDiffuseColor[2] floatValue] * [lightDiffuseColor[2] floatValue]) + [triangleColorInit[2] floatValue]],
                                 [NSNumber numberWithFloat:
                                  (illuminance * [materialDiffuseColor[2] floatValue] * [lightDiffuseColor[2] floatValue]) + [triangleColorInit[2] floatValue]],
                                 
                                 nil];
        
        
        
        UIColor * polyFill =[UIColor colorWithRed:[triangleColor[0] floatValue] green:[triangleColor[1] floatValue]blue:[triangleColor[2] floatValue] alpha:1] ;
        poly.fillColor = polyFill;
        poly.strokeColor = polyFill;
        [self.skshapes addObject:poly];
        [self addChild:poly];


    }
//    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//
//    self.delaunayVoronoi = [DelaunayVoronoi voronoiWithPoints:[self randomPointsWithLength:kMaxNumPoints] plotBounds:rect];
//    
//    [self removeAllChildren];
//    for (NSObject* t in self.delaunayVoronoi.triangles){
//        NSLog(@"here");
//    }
//    int count = 0;
//    for (DelaunayEdge *e in self.delaunayVoronoi.edges) {
//        CGMutablePathRef p = CGPathCreateMutable();
//        CGPathMoveToPoint(p, NULL, 0, -260);
//        CGPathAddLineToPoint(p, NULL, 160, 0);
//        CGPathAddLineToPoint(p, NULL, 0, 260);
//        CGPathCloseSubpath(p);
//        SKShapeNode *poly = [SKShapeNode node];
//        poly.path = p;
//        poly.fillColor = [UIColor redColor];
//        [self addChild:poly];
//        count++;
//        SKShapeNode *line = [SKShapeNode node];
//        line.path = [self linePathWithStartPoint:e.delaunayLine.p0 andEndPoint:e.delaunayLine.p1];
//        line.lineWidth = 2;
//        if (count%3==0){
//            [line setStrokeColor:[UIColor whiteColor]];
//        }else if(count%3==1){
//            [line setStrokeColor:[UIColor redColor]];
//        }else if (count%3==2){
//            [line setStrokeColor:[UIColor blueColor]];
//            
//        }
//        [line setFillColor:[UIColor greenColor]];
//        [self addChild:line];
//    }
}

- (void)updatePosition {
    time_t now = (time_t) [[NSDate date] timeIntervalSince1970];
    
    DelaunayPoint *newPoint =  [DelaunayPoint pointAtX:400*sin(now)
                                                  andY:300*cos(now)];
    _triangulation.lightPoint = newPoint;
   
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    DelaunayPoint *newPoint =  [DelaunayPoint pointAtX:_triangulation.lightPoint.x+100*sin(currentTime*0.01)
                                                  andY:_triangulation.lightPoint.y];
    _triangulation.lightPoint = newPoint;
    
    for(SKShapeNode * shape in self.skshapes){
        
//        shape.fillColor = [UIColor colorWithRed:(arc4random() / (float)0x100000000) green:(arc4random() / (float)0x100000000) blue:(arc4random() / (float)0x100000000) alpha:0.9];
        NSLog(@"update called");
    }
    
    
    
}

@end
