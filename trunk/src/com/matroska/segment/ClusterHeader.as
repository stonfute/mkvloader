package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class ClusterHeader extends EBMLElement
	{
		public var vTimecode:uint;
		public var vPosition:uint;
		public var vPrevSize:uint;
		public var vBlockGroup:Vector.<BlockGroupEntry >  = new Vector.<BlockGroupEntry >   ;
		//public var vSilentTracks:SilentTracksEntry;
		//public var vSimpleBlock:ByteArray;

		private var MKV:MKVFile;

		public function ClusterHeader(MKV:MKVFile, pos:uint)
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
					case Timecode :
						this.vTimecode = ByteUtils.readUInt(ptr,cTagSize);
						trace("\tTimecode : " + this.vTimecode);
						break;

					case Position :
						this.vPosition = ByteUtils.readUInt(ptr,cTagSize);
						trace("\tPosition : " + this.vPosition);
						break;

					case PrevSize :
						this.vPrevSize = ByteUtils.readUInt(ptr,cTagSize);
						trace("\tPrevSize : " + this.vPrevSize);
						break;

					case SimpleBlock :
						trace("\tSimpleBlock : " + cTagSize + "bytes");
						

						var leadingBits:uint = ptr[ptr.position];
						var trackIDSize:uint;

						if (leadingBits >= 128)
						{
							//PoC code, only here temporary
							if ((leadingBits&0x7F) == 1) { //Will only play track 1
								ptr.position++;
								var rTs:uint = ByteUtils.readSInt(ptr, 2);
								trace("\t\tTimecode : " + rTs);
								var flags:uint = ptr.readUnsignedByte();
								var keyframe:Boolean = false;
								if (flags&0x80) {
									keyframe = true;
								}
								//Add to FLV Buffer
								
								MKV.appendFrame(0x09, cTagSize - 4, this.vTimecode + rTs, ptr.position, keyframe);
								
								ptr.position +=  cTagSize - 4 ;
							} else {
								ptr.position +=  cTagSize ;
							}
						} else {
							ptr.position +=  cTagSize ;
						}
						
						break;

					case BlockGroup :
						trace("\tBlockGroup : ");
						ptr.position = initialPos;
						this.vBlockGroup.push(new BlockGroupEntry(MKV, initialPos, this.vTimecode));
						break;

					default :
						trace("\tIgnored tag ID in Cluster Header : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}