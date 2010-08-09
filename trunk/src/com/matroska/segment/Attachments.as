package com.matroska.segment
{

	public final class Attachments extends EBMLElement
	{

		public function Attachments(MKV:MKVFile, pos:uint)
		{
			readTag(MKV.buffer, pos);
		}

	}

}