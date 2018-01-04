package pman.bg.db;

import tannus.io.*;
import tannus.ds.*;
import tannus.sys.*;
import tannus.async.*;
import tannus.async.promises.*;
import tannus.sys.Path;
import tannus.http.Url;
import tannus.sys.FileSystem as Fs;

import edis.libs.nedb.*;
import edis.storage.db.*;
import edis.core.Prerequisites;

import Slambda.fn;
import edis.Globals.*;

import pman.bg.Dirs;
import pman.bg.media.*;
import pman.bg.media.TagRow;

using StringTools;
using tannus.ds.StringUtils;
using Slambda;
using tannus.ds.ArrayTools;
using tannus.FunctionTools;
using tannus.async.Asyncs;
using pman.bg.MediaTools;

class TagTable extends Table {
    /* Constructor Function */
    public function new(store: DataStore):Void {
        super( store );
    }

/* === Instance Methods === */

    /**
      * initialize [this]
      */
    override function init(done: VoidCb):Void {
        var tasks = [];
        tasks.push(createIndex.bind('name', true, false, _));
        super.init(function(?error) {
            if (error != null)
                return done(error);
            else
                tasks.series( done );
        });
    }

    /**
      * 
      */
    public function getRowsByNames(names:Array<String>, ?done:Cb<Array<Maybe<TagRow>>>):ArrayPromise<Maybe<TagRow>> {
        var queryDef:Query = new Query({
            name: {
                "$in": names
            }
        });
        return query(queryDef, done);
    }
}
