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
		
		private var MKV:MKVFile = null;
		private var fr:FileReference = new FileReference();
		
		private var urlStream:URLStream;
		private var urlRequest:URLRequest;
		private var buffer:ByteArray = new ByteArray();
		
		private var tf:TextField = new TextField();
		
		public function MKVP() {
			
			stage.frameRate = 24.0;
			
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.textColor = 0xFFFFFF;
			tf.htmlText = "<p align='center'>Click anywhere to load a MKV file (For now LIMITED TO AVC VIDEO ONLY, SUPPORT FOR OTHER MKV SOON) !\nNo Audio, no Subtitle, they'll be added soon !\nCoded by JesusYamato.\nThis is only an experimental and proof of concept project, this will be implemented in a real player soon !\nIf you wish to contribute : http://googlecode.com/p/mkvloader\nEnjoy the voodoo magic ;)</p>";
			tf.x = (stage.stageWidth-tf.width)/2;
			tf.y = (stage.stageHeight-tf.height)/2;
			addChild(tf);
			
			addEventListener(MouseEvent.CLICK, loadFile);
           	
		}
		
		private function loadFile(e:Event):void {
			/*
			fr.addEventListener(Event.SELECT, fileSelected);
			fr.addEventListener(ProgressEvent.PROGRESS, readBuffer);
			fr.addEventListener(Event.COMPLETE, fileLoaded);
			fr.browse([new FileFilter("Matroska File with AVC Video only (*.mkv)", "*.mkv")]);
			*/
			removeEventListener(MouseEvent.CLICK, loadFile);
			urlRequest = new URLRequest("asset/MKVSample.mkv");
			urlStream = new URLStream();
			urlStream.addEventListener(ProgressEvent.PROGRESS, readBuffer);
			urlStream.addEventListener(Event.COMPLETE, fileLoaded);
			urlStream.load(urlRequest);
			
		}
		
		private function readBuffer(e:Event):void {
			//TODO : Handle Streaming mode
			var progressStr:String = (uint)(((Object)(e).bytesLoaded/(Object)(e).bytesTotal)*100) + "%";
			tf.text = progressStr;
			
			if (urlStream.bytesAvailable >= 1024*386) { //Read per chunk of 386KB
				urlStream.readBytes(buffer, buffer.length);
				if (MKV == null) {
					addChild(tf);
					MKV = new MKVFile(buffer);
				} else {
					MKV.update();
				}
				System.gc();
			}
			
		}
		
		private function fileSelected(e:Event) {
			/*
				trace("Started Loading");
				fr.load();
			*/
			
		}
		
		private function fileLoaded(e:Event):void {
			
			if (urlStream.bytesAvailable > 0) {
				urlStream.readBytes(buffer, buffer.length);
				MKV.update();
			}
			
			urlStream.removeEventListener(ProgressEvent.PROGRESS, readBuffer);
			urlStream.removeEventListener(Event.COMPLETE, fileLoaded);
			urlStream.close();
			urlStream = null;

			
			removeChild(tf);
			System.gc();
			
			var flvFile:ByteArray = new ByteArray();
			
			MKV.startFLV(flvFile);
			
			for each(var f:Frame in MKV.index) {
				f.flvInsert(MKV, flvFile);
			}
			
			fr.save(flvFile, "test.flv");
			
		}
		
	}
	
}
