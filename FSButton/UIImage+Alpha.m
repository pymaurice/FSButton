//
//  UIImage+Transparent.m
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

#import "UIImage+Alpha.h"

@implementation UIImage (Alpha)

-(int)alphaValueAt:(CGPoint)point{
    CGImageRef img = [self CGImage];
    
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(img);
    
    if(alpha == kCGImageAlphaNone || alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast){
        //No alpha channel : no transparency
        return NO;
    }
    
    //First, test if point is eligible
    if(!CGRectContainsPoint([self imageRect], point)){
        return NO;
    }
    
    //Init
    size_t bytesPerRow = CGImageGetBytesPerRow(img);
    
    size_t bitsPerPixel = CGImageGetBitsPerPixel(img);
    size_t bytesPerPixel = CGImageGetBitsPerPixel(img)/8;
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(img);
    size_t bytesPerComponent = CGImageGetBitsPerComponent(img)/8;
    size_t components = bitsPerPixel / bitsPerComponent;
    
    //Looking for pixel
    int pixel = 0;
    
    NSRange range;
    
    int pixelOffsetBytes = trunc(point.y) * bytesPerRow + trunc(point.x) * bytesPerPixel;
  
    //Decode alpha channel
    switch(alpha){
        case kCGImageAlphaPremultipliedLast:
        case kCGImageAlphaLast:
            range = NSMakeRange(pixelOffsetBytes + bytesPerComponent*(components-1), bitsPerPixel/components);
            break;
        case kCGImageAlphaPremultipliedFirst:
        case kCGImageAlphaFirst:
            range = NSMakeRange(pixelOffsetBytes, bitsPerPixel/components);
            break;
        default:
            break;
    }
    
    NSData *data = (__bridge NSData *)CGDataProviderCopyData(CGImageGetDataProvider(img));
    
    //Extract alpha channel value
    [data getBytes:&pixel range:range];
    
    
    CFRelease((__bridge CFDataRef)data);
    
    return pixel;
    
}


-(CGRect)imageRect{
    return CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
}


@end
