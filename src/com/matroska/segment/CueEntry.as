package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class CueEntry extends EBMLElement
	{
		private var MKV:MKVFile;
		
		public var vCueTime:uint;
		public var vCueTrackPositions:CueTrackPosition = null;
		
		
		public function CueEntry(MKV:MKVFile, pos:uint)
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

				cTagSize = getDataSize(ptr,ptr.position);

				switch (cTagId)
				{
					case CueTime:
						this.vCueTime = ByteUtils.readUInt(ptr, cTagSize)
						trace("\t\tCueTime : " + this.vCueTime);
						break;
					case CueTrackPositions:
						ptr.position = initialPos;
						trace("\t\tCue Track Position : ");
						this.vCueTrackPositions = new CueTrackPosition(MKV, initialPos);
						break;
					default :
						trace("\t\tIgnored tag ID in Cue Entry : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}