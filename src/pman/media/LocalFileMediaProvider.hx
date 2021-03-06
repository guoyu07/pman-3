package pman.media;

import tannus.io.*;
import tannus.ds.*;
import tannus.sys.File;
import tannus.sys.Path;

import gryffin.media.MediaObject;
import gryffin.display.Video;
import gryffin.audio.Audio;

import electron.ext.FileFilter;

import pman.bg.media.MediaFeature;

import haxe.Serializer;
import haxe.Unserializer;
import foundation.Tools.defer;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;
using Slambda;
using pman.bg.DictTools;

/**
  * MediaProvider for Media derived from media on the user's local filesystem
  */
class LocalFileMediaProvider extends MediaProvider {
	/* Constructor Function */
	public function new(file : File):Void {
		super();

		src = MediaSource.MSLocalPath( file.path );
		var _sp = file.path.toString();
		if (FileFilter.VIDEO.test(_sp))
		    type = MediaType.MTVideo;
        else if (FileFilter.AUDIO.test(_sp))
            type = MediaType.MTAudio;
        else if (FileFilter.IMAGE.test(_sp))
            type = MediaType.MTImage;
		this.file = file;
		switch ( type ) {
            case MTVideo:
                addFeatures(MediaFeature.createAll());

            case MTAudio:
                addFeatures([
                    Playback, PlaybackSpeed,
                    Duration, Volume, CurrentTime,
                    FutureTime, RecordAudio, End,
                    Mute, LoadEvent, CanPlayEvent,
                    PlayEvent, PauseEvent, LoadedMetadataEvent,
                    ErrorEvent, EndEvent, ProgressEvent,
                    DurationChangeEvent, VolumeChangeEvent,
                    SpeedChangeEvent
                ]);

            case MTImage:
                addFeatures([
                    CanvasDisplay,
                    Display,
                    DomDisplay,
                    Dimensions,
                    CaptureImage,
                    LoadEvent
                ]);


            case null:
                //betty
		}
	}

/* === Instance Methods === */

	/**
	  * get the Media
	  */
	override function getMedia():Promise<Media> {
		return Promise.create({
			defer(function() {
				var media:Media = cast new LocalFileMedia( file );
				media.provider = this;
			    media.type = type;
				media.features = cast features.copy();
				return media;
			});
		});
	}

	/**
	  * Serialize [this] provider
	  */
	@:keep
	override function hxSerialize(s : Serializer):Void {
		super.hxSerialize( s );

		s.serialize(file.path.toString());
	}

	/**
	  * unserialize [this] provider
	  */
	@:keep
	override function hxUnserialize(u : Unserializer):Void {
		super.hxUnserialize( u );

		file = new File(new Path(u.unserialize()));
	}

/* === Instance Fields === */

	private var file : File;
}
