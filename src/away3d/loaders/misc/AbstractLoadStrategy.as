package away3d.loaders.misc {
	import away3d.errors.AbstractMethodError;

	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class AbstractLoadStrategy extends EventDispatcher {
		protected var _dataFormat:String;
		protected var _data:*;
		
		public function load(urlRequest : URLRequest) : void {
			throw new AbstractMethodError();
		}
		
		public function set dataFormat(dataFormat:String) : void {
			_dataFormat = dataFormat;	
		}
		
		public function get data() : * {
			return _data;
		}
	}
}
