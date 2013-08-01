#import "SerialImageDecompressor.h"

@implementation SerialImageDecompressor {
    NSOperationQueue *_queue;
}

- (id)init {
    self = [super init];
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 1;
    return self;
}

- (void)postImageForDecompression:(UIImage *)image context:(id)context {
    [_queue addOperationWithBlock:^{
        
        UIImage *decompressedImage = [SerialImageDecompressor decompressImage:image];
        
        CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopDefaultMode, ^ {
            [self.delegate decompressor:self didDecompressImage:decompressedImage context:context];
            
        });
    }];
}

- (void)cancelOperations {
    [_queue cancelAllOperations];
}

+ (UIImage *)decompressImage:(UIImage *)image {
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), CGImageGetBitsPerComponent(imageRef), CGImageGetWidth(imageRef) * 4, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
    
    CGContextDrawImage(bitmapContext, CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)), imageRef);
    
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(bitmapContext);
    
    UIImage *decompressedImage = [[UIImage alloc] initWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(decompressedImageRef);
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    
    return decompressedImage;
}

@end
