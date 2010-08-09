package com.matroska.segment
{
	import com.matroska.EBMLElement;
	import com.matroska.MKVFile;

	public class SeekHeader extends EBMLElement
	{

		public function SeekHeader(MKV:MKVFile, pos:uint)
		{
			readTag(MKV.buffer, pos);
		}

	}

}