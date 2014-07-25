//
//  RestKitHelper.h
//  TestRestKit
//
//  Created by Michael on 13-2-16.
//  Copyright (c) 2013年 Michael. All rights reserved.
//

#import "RestKit/RestKit.h"
#import <Foundation/Foundation.h>


@interface RestKitHelper : NSObject

+(void)getObjectOfClass:(Class )cls
          AtPath:(NSString *)url
         success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
         failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+(RKObjectMapping *)getObjectMapping:(Class )cls;
+(RKObjectMapping *)getPostObjectMapping:(Class )cls;
+(void)postObject:(id)obj
           AtPath:(NSString *)url
          success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
          failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+(void)deleteObject:(id)obj
           AtPath:(NSString *)url
          success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
          failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+(void)uploadWithFileData:(NSData *)data
                     path:(NSString *)path
                     name:(NSString *)name
                 fileName:(NSString *)fileName
                 mimeType:(NSString *)mimeType
                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

+(void)postObject:(id)obj
 withResponseType:(Class )cls
           AtPath:(NSString *)path
          success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
          failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;
@end
