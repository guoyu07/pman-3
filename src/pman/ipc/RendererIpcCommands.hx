package pman.ipc;

import tannus.io.*;
import tannus.ds.*;
import tannus.math.Random;
import tannus.graphics.Color;
import tannus.node.ChildProcess;

import crayon.*;

import electron.ext.*;
import electron.renderer.IpcRenderer as Ipc;
import electron.ext.Dialog;
import electron.Tools.defer;

import pman.LaunchInfo;
import pman.core.*;
import pman.ui.*;
import pman.db.*;
import pman.events.*;
import pman.media.*;
import pman.ww.Worker;

import Std.*;
import tannus.internal.CompileTime in Ct;
import tannus.TSys as Sys;

using StringTools;
using tannus.ds.StringUtils;
using tannus.ds.ArrayTools;
using Lambda;
using Slambda;

class RendererIpcCommands extends BaseIpcCommands {
    /* Constructor Function */
    public function new(m : BPlayerMain):Void {
        super();

        this.main = m;
    }

/* === Instance Methods === */

    /**
      * bind commands
      */
    public function bind():Void {
        fbind('OpenFile', player.selectAndOpenFiles);
        fbind('OpenDirectory', player.selectAndOpenDirectory);
        fbind('ExportPlaylist', player.exportPlaylist);
        fbind('TogglePlaylist', player.togglePlaylist);
        fbind('ClearPlaylist', player.clearPlaylist);
        fbind('ShufflePlaylist', player.shufflePlaylist);

        /*
        b('OpenFile', function() player.selectAndOpenFiles());
        b('OpenDirectory', function() player.selectAndOpenDirectory());
        b('ExportPlaylist', function() player.exportPlaylist());
        b('TogglePlaylist', function() player.togglePlaylist());
        b('ClearPlaylist', function() player.clearPlaylist());
        b('ShufflePlaylist', function() player.shufflePlaylist());
        b('SavePlaylist', function(e, ?saveAs:Bool) {
            trace( saveAs );
            player.savePlaylist( saveAs );
        });
        b('LoadPlaylist', function(e, name:String) {
            player.loadPlaylist( name );
        });

        b('Snapshot', function() {
            player.snapshot();
        });
        b('EditPreferences', function() {
            player.editPreferences();
        });
        b('EditMarks', function() {
            player.editBookmarks();
        });

        // launch info has been received
        b('LaunchInfo', function(e, info:RawLaunchInfo) {
            main._provideLaunchInfo( info );
        });

        b('AddComponent', function(e, name:String) {
            switch ( name ) {
                case 'skim':
                    player.skim();

                default:
                    null;
            }
        });

        b('Exec', function(e, code:String) {
            player.exec(code, function(?error) {
                null;
            });
        });

        b('Notify', function(e, sdata:String) {
            var data:Dynamic = sdata;
            if (sdata.has('{') || sdata.has('}'))
                data = haxe.Json.parse( sdata );
            player.message(
                if (Std.is(data, String))
                    (cast data)
                else
                    (pman.ui.PlayerMessageBoard.messageOptionsFromJson(untyped data))
            );
        });

        b('Tab:Select', function(e, index:Int) {
            player.session.setTab( index );
        });

        b('Tab:Create', function() {
            player.session.newTab();
        });

        b('Tab:Delete', function(e, index:Int) {
            player.session.deleteTab( index );
        });
        */
    }

/* === Utils === */

/* === Overrides === */

    override function _post(channel:String, data:Dynamic):Void {
        Ipc.send(channel, data);
    }

    override function _onMessage(channel:String, handler:Dynamic->Void):Void {
        Ipc.on(channel, function(event, ?packet:Dynamic) {
            handler( packet );
        });
    }

/* === Computed Instance Fields === */

    public var player(get, never):Player;
    private inline function get_player() return main.player;

/* === Instance Fields === */

    public var main : BPlayerMain;
}
