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
		
		private var tf:TextField = new TextField();
		private var mkvVideo:MatroskaVideo;
		public function MKVP() {
			mkvVideo = new MatroskaVideo("asset/MKVSample.mkv");
			
			mkvVideo.addEventListener("MKVDownloaded", proposeDownload);
			mkvVideo.addEventListener("MKVProgress", downloadProgress);
			
			mkvVideo.loadVideo();
			//mkvVideo.smoothing = true; //Do this only if you're scaling!
			addChild(mkvVideo);
			
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.textColor = 0xFFFFFF;
			tf.x = 0;
			tf.y = 480+tf.height+20;
			
			addChild(tf);
		}
		
		private function downloadProgress(e:ProgressEvent) {
			
			tf.text = "Downloading : " + (int)((e.bytesLoaded/e.bytesTotal)*100) + "%";
			tf.x = 0;
		}
		
		private function proposeDownload(e:Event) {
			tf.text = "Downloaded ! Click HERE to save the file to your harddisk.";
			tf.x = 0;
			tf.addEventListener(MouseEvent.CLICK, downloadMKV);
		}
		
		private function downloadMKV(e:MouseEvent) {
			var fr:FileReference = new FileReference();
			fr.save(mkvVideo.mkvFileBuffer, "myDownloadedFile.mkv");
		}
		
	}
	
}
