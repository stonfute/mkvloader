package com.matroska.segment
{

	public class Cues extends EBMLElement
	{

		public function Cues(MKV:MKVFile, pos:uint)
		{
			readTag(MKV.buffer, pos);
		}

	}

}