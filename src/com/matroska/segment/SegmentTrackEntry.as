package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class SegmentTrackEntry extends EBMLElement
	{
		public var trackNumber:uint;
		public var trackUID:uint;
		public var trackType:uint;
		public var flagEnabled:uint = 1;
		public var flagDefault:uint = 1;
		public var flagForced:uint = 0;
		public var flagLacing:uint = 1;
		public var minCache:uint = 0;
		public var trackTimecodeScale:Number = 1.0;
		public var maxBlockAdditionID:uint = 0;
		public var codecID:String;
		public var codecDecodeAll:uint = 1;
		public var codecPrivate:ByteArray;
		public var defaultDuration:uint;
		public var language:String = "eng";
		public var name:String;
		public var video:TrackVideo;
		public var audio:TrackAudio;
		public var contentEncodings:ContentEncodingHeader;
		
		private var MKV:MKVFile;
		
		public function SegmentTrackEntry(MKV:MKVFile, pos:uint)
		{
			this.MKV = MKV;
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

				cTagSize = getEBMLValue(ptr,ptr.position);

				switch (cTagId)
				{
					case TrackNumber :
						this.trackNumber = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case TrackUID :
						this.trackUID = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case TrackType :
						this.trackType = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case FlagEnabled :
						this.flagEnabled = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case FlagDefault :
						this.flagDefault = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case FlagForced :
						this.flagForced = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case FlagLacing :
						this.flagLacing = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case MinCache :
						this.minCache = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case TrackTimecodeScale :
						this.trackTimecodeScale = ByteUtils.readFNum(ptr,cTagSize);
						break;
					case MaxBlockAdditionID :
						this.maxBlockAdditionID = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case CodecID :
						this.codecID = ByteUtils.readStr(ptr,cTagSize);
						break;
					case CodecDecodeAll :
						this.codecDecodeAll = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case CodecPrivate :
						this.codecPrivate = new ByteArray();
						MKV.index.push(new Frame(trackNumber, ptr.position, cTagSize, 0, true, 0, true));
						ptr.position +=  cTagSize;
						break;
					case DefaultDuration :
						this.defaultDuration = ByteUtils.readUInt(ptr,cTagSize);
						break;
					case Language :
						this.language = ByteUtils.readStr(ptr,cTagSize);
						break;
					case Name :
						this.name = ByteUtils.readStr(ptr,cTagSize);
						break;
					case Video :
						ptr.position = initialPos;
						video = new TrackVideo(MKV, ptr.position);
						break;
					case Audio :
						ptr.position = initialPos;
						audio = new TrackAudio(MKV, ptr.position);
						break;
					case ContentEncodings :
						ptr.position = initialPos;
						contentEncodings = new ContentEncodingHeader(MKV, ptr.position);
						break;
					default :
						trace("\t\tIgnored tag ID in Track Entry : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}