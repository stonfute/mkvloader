package com.matroska.segment
{

	public class Tags extends EBMLElement
	{

		public function Tags(MKV:MKVFile, pos:uint)
		{
			readTag(MKV.buffer, pos);
		}
	}

}