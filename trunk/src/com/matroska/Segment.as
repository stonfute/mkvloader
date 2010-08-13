package com.matroska
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;


	public final class Segment extends EBMLElement {;

	public var clusters:Vector.<ClusterHeader >  = new Vector.<ClusterHeader >   ;
	public var seekHeaders:Vector.<SeekHeader >  = new Vector.<SeekHeader >   ;

	public var attachments:Attachment = null;
	public var cue:CueHeader = null;
	public var info:SegmentInfo;
	public var tracks:SegmentTracks = null;

	//public var chapters:Chapters = null;
	//public var tags:Tags = null;

	private var MKV:MKVFile;
	private var readData:Number = 0;
	private var missingBytes:uint = 0;

	public function Segment(MKV:MKVFile, pos:uint)
	{
		this.MKV = MKV;

		readTag(MKV.buffer, pos);
	}

	override protected function readTag(ptr:ByteArray, pos:uint):void
	{
		
		super.readTag(ptr, pos);

		/*
		Process Children
		*/

		while (readData != dataSize)
		{
			var initialPos:uint = ptr.position;
			var cTagId:uint = getTagID(ptr,initialPos);
			var cTagSize:Number = 0;

			cTagSize = getEBMLValue(ptr,ptr.position);

			if (ptr.bytesAvailable < cTagSize)
			{
				missingBytes = cTagSize;
				MKV.buffer.position = initialPos;//we roll back;
				return
			}

			switch (cTagId)
			{
				case SeekHead :
					ptr.position = initialPos;
					seekHeaders.push(new SeekHeader(MKV, initialPos));
					break;
				case VOID :
					ptr.position +=  cTagSize;
					break;
				case Info :
					ptr.position = initialPos;
					info = new SegmentInfo(MKV,initialPos);
					break;
				case Cues :
					ptr.position = initialPos;
					cue = new CueHeader(MKV,initialPos);
					break;
				case Tracks :
					ptr.position = initialPos;
					tracks = new SegmentTracks(MKV,initialPos);
					break;
				case Attachments :
					ptr.position = initialPos;
					attachments = new Attachment(MKV,initialPos);
					break;
				case Cluster :
					ptr.position = initialPos;
					clusters.push(new ClusterHeader(MKV, initialPos));
					break;
				case Chapters :
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

	public function update()
	{
		
		if (missingBytes < MKV.buffer.bytesAvailable)
		{
			var ptr:ByteArray = MKV.buffer;
			
			while (readData != dataSize)
			{
				var initialPos:uint = ptr.position;
				var cTagId:uint = getTagID(ptr,initialPos);
				var cTagSize:Number = 0;

				cTagSize = getEBMLValue(ptr,ptr.position);

				if (ptr.bytesAvailable < cTagSize)
				{
					MKV.buffer.position = initialPos;//we roll back;
					missingBytes = cTagSize;
					return;
				}

				switch (cTagId)
				{
					case SeekHead :
						ptr.position = initialPos;
						seekHeaders.push(new SeekHeader(MKV, initialPos));
						break;
					case VOID :
						ptr.position +=  cTagSize;
						break;
					case Info :
						ptr.position = initialPos;
						info = new SegmentInfo(MKV,initialPos);
						break;
					case Cues :
						ptr.position = initialPos;
						cue = new CueHeader(MKV,initialPos);
						break;
					case Tracks :
						ptr.position = initialPos;
						tracks = new SegmentTracks(MKV,initialPos);
						break;
					case Attachments :
						ptr.position = initialPos;
						attachments = new Attachment(MKV,initialPos);
						break;
					case Cluster :
						ptr.position = initialPos;
						clusters.push(new ClusterHeader(MKV, initialPos));
						break;
					case Chapters :
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

}