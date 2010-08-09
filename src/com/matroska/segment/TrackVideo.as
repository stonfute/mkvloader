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

		//public var gammaValue:uint;



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

				cTagSize = getDataSize(ptr,ptr.position);

				switch (cTagId)
				{
					case FlagInterlaced :
						this.flagInterlaced = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tFlagInterlaced : " + this.flagInterlaced);
						break;

					case StereoMode :
						this.stereoMode = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tStereoMode : " + this.stereoMode);
						break;

					case PixelWidth :
						this.pixelWidth = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tPixelWidth : " + this.pixelWidth);
						break;

					case PixelHeight :
						this.pixelHeight = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tPixelHeight : " + this.pixelHeight);
						break;

					case PixelCropBottom :
						this.pixelCropBottom = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tPixelCropBottom : " + this.pixelCropBottom);
						break;

					case PixelCropTop :
						this.pixelCropTop = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tPixelCropTop : " + this.pixelCropTop);
						break;

					case PixelCropLeft :
						this.pixelCropLeft = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tPixelCropLeft : " + this.pixelCropLeft);
						break;

					case PixelCropRight :
						this.pixelCropRight = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tPixelCropRight : " + this.pixelCropRight);
						break;

					case DisplayWidth :
						this.displayWidth = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tDisplayWidth : " + this.displayWidth);
						break;

					case DisplayHeight :
						this.displayHeight = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tDisplayHeight : " + this.displayHeight);
						break;

					case DisplayUnit :
						this.displayUnit = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tDisplayUnit : " + this.displayUnit);
						break;

					case AspectRatioType :
						this.aspectRatioType = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tAspectRatioType : " + this.aspectRatioType);
						break;

					case ColourSpace :
						this.colourSpace = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tColourSpace : " + this.colourSpace);
						break;

						/*
						case GammaValue :
						this.gammaValue = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tGammaValue : " + this.gammaValue);
						break;
						*/

					case FrameRate :
						this.frameRate = ByteUtils.readFNum(ptr,cTagSize);
						trace("\t\t\tFrameRate : " + this.frameRate);
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