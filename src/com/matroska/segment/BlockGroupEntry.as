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
		public var vReferenceBlock:uint;

		private var MKV:MKVFile;

		public function BlockGroupEntry(MKV:MKVFile, pos:uint)
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
					case Block :

						trace("\t\tBlock : " + cTagSize + "bytes");
						ptr.position +=  cTagSize;

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
						this.vReferenceBlock = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\tReferenceBlock : " + this.vReferenceBlock);
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