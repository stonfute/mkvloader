package com.matroska
{
	import flash.utils.ByteArray;
	import com.matroska.utils.ByteUtils;

	public final class EBML extends EBMLElement {;

	public var version:uint = 1;
	public var readVersion:uint = 1;
	public var maxIDLength:uint = 4;
	public var maxSizeLength:uint = 8;
	public var docType:String = "matroska";
	public var docTypeVersion:uint = 1;
	public var docTypeReadVersion:uint = 1;

	public function EBML(MKV:MKVFile, pos:uint)
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

				case EBMLVersion :
					version = ByteUtils.readUInt(ptr,cTagSize);
					break;
				case EBMLReadVersion :
					readVersion = ByteUtils.readUInt(ptr,cTagSize);
					break;
				case EBMLMaxIDLength :
					maxIDLength = ByteUtils.readUInt(ptr,cTagSize);
					break;
				case EBMLMaxSizeLength :
					maxSizeLength = ByteUtils.readUInt(ptr,cTagSize);
					break;
				case DocType :
					docType = ByteUtils.readStr(ptr,cTagSize);
					break;
				case DocTypeVersion :
					docTypeVersion = ByteUtils.readUInt(ptr,cTagSize);
					break;
				case DocTypeReadVersion :
					docTypeReadVersion = ByteUtils.readUInt(ptr,cTagSize);
					break;
				default :
					trace("Unknow tag ID in EBML Header : " + cTagId.toString(16));
					ptr.position +=  cTagSize;
					break;
			}
			
			readData +=  ptr.position - initialPos;

		}
	}


	public function toString():String
	{
		return "EBML Header :\n" +
		"Version : " + version + "\n" +
		"Read Version : " + readVersion +  "\n" +
		"Max ID Length : " + maxIDLength +  "\n" +
		"Max Size Length : " + maxSizeLength +  "\n" +
		"DocType : " + docType +  "\n" +
		"DocType Version : " + docTypeVersion +  "\n" +
		"DocType Read Version : " + docTypeReadVersion;
	}

}

}