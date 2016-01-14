import Sugar
import Sugar.data;
import Sugar.io;

//import Promise

public class SharedClassTest {
	
	private var dbConn:SQLiteConnection?;
	
	/******************
	* Private API
	******************/
	
	func databaseExecuteQuery(dbConn:SQLiteConnection, query:String) throws -> SQLiteQueryResult {
		let RES:SQLiteQueryResult = dbConn.ExecuteQuery(query , nil);
		return RES;
	}
	
	func getDatabaseConnection() -> SQLiteConnection? {
		
		// file system folder path
		let Separator:Char=Sugar.io.folder.Separator;
		let userLocal:Folder=Sugar.IO.Folder.UserLocal()
		let dbPath:String = Sugar.io.Path.Combine(userLocal.Path,"db")
		let dbFilePath:String = Sugar.io.Path.Combine(dbPath,"db.sql")
		
		// scan app sub-folders
		let parentPath:String=Path.GetParentDirectory( Path.GetParentDirectory(userLocal.Path) );
		writeLn ( "Scanning \(parentPath)..." )
		let folders:String[]=Sugar.io.FolderUtils.GetFolders(parentPath,false);
		for f in folders {
			if f.EndsWith("Documents") {
				writeLn("Documents folder \(f)");
			}
		}
		
		if( Sugar.IO.FolderUtils.Exists(dbPath) ) {
			// db file exists
			writeLn("Database found at \(dbFilePath)")
			do {
				let dbConn:SQLiteConnection = SQLiteConnection.init(dbFilePath, false, true); // name, readonly, createifneeded
				return dbConn;
			} catch let error as SQLiteException {
				writeLn("sql connection error");
				writeLn( error.description.ToString() );
				return nil;
			}
		}
		else {
			// create db
			Sugar.IO.FolderUtils.Create(dbPath);
			
			do {
				let dbConn:SQLiteConnection = SQLiteConnection.init(dbFilePath, false, true); // name, readonly, createifneeded
				let SQL = "CREATE TABLE IF NOT EXISTS CACHE (ID INTEGER PRIMARY KEY AUTOINCREMENT, CACHE_KEY TEXT UNIQUE, CACHE_VALUE TEXT, TIMESTAMP TEXT);";
				dbConn.Execute(SQL,nil);
				writeLn("Database created at \(dbFilePath)");
				return dbConn;
			} catch let error as SQLiteException {
				writeLn("sql create table error");
				writeLn( error.description.ToString() );
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
				writeLn("sql error");
				writeLn( error.description.ToString() );
			}
		}
		else {
			writeLn("Database error");
		}
	}
	
	/**
	* Perform HTTP Call
	*/
	public func httpCall(var url: String, completion: (response:String?) ->()  )	
	{
		
		// this is just an example now until the Promise.swift will work
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