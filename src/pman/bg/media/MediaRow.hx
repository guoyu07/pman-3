package pman.bg.media;

import tannus.io.*;
import tannus.ds.*;
import tannus.sys.*;
import tannus.async.*;
import tannus.sys.Path;
import tannus.http.Url;

import pman.bg.media.MediaSource;

import Slambda.fn;

using StringTools;
using tannus.ds.StringUtils;
using Slambda;
using tannus.ds.ArrayTools;
using tannus.FunctionTools;
using pman.bg.URITools;

typedef MediaRow = {
    ?_id: String,
    uri: String,
    ?title: String,
    ?data: MediaDataRow
};

typedef MediaDataRow = {
    views: Int,
    starred: Bool,
    ?rating: Float,
    ?contentRating: String,
    ?channel: String,
    ?description: String,
    marks: Array<String>,
    tags: Array<String>,
    actors: Array<String>,
    meta: Null<MediaMetadataRow>
}

typedef MediaMetadataRow = {
    duration : Float,
    video : Null<{
        width:Int,
        height:Int,
        frame_rate: String,
        time_base: String
    }>,
    audio: Null<{}>
};
