package com.matroska.segment
{
	import com.matroska.EBMLElement;
	import com.matroska.MKVFile;
	
	public class Clusters extends EBMLElement
	{

		public function Clusters(MKV:MKVFile, pos:uint)
		{
			readTag(MKV.buffer, pos);
		}
	}

}