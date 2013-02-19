package away3d.loaders.misc {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class URLLoaderStrategy extends AbstractLoadStrategy {			
		private var _urlLoader : URLLoader;
		
		public override function load(urlRequest:URLRequest):void {
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = _dataFormat;
			_urlLoader.addEventListener(Event.COMPLETE, handleLoaderComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleLoaderError);			
			_urlLoader.load(urlRequest);
		}
		
		private function removeListeners() : void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, handleLoaderComplete);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, handleLoaderError);
		}
		
		private function handleLoaderError(event:IOErrorEvent) : void
		{
			removeListeners();
			if(hasEventListener(IOErrorEvent.IO_ERROR)) 
				dispatchEvent(event);
		}
		
		private function handleLoaderComplete(event : Event) : void
		{
			removeListeners();
			
			_data = _urlLoader.data;
			
			if(hasEventListener(Event.COMPLETE)) 
				dispatchEvent(event);
		}		
	}
}
;