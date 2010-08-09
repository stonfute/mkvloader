package com.matroska
{
	import com.matroska.*;
	import com.matroska.segment.*;
	
	public class EBMLTagName
	{

		protected static const EBML:uint = 0x1A45DFA3;
		protected static const EBMLVersion:uint = 0x4286;
		protected static const EBMLReadVersion:uint = 0x42F7;
		protected static const EBMLMaxIDLength:uint = 0x42F2;
		protected static const EBMLMaxSizeLength:uint = 0x42F3;
		protected static const DocType:uint = 0x4282;
		protected static const DocTypeVersion:uint = 0x4287;
		protected static const DocTypeReadVersion:uint = 0x4285;


		protected static const CRC32:uint = 0xBF;
		protected static const VOID:uint = 0xEC;


		protected static const Segment:uint = 0x18538067;


		protected static const SeekHead:uint = 0x114D9B74;
		protected static const Seek:uint = 0x4DBB;
		protected static const SeekID:uint = 0x53AB;
		protected static const SeekPosition:uint = 0x53AC;


		protected static const Info:uint = 0x1549a966;
		protected static const SegmentUID:uint = 0x73a4;
		protected static const SegmentFilename:uint = 0x7384;
		protected static const PrevUID:uint = 0x3cb923;
		protected static const PrevFilename:uint = 0x3c83ab;
		protected static const NextUID:uint = 0x3eb923;
		protected static const NextFilename:uint = 0x3e83bb;
		protected static const SegmentFamily:uint = 0x4444;
		protected static const ChapterTranslate:uint = 0x6924;
		protected static const ChapterTranslateEditionUID:uint = 0x69FC;
		protected static const ChapterTranslateCodec:uint = 0x69BF;
		protected static const ChapterTranslateID:uint = 0x69A5;
		protected static const TimecodeScale:uint = 0x2ad7b1;
		protected static const Duration:uint = 0x4489;
		protected static const DateUTC:uint = 0x4461;
		protected static const Title:uint = 0x7ba9;
		protected static const MuxingApp:uint = 0x4d80;
		protected static const WritingApp:uint = 0x5741;


		protected static const Cluster:uint = 0x1f43b675;
		protected static const Timecode:uint = 0xe7;
		protected static const SilentTracks:uint = 0x5854;
		protected static const SilentTracksNumber:uint = 0x58D7;
		protected static const Position:uint = 0xa7;
		protected static const PrevSize:uint = 0xab;
		protected static const SimpleBlock:uint = 0xA3;
		protected static const BlockGroup:uint = 0xa0;
		protected static const Block:uint = 0xa1;
		//protected static const BlockVirtual:uint = 0xa2;
		protected static const BlockAdditions:uint = 0x75a1;
		protected static const BlockMore:uint = 0xa6;
		protected static const BlockAddID:uint = 0xee;
		protected static const BlockAdditional:uint = 0xa5;
		protected static const BlockDuration:uint = 0x9b;
		protected static const ReferencePriority:uint = 0xfa;
		protected static const ReferenceBlock:uint = 0xfb;
		//protected static const ReferenceVirtual:uint = 0xfd;
		protected static const CodecState:uint = 0xa4;
		protected static const Slices:uint = 0x8e;
		protected static const TimeSlice:uint = 0xe8;
		protected static const LaceNumber:uint = 0xcc;
		//protected static const FrameNumber:uint = 0xcd;
		//protected static const BlockAdditionID:uint = 0xcb;
		//protected static const Delay:uint = 0xce;
		//protected static const Duration:uint = 0xcf;


		protected static const Tracks:uint = 0x1654ae6b;
		protected static const TrackEntry:uint = 0xae;
		protected static const TrackNumber:uint = 0xd7;
		protected static const TrackUID:uint = 0x73c5;
		protected static const TrackType:uint = 0x83;
		protected static const FlagEnabled:uint = 0xb9;
		protected static const FlagDefault:uint = 0x88;
		protected static const FlagForced:uint = 0x55AA;
		protected static const FlagLacing:uint = 0x9c;
		protected static const MinCache:uint = 0x6de7;
		protected static const MaxCache:uint = 0x6df8;
		protected static const DefaultDuration:uint = 0x23e383;
		protected static const TrackTimecodeScale:uint = 0x23314f;
		protected static const MaxBlockAdditionID:uint = 0x55EE;
		protected static const Name:uint = 0x536e;
		protected static const Language:uint = 0x22b59c;
		protected static const CodecID:uint = 0x86;
		protected static const CodecPrivate:uint = 0x63a2;
		protected static const CodecName:uint = 0x258688;
		protected static const AttachmentLink:uint = 0x7446;
		//protected static const CodecSettings:uint = 0x3a9697;
		//protected static const CodecInfoURL:uint = 0x3b4040;
		//protected static const CodecDownloadURL:uint = 0x26b240;
		protected static const CodecDecodeAll:uint = 0xaa;
		protected static const TrackOverlay:uint = 0x6fab;
		protected static const TrackTranslate:uint = 0x6624;
		protected static const TrackTranslateEditionUID:uint = 0x66FC;
		protected static const TrackTranslateCodec:uint = 0x66BF;
		protected static const TrackTranslateTrackID:uint = 0x66A5;
		protected static const Video:uint = 0xe0;
		protected static const FlagInterlaced:uint = 0x9a;
		protected static const StereoMode:uint = 0x53b8;
		protected static const PixelWidth:uint = 0xb0;
		protected static const PixelHeight:uint = 0xba;
		protected static const PixelCropBottom:uint = 0x54AA;
		protected static const PixelCropTop:uint = 0x54BB;
		protected static const PixelCropLeft:uint = 0x54CC;
		protected static const PixelCropRight:uint = 0x54DD;
		protected static const DisplayWidth:uint = 0x54b0;
		protected static const DisplayHeight:uint = 0x54ba;
		protected static const DisplayUnit:uint = 0x54b2;
		protected static const AspectRatioType:uint = 0x54b3;
		protected static const ColourSpace:uint = 0x2eb524;
		//protected static const GammaValue:uint = 0x2fb523;
		protected static const FrameRate:uint = 0x2383e3;
		protected static const Audio:uint = 0xe1;
		protected static const SamplingFrequency:uint = 0xb5;
		protected static const OutputSamplingFrequency:uint = 0x78b5;
		protected static const Channels:uint = 0x9f;
		//protected static const ChannelPositions:uint = 0x7d7b;
		protected static const BitDepth:uint = 0x6264;
		protected static const ContentEncodings:uint = 0x6d80;
		protected static const ContentEncoding:uint = 0x6240;
		protected static const ContentEncodingOrder:uint = 0x5031;
		protected static const ContentEncodingScope:uint = 0x5032;
		protected static const ContentEncodingType:uint = 0x5033;
		protected static const ContentCompression:uint = 0x5034;
		protected static const ContentCompAlgo:uint = 0x4254;
		protected static const ContentCompSettings:uint = 0x4255;
		protected static const ContentEncryption:uint = 0x5035;
		protected static const ContentEncAlgo:uint = 0x47e1;
		protected static const ContentEncKeyID:uint = 0x47e2;
		protected static const ContentSignature:uint = 0x47e3;
		protected static const ContentSigKeyID:uint = 0x47e4;
		protected static const ContentSigAlgo:uint = 0x47e5;
		protected static const ContentSigHashAlgo:uint = 0x47e6;


		protected static const Cues:uint = 0x1c53bb6b;
		protected static const CuePoint:uint = 0xbb;
		protected static const CueTime:uint = 0xb3;
		protected static const CueTrackPositions:uint = 0xb7;
		protected static const CueTrack:uint = 0xf7;
		protected static const CueClusterPosition:uint = 0xf1;
		protected static const CueBlockNumber:uint = 0x5378;
		protected static const CueCodecState:uint = 0xea;
		protected static const CueReference:uint = 0xdb;
		protected static const CueRefTime:uint = 0x96;
		//protected static const CueRefCluster:uint = 0x97;
		//protected static const CueRefNumber:uint = 0x535f;
		//protected static const CueRefCodecState:uint = 0xeb;


		protected static const Attachments:uint = 0x1941a469;
		protected static const AttachedFile:uint = 0x61a7;
		protected static const FileDescription:uint = 0x467e;
		protected static const FileName:uint = 0x466e;
		protected static const FileMimeType:uint = 0x4660;
		protected static const FileData:uint = 0x465c;
		protected static const FileUID:uint = 0x46ae;


		protected static const Chapters:uint = 0x1043a770;
		protected static const EditionEntry:uint = 0x45b9;
		protected static const EditionUID:uint = 0x45BC;
		protected static const EditionFlagHidden:uint = 0x45BD;
		protected static const EditionFlagDefault:uint = 0x45DB;
		protected static const EditionFlagOrdered:uint = 0x45DD;
		protected static const ChapterAtom:uint = 0xb6;
		protected static const ChapterUID:uint = 0x73c4;
		protected static const ChapterTimeStart:uint = 0x91;
		protected static const ChapterTimeEnd:uint = 0x92;
		protected static const ChapterFlagHidden:uint = 0x98;
		protected static const ChapterFlagEnabled:uint = 0x4598;
		protected static const ChapterSegmentUID:uint = 0x6E67;
		protected static const ChapterSegmentEditionUID:uint = 0x6EBC;
		protected static const ChapterPhysicalEquiv:uint = 0x63C3;
		protected static const ChapterTrack:uint = 0x8f;
		protected static const ChapterTrackNumber:uint = 0x89;
		protected static const ChapterDisplay:uint = 0x80;
		protected static const ChapString:uint = 0x85;
		protected static const ChapLanguage:uint = 0x437c;
		protected static const ChapCountry:uint = 0x437e;
		protected static const ChapProcess:uint = 0x6944;
		protected static const ChapProcessCodecID:uint = 0x6955;
		protected static const ChapProcessPrivate:uint = 0x450D;
		protected static const ChapProcessCommand:uint = 0x6911;
		protected static const ChapProcessTime:uint = 0x6922;
		protected static const ChapProcessData:uint = 0x6933;


		protected static const Tags:uint = 0x1254c367;
		protected static const Tag:uint = 0x7373;
		protected static const Targets:uint = 0x63c0;
		protected static const TargetTypeValue:uint = 0x68CA;
		protected static const TargetType:uint = 0x63CA;
		protected static const TagTrackUID:uint = 0x63C5;
		protected static const TagEditionUID:uint = 0x63C9;
		protected static const TagChapterUID:uint = 0x63C4;
		protected static const AttachmentUID:uint = 0x63C6;
		protected static const SimpleTag:uint = 0x67C8;
		protected static const TagName:uint = 0x45A3;
		protected static const TagLanguage:uint = 0x447A;
		protected static const TagDefault:uint = 0x4484;
		protected static const TagString:uint = 0x4487;
		protected static const TagBinary:uint = 0x4485;
	}

}