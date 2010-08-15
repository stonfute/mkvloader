package  {
	
	import flash.display.MovieClip;
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.events.Event;
	import com.matroska.MKVFile;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.system.System;
	import com.matroska.Frame;
	import flash.utils.getTimer;

	public class MKVP extends MovieClip {
		
		public function MKVP() {
			var mkvVideo:MatroskaVideo = new MatroskaVideo("http://jesusyamato.com/derp.txt");
			mkvVideo.loadVideo();
			addChild(mkvVideo);
		}
	}
	
}
