//
//  FSButton.m
//  FSButtonDemo
//
//  Created by PYM on 16/10/13.
//
//  Copyright (c) 2013 Pierre-Yves Maurice
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "FSButton.h"
#import "UIImage+Alpha.h"

@interface FSButton(){
    CGPoint lastPoint;
    BOOL lastPointIsTransparent;
}
@end

@implementation FSButton

@synthesize tolerance, shouldAlwaysRespondWhenLastResponder;

-(id)init{
    self = [super init];
    if(self){
        self.shouldAlwaysRespondWhenLastResponder = NO;
        self.tolerance = kDefaultTolerance;
        lastPointIsTransparent = NO;
        lastPoint = CGPointMake(-1, -1);
    }
    return self;
}

-(id)initWithTolerance:(float)maxTolerance{
    self = [super init];
    if(self){
        self.shouldAlwaysRespondWhenLastResponder = NO;
        self.tolerance = maxTolerance;
        lastPointIsTransparent = NO;
        lastPoint = CGPointMake(-1, -1);
    }
    return self;
}
//This method returns a boolean if the receiver (i.e. this button) contains the point in parameter
//If the method returns YES, all the underlying objects are tested
//If the method returns NO, nothing happens
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    BOOL inside = [super pointInside:point withEvent:event];
    BOOL transparent = NO;
    
    //If we are outside the bounds of the button, we don't do anything
    if(inside && self.imageView && self.imageView.image){
        
        //If there is no more potential responder and the button is configured to always respond : return YES
        if(![self nextResponder] && self.shouldAlwaysRespondWhenLastResponder){
            return YES;
        }
        else{
            //Simple optimization : this method is called multiple time for each touch (touchStart, touchEnd I guess...)
            if(lastPoint.x >=0 && lastPoint.y >= 0 && CGPointEqualToPoint(point, lastPoint)){
                transparent = lastPointIsTransparent;
            }
            else{
                //Find the value of alpha channel for the pixel selected
                int alpha = [self.imageView.image alphaValueAt:point];
               
                transparent = (alpha <= self.tolerance);
                
                //Save the value and the coordinate to prevent useless calculation is the method is called for the same point
                lastPoint = point;
                lastPointIsTransparent = transparent;
            }
        }
    }
    
    return !transparent;
    
}

@end
