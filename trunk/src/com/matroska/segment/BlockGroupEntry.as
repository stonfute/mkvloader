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

		public var keyframe:Boolean = true;
		public var track:uint = 0;
		public var pTimecode:uint;
		public var timecode:uint = 0;
		public var dPos:uint = 0;
		public var dSize:uint = 0;
		
		
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

				cTagSize = getDataSize(ptr,ptr.position);

				switch (cTagId)
				{
					case Block :

						trace("\t\tBlock : " + cTagSize + "bytes");

						var leadingBits:uint = ptr[ptr.position];
						var trackIDSize:uint;

						if (leadingBits >= 128)
						{
							//PoC code, only here temporary
							if ((leadingBits&0x7F) == 1) { //Will only play track 1
								
								ptr.position++;
								track = 1;
								timecode = ByteUtils.readSInt(ptr, 2);
								ptr.position++;
								trace("\t\t\tTimecode : " + timecode);
								
								dPos = ptr.position;
								dSize = cTagSize - 4;
								
								ptr.position +=  cTagSize - 4;
							} else {								
								ptr.position +=  cTagSize ;
							}
						} else {
							ptr.position +=  cTagSize ;
						}

						break;

					case BlockDuration :
						this.vBlockDuration = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tBlockDuration : " + this.vBlockDuration);
						break;

					case ReferencePriority :
						this.vReferencePriority = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tReferencePriority : " + this.vReferencePriority);
						break;

					case ReferenceBlock :
						this.vReferenceBlock = ByteUtils.readSInt(ptr,cTagSize);
						trace("\t\tReferenceBlock : " + this.vReferenceBlock);
						if (this.vReferenceBlock != 0) {
							this.keyframe = false;
						} else {
							trace("Ref 0, keyframe");
						}
						break;


					default :
						trace("\tIgnored tag ID in Cluster Header : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}
				

				
				readData +=  ptr.position - initialPos;

			}
			if (track == 1) { //Add to FLV Buffer
				MKV.appendFrame(0x09, dSize, timecode + pTimecode, dPos, keyframe);
			}
		}
	}

}