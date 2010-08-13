package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class AttachedFileEntry extends EBMLElement
	{

		public var vFileDescription:String;
		public var vFileName:String;
		public var vFileMimeType:String;
		
		public var dPos:uint;
		public var dSize:uint;
		
		public var vFileUID:uint;

		public function AttachedFileEntry (MKV:MKVFile, pos:uint)
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
					case FileDescription :
						this.vFileDescription = ByteUtils.readStr(ptr,cTagSize);
						break;

					case FileName :
						this.vFileName = ByteUtils.readStr(ptr,cTagSize);
						break;

					case FileMimeType :
						this.vFileMimeType = ByteUtils.readStr(ptr,cTagSize);
						break;

					case FileData :
						dPos = ptr.position;
						dSize = cTagSize;
						ptr.position +=  cTagSize;
						break;

					case FileUID :
						this.vFileUID = ByteUtils.readUInt(ptr,cTagSize);
						break;

					default :
						trace("\t\t\tIgnored tag ID in File Attachment : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}

				readData +=  ptr.position - initialPos;

			}
		}
	}

}