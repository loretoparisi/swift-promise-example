/**
* Silver Sugar Shared Project Example
* Object Model
* @author: Loreto Parisi (loreto at musixmatch dot com )
* @2015-2016 Loreto Parisi
*/

/**
* Object model represeting a Cache object instance
*/
public class CacheObject : BaseObject {
	public var key:String!
	public var value:String!
	public var timestamp : String!
	public init(key:String!, value:String!, timestamp:String!) {
		self.key=key
		self.value=value
		self.timestamp=timestamp
	}
} //CacheObject