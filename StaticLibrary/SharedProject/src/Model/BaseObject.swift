/**
* Silver Sugar Shared Project Example
* Object Model
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

import Sugar.Json;

/**
* Base JSON Object Model
*/
public class BaseObject {
	
	private var rawObject:Sugar.Json.JsonObject?;
	
	public init() {
		super.init();
	}
	
	/**
	 * Object to String
	 */
	public func ToJson() -> (String?) {
		if let obj=self.rawObject {
			return obj.ToJson();
		}
		return nil;
	}
	
	/**
	 * Map json string to object
	 */
	public func map(jsonString:String!) ->() {
		let myObject:Sugar.Json.JsonObject = Sugar.Json.JsonObject.Load( jsonString );
		if let obj = myObject {
			let props = obj.Keys;
			for el in props {
				if let value = obj.Item[el] {
				}
			}
			self.rawObject=Sugar.Json.JsonObject.Load( myObject.ToJson() );
		}
	}
	
} //BaseObject