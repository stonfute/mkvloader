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

		public static const BUFFERSIZE:uint = 395264;
		public static const CACHETIME:uint = 20;

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

		private var cacheTimer:Timer = new Timer(2000);


		public function MatroskaVideo(url:String, cacheTime:uint = CACHETIME, bufferSize:uint = BUFFERSIZE)
		{
			super(1920,1080);
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
			System.gc();
			if (ns.bufferLength < cacheTime / 2)
			{
				for (var i:uint = cacheIndex; i < MKV.index.length; i++)
				{
					if (ns.bufferLength >= cacheTime)
					{
						System.gc();
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
				System.gc();
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