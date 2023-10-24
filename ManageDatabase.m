
#import "ManageDatabase.h"



@interface ManageDatabase ()

@property(nonatomic,strong)NSString *databasePath;

@end




@implementation ManageDatabase

+(instancetype)sharedManager{
    static ManageDatabase *sharedManager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc]init];
    });
    return  sharedManager;
}

- (void)setupDatabase {
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    self.databasePath = [docsPath stringByAppendingPathComponent:@"mydatabase.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:self.databasePath];
    if (![database open]) {
        NSLog(@"Could not open the database.");
        return;
    }
    NSString *createTableUser = @"CREATE TABLE IF NOT EXISTS Users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, password TEXT, usertype TEXT)";
    if (![database executeUpdate:createTableUser])
    {
        NSLog(@"Error: User table creation failed.");
    }
    NSString *createTableDashboards = @"CREATE TABLE IF NOT EXISTS Dashs(id INTEGER PRIMARY KEY AUTOINCREMENT, itemimg TEXT, itemname TEXT, itemprice INTEGER, itembrand TEXT, hidden INTEGER DEFAULT 0)";
    if (![database executeUpdate:createTableDashboards])
    {
        NSLog(@"Error: Dashboard table creation failed");
    }
    NSString *finalCart = @"CREATE TABLE IF NOT EXISTS MyCarts(id INTEGER PRIMARY KEY AUTOINCREMENT,cartimg TEXT,cartitemname TEXT,cartitemprice INTEGER, userid INTEGER,cartquantity INTEGER DEFAULT 1,cartupdprice INTEGER DEFAULT 1)";
    if(![database executeUpdate:finalCart])
    {
        NSLog(@"Error : MyCart table creation failed");
    }
    NSString *storeTotal = @"CREATE TABLE IF NOT EXISTS MyTotal(id INTEGER PRIMARY KEY AUTOINCREMENT,total INTEGER DEFAULT 1,userid INTEGER)";
    if(![database executeUpdate:storeTotal])
    {
        NSLog(@"Error : MyTotal table creation failed");
    }
    [database close];
}


- (NSString *)databasePath {
    if (!_databasePath) {
        NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        _databasePath = [docsPath stringByAppendingPathComponent:@"mydatabase.sqlite"];
    }
    return _databasePath;
}




@end

