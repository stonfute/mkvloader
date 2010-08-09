package com.matroska.utils
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	
	//TODO : Use fastmem to use alchemy opcodes
	
	public final class ByteUtils {

	public static function readUInt(ptr:ByteArray, len:uint):Number
	{

		switch (len)
		{
			case 1 :
				return ptr.readUnsignedByte();
				break;

			case 2 :
				return ptr.readUnsignedShort();
				break;

			case 3 :
				ptr.position--;
				return ptr.readUnsignedInt() & 0x00FFFFFF;
				break;

			case 4 :
				return ptr.readUnsignedInt();
				break;

			case 5 :
				return ptr.readUnsignedByte() * 4294967296 + ptr.readUnsignedInt();
				break;

			case 6 :
				return ptr.readUnsignedShort() * 4294967296 + ptr.readUnsignedInt();
				break;

			case 7 :
				ptr.position +=  1;
				return ptr.readUnsignedShort() * 4294967296 + ptr.readUnsignedInt();
				break;

			case 8 :
				ptr.position +=  2;
				return ptr.readUnsignedShort() * 4294967296.0 + (Number)(ptr.readUnsignedInt());
				break;

			default :
				throw new Error("Integer bigger than 48bits aren't supported, blame as3. No matroska file would have data that big (255TB) for at least the next 20 years to come.");
				break;
		}
	}

	public static function readStr(ptr:ByteArray, len:uint):String
	{
		return ptr.readUTFBytes(len);
	}
	
	public static function readFNum(ptr:ByteArray, len:uint):Number {
		switch(len) {
			case 4:
				return ptr.readFloat();
			break;
			case 8:
				return ptr.readDouble();
			break;
			default:
				throw new Error(len + "bytes floating point numbers aren't supported yet ...");
			break;
		}
	}

}

}