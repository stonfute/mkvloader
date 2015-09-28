# AS3 Parser/Player for Matroska 2 files #

## How does it work ? ##
Parses a MKV buffer and encapsulates Video/Audio packets on the fly to FLV.

Written 100% in AS3, no Alchemy opcodes or C libs dependency.
### Current version limitation ###

- No Subtitles support (yet).

- Uses Flash 10.1 API to load video from buffer, will only work on Flash 10.1.XX+ (this won't change).

### Planned ###
~~- Video : H.264~~

- Video : VP6

~~- Audio : MP3 2.0~~

~~- Audio : AAC 2.0~~

- Audio : Vorbis 2.0 (AS3 Decoder)

- Audio : FLAC 2.0 (AS3 Decoder)

- Audio : Multiple tracks

- Subtitle : ASS (Basic tags)

- Subtitle : Embedded fonts

- Subtitle : ASS (Complex overrides)

- Extra : Chapters


Feature request ?
Want to join the crew ?
Mail JesusYamato@gmail.com