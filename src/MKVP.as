package  {
	
	import flash.display.MovieClip;
	import com.matroska.*;
	import com.matroska.segment.*;
	import flash.utils.ByteArray;
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	
	public class MKVP extends MovieClip {
		
		private var mkvFile:ByteArray = new ByteArray();
		private var urlStream:URLStream = new URLStream();
		private var urlRequest:URLRequest = new URLRequest();
		private var MKV:MKVFile = null;
		
		public function MKVP() {
			urlRequest.url = "asset/MKVSample.mkv";
			urlStream.addEventListener(ProgressEvent.PROGRESS, readBuffer);
			urlStream.addEventListener(Event.COMPLETE, fileLoaded);
			urlStream.load(urlRequest);
		}
		
		private function readBuffer(e:Event):void {
			//TODO : Handle Streaming mode
		}
		
		private function fileLoaded(e:Event):void {
			urlStream.readBytes(mkvFile, mkvFile.length);
			MKV = new MKVFile(mkvFile);
			trace(mkvFile.length);
		}
		
	}
	
}
