//
//  EDDiagnosticView.m
//  Edgy
//
//  Created by Mike Rotondo on 6/18/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "EDDiagnosticView.h"
#import "DelaunayTriangulation.h"
#import "DelaunayPoint.h"
#import "DelaunayEdge.h"
#import "DelaunayTriangle.h"
#import "VoronoiCell.h"

@implementation EDDiagnosticView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    for (DelaunayTriangle *triangle in self.triangulation.triangles)
//    {
//        if ([triangle inFrameTriangleOfTriangulation:self.triangulation])
//            continue;
//        
////        [triangle.color set];
//        [[UIColor whiteColor] set];
//        [[UIColor blackColor] setStroke];
//        [triangle drawInContext:ctx];
//        CGContextDrawPath(ctx, kCGPathFillStroke);
//        //CGContextStrokePath(ctx);
//        
//    }
//
//    // Draw circumcenters & circumcircles
//    for (DelaunayTriangle *triangle in self.triangulation.triangles)
//    {
//        // Don't draw Delaunay triangles that include the frame edges
//        //        if ([triangle inFrameTriangleOfTriangulation:self.triangulation])
//        //            continue;
//        
//        [[UIColor redColor] set];
//        CGPoint circumcenter = [triangle circumcenter];
//        CGContextMoveToPoint(ctx, circumcenter.x + 10, circumcenter.y);
//        CGContextAddArc(ctx, circumcenter.x, circumcenter.y, 10, 0, 2 * M_PI, 0);
//        CGContextFillPath(ctx);
//        
//        DelaunayPoint *p = [triangle startPoint];
//        float bigradius = sqrtf(powf(p.x - circumcenter.x, 2) + powf(p.y - circumcenter.y, 2));
//        CGContextMoveToPoint(ctx, circumcenter.x + bigradius, circumcenter.y);
//        CGContextAddArc(ctx, circumcenter.x, circumcenter.y, bigradius, 0, 2 * M_PI, 0);
//        CGContextStrokePath(ctx);
//    }
    
    //Draw the voronoi cells
    NSDictionary *voronoiCells = [self.triangulation voronoiCells];
    for (VoronoiCell *cell in [voronoiCells objectEnumerator])
    {
        
        [cell drawInContext:ctx];
        if (cell.site.color)
        {
            [cell.site.color set];
            CGContextDrawPath(ctx, kCGPathFill);
        }
        else
        {
//            // Reset Triangle Color
//            FSS.Vector4.set(triangle.color.rgba);
//            
//            // Iterate through Lights
//            for (l = lights.length - 1; l >= 0; l--) {
//                light = lights[l];
//                
//                // Calculate Illuminance
//                FSS.Vector3.subtractVectors(light.ray, light.position, triangle.centroid);
//                FSS.Vector3.normalise(light.ray);
//                illuminance = FSS.Vector3.dot(triangle.normal, light.ray);
//                if (this.side === FSS.FRONT) {
//                    illuminance = Math.max(illuminance, 0);
//                } else if (this.side === FSS.BACK) {
//                    illuminance = Math.abs(Math.min(illuminance, 0));
//                } else if (this.side === FSS.DOUBLE) {
//                    illuminance = Math.max(Math.abs(illuminance), 0);
//                }
//                
//                // Calculate Ambient Light
//                FSS.Vector4.multiplyVectors(this.material.slave.rgba, this.material.ambient.rgba, light.ambient.rgba);
//                FSS.Vector4.add(triangle.color.rgba, this.material.slave.rgba);
//                
//                // Calculate Diffuse Light
//                FSS.Vector4.multiplyVectors(this.material.slave.rgba, this.material.diffuse.rgba, light.diffuse.rgba);
//                FSS.Vector4.multiplyScalar(this.material.slave.rgba, illuminance);
//                FSS.Vector4.add(triangle.color.rgba, this.material.slave.rgba);
//            }
//            
//            // Clamp & Format Color
//            FSS.Vector4.clamp(triangle.color.rgba, 0, 1);
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
            
           
            [[UIColor colorWithRed:[triangleColor[0] floatValue] green:[triangleColor[1] floatValue]blue:[triangleColor[2] floatValue] alpha:1] set];
            CGContextDrawPath(ctx, kCGPathFill);
            //kCGPathStroke);
//            [[UIColor colorWithRed:(arc4random() / (float)0x100000000) green:(arc4random() / (float)0x100000000) blue:(arc4random() / (float)0x100000000) alpha:0.9] set];
//            CGContextDrawPath(ctx, kCGPathFill);//kCGPathStroke);
            
        }
    }
}


@end
