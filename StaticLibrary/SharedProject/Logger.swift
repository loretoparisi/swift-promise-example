/**
* Silver Sugar Shared Project Example
* Logger Module
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

/**
* Base Logger 
*/
public class Logger {
	
	// Log Levels
	public enum Level: Int {
		case QUIET = 0
		case ERROR = 1
		case WARN = 2
		case INFO = 3
		case DEBUG = 4
	}
	
	// Log Level
	var _level: Level = Level.QUIET
	
	init(var level:Level) {
		_level=level;
	}
	
	/**
	* Helper fun to log errors exceptions by platform type
	*/
	func error(var message:String, var error:Object?) ->() {
	}
	
	/**
	* Helper fun to log debug messages
	*/
	func debug(var message:String) ->() {
	}

}

/**
* Console Logger 
*/
public class ConsoleLogger : Logger {
	
	/**
	* Helper fun to log debug messages
	*/
	override func debug(var message:String) ->() {
		writeLn(message);
	}
	
	/**
	* Helper fun to log errors exceptions by platform type
	*/
	override func error(var message:String, var error:Object?) ->() {
		writeLn(message);
		if let error = error {
			writeLn(error);
		}
	}
}

/**
* File Logger 
*/
public class FileLogger : Logger {

}

/**
* Remote Socket Logger 
*/
public class RemoteLogger : Logger {

}



