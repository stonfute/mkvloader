package com.matroska.segment
{
	import flash.utils.ByteArray;
	import com.matroska.*;
	import com.matroska.segment.*;
	import com.matroska.utils.ByteUtils;

	public class SegmentTracks extends EBMLElement
	{
		public var trackEntries:Vector.<SegmentTrackEntry >  = new Vector.<SegmentTrackEntry >   ;
		private var MKV:MKVFile;
		public function SegmentTracks(MKV:MKVFile, pos:uint)
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

				cTagSize = getEBMLValue(ptr,ptr.position);

				switch (cTagId)
				{
					case TrackEntry :
						ptr.position = initialPos;
						trackEntries.push(new SegmentTrackEntry(MKV, initialPos));
						break;
					default :
						trace("\tIgnored tag ID in Tracks : " + cTagId.toString(16));
						ptr.position +=  cTagSize;
						break;
				}
				
				for each (var trackEntry:SegmentTrackEntry in trackEntries)
				{
					if (trackEntry.video != null) { //video track
						if (MKV.currentVideoTrack == 0) {
							MKV.currentVideoTrack = trackEntry.trackNumber;
						} else if (trackEntry.flagDefault) {
							MKV.currentVideoTrack = trackEntry.trackNumber;
						}
						continue;
					} else if (trackEntry.audio != null) { //audio track
						if (MKV.currentAudioTrack == 0) {
							MKV.currentAudioTrack = trackEntry.trackNumber;
						} else if (trackEntry.flagDefault) {
							MKV.currentAudioTrack = trackEntry.trackNumber;
						}
						continue;
					} else { //subtitle track
						if (MKV.currentSubtitleTrack == 0) {
							MKV.currentSubtitleTrack = trackEntry.trackNumber;
						} else if (trackEntry.flagDefault) {
							MKV.currentSubtitleTrack = trackEntry.trackNumber;
						}
						continue;
					}
				}
				readData +=  ptr.position - initialPos;

			}
		}
	}

}