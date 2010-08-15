package 
{
	import flash.media.Video;
	import flash.net.URLRequest;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import com.matroska.MKVFile;
	import flash.net.URLStream;
	import flash.system.System;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.NetStreamAppendBytesAction;

	public class MatroskaVideo extends Video
	{

		public static const BUFFERSIZE:uint = 1024*256;
		
		//seems to be the most correct cache time for minimum cpu usage/no lag during playback for 720p mkv
		public static const CACHETIME:uint = 5;
		private var cacheTimer:Timer = new Timer(2000);
		
		public var url:String;

		public var bufferSize:uint;
		public var cacheTime:uint;

		private var mkvFileBuffer:ByteArray = new ByteArray();
		private var cacheBuffer:ByteArray = new ByteArray();
		private var cacheIndex:uint = 0;

		public var MKV:MKVFile;
		private var urlStream:URLStream;
		private var urlRequest:URLRequest;

		private var nc:NetConnection = new NetConnection();
		private var ns:NetStream;

		


		public function MatroskaVideo(url:String, cacheTime:uint = CACHETIME, bufferSize:uint = BUFFERSIZE)
		{
			super(640,480);
			this.url = url;
			this.bufferSize = bufferSize;
			this.cacheTime = cacheTime;

		}

		public function loadVideo():void
		{
			var urlRequest:URLRequest = new URLRequest(url);
			urlStream = new URLStream();
			urlStream.addEventListener(ProgressEvent.PROGRESS, readBuffer);
			urlStream.addEventListener(Event.COMPLETE, fileLoaded);
			urlStream.load(urlRequest);
			nc.connect(null);
			if (ns == null) {
				ns = new NetStream(nc);
				attachNetStream(ns);
				ns.play(null);
			} else {
				ns.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
			}
			
			//ns.togglePause();
		}

		public function togglePause():void
		{
			ns.togglePause();
		}

		private function fillBuffer(e:TimerEvent):void
		{

			if (ns.bufferLength < cacheTime / 2)
			{
				
				for (var i:uint = cacheIndex; i < MKV.index.length; i++)
				{
					if (ns.bufferLength >= cacheTime) {
						break;
					}
					MKV.index[cacheIndex].flvInsert(MKV, cacheBuffer);
					ns.appendBytes(cacheBuffer);
					cacheBuffer.clear();
					cacheIndex++;
				}
			}

		}

		public function readBuffer(e:ProgressEvent):void
		{

			if (urlStream.bytesAvailable >= bufferSize)
			{
				urlStream.readBytes(mkvFileBuffer, mkvFileBuffer.length, bufferSize);
				if (MKV == null)
				{
					MKV = new MKVFile(mkvFileBuffer);
					MKV.startFLV(cacheBuffer);
					cacheTimer.addEventListener(TimerEvent.TIMER, fillBuffer);
					cacheTimer.start();
				}
				else
				{
					MKV.update();
				}
			}
		}

		public function fileLoaded(e:Event)
		{
			close();
		}

		public function close()
		{

			if (urlStream.bytesAvailable > 0)
			{
				urlStream.readBytes(mkvFileBuffer, mkvFileBuffer.length);
				MKV.update();
			}

			urlStream.removeEventListener(ProgressEvent.PROGRESS, readBuffer);
			urlStream.removeEventListener(Event.COMPLETE, fileLoaded);
			urlStream.close();
			urlStream = null;
			mkvFileBuffer.position = 0;
			System.gc();

		}

		public function clean()
		{
			close();
			cacheBuffer.clear();
			mkvFileBuffer.clear();
			MKV = null;
			cacheBuffer = null;
			mkvFileBuffer = null;
			System.gc();
		}

		private function onTrackInfosLoaded(e:Event)
		{

		}


	}
}