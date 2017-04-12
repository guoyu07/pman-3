package pack;

import tannus.io.*;
import tannus.ds.*;
import tannus.sys.*;

import haxe.Json;
import js.Lib.require;

import pack.*;
import pack.Tools.*;
import Packer.TaskOptions;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;
using Slambda;
using pack.Tools;

class Installer extends Task {
    /* Constructor Function */
    public function new(platform:String, arch:String):Void {
        super();

        this.platform = platform;
        this.arch = arch;

        buildOptions();
    }

/* === Instance Methods === */

    /**
      * execute [this] Task
      */
    override function execute(callback : ?Dynamic->Void):Void {
        build(options, function(?error : Dynamic) {
            callback( error );
        });
    }

    /**
      * construct the options
      */
    private function buildOptions():Void {
        options = {
            src: (path('releases/pman-$platform-$arch').toString()),
            dest: (path('installers').toString()),
            arch: translateArch( arch ),
            rename: function(sdest:String, ssrc:String) {
                var result = rename(Path.fromString( sdest ), Path.fromString( ssrc ));
                trace( result );
                return result.toString();
            }
        };
    }

    /**
      * get an architecture name that will be recognized by the [build] method from [arch]
      */
    private inline function translateArch(n : String):String {
        return (switch ( n ) {
            case 'x64': 'amd64';
            default: n;
        });
    }

    /**
      * rename shit
      */
    private function rename(dest:Path, src:Path):Path {
        return dest.plusPath( src );
    }

    /**
      * get the method that shall be used to generate the installer itself
      */
    private function getBuildFunction():Dynamic {
        return (function(o:Object, cb:Null<Dynamic>->Void) {
            cb( null );
        });
    }

/* === Computed Instance Fields === */

    // the 'build' method
    private var build(get, never):Dynamic;
    private function get_build():Dynamic {
        if (_build == null) {
            _build = getBuildFunction();
        }
        return _build;
    }

/* === Instance Fields === */

    public var platform:String;
    public var arch:String;
    public var options:Object;

    private var _build:Null<Dynamic> = null;
}
