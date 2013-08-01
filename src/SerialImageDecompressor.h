#import <Foundation/Foundation.h>

@protocol SerialImageDecompressorDelegate;

@interface SerialImageDecompressor : NSObject

@property (nonatomic, weak) id <SerialImageDecompressorDelegate> delegate;

@property (atomic) BOOL wakeUpMainThread; // YES

- (void)postImageForDecompression:(UIImage *)image context:(id)context;
- (void)cancelOperations;

+ (UIImage *)decompressImage:(UIImage *)image;

@end

@protocol SerialImageDecompressorDelegate <NSObject>

- (void)decompressor:(SerialImageDecompressor *)decompressor didDecompressImage:(UIImage *)image context:(id)context;

@end