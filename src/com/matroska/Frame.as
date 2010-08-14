package com.matroska
{
	import flash.utils.ByteArray;
	import com.matroska.segment.SegmentTrackEntry;
	
	public final class Frame {
	
	
	private var lacingType:uint;
	private var trackID:uint;
	private var isKey:Boolean = false;
	private var dPos:uint;
	private var dSize:uint;
	private var fTimestamp:uint;//First frame timestamp, in case of lacing, will increment by default_duration of this track
	private var isCodecPrivate:Boolean = false;
	
	private var frameSize:Vector.<uint >  = new Vector.<uint >   ;
	
	public function Frame(trackID:uint, dPos:uint, dSize:uint, fTimestamp:uint, isKey:Boolean = false, lacingType:uint = 0, isCodecPrivate:Boolean = false)
	{
		this.trackID = trackID;
		this.dPos = dPos;
		this.dSize = dSize;
		this.fTimestamp = fTimestamp;
		this.isKey = isKey;
		this.lacingType = lacingType;
		this.isCodecPrivate = isCodecPrivate;
	}
	
	private function write(inputBuffer:ByteArray, flvBuffer:ByteArray, type:uint, start:uint, len:uint, ts:uint, track:SegmentTrackEntry):void
	{
		var bodySize:uint = 0;
	
		switch (type)
		{
			case 0x09 :
	
				switch (track.codecID)
				{
					case "V_MPEG4/ISO/AVC" :
					
						
						flvBuffer.writeByte(0x09); bodySize++;
						flvBuffer.writeUnsignedInt((len+5)<<8); flvBuffer.position--; bodySize +=  3;
						flvBuffer.writeUnsignedInt((ts)<<8); flvBuffer.position--; bodySize +=  3;
						flvBuffer.writeByte((ts)>>24); bodySize++;
						flvBuffer.writeUnsignedInt(0); flvBuffer.position--; bodySize +=  3;
	
						if (isKey)
							flvBuffer.writeByte(0x17);
						else
							flvBuffer.writeByte(0x27);
						
						bodySize++;
						
						if (isCodecPrivate)
							flvBuffer.writeByte(0x00);
						else
							flvBuffer.writeByte(0x01);
							
						bodySize++;
						
						flvBuffer.writeUnsignedInt(0); flvBuffer.position--; bodySize +=  3;
						flvBuffer.writeBytes(inputBuffer, inputBuffer.position, len); bodySize +=  len; inputBuffer.position += len;
						
						flvBuffer.writeUnsignedInt(bodySize);
						break;
					default ://Non supported format for now
						inputBuffer.position +=  len;
						break;
				}
	
				break;
	
			case 0x08 :
	
				switch (track.codecID)
				{
					case "A_AAC" :
						flvBuffer.writeByte(0x08); bodySize++;
						flvBuffer.writeUnsignedInt((len+2)<<8); flvBuffer.position--; bodySize +=  3;
						flvBuffer.writeUnsignedInt((ts)<<8); flvBuffer.position--; bodySize +=  3;
						flvBuffer.writeByte((ts)>>24); bodySize++;
						flvBuffer.writeUnsignedInt(0); flvBuffer.position--; bodySize +=  3;
	
						flvBuffer.writeByte(0xAF); //ID 1010 - SndRate 11 - SndSize 1 - SndType 1 | 1010 1111
						bodySize++;
						
						if (isCodecPrivate)
							flvBuffer.writeByte(0x00);
						else
							flvBuffer.writeByte(0x01);
							
						bodySize++;
						
						flvBuffer.writeBytes(inputBuffer, inputBuffer.position, len); bodySize +=  len; inputBuffer.position += len;
						
						flvBuffer.writeUnsignedInt(bodySize);
						
						break;
					default ://Non supported format for now
						inputBuffer.position +=  len;
						break;
				}
	
				break;
	
			case 0x16 ://Subtitles skipped for now
	
			default :
				inputBuffer.position +=  len;
				break;
		}
	
	}
	
	public function flvInsert(mkvFile:MKVFile, outputBuffer:ByteArray):void
	{
		var trackInfo:SegmentTrackEntry = mkvFile.getTrackInfo(trackID);
		var buffer:ByteArray = mkvFile.buffer;
	
		var type:uint;
		var nFrame:uint;
		var i:uint;
	
		switch (trackInfo.trackNumber)
		{
			case mkvFile.currentVideoTrack :
				type = 0x09;
				break;
			case mkvFile.currentAudioTrack :
				type = 0x08;
				break;
			case mkvFile.currentSubtitleTrack :
				type = 0x16;
				break;
			default :
				return;
				break;
		}
	
		buffer.position = dPos;
		
		if (isCodecPrivate) {
			write(buffer, outputBuffer, type, dPos, dSize, fTimestamp, trackInfo);
			return;
		}
		
		switch (lacingType)
		{
	
			case 1 ://Xiph Lacing
				nFrame = buffer.readUnsignedByte();
				for (i = 0; i<nFrame; i++)
				{
					var fSize:uint = 0;
					var tmpSize:uint = 0;
					do
					{
						tmpSize = buffer.readUnsignedByte();
						fSize +=  tmpSize;
					} while (tmpSize == 0xFF);
					frameSize.push(fSize);
				}
				break;
	
			case 2 ://Fixed Size Lacing
				nFrame = buffer.readUnsignedByte();
				for (i = 0; i<nFrame; i++)
				{
					frameSize.push((dSize-1)/(nFrame +1));
				}
				break;
	
			case 3 ://EBML Lacing
				nFrame = buffer.readUnsignedByte();
				frameSize.push(EBMLElement.getEBMLValue(buffer, buffer.position));
	
				for (i = 1; i<nFrame; i++)
				{
					var elem:Number = EBMLElement.getEBMLValue(buffer,buffer.position);
	
					if (elem < 127)
					{//1byte
						elem -=  63;
					}
					else if (elem < 16383)
					{//2bytes
						elem -=  8191;
					}
					else if (elem < 2097151)
					{//3bytes
						elem -=  1048575;
					}
					else if (elem < 268435455)
					{//4bytes
						elem -=  134217727;
					}
					else if (elem < 34359738367)
					{//5bytes
						elem -=  17179869183;
					}
					else if (elem < 4398046511103)
					{//6bytes
						elem -=  2199023255551;
					}
					else
					{
						throw new Error("No support for elements that big.");
					}
					frameSize.push(frameSize[i-1]+elem);
				}
				break;
	
			default :
				break;
		}
	
		for (i=0; i <= frameSize.length; i++)
		{
			var nextFrameSize:uint;
			if (i == frameSize.length)
			{
				fSize = dSize - (buffer.position - dPos);
			}
			else
			{
				fSize = frameSize[i];
			}
			write(buffer, outputBuffer, type, buffer.position, fSize, fTimestamp + (trackInfo.defaultDuration * i / 1000000), trackInfo);
		}
	
	
	
	}
	
	}
}