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
		public var video:uint;
		public var audio:uint;

		public function SegmentTrackEntry(MKV:MKVFile, pos:uint)
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
					case TrackNumber :
						this.trackNumber = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tTrackNumber : " + this.trackNumber);
						break;
					case TrackUID :
						this.trackUID = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tTrackUID : " + this.trackUID);
						break;
					case TrackType :
						this.trackType = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tTrackType : " + this.trackType);
						break;
					case FlagEnabled :
						this.flagEnabled = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tflagEnabled : " + this.flagEnabled);
						break;
					case FlagDefault :
						this.flagDefault = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tflagDefault : " + this.flagDefault);
						break;
					case FlagForced :
						this.flagForced = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tflagForced : " + this.flagForced);
						break;
					case FlagLacing :
						this.flagLacing = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tflagLacing : " + this.flagLacing);
						break;
					case MinCache :
						this.minCache = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tMin Cache : " + this.minCache);
						break;
					case TrackTimecodeScale :
						this.trackTimecodeScale = ByteUtils.readFNum(ptr,cTagSize);
						trace("\t\tTrack Timecode Scale : " + this.trackTimecodeScale);
						break;
					case MaxBlockAdditionID :
						this.maxBlockAdditionID = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tMax Block Addition ID : " + this.maxBlockAdditionID);
						break;
					case CodecID :
						this.codecID = ByteUtils.readStr(ptr,cTagSize);
						trace("\t\tCodec ID : " + this.codecID);
						break;
					case CodecDecodeAll :
						this.codecDecodeAll = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tCodec Decode All : " + this.codecDecodeAll);
						break;
					case CodecPrivate :
						this.codecPrivate = new ByteArray();
						ptr.readBytes(this.codecPrivate, 0, cTagSize);
						trace("\t\tCodec Private : " + this.codecPrivate);
						break;
					case DefaultDuration :
						this.defaultDuration = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tDefault Duration : " + this.defaultDuration);
						break;
					case Language :
						this.language = ByteUtils.readStr(ptr,cTagSize);
						trace("\t\tLanguage : " + this.language);
						break;
					case Name :
						this.name = ByteUtils.readStr(ptr,cTagSize);
						trace("\t\tName : " + this.name);
						break;
					case Video :
						trace("\t\tVideo Track Info (Skipped)");
						ptr.position +=  cTagSize;
						break;
					case Audio :
						trace("\t\tAudio Track Info (Skipped)");
						ptr.position +=  cTagSize;
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