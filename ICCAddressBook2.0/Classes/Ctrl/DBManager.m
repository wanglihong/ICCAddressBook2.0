//
//  DBManager.m
//  ICCAddressBook2.0
//
//  Created by Dennis Yang on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

@synthesize database = _database;

static DBManager *_instance = nil;

// 单例
+ (DBManager *)defaultManager {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[DBManager alloc] init];
		}
	}
	
	return _instance;
}

// 数据库 路径
- (NSString *)filePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	return [documentsDirectory stringByAppendingPathComponent:DBNAME];
}

// 数据库 创建或打开
- (BOOL)open
{
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:[self filePath]];
    
    if (exist) 
    {
        if (sqlite3_open([[self filePath] UTF8String], &_database) != SQLITE_OK) 
        {
            sqlite3_close(_database);
        }
        
        [self createTable];
        
        return YES;
    }
    
    if (sqlite3_open([[self filePath] UTF8String], &_database) == SQLITE_OK) 
    {
        [self createTable];
        
        return YES;
    }
    else 
    {
        sqlite3_close(_database);
        
        return NO;
    }
    
    return NO;
}

// 表 创建
- (BOOL)createTable
{
    char *sql = "create table if not exists myTable(ID INTEGER PRIMARY KEY AUTOINCREMENT, personId int, chineseName text, englishName text, team text, position text, ext text, phone text, email text, msn text, telephone text, pic160 text, pic320 text, pic640 text)";
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, sql, -1, &statement, nil) != SQLITE_OK) 
    {
        return NO;
    }
    
    int result = sqlite3_step(statement);   // 执行sql语句
    
    sqlite3_finalize(statement);
    
    if (result != SQLITE_DONE) 
    {
        return NO;
    }
    
    return NO;
}

// 表数据 查询
- (NSMutableArray *)dataFromeTable
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    if ([self open]) 
    {
        sqlite3_stmt *statement = nil;
		
		char *sql = "SELECT personId, chineseName, englishName, team, position, ext, phone, email, msn, telephone, pic160, pic320, pic640 FROM myTable";
        
        if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) == SQLITE_OK) 
        {
			while (sqlite3_step(statement) == SQLITE_ROW) 
            {
                char *personId      = (char*)sqlite3_column_text(statement, 0);
                char *chineseName   = (char*)sqlite3_column_text(statement, 1);
                char *englishName   = (char*)sqlite3_column_text(statement, 2);
                char *team          = (char*)sqlite3_column_text(statement, 3);
                char *position      = (char*)sqlite3_column_text(statement, 4);
                char *ext           = (char*)sqlite3_column_text(statement, 5);
                char *phone         = (char*)sqlite3_column_text(statement, 6);
                char *email         = (char*)sqlite3_column_text(statement, 7);
                char *msn           = (char*)sqlite3_column_text(statement, 8);
                char *telephone     = (char*)sqlite3_column_text(statement, 9);
                char *pic160        = (char*)sqlite3_column_text(statement, 10);
                char *pic320        = (char*)sqlite3_column_text(statement, 11);
                char *pic640        = (char*)sqlite3_column_text(statement, 12);
                
				Person *person = [[[Person alloc] init] autorelease];
                person.personId    = [NSString stringWithUTF8String:(personId ? personId : "")];
				person.chineseName = [NSString stringWithUTF8String:(chineseName ? chineseName : "")];
                person.englishName = [NSString stringWithUTF8String:(englishName ? englishName : "")];
                person.team        = [NSString stringWithUTF8String:(team ? team : "")];
                person.position    = [NSString stringWithUTF8String:(position ? position : "")];
                person.ext         = [NSString stringWithUTF8String:(ext ? ext : "")];
                person.phone       = [NSString stringWithUTF8String:(phone ? phone : "")];
                person.email       = [NSString stringWithUTF8String:(email ? email : "")];
                person.msn         = [NSString stringWithUTF8String:(msn ? msn : "")];
                person.telephone   = [NSString stringWithUTF8String:(telephone ? telephone : "")];
                person.pic160      = [NSString stringWithUTF8String:(pic160 ? pic160 : "")];
                person.pic320      = [NSString stringWithUTF8String:(pic320 ? pic320 : "")];
                person.pic640      = [NSString stringWithUTF8String:(pic640 ? pic640 : "")];
                [array addObject:person];
                //printf("%s", sqlite3_column_text(statement, 2));
                //printf("%d", person.personId);
			}
		}
        
        sqlite3_finalize(statement);
		sqlite3_close(_database);
    }
    
    return array;
}

- (Person *)select:(NSString *)personId
{
    Person *person = [[[Person alloc] init] autorelease];
    
    if ([self open]) 
    {
        sqlite3_stmt *statement = nil;
		
		char *sql = "SELECT personId, chineseName, englishName, team, position, ext, phone, email, msn, telephone, pic160, pic320, pic640 FROM myTable where personId = ?";
        
        if (sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) == SQLITE_OK) 
        {
            sqlite3_bind_text(statement, 1, [personId UTF8String], -1, SQLITE_TRANSIENT);
            
            if (sqlite3_step(statement) == SQLITE_ROW) 
            {
                char *personId      = (char*)sqlite3_column_text(statement, 0);
                char *chineseName   = (char*)sqlite3_column_text(statement, 1);
                char *englishName   = (char*)sqlite3_column_text(statement, 2);
                char *team          = (char*)sqlite3_column_text(statement, 3);
                char *position      = (char*)sqlite3_column_text(statement, 4);
                char *ext           = (char*)sqlite3_column_text(statement, 5);
                char *phone         = (char*)sqlite3_column_text(statement, 6);
                char *email         = (char*)sqlite3_column_text(statement, 7);
                char *msn           = (char*)sqlite3_column_text(statement, 8);
                char *telephone     = (char*)sqlite3_column_text(statement, 9);
                char *pic160        = (char*)sqlite3_column_text(statement, 10);
                char *pic320        = (char*)sqlite3_column_text(statement, 11);
                char *pic640        = (char*)sqlite3_column_text(statement, 12);
                
                person.personId    = [NSString stringWithUTF8String:(personId ? personId : "")];
				person.chineseName = [NSString stringWithUTF8String:(chineseName ? chineseName : "")];
                person.englishName = [NSString stringWithUTF8String:(englishName ? englishName : "")];
                person.team        = [NSString stringWithUTF8String:(team ? team : "")];
                person.position    = [NSString stringWithUTF8String:(position ? position : "")];
                person.ext         = [NSString stringWithUTF8String:(ext ? ext : "")];
                person.phone       = [NSString stringWithUTF8String:(phone ? phone : "")];
                person.email       = [NSString stringWithUTF8String:(email ? email : "")];
                person.msn         = [NSString stringWithUTF8String:(msn ? msn : "")];
                person.telephone   = [NSString stringWithUTF8String:(telephone ? telephone : "")];
                person.pic160      = [NSString stringWithUTF8String:(pic160 ? pic160 : "")];
                person.pic320      = [NSString stringWithUTF8String:(pic320 ? pic320 : "")];
                person.pic640      = [NSString stringWithUTF8String:(pic640 ? pic640 : "")];
            }
        }
        
        sqlite3_finalize(statement);
		sqlite3_close(_database);
    }
    
    return person;
}

// 插入一条数据
- (BOOL)insert:(Person *)person
{
    if ([self open]) 
    {
        sqlite3_stmt *statement;
		
		char *sql = "INSERT INTO myTable(personId, chineseName, englishName, team, position, ext, phone, email, msn, telephone, pic160, pic320, pic640) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        int result = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
        
        if (result != SQLITE_OK) 
        {
            sqlite3_close(_database);
            
            return NO;
        }
        
        sqlite3_bind_text(statement, 1, [person.personId    UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, 2, [person.chineseName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [person.englishName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [person.team        UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [person.position    UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [person.ext         UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [person.phone       UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 8, [person.email       UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 9, [person.msn         UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 10,[person.telephone   UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 11,[person.pic160      UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 12,[person.pic320      UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 13,[person.pic640      UTF8String], -1, SQLITE_TRANSIENT);
        
		result = sqlite3_step(statement);
		sqlite3_finalize(statement);
        
        if (result == SQLITE_ERROR) 
        {
            sqlite3_close(_database);
            
			return NO;
        }
        
        sqlite3_close(_database);
        
		return YES;
    }
    
    return NO;
}

//删除一条数据
- (BOOL)delete:(Person *)person
{
	if ([self open])
    {
		sqlite3_stmt *statement;
		
		static char *sql = "delete from myTable  where chineseName = ?";
		
		int result = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
        
		if (result != SQLITE_OK) 
        {
			sqlite3_close(_database);
            
			return NO;
		}
		
		//这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
		//当掌握了原理后就不害怕复杂了
		sqlite3_bind_text(statement, 1, [person.chineseName UTF8String], -1, SQLITE_TRANSIENT);
		
		result = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		if (result == SQLITE_ERROR) 
        {
			sqlite3_close(_database);
            
			return NO;
		}
        
		sqlite3_close(_database);
        
		return YES;
	}
    
	return NO;
}

// 更新数据
- (BOOL)update:(Person *)person
{
	if ([self open]) 
    {
		//我想下面几行已经不需要我讲解了，嘎嘎 
		sqlite3_stmt *statement;
		//组织SQL语句
		char *sql = "update myTable set chineseName = ?  WHERE personId = ?";
		
		//将SQL语句放入sqlite3_stmt中
		int result = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
		if (result != SQLITE_OK) 
        {
			sqlite3_close(_database);
            
			return NO;
		}
		
		//这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
		//当掌握了原理后就不害怕复杂了
		sqlite3_bind_text(statement, 1, [person.chineseName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(statement, 2, [person.personId UTF8String], -1, SQLITE_TRANSIENT);
		
		//执行SQL语句。这里是更新数据库
		result = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		//如果执行失败
		if (result == SQLITE_ERROR) 
        {
			sqlite3_close(_database);
            
			return NO;
		}
        
		//执行成功后依然要关闭数据库
		sqlite3_close(_database);
        
		return YES;
	}
    
	return NO;
}

// 清空表数据
- (BOOL)clear
{
    if ([self open]) 
    {
		sqlite3_stmt *statement;
		
        char *sql = "delete from myTable";
		
		int result = sqlite3_prepare_v2(_database, sql, -1, &statement, NULL);
		if (result != SQLITE_OK) 
        {
			sqlite3_close(_database);
            
			return NO;
		}
		
		result = sqlite3_step(statement);
		sqlite3_finalize(statement);
		
		//如果执行失败
		if (result == SQLITE_ERROR) 
        {
			sqlite3_close(_database);
            
			return NO;
		}
        
		//执行成功后依然要关闭数据库
		sqlite3_close(_database);
        
		return YES;
	}
    
	return NO;
}

@end

