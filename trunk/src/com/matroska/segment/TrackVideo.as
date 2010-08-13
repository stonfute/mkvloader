package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class TrackVideo extends EBMLElement
	{
		public var flagInterlaced:uint = 0;
		public var stereoMode:uint = 0;
		public var pixelWidth:uint;
		public var pixelHeight:uint;
		public var pixelCropBottom:uint = 0;
		public var pixelCropTop:uint = 0;
		public var pixelCropLeft:uint = 0;
		public var pixelCropRight:uint = 0;
		public var displayWidth:uint;
		public var displayHeight:uint;
		public var displayUnit:uint = 0;
		public var aspectRatioType:uint = 0;
		public var colourSpace:uint;
		public var frameRate:Number;



		public function TrackVideo(MKV:MKVFile, pos:uint)
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
					case FlagInterlaced :
						this.flagInterlaced = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case StereoMode :
						this.stereoMode = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case PixelWidth :
						this.pixelWidth = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case PixelHeight :
						this.pixelHeight = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case PixelCropBottom :
						this.pixelCropBottom = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case PixelCropTop :
						this.pixelCropTop = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case PixelCropLeft :
						this.pixelCropLeft = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case PixelCropRight :
						this.pixelCropRight = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case DisplayWidth :
						this.displayWidth = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case DisplayHeight :
						this.displayHeight = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case DisplayUnit :
						this.displayUnit = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case AspectRatioType :
						this.aspectRatioType = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case ColourSpace :
						this.colourSpace = ByteUtils.readUInt(ptr,cTagSize);
						break;

						/*
						case GammaValue :
						this.gammaValue = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tGammaValue : " + this.gammaValue);
						break;
						*/

					case FrameRate :
						this.frameRate = ByteUtils.readFNum(ptr,cTagSize);
						break;

					default :
						trace("\t\t\tIgnored tag ID in Video Entry : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}