package com.matroska
{
	import flash.utils.ByteArray;
	import flash.net.FileReference;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.System;

	public class MKVFile
	{

		public var buffer:ByteArray = null;
		
		public var flvBuffer:ByteArray = new ByteArray();
		private var lastSize:uint = 0;
		
		public var Segments:Vector.<Segment>  = new Vector.<Segment>;
		private var nc:NetConnection = new NetConnection();
		private var ns:NetStream;
		
		public function MKVFile(mkvFile:ByteArray)
		{
			buffer = mkvFile;
			
			var myVideo:Video = new Video(1280,720); 
			
            nc.connect(null);             
           	ns = new NetStream(nc);
            ns.client = new Object();
            myVideo.attachNetStream(ns);
			ns.play(null);
			ns.togglePause();

			var ebml:EBML = new EBML(this,buffer.position);
			var segment:Segment = new Segment(this,buffer.position);
			
			MKVP.INSTANCE.addChild(myVideo);
          	buffer.clear();
			buffer = null;
			Segments = null;
			new Object();
			new Object();
			new Object();
			System.gc();
			System.gc();
			ns.togglePause();
			MKVP.INSTANCE.stage.frameRate = 5; 

		}
		
		public function startFrame(type:uint, dSize:uint, timestamp:uint, dPos:uint):void { //Codec private data write

			if (type == 9) { //Video
				var bodySize:uint = 0;
				
				flvBuffer.writeByte(0x46);
				flvBuffer.writeByte(0x4C);
				flvBuffer.writeByte(0x56);
				flvBuffer.writeByte(0x01);
				flvBuffer.writeByte(0x01); //Only video
				flvBuffer.writeUnsignedInt(0x09);
				
				flvBuffer.writeUnsignedInt(lastSize); //prevTagSize
				//FLV TAG
					flvBuffer.writeByte(0x09); bodySize++; //Tag Type
					flvBuffer.writeUnsignedInt((dSize+5)<<8); flvBuffer.position--; bodySize+=3; //Data Size
					flvBuffer.writeUnsignedInt((timestamp)<<8); flvBuffer.position--; bodySize+=3; //TimeStamp
					flvBuffer.writeByte((timestamp)>>24);bodySize++; //TimeStamp Extended
					flvBuffer.writeByte(0);flvBuffer.writeByte(0);flvBuffer.writeByte(0);bodySize += 3; //Stream ID
					//VIDEODATA
						flvBuffer.writeByte(0x17);bodySize++;
							//AVCVIDEOPACKET
							flvBuffer.writeByte(0x0);bodySize++; // AVCPacketType - AVC NALU Sequence Start
							flvBuffer.writeByte(0);flvBuffer.writeByte(0);flvBuffer.writeByte(0);bodySize += 3; //Composition Time
							flvBuffer.writeBytes(buffer, dPos, dSize);bodySize += dSize;
				
				lastSize = bodySize;
			}
			

		}
		
		public function appendFrame(type:uint, dSize:uint, timestamp:uint, dPos:uint, keyframe:Boolean):void {

			var bodySize:uint = 0;
			if (type == 9) { //Video
				flvBuffer.writeUnsignedInt(lastSize); //prevTagSize
				//FLV TAG
					flvBuffer.writeByte(0x09); bodySize++; //Tag Type
					flvBuffer.writeUnsignedInt((dSize+5)<<8); flvBuffer.position--; bodySize+=3; //Data Size
					flvBuffer.writeUnsignedInt((timestamp)<<8); flvBuffer.position--; bodySize+=3; //TimeStamp
					flvBuffer.writeByte((timestamp)>>24);bodySize++; //TimeStamp Extended
					flvBuffer.writeByte(0);flvBuffer.writeByte(0);flvBuffer.writeByte(0);bodySize += 3; //Stream ID
					//VIDEODATA
						if (keyframe) {
							flvBuffer.writeByte(0x17);
						} else {
							flvBuffer.writeByte(0x27);
						}
						bodySize++;
							//AVCVIDEOPACKET
							flvBuffer.writeByte(0x1);bodySize++; // AVCPacketType - AVC NALU
							flvBuffer.writeByte(0);flvBuffer.writeByte(0);flvBuffer.writeByte(0);bodySize += 3; //Composition Time
							flvBuffer.writeBytes(buffer, dPos, dSize);bodySize += dSize;
				
				lastSize = bodySize;
			}
			//if (flvBuffer.position >= 1024*1024*10) {
				ns.appendBytes(flvBuffer);
				flvBuffer.clear();
			//}
			
		}

	}

}