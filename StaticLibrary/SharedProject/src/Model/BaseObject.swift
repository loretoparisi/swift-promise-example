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
	
	/******************
	 * Private API
	******************/
	
	/**
	 * Map JsonNode to KeyValuePair
	 */
	private func mapNodeToKV(node:Sugar.Json.JsonNode,json:[String:AnyObject],key:String!,pos:Int!) -> ([String:AnyObject]?) {
		if node.Count>=1 {
			for k in node.Keys {
				json[key]=mapNodeToKV(node.Item[k]!,json:json,key:k,pos:pos+1)!;
				writeLn("[KEY]:\n\(key):[VALUE]:\n\(json[key])");
			}
			return json;
		}
		else {
			json[key]=node;
			writeLn("[KEY]:\n\(key):[VALUE]:\n\(json[key])");
			return json;
		}
	}
	
	/******************
	 * Public API
	******************/
	public init() {
		super.init();
	}
	
	/**
	 * Object to Json String
	 */
	public func ToJson() -> (String?) {
		if let obj=self.rawObject {
			return obj.ToJson();
		}
		return nil;
	}
	
	/**
	 * Get Json Object
	 * @TODO: recursive mapping
	 */
	public func toJsonObject() -> ([String:AnyObject]?) {
		var json:[String:AnyObject]! = [String:AnyObject]();
		if let node = self.rawObject {
			json=mapNodeToKV(node,json:json,key:"root",pos:0);
			/*for k in node.Keys {
				json[k]=node.Item[k]!
			}*/
			return json;
		}
		return nil;
	}
	
	/**
	 * Map json string to object
	 */
	public func map(jsonString:String!) ->() {
		let myObject:Sugar.Json.JsonObject = Sugar.Json.JsonObject.Load( jsonString );
		if let obj = myObject {
			let allKeys = obj.Keys;
			for key in allKeys {
				if let value = obj.Item[key] {
					writeLn("[\(key)]=\(value)");
				}
			}
			self.rawObject=Sugar.Json.JsonObject.Load( myObject.ToJson() );
		}
	}
	
} //BaseObject