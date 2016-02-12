/**
* Silver Sugar Shared Project Example
* Storage Module
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

import Sugar
import Sugar.Data;
import Sugar.IO;

/**
* Storage Common Handlers
*/
public class Storage {
	
	// Console Logger
	var logger:Logger;
	
	public init() {
		let level = Logger.Level.DEBUG;
		logger = ConsoleLogger( level:level );
	}
	
	public init(var logger:Logger) {
		self.logger = logger;
	}

} //Storage

/**
* In-memory Storage (Cache) Handlers
*/
public class MemoryStorage : Storage {

} //MemoryStorage

/**
* Persistent Storage Handlers
*/
public class PersistentStorage : Storage {

} //PersistentStorage

/**
* Database Persistent Storage
*/
public class DatabaseStorage : PersistentStorage {
	
	// Database name
	let DBNAME:String = "db4.sq";

	// Database Absolute Path
	var dbPath:String?;
	
	// SQLite Lazy Connection
	lazy var conn:SQLiteConnection? = {
		return self.getConnection();
	}()
	
	/******************
	* Public API
	******************/
	
	/**
	* Execute Select Query
	* @throws SQLiteException
	*/
	func executeQuery(conn:SQLiteConnection!, query:String!, parameters: AnyObject![]) throws -> SQLiteQueryResult {
		let RES:SQLiteQueryResult = conn.ExecuteQuery(query , parameters);
		return RES;
	} //executeQuery
	
	/**
	* Execute and return the number of affected rows
	* @throws SQLiteException
	*/
	func execute(conn:SQLiteConnection!, query:String!, parameters: AnyObject![]) throws -> Int64 {
		let RES:Int64 = conn.Execute(query , parameters);
		return RES;
	} //execute
	
	/**
	* Execute insert and return the last insert id
	* @throws SQLiteException
	*/
	func executeInsert(conn:SQLiteConnection!, query:String!, parameters: AnyObject![]) throws -> Int64 {
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
		let Separator:Char=Sugar.IO.Folder.Separator;
		let userLocal:Folder=Sugar.IO.Folder.UserLocal();
		let userLocalPath:String=userLocal.Path;
		let dbPath:String = Sugar.IO.Path.Combine(userLocalPath,"db")
		let dbFilePath:String = Sugar.IO.Path.Combine(dbPath,DBNAME)
		
		logger.debug("User path \(userLocalPath)");
		logger.debug("App folder path \(dbPath)");
		logger.debug("Database path \(dbFilePath)");
		
		// scan app sub-folders
		/*var parentPath:String = Path.GetParentDirectory(userLocalPath)?
		if parentPath!=nil && parentPath != "" {
			parentPath=Path.GetParentDirectory( parentPath );
			writeLn ( "Scanning \(parentPath)..." )
			let folders:String[]=Sugar.io.FolderUtils.GetFolders(parentPath,false);
			for f in folders {
				if f.EndsWith("Documents") {
					logger.debug("Documents folder \(f)");
					}
			}
		}*/
		
		if( Sugar.IO.FolderUtils.Exists(dbPath) ) { //db folder
			if( Sugar.IO.FileUtils.Exists(dbFilePath) ) { // db file
				
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
					try execute(dbConn, query:SQL, parameters:[]);
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
				try execute(dbConn, query:SQL, parameters:[]);
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
		
	/**
	* Test the database connection and statements
	*/
	public func testDatabase() -> () {
		if let dbConn = self.conn {
			testSelect(dbConn);
			testInsert(dbConn);
			testSelect(dbConn);
		}
		else {
			logger.error("Database error",error:nil);
		}
	} //testDatabase
	
	/**
	 * Test a insert of an object
	 */
	/**
	* Test Object Insert
	*/
	private func testInsertObject(object:CacheObject!) -> Bool {
		if let dbConn = self.conn {
			return true;
		}
		else {
			logger.error("testInsertObject error",error:nil);
			return false;
		}
	} //testInsertObject
	
	/**
	 * Test remove of an object
	 */
	private func testRemoveObject(let object:CacheObject!) -> Bool {
		if let dbConn = self.conn {
			return true;
		}
		else {
			logger.error("testRemoveObject error",error:nil);
			return false;
		}
	} //testInsertObject
	
	/**
	 * Test Select objects
	 */
	private func testSelectObjects() -> CacheObject[]? {
		if let dbConn = self.conn {
			return nil;
		}
		else {
			logger.error("testSelectObjects error",error:nil);
			return nil;
		}
	} //testSelectObjects
	
	/**
	* Test a Insert statement
	*/
	private func testInsert(conn:SQLiteConnection!) -> Bool {
		do {
				
			let rndIndex=(Sugar.Random()).NextInt();
			let key="USER_"+Sugar.Convert.ToString(rndIndex,10);
				
			let INSERT = "INSERT OR REPLACE INTO CACHE (cache_key, cache_value, timestamp) VALUES (?,?,?);";
			try executeInsert(conn, query:INSERT , parameters:[key,"PIPPO","20150101"]);
			
		} catch let error as SQLiteException {
			logger.error("testInsert sql error",error:error);
			return false;
		} catch let error as SugarException {
			logger.error("testInsert error",error:error);
			return false;
		}
		return true;
	} //testInsert
	
	/**
	* Test a Select statement
	*/
	private func testSelect(conn:SQLiteConnection!) -> SQLiteQueryResult? {
		do {
				
			let SELECT = "SELECT CACHE.cache_key, CACHE.cache_value, CACHE.timestamp from CACHE"
			let result:SQLiteQueryResult= try executeQuery(conn, query:SELECT , parameters:[]);
			
			while result.MoveNext() {
				var i=0;
				logger.debug( result.GetString( i ) ); // col1
				logger.debug( result.GetString( ++i ) ); // col2
				logger.debug( result.GetString( ++i ) ); // col3
			}
			
			return result;
			
		} catch let error as SQLiteException {
			logger.error("testSelect sql error",error:error);
			return nil;
		} catch let error as SugarException {
			logger.error("testSelect error",error:error);
			return nil;
		}
	} //testSelect
	
	/**
	* Test delete statement
	*/
	private func testDelete(let key:String, conn:SQLiteConnection!) -> Bool {
		do {
				
			let STMT = "DELETE FROM CACHE where cache_key=?;";
			try execute(conn, query:STMT , parameters:[key]);
			
		} catch let error as SQLiteException {
			logger.error("testDelete sql error",error:error);
			return false;
		} catch let error as SugarException {
			logger.error("testDelete error",error:error);
			return false;
		}
		return true;
	} //testDelete
	
} //DatabaseStorage


