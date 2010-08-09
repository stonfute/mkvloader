package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class CueTrackPosition extends EBMLElement
	{
		public var vCueTrack:uint;
		public var vCueClusterPosition:uint;
		public var vCueBlockNumber:uint;
		public var vCueCodecState:uint;
		
		public function CueTrackPosition(MKV:MKVFile, pos:uint)
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
					case CueTrack:
						this.vCueTrack = ByteUtils.readUInt(ptr, cTagSize)
						trace("\t\t\tCueTrack : " + this.vCueTrack);
						break;

					case CueClusterPosition:
						this.vCueClusterPosition = ByteUtils.readUInt(ptr, cTagSize)
						trace("\t\t\tCueClusterPosition : " + this.vCueClusterPosition);
						break;

					case CueBlockNumber:
						this.vCueBlockNumber = ByteUtils.readUInt(ptr, cTagSize)
						trace("\t\t\tCueBlockNumber : " + this.vCueBlockNumber);
						break;

					case CueCodecState:
						this.vCueCodecState = ByteUtils.readUInt(ptr, cTagSize)
						trace("\t\t\tCueCodecState : " + this.vCueCodecState);
						break;

					default :
						trace("\t\t\tIgnored tag ID in Cue Track Positions : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}