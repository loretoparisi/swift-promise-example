/**
* Silver Sugar Shared Project Example
* Logger Module
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

import Sugar

/**
* Base Logger 
*/
internal class Logger {
	
	// Log Levels
	internal enum Level: Int {
		case QUIET = 0
		case ERROR = 1
		case WARN = 2
		case INFO = 3
		case DEBUG = 4
	}
	
	// Log Tags
	internal enum Tag: String {
		case QUIET = "QUIET"
		case ERROR = "ERROR"
		case WARN = "WARN"
		case INFO = "INFO"
		case DEBUG = "DEBUG"
	}
	
	// Log Level
	var _level: Level = Level.QUIET
	
	public init(var level:Level) {
		_level=level;
	}
	
	/**
	* Helper fun to log errors exceptions by platform type
	*/
	func error(var message:String, var error:Object?) ->() {
	}
	
	/**
	* Helper fun to log warning messages
	*/
	func warn(var message:String) ->() {
	
	}
	
	/**
	* Helper fun to log debug messages
	*/
	func debug(var message:String) ->() {
	}

} //Logger

/**
* Console Logger 
*/
internal class ConsoleLogger : Logger {
	
	/**
	 * Log messages to console
	 */
	private func log(let tag:String, var message:String) -> () {
		
		let now = DateTime.UtcNow;
		let msg= "[\(now)] \(tag):\(message)";
		//@TODO: format msg
		writeLn(msg);
	}
	
	/**
	 * Dump error
	 */
	private func dump(var error:Object?) -> () {
		if let error = error {
			writeLn(error);
		}
	}
	
	/**
	* Helper fun to log debug messages
	*/
	override func warn(var message:String) ->() {
		self.log(Tag.WARN,message:message);
	}
	
	/**
	* Helper fun to log debug messages
	*/
	override func debug(var message:String) ->() {
		self.log(Tag.DEBUG,message:message);
	}
	
	/**
	* Helper fun to log errors exceptions by platform type
	*/
	override func error(var message:String, var error:Object?) ->() {
		self.log(Tag.ERROR,message:message);
		self.dump(error);
	}
} //ConsoleLogger

/**
* File Logger 
*/
internal class FileLogger : Logger {

} //FileLogger

/**
* Remote Socket Logger 
*/
internal class RemoteLogger : Logger {

} //RemoteLogger



