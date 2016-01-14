/**
* Silver Sugar Shared Project Example
* HTTP and Database Logic
* iOS and Android targets
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

import Sugar
import Sugar.data;
import Sugar.io;

public class SharedClassTest {
	
	var dbConn:SQLiteConnection?;
	
	/******************
	* Private API
	******************/
	
	func databaseExecuteQuery(dbConn:SQLiteConnection, query:String) throws -> SQLiteQueryResult {
		let RES:SQLiteQueryResult = dbConn.ExecuteQuery(query , nil);
		return RES;
	}
	
	/**
	* Helper fun to log errors exceptions by platform type
	*/
	func logError(var message:String, var error:Object?) ->() {
		writeLn(message);
		#if cocoa
			if let err = error {
				writeLn( err.description.ToString() );
			}
		#else if java
			if let err = error {
				writeLn(error);
			}
		#endif
	}
	
	func getDatabaseConnection() -> SQLiteConnection? {
		
		// file system folder path
		let Separator:Char=Sugar.io.folder.Separator;
		let userLocal:Folder=Sugar.IO.Folder.UserLocal();
		let userLocalPath:String=userLocal.Path;
		let dbPath:String = Sugar.io.Path.Combine(userLocalPath,"db")
		let dbFilePath:String = Sugar.io.Path.Combine(dbPath,"db.sql")
		
		let altFilePath:String = Sugar.io.Path.Combine(userLocalPath,"db.sql")
		
		writeLn("User path \(userLocalPath)");
		writeLn("App folder path \(dbPath)");
		writeLn("Database path \(dbFilePath) \(altFilePath)");
		
		// scan app sub-folders
		var parentPath:String = Path.GetParentDirectory(userLocalPath)?
		if parentPath!=nil {
			parentPath=Path.GetParentDirectory( parentPath );
			writeLn ( "Scanning \(parentPath)..." )
			let folders:String[]=Sugar.io.FolderUtils.GetFolders(parentPath,false);
			for f in folders {
				if f.EndsWith("Documents") {
					writeLn("Documents folder \(f)");
					}
			}
		}
		
		if( Sugar.IO.FolderUtils.Exists(dbPath) ) {
			// db file exists
			writeLn("Database found at \(dbFilePath)")
			do {
				let dbConn:SQLiteConnection = SQLiteConnection.init(dbFilePath, false, true); // name, readonly, createifneeded
				return dbConn;
			} catch let error as SQLiteException {
				logError("sql connection error",error:error);
				return nil;
			}
		}
		else {
			// create database file
			do {
				
				Sugar.IO.FolderUtils.Create(dbPath);
			
				let dbConn:SQLiteConnection = SQLiteConnection.init(dbFilePath, false, true); // name, readonly, createifneeded
				let SQL = "CREATE TABLE IF NOT EXISTS CACHE (ID INTEGER PRIMARY KEY AUTOINCREMENT, CACHE_KEY TEXT UNIQUE, CACHE_VALUE TEXT, TIMESTAMP TEXT);";
				dbConn.Execute(SQL,nil);
				writeLn("Database created at \(dbFilePath)");
				
				return dbConn;
			} catch let error as SugarIOException {
				logError("sql file error",error:error);
				return nil;
			} catch let error as SQLiteException {
				logError("sql create table error",error:error);
				return nil;
			}
		}
	}
	
	/******************
	* Public API
	******************/
	
	/**
	* Database setup
	*/
	public func databaseSetup() -> () {
		
		let guid = Sugar.Guid.NewGuid();
		let osName:String = Sugar.Environment.OSName;
		let osVersion:String = Sugar.Environment.OSVersion;
		let userName:String = Sugar.Environment.UserName;
		
		let systemInfo:String = "\(osName)/\(osVersion)/\(userName)/\(guid)";
		writeLn( systemInfo );
		
		// get database connection
		self.dbConn = getDatabaseConnection();
		if let conn = self.dbConn {
			do {
				
				let rndIndex=(Sugar.Random()).NextInt();
				let key="USER_"+Sugar.Convert.ToString(rndIndex);
				
				let INSERT = "INSERT OR REPLACE INTO CACHE (cache_key, cache_value, timestamp) VALUES (?,?,?);";
				conn.Execute(INSERT,[key,"PIPPO","20150101"]);
				
				let SELECT = "SELECT * from CACHE"
				let result:SQLiteQueryResult=conn.ExecuteQuery(SELECT);
				writeLn( result );
				
				while result.MoveNext() {
					writeLn(  result.GetString( 0 ) ); // col1
					writeLn( result.GetString( 1 ) ); // col2
					writeLn( result.GetString( 2 ) ); // col3
				}
			
			} catch let error as SQLiteException {
				logError("sql error",error:error);
			}
		}
		else {
			logError("Database error",error:nil);
		}
	}
	
	/**
	* Perform HTTP Call
	*/
	public func httpCall(var url: String, completion: (response:String?) ->()  )	
	{
		
		/*var promise = Promise { (resolve: (AnyObject?) -> (), reject: (AnyObject?) -> ()) -> () in
			
			/*response = API.login()
			if (response.success) {
				resolve(response.user)
			} else {
				reject(response.error)
			}*/
		}
		promise.then { (value) -> () in
				// Probably doing something important with this data now
			}
			.catch_ { (error) -> () in
				// Display error message, log errors
			}
			.finally { () -> () in
			// Close connections, do cleanup
		}*/
		
		//let jsonObj:Sugar.Json.JsonObject = Sugar.Json.JsonObject();
		//let parsedJsonObj:Sugar.Json.JsonObject = Sugar.Json.JsonObject.Load("");
		
		let jsonCallback: HttpContentResponseBlock<Sugar.Json.JsonDocument!>! = { response in 
			if response.Success {
				var obj = response.Content.RootObject
			}
		}
		Http.ExecuteRequestAsJson( Url(url), jsonCallback)
		
		Http.ExecuteRequest(Url( url ), { response in
			writeLn (response )
		})
		
		Http.ExecuteRequest(Url(url), { response in
			if response.Success {
				response.GetContentAsString(nil) { content in
					if content.Success {
						completion( content.Content )
					}
				}
			}
		});
		
		/*let plainCallback: HttpResponseBlock<String!> = { response in
		
		}
		Http.ExecuteRequest(Url( url ), plainCallback)*/
		
	}
	
	/***********************
	* Platform-Dependent API
	************************/
	
	#if java
	public func context(var context:android.content.Context) ->() {
		Sugar.Environment.ApplicationContext = context;
	}
	#endif
}