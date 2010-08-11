package  {
	
	import flash.display.MovieClip;
	import com.matroska.*;
	import com.matroska.segment.*;
	import flash.utils.ByteArray;
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.system.System;
	import flash.text.TextField;
	import flash.sampler.NewObjectSample;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.events.DataEvent;
	
	public class MKVP extends MovieClip {
		
		private var mkvFile:ByteArray = new ByteArray();
		private var urlStream:URLStream = new URLStream();
		private var urlRequest:URLRequest = new URLRequest();
		private var MKV:MKVFile = null;
		private var fr:FileReference = new FileReference();

		public static var INSTANCE:MKVP = null;
		private static var tf:TextField = new TextField();
		
		public function MKVP() {
			INSTANCE = this;
			stage.frameRate = 1000;
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.textColor = 0xFFFFFF;
			tf.htmlText = "<p align='center'>Click anywhere to load a MKV file (For now LIMITED TO AVC VIDEO ONLY, SUPPORT FOR OTHER MKV SOON) !\nNo Audio, no Subtitle, they'll be added soon !\nCoded by JesusYamato.\nThis is only an experimental and proof of concept project, this will be implemented in a real player soon !\nIf you wish to contribute : http://googlecode.com/p/mkvloader\nEnjoy the voodoo magic ;)</p>";
			tf.x = (stage.stageWidth-tf.width)/2;
			tf.y = (stage.stageHeight-tf.height)/2;
			addChild(tf);
			addEventListener(MouseEvent.CLICK, loadFile);
           	
		}
		
		private function loadFile(e:Event):void {
			
			fr.addEventListener(Event.SELECT, fileSelected);
			fr.addEventListener(ProgressEvent.PROGRESS, readBuffer);
			fr.addEventListener(Event.COMPLETE, fileLoaded);
			fr.browse([new FileFilter("Matroska File with AVC Video only (*.mkv)", "*.mkv")]);
			
		}
		
		private function readBuffer(e:Event):void {
			//TODO : Handle Streaming mode
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.textColor = 0xCCCCCC;
			var progressStr:String = (uint)(((Object)(e).bytesLoaded/(Object)(e).bytesTotal)*100) + "%";
			tf.text = progressStr;
			tf.x = (stage.stageWidth-tf.width)/2;
			tf.y = (stage.stageHeight-tf.height)/2;
		}
		
		private function fileSelected(e:Event) {
			trace("Started Loading");
			fr.load();
			removeChild(tf);
			addChild(tf);
		}
		
		private function fileLoaded(e:Event):void {
			try {
				removeChild(tf);
				MKV = null;
				System.gc();
				System.gc();
			} catch (e:Error) {
				
			}
			
			trace("Started Parsing");
			System.gc();
			System.gc();
			MKV = new MKVFile(e.target.data);
			
		}
		
	}
	
}
