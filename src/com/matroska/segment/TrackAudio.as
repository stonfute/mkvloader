﻿package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class TrackAudio extends EBMLElement
	{
		public var vSamplingFrequency:Number = 8000.0;
		public var vOutputSamplingFrequency:Number;
		public var vChannels:uint = 1;
		public var vBitDepth:uint;

		public function TrackAudio(MKV:MKVFile, pos:uint)
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
					case SamplingFrequency :
						this.vSamplingFrequency = ByteUtils.readFNum(ptr,cTagSize);
						break;

					case OutputSamplingFrequency :
						this.vOutputSamplingFrequency = ByteUtils.readFNum(ptr,cTagSize);
						break;

					case Channels :
						this.vChannels = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case BitDepth :
						this.vBitDepth = ByteUtils.readUInt(ptr,cTagSize);
						break;

					default :
						trace("\t\t\tIgnored tag ID in Audio Entry : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}