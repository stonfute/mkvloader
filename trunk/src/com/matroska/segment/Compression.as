package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class Compression extends EBMLElement
	{
		public var compressionAlgo:uint = 0; //Zlib default
		
		public var compressionSettingsStart:uint;
		public var compressionSettingsSize:uint;
		
		private var MKV:MKVFile;

		public function Compression(MKV:MKVFile, pos:uint)
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
					case ContentCompAlgo:
						compressionAlgo = ByteUtils.readUInt(ptr, cTagSize);
						break;
					case ContentCompSettings:
						compressionSettingsStart = ptr.position;
						compressionSettingsSize = cTagSize;
						ptr.position +=  cTagSize;
						break;
					default :
						trace("\t\t\tIgnored tag ID in Content Compression : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}