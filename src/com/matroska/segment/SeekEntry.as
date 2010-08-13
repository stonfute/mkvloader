package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class SeekEntry extends EBMLElement
	{
		public var vSeekID:uint;
		public var vSeekPosition:uint;

		public function SeekEntry(MKV:MKVFile, pos:uint)
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

				cTagSize = getEBMLValue(ptr,ptr.position);

				switch (cTagId)
				{
					case SeekID :
						this.vSeekID = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case SeekPosition :
						this.vSeekPosition = ByteUtils.readUInt(ptr,cTagSize);
						break;


					default :
						trace("\t\tIgnored tag ID in Seek Entry : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}