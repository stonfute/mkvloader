package com.matroska
{
	import flash.utils.ByteArray;

	public class MKVFile
	{

		public var buffer:ByteArray = null;
		public var EBMLs:Vector.<EBML >  = new Vector.<EBML >   ;

		public function MKVFile(mkvFile:ByteArray)
		{
			buffer = mkvFile;
			var ebml:EBML = new EBML(this,buffer.position);
			var segment:Segment = new Segment(this,buffer.position);
		}

	}

}