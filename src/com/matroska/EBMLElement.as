package com.matroska
{
	import flash.utils.ByteArray;
	import com.matroska.utils.ByteUtils;
	import com.matroska.*;
	import com.matroska.segment.*;
	
	public class EBMLElement extends EBMLTagName
	{

		public var tag:uint;
		public var tagSize:uint;
		public var dataSize:Number;
		public var elementOffset:uint;

		protected function readTag(ptr:ByteArray, pos:uint):void
		{

			var leadingBits:uint = ptr[pos] >> 4;

			if (leadingBits >= 8)
			{
				tagSize = 1;
			}
			else if (leadingBits >= 4)
			{
				tagSize = 2;
			}
			else if (leadingBits >= 2)
			{
				tagSize = 3;
			}
			else if (leadingBits == 1)
			{
				tagSize = 4;
			}
			else
			{
				throw new Error("Not a valid Tag");
			}

			tag = ByteUtils.readUInt(ptr,tagSize);

			leadingBits = ptr[pos + tagSize];

			if (leadingBits >= 128)
			{

				dataSize = ByteUtils.readUInt(ptr,1) & 0x7F;
			}
			else if (leadingBits >= 64)
			{
				dataSize = ByteUtils.readUInt(ptr,2) & 0x3FFF;
			}
			else if (leadingBits >= 32)
			{
				dataSize = ByteUtils.readUInt(ptr,3) & 0x1FFFFF;
			}
			else if (leadingBits >= 16)
			{
				dataSize = ByteUtils.readUInt(ptr,4) & 0xFFFFFFF;
			}
			else if (leadingBits >= 8)
			{
				dataSize = ByteUtils.readUInt(ptr,5) << 25 >> 25;
			}
			else if (leadingBits >= 4)
			{
				dataSize = ByteUtils.readUInt(ptr,6) << 17 >> 17;
			}
			else if (leadingBits >= 2)
			{
				dataSize = ByteUtils.readUInt(ptr,7);//Only 48BITS - Truncated
			}
			else if (leadingBits == 1)
			{
				dataSize = ByteUtils.readUInt(ptr,8);//Only 48BITS - Truncated
			}
			else
			{
				throw new Error("Not a valid data size");
			}

		}

		protected function getTagID(ptr:ByteArray, pos:uint):uint
		{

			var leadingBits:uint = ptr[pos] >> 4;

			if (leadingBits >= 8)
			{
				return ByteUtils.readUInt(ptr, 1);
			}
			else if (leadingBits >= 4)
			{
				return ByteUtils.readUInt(ptr, 2);
			}
			else if (leadingBits >= 2)
			{
				return ByteUtils.readUInt(ptr, 3);
			}
			else if (leadingBits == 1)
			{
				return ByteUtils.readUInt(ptr, 4);
			}
			else
			{
				throw new Error("Not a valid Tag");
			}

		}

		protected function getDataSize(ptr:ByteArray, pos:uint):Number
		{
			var leadingBits:uint = ptr[pos];

			if (leadingBits >= 128)
			{
				return ByteUtils.readUInt(ptr, 1) & 0x7F;
			}
			else if (leadingBits >= 64)
			{
				return ByteUtils.readUInt(ptr, 2) & 0x3FFF;
			}
			else if (leadingBits >= 32)
			{
				return ByteUtils.readUInt(ptr, 3) & 0x1FFFFF;
			}
			else if (leadingBits >= 16)
			{
				return ByteUtils.readUInt(ptr, 4) & 0xFFFFFFF;
			}
			else if (leadingBits >= 8)
			{
				return ByteUtils.readUInt(ptr, 5) << 25 >> 25;
			}
			else if (leadingBits >= 4)
			{
				return ByteUtils.readUInt(ptr, 6) << 17 >> 17;
			}
			else if (leadingBits >= 2)
			{
				return ByteUtils.readUInt(ptr, 7);//Only 48BITS - Truncated
			}
			else if (leadingBits == 1)
			{
				return ByteUtils.readUInt(ptr, 8);//Only 48BITS - Truncated
			}
			else
			{
				throw new Error("Not a valid data size");
			}
		}
	}

}