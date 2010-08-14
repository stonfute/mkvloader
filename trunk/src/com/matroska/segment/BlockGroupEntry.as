package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class BlockGroupEntry extends EBMLElement
	{
		public var vBlock:ByteArray;
		public var vBlockDuration:uint;
		public var vReferencePriority:uint;
		public var vReferenceBlock:int;
		
		private var pTimecode:uint; //Parent -Cluster- Timecode
		private var blockIndex:Vector.<uint> = new Vector.<uint>(); //a BlockGroup can have more than one block, keep index and process them all at the end
		private var blockSize:Vector.<uint> = new Vector.<uint>(); //a BlockGroup can have more than one block, keep size and process them all at the end
		
		private var MKV:MKVFile;

		public function BlockGroupEntry(MKV:MKVFile, pos:uint, pTimecode:uint)
		{
			this.pTimecode = pTimecode;
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
					case Block :
						blockIndex.push(ptr.position);
						blockSize.push(cTagSize);
						ptr.position +=  cTagSize;
						break;

					case BlockDuration :
						this.vBlockDuration = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case ReferencePriority :
						this.vReferencePriority = ByteUtils.readUInt(ptr,cTagSize);
						break;

					case ReferenceBlock :
						this.vReferenceBlock = ByteUtils.readSInt(ptr,cTagSize);
						break;

					default :
						trace("\tIgnored tag ID in Cluster Header : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}
				

				
				readData +=  ptr.position - initialPos;

			}
			
			//Process blocks
			var savedPos:uint = ptr.position;
			
			while (blockIndex.length > 0) {
				var bTimecode:uint;
				var bTrackID:uint;
				var bLacingType:uint;
				var bSize:uint;
				var bKeyFrame:Boolean = false;
				var bHeaderSize:uint;
				var cPos:uint = blockIndex.pop();
				if (vReferenceBlock == 0) {
					bKeyFrame = true;
				}
				
				ptr.position = cPos;
				bSize = blockSize.pop();
				bTrackID = getEBMLValue(ptr, ptr.position);
				bTimecode = pTimecode + ByteUtils.readSInt(ptr, 2);
				bLacingType = (ptr.readUnsignedByte() & 0x06)>>1; //Lacing flag
				bHeaderSize = ptr.position - cPos;
				MKV.index.push(new Frame(bTrackID, ptr.position, bSize - bHeaderSize, bTimecode, bKeyFrame, bLacingType));
			}
			ptr.position = savedPos;
		}
	}

}