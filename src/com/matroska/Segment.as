package com.matroska
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	
	
	public final class Segment extends EBMLElement {;
	
	public var clusters:Vector.<ClusterHeader> = new Vector.<ClusterHeader>;
	public var seekHeaders:Vector.<SeekHeader> = new Vector.<SeekHeader>;
	
	public var attachments:Attachment = null;
	//public var chapters:Chapters = null;
	public var cue:CueHeader = null;
	public var info:SegmentInfo;
	//public var tags:Tags = null;
	public var tracks:SegmentTracks = null;
	
	private var MKV:MKVFile;
	
	public function Segment(MKV:MKVFile, pos:uint)
	{
		this.MKV = MKV;
		
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

			

			cTagSize = getDataSize(ptr,ptr.position);


			switch (cTagId)
			{
				case SeekHead :
					trace("Seek Header - " + cTagSize + " bytes");
					ptr.position = initialPos;
					seekHeaders.push(new SeekHeader(MKV, initialPos));
					break;
				case VOID :
					trace("VOID - " + cTagSize + " bytes");
					ptr.position +=  cTagSize;
					break;
				case Info :
					trace("Info - " + cTagSize + " bytes");
					ptr.position = initialPos;
					info = new SegmentInfo(MKV, initialPos);
					break;
				case Cues :
					trace("Cues - " + cTagSize + " bytes");
					ptr.position = initialPos;
					cue = new CueHeader(MKV, initialPos);
					break;
				case Tracks :
					trace("Tracks - " + cTagSize + " bytes");
					ptr.position = initialPos;
					tracks = new SegmentTracks(MKV, initialPos);
					break;
				case Attachments :
					trace("Attachments - " + cTagSize + " bytes");
					ptr.position = initialPos;
					attachments = new Attachment(MKV, initialPos);
					break;
				case Cluster :
					trace("Cluster - " + cTagSize + " bytes");
					ptr.position = initialPos;
					clusters.push(new ClusterHeader(MKV, initialPos));
					break;
				case Chapters :
					trace("Chapters - " + cTagSize + " bytes");
					ptr.position +=  cTagSize;
					break;
				default :
					trace("Unknow tag ID in EBML Header : " + cTagId.toString(16));
					ptr.position +=  cTagSize;
					break;
			}

			readData +=  ptr.position - initialPos;
			
		}
	}
}

}