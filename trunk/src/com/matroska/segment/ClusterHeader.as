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

				cTagSize = getEBMLValue(ptr,ptr.position);
				
				switch (cTagId)
				{
					case Timecode :
						this.vTimecode = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case Position :
						this.vPosition = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case PrevSize :
						this.vPrevSize = ByteUtils.readUInt(ptr,cTagSize);
						
						break;

					case SimpleBlock :
					
						var bTimecode:uint;
						var bTrackID:uint;
						var bLacingType:uint;
						var bKeyFrame:Boolean = false;
						var bFlag:uint;
						var bHeaderSize:uint;
						var cPos:uint = ptr.position;
						
						bTrackID = getEBMLValue(ptr, ptr.position);
						bTimecode = vTimecode + ByteUtils.readSInt(ptr, 2);
						bFlag = ptr.readUnsignedByte();
						bKeyFrame = (((bFlag & 0x80)>>7) == 1) ? true : false;
						bLacingType = (bFlag & 0x06)>>1;
						bHeaderSize =  ptr.position - cPos;
						MKV.index.push(new Frame(bTrackID, ptr.position, bHeaderSize, bTimecode, bKeyFrame, bLacingType));
						
						ptr.position +=  cTagSize - bHeaderSize ;
						break;

					case BlockGroup :
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