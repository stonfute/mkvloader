package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public final class SegmentInfo extends EBMLElement
	{
		/* No way to support ordered chapters unless we stream and the client / server implement a protocol */
		
		/*
		public var segmentUID:ByteArray;
		public var segmentFilename:String;
		public var prevUID:ByteArray;
		public var prevFilename:String;
		public var nextUID:ByteArray;
		public var nextFilename:String;
		public var segmentFamily:ByteArray;
		public var chapterTranslate:ChapterTranslate;
											|-> public var chapterTranslateEditionUID:uint;
											|->public var chapterTranslateCodec:uint;
											`->public var chapterTranslateID:uint;
		public var dateUTC:Date;
		*/

		public var timecodeScale:uint = 1000000;
		public var duration:Number;
		
		public var title:String;
		public var muxingApp:String;
		public var writingApp:String;

		public function SegmentInfo(MKV:MKVFile, pos:uint)
		{
			readTag(MKV.buffer, pos);
		}
		override protected function readTag(ptr:ByteArray, pos:uint):void
		{
			var readData:Number = 0;
			super.readTag(ptr, pos);

			/*
			Process Children
			*/

			while (readData != dataSize)
			{
				var initialPos:uint = ptr.position;
				var cTagId:uint = getTagID(ptr,initialPos);
				var cTagSize:Number = 0;

				cTagSize = getDataSize(ptr,ptr.position);

				switch (cTagId)
				{
					case TimecodeScale :
						this.timecodeScale = ByteUtils.readUInt(ptr,cTagSize);
						trace("\tTimecodeScale", this.timecodeScale);
						break;
					case MuxingApp :
						this.muxingApp = ByteUtils.readStr(ptr,cTagSize);
						trace("\tMuxing App", this.muxingApp);
						break;
					case WritingApp :
						this.writingApp = ByteUtils.readStr(ptr,cTagSize);
						trace("\tWriting App", this.writingApp);
						break;
					case Duration :
						this.duration = ByteUtils.readFNum(ptr,cTagSize);
						trace("\tDuration", this.duration);
						break;
					case Title :
						this.title = ByteUtils.readStr(ptr,cTagSize);
						trace("\tTitle", this.title);
						break;
					default :
						trace("\tIgnored tag ID in Info : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}