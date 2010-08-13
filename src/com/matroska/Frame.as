package com.matroska {
	import flash.utils.ByteArray;

	public final class Frame {
		
		
		private var lacingType:uint;
		private var trackID:uint;
		private var isKey:Boolean = false;
		private var dPos:uint;
		private var dSize:uint;
		private var fTimestamp:uint; //First frame timestamp, in case of lacing, will increment by default_duration of this track
		private var isCodecPrivate:Boolean = false;
		
		public function Frame(trackID:uint, dPos:uint, dSize:uint, fTimestamp:uint, isKey:Boolean = false, lacingType:uint = 0, isCodecPrivate:Boolean = false) {
			this.trackID = trackID;
			this.dPos = dPos;
			this.dSize = dSize;
			this.fTimestamp = fTimestamp;
			this.isKey = isKey;
			this.lacingType = lacingType;
			this.isCodecPrivate = isCodecPrivate;
		}
		
		public function flvInsert(mkvFile:MKVFile, outputBuffer:ByteArray):void {
			//TODO var trackInfo:TrackEntry = mkvFile.getTrackInfo(trackID); 
			//Etc ...
		}
		
	}
}