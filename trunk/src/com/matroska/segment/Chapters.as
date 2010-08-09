package com.matroska.segment
{

	public class Chapters extends EBMLElement
	{

		public function Chapters(MKV:MKVFile, pos:uint)
		{
			readTag(MKV.buffer, pos);
		}

	}

}