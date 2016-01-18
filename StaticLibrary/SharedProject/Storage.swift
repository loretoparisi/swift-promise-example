/**
* Silver Sugar Shared Project Example
* Storage Module
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

import Sugar
import Sugar.data;
import Sugar.io;

/**
* Storage Common Handlers
*/
public class Storage {
	
	// Console Logger
	var logger:Logger;
	
	init() {
		let level = Logger.Level.DEBUG;
		logger = ConsoleLogger( level:level );
	}
	
	init(var logger:Logger) {
		self.logger = logger;
	}

}

/**
* In-memory Storage (Cache) Handlers
*/
public class MemoryStorage : Storage {

}

/**
* Persistent Storage Handlers
*/
public class PersistentStorage : Storage {

}

/**
* Database Persistent Storage
*/
public class DatabaseStorage : PersistentStorage {

	// SQLite Connection
	var conn:SQLiteConnection?;
	
	// Database Absolute Path
	var dbPath:String?;
	
	lazy private var sharedConn:SQLiteConnection = {
		return SQLiteConnection.init("", false, true); // name, readonly, createifneeded
	}()
	
	/******************
	* Public API
	******************/
	
	/**
	* Execute Select Query
	* @throws SQLiteException
	*/
	func executeQuery(conn:SQLiteConnection!, query:String!, parameters: NSObject![]) throws -> SQLiteQueryResult {
		let RES:SQLiteQueryResult = conn.ExecuteQuery(query , parameters);
		return RES;
	} //executeQuery
	
	/**
	* Execute and return the number of affected rows
	* @throws SQLiteException
	*/
	func execute(conn:SQLiteConnection!, query:String!, parameters: NSObject![]) throws -> Int64 {
		let RES:Int64 = conn.Execute(query , parameters);
		return RES;
	} //execute
	
	/**
	* Execute insert and return the last insert id
	* @throws SQLiteException
	*/
	func executeInsert(conn:SQLiteConnection!, query:String!, parameters: NSObject![]) throws -> Int64 {
		let RES:Int64 = conn.ExecuteInsert(query , parameters);
		return RES;
	} //executeInsert
	
	/******************
	* Private API
	******************/
	
	/**
	* Retrieve Database Connection
	*/
	private func getConnection() -> SQLiteConnection? {
		
		// file system folder path
		let Separator:Char=Sugar.io.folder.Separator;
		let userLocal:Folder=Sugar.IO.Folder.UserLocal();
		let userLocalPath:String=userLocal.Path;
		let dbPath:String = Sugar.io.Path.Combine(userLocalPath,"db")
		let dbFilePath:String = Sugar.io.Path.Combine(dbPath,"db.sql")
		
		logger.debug("User path \(userLocalPath)");
		logger.debug("App folder path \(dbPath)");
		logger.debug("Database path \(dbFilePath)");
		
		// scan app sub-folders
		var parentPath:String = Path.GetParentDirectory(userLocalPath)?
		if parentPath!=nil {
			parentPath=Path.GetParentDirectory( parentPath );
			writeLn ( "Scanning \(parentPath)..." )
			let folders:String[]=Sugar.io.FolderUtils.GetFolders(parentPath,false);
			for f in folders {
				if f.EndsWith("Documents") {
					logger.debug("Documents folder \(f)");
					}
			}
		}
		
		if( Sugar.IO.FolderUtils.Exists(dbPath) ) { //db folder
			let fd:File = Sugar.IO.File(dbFilePath);
			if( fd.Exists() ) { // db file
				
				// db file exists
				writeLn("Database found at \(dbFilePath)")
				do {
					let dbConn:SQLiteConnection = SQLiteConnection.init(dbFilePath, false, true); // name, readonly, createifneeded
					return dbConn;
				} catch let error as SQLiteException {
					logger.error("sql connection error",error:error);
					return nil;
				}
			}
			else { // create database file in database folder
				do {
					let dbConn:SQLiteConnection = SQLiteConnection.init(dbFilePath, false, true); // name, readonly, createifneeded
					let SQL = "CREATE TABLE IF NOT EXISTS CACHE (ID INTEGER PRIMARY KEY AUTOINCREMENT, CACHE_KEY TEXT UNIQUE, CACHE_VALUE TEXT, TIMESTAMP TEXT);";
					dbConn.Execute(SQL,nil);
					logger.debug("Database created at \(dbFilePath)");
					return dbConn;
				} catch let error as SQLiteException {
					logger.error("sql connection error",error:error);
					return nil;
				}
			}
		}
		else {
			// create database file
			do {
				
				Sugar.IO.FolderUtils.Create(dbPath);
			
				let dbConn:SQLiteConnection = SQLiteConnection.init(dbFilePath, false, true); // name, readonly, createifneeded
				let SQL = "CREATE TABLE IF NOT EXISTS CACHE (ID INTEGER PRIMARY KEY AUTOINCREMENT, CACHE_KEY TEXT UNIQUE, CACHE_VALUE TEXT, TIMESTAMP TEXT);";
				dbConn.Execute(SQL,nil);
				logger.debug("Database created at \(dbFilePath)");
				return dbConn;
			} catch let error as SugarIOException {
				logger.error("sql file error",error:error);
				return nil;
			} catch let error as SQLiteException {
				logger.error("sql create table error",error:error);
				return nil;
			}
		}
	
	} //getConnection
	
	/******************
	* Test API
	******************/
		
	public func testDatabaseStorage() -> () {
		self.conn = getConnection();
		if let dbConn = self.conn {
			testInsert(dbConn);
			testSelect(dbConn);
		}
		else {
			logger.error("Database error",error:nil);
		}
	}
	
	private func testInsert(conn:SQLiteConnection!) -> Bool {
		do {
				
			let rndIndex=(Sugar.Random()).NextInt();
			let key="USER_"+Sugar.Convert.ToString(rndIndex);
				
			let INSERT = "INSERT OR REPLACE INTO CACHE (cache_key, cache_value, timestamp) VALUES (?,?,?);";
			try executeInsert(conn, query:INSERT , parameters:[key,"PIPPO","20150101"]);
			
		} catch let error as SQLiteException {
			logger.error("sql error",error:error);
			return false;
		}
		return true;
	} //testInsert
	
	private func testSelect(conn:SQLiteConnection!) -> Bool {
		do {
				
			let SELECT = "SELECT * from CACHE"
			let result:SQLiteQueryResult= try executeQuery(conn, query:SELECT , parameters:[]);
			while result.MoveNext() {
				logger.debug(  result.GetString( 0 ) ); // col1
				logger.debug( result.GetString( 1 ) ); // col2
				logger.debug( result.GetString( 2 ) ); // col3
			}
			
		} catch let error as SQLiteException {
			logger.error("sql error",error:error);
			return false;
		}
		return true;
	} //testSelect
	
}


