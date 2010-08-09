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
		public var vFileData:ByteArray;
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

				cTagSize = getDataSize(ptr,ptr.position);

				switch (cTagId)
				{
					case FileDescription :
						this.vFileDescription = ByteUtils.readStr(ptr,cTagSize);
						trace("\t\t\tFileDescription : " + this.vFileDescription);
						break;

					case FileName :
						this.vFileName = ByteUtils.readStr(ptr,cTagSize);
						trace("\t\t\tFileName : " + this.vFileName);
						break;

					case FileMimeType :
						this.vFileMimeType = ByteUtils.readStr(ptr,cTagSize);
						trace("\t\t\tFileMimeType : " + this.vFileMimeType);
						break;

					case FileData :

						trace("\t\t\tFileData is " + cTagSize + "bytes");
						ptr.position +=  cTagSize;
						break;

					case FileUID :
						this.vFileUID = ByteUtils.readUInt(ptr,cTagSize);
						trace("\t\t\tFileUID : " + this.vFileUID);
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