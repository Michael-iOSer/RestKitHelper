//
//  RestKitHelper.m
//  TestRestKit
//
//  Created by Michael on 13-2-16.
//  Copyright (c) 2013年 Michael. All rights reserved.
//

#import "RestKitHelper.h"
#import <objc/runtime.h>
#import "AppDef.h"
#import "CustomResponse.h"

@implementation RestKitHelper

+(void)getObjectOfClass:(Class )cls
                 AtPath:(NSString *)url
                success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    RKObjectMapping *mapping = [self getObjectMapping:cls];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:nil keyPath:nil statusCodes:nil];
    
    // Add our descriptors to the manager
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SERVER_ADDR]];
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager getObjectsAtPath:url parameters:nil success:success failure:failure];
}


+(RKObjectMapping *)getObjectMapping:(Class )cls
{
    unsigned int outCount = 0;
    unsigned int i = 0;
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    objc_property_t *properties = class_copyPropertyList([cls class], &outCount);
    for(i = 0; i < outCount; i++) {
        [array addObject:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    NSDictionary *objectMappingDictionary = [[NSDictionary alloc] initWithObjects:array forKeys:array];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:cls];
    [mapping addAttributeMappingsFromDictionary:objectMappingDictionary];
    return mapping;
}



+(RKObjectMapping *)getPostObjectMapping:(Class )cls
{
    unsigned int outCount = 0;
    unsigned int i = 0;
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    
    objc_property_t *properties = class_copyPropertyList([cls class], &outCount);
    for(i = 0; i < outCount; i++) {
        [array addObject:[NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    NSDictionary *objectMappingDictionary = [[NSDictionary alloc] initWithObjects:array forKeys:array];
    
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromDictionary:objectMappingDictionary];
    return mapping;
}


+(void)postObject:(id)obj
 withResponseType:(Class )cls
           AtPath:(NSString *)path
          success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
          failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure

{
    RKObjectMapping *mapping = [RestKitHelper getPostObjectMapping:obj];
    RKRequestDescriptor *requesDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping objectClass:[obj class] rootKeyPath:nil];
    
    // Add our descriptors to the manager
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SERVER_ADDR]];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    [manager addRequestDescriptor:requesDescriptor];
    
    RKObjectMapping *responseMapping = [self getObjectMapping:cls];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping pathPattern:nil keyPath:nil statusCodes:nil];
    
    // Add our descriptors to the manager
    [manager addResponseDescriptor:responseDescriptor];
    
    [manager postObject:obj path:path parameters:nil success:success failure:failure];
}


+(void)postObject:(id)obj
           AtPath:(NSString *)path
          success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
          failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    [self postObject:obj withResponseType:[CustomResponse class] AtPath:path success:success failure:failure];
}


+(void)deleteObject:(id)obj
           AtPath:(NSString *)path
          success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
          failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    RKObjectMapping *mapping = [RestKitHelper getPostObjectMapping:obj];
    RKRequestDescriptor *requesDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:mapping objectClass:[obj class] rootKeyPath:nil];
    
    // Add our descriptors to the manager
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:SERVER_ADDR]];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;

    [manager addRequestDescriptor:requesDescriptor];
    [manager deleteObject:obj path:path parameters:nil success:success failure:failure];
}


+(void)uploadWithFileData:(NSData *)data
                     path:(NSString *)path
             name:(NSString *)name
         fileName:(NSString *)fileName
         mimeType:(NSString *)mimeType
                  success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                  failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [[RKObjectManager sharedManager] multipartFormRequestWithObject:nil method:RKRequestMethodPOST path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                    {
                                        [formData appendPartWithFileData:data
                                                                    name:name
                                                                fileName:fileName
                                                                mimeType:mimeType];
                                    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:success failure:failure];
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation:operation]; // NOTE: Must be enqueued rather than started
}


@end
