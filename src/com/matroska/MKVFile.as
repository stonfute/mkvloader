package com.matroska
{
	import flash.utils.ByteArray;
	import flash.system.System;
	import com.matroska.segment.SegmentTrackEntry;

	public class MKVFile
	{

		public var buffer:ByteArray = null;
		public var segment:Segment = null;

		public var currentAudioTrack:uint = 0;
		public var currentVideoTrack:uint = 0;
		public var currentSubtitleTrack:uint = 0;

		public var index:Vector.<Frame >  = new Vector.<Frame >   ;

		public function MKVFile(mkvFile:ByteArray)
		{
			buffer = mkvFile;
			var ebml:EBML = new EBML(this,buffer.position);
			segment = new Segment(this,buffer.position);

		}

		public function update()
		{
			segment.update();
		}

		public function getTrackInfo(trackID:uint):SegmentTrackEntry
		{
			for each (var trackEntry:SegmentTrackEntry in segment.tracks.trackEntries)
			{
				if (trackEntry.trackNumber == trackID)
				{
					return trackEntry;
				}
			}
			return null;
		}


		public function startFLV(flvBuffer:ByteArray):void
		{
			flvBuffer.writeByte(0x46);
			flvBuffer.writeByte(0x4C);
			flvBuffer.writeByte(0x56);
			flvBuffer.writeByte(0x01);
			flvBuffer.writeByte(0x01);
			//Video+Audio;
			flvBuffer.writeUnsignedInt(0x00000009);
			flvBuffer.writeUnsignedInt(0x00000000);
		}


	}

}