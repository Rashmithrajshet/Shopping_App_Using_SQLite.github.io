//
//  ManageDatabase.h
//  SecondTry
//
//  Created by lcodeM2 on 04/10/23.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"


NS_ASSUME_NONNULL_BEGIN

@interface ManageDatabase : NSObject

+ (instancetype)sharedManager;
-(void)setupDatabase;
-(NSString *)databasePath;

@property(nonatomic,strong)NSString *userID;


@end

NS_ASSUME_NONNULL_END
