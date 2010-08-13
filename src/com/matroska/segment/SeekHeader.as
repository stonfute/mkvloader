package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class SeekHeader extends EBMLElement
	{
		public var seeks:Vector.<SeekEntry >  = new Vector.<SeekEntry >   ;
		private var MKV:MKVFile;

		public function SeekHeader(MKV:MKVFile, pos:uint)
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
					case Seek :
						ptr.position = initialPos;
						seeks.push(new SeekEntry(MKV, initialPos));
						break;
					default :
						trace("\tIgnored tag ID in Seek Header : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}