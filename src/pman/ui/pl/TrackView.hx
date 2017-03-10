package pman.ui.pl;

import tannus.io.*;
import tannus.html.Element;
import tannus.geom.*;
import tannus.events.*;

import crayon.*;
import foundation.*;

import gryffin.core.*;
import gryffin.display.*;

import electron.ext.*;
import electron.ext.Dialog;

import pman.core.*;
import pman.media.*;

import Slambda.fn;
import tannus.math.TMath.*;

using StringTools;
using Lambda;
using Slambda;
using tannus.math.TMath;

class TrackView extends Pane {
	/* Constructor Function */
	public function new(v:PlaylistView, t:Track):Void {
		super();

		addClass( 'track' );

		list = v;
		track = t;

		build();
	}

/* === Instance Methods === */

	/**
	  * Build [this] 
	  */
	override function populate():Void {
		title = new Pane();
		title.addClass( 'title' );
		title.text = track.title;
		append( title );

		if ( !eventInitted ) {
		    __events();
		}

		var a = this.el.attributes;
		a['title'] = track.title;
		a['data-uri'] = track.uri;

		needsRebuild = false;
	}

	/**
	  * configure events and such
	  */
	private function __events():Void {
        forwardEvents(['click', 'contextmenu', 'mousedown', 'mouseup', 'mousemove'], null, MouseEvent.fromJqEvent);
		on('click', onLeftClick);
		on('contextmenu', onRightClick);

		el.plugin( 'disableSelection' );

		configureDragAndDropRearrangement();

		eventInitted = true;
	}

	/**
	  * handle a Click
	  */
	private function onLeftClick(event : MouseEvent):Void {
		event.cancel();

		if (player.track != track) {
			player.openTrack( track );
		}
	}
	
	/**
	  * handle right click
	  */
	private function onRightClick(event : MouseEvent):Void {
		event.cancel();

		var ctxMenu:Menu = Menu.buildFromTemplate([
			{
				label: 'Play',
				click: function(x,y,z) {
					player.openTrack( track );
				}
			},
			{
				label: 'Play Next',
				click: function(x,y,z) {
                    playlist.move(track, fn(session.indexOfCurrentMedia() + 1));
					//playlist.moveToAfter(track, session.focusedTrack);
				}
			},
			{
				label: 'Remove from Playlist',
				click: function(x, y, z) {
					playlist.remove( track );
				}
			},
			{type: 'separator'},
			{
				label: 'Clear Playlist',
				click: function(x, y, z) {
					player.clearPlaylist();
				}
			},
			{
				label: 'Save Playlist'
			},
			{
				label: 'Export Playlist'
			}
		]);
		menuOpen = true;
		ctxMenu.popup();
	}

	/**
	  * configure the drag-n-drop system
	  */
	private function configureDragAndDropRearrangement():Void {
		var di:Element = '<li><div class="drop-indicator"></div></li>';

		on('mousedown', function(event : MouseEvent) {
			if ( menuOpen ) {
				menuOpen = false;
				return ;
			}
			if (event.button != 1) {
				trace( event.button );
				return ;
			}

			var start = event.position;
			list.once('mousemove', function(event : MouseEvent) {
				//var dis:Float = Math.abs(event.position.distanceFrom( start ));
				dragging = true;
			});

			list.once('mouseup', function(event : MouseEvent) {
				if (event.button != 1) {
					return ;
				}

				if ( dragging ) {
					var tvOver:Null<TrackView> = list.findTrackViewByPoint( event.position );
					if (list.tracks[0] != null && tvOver == null) {
					    tvOver = list.tracks[0];
					}

					if (tvOver != null) {
						var t:Track = tvOver.track;
						var r = tvOver.rect();
						var hwm = (r.y + (r.h / 2));

						di.remove();
						dragging = false;

						if (event.position.y > hwm) {
                            //playlist.move(track, fn(min((playlist.indexOf( t ) + 1), (playlist.length - 1))));
                            playlist.move(track, function() {
                                return (playlist.indexOf( t ) + 1).clamp(0, playlist.length);
                            });
							//playlist.moveToAfter(track, t);
						}
						else {
                            //playlist.move(track, fn(max(playlist.indexOf( t ) - 1, 0)));
                            playlist.move(track, function() {
                                return (playlist.indexOf( t ) - 1).clamp(0, playlist.length);
                            });
							//playlist.moveToBefore(track, t);
						}
					}
				}
			});

			//list.list.once('mouseleave', function(event : MouseEvent) {
				//dragging = false;
				//di.remove();
			//});
		});

		list.on('click', function(event) {
			//dragging = false;
			list.stopDragging();
		});

		list.on('mousemove', function(event : MouseEvent) {
			if ( dragging ) {
				var tvOver:Null<TrackView> = list.findTrackViewByPoint( event.position );
				if (tvOver != null) {
					var r = tvOver.rect();
					var hwm = (r.y + (r.h / 2));

					di.remove();
					//di = '<li><div class="drop-indicator"></div></li>';

					(event.position.y > hwm ? tvOver.li.after : tvOver.li.before)( di );
				}
			}
		});
	}

    /**
      * permanently destroy [this] TrackView
      */
	override function destroy():Void {
        super.detach();
        //needsRebuild = true;
	}
	
	/**
	  * detach [this] TrackView
	  */
	override function detach():Void {
        super.detach();
		//needsRebuild = true;
	}

	/**
	  * Whether [this] Track is focused
	  */
	public inline function focused(?value : Bool):Bool return c('focused', value);

	/**
	  * Whether [this] Track is hovered
	  */
	public inline function hovered(?value : Bool):Bool return c('hovered', value);

	/**
	  * get the status of a flag
	  */
	private inline function cg(name : String):Bool {
		return el.hasClass( name );
	}

	/**
	  * set the status of a flag
	  */
	private inline function cs(name:String, value:Bool):Void {
		(value ? addClass : removeClass)( name );
	}

	/**
	  * (if provided) assign the status of the [name] flag
	  * and return the status of the [name] flag
	  */
	private inline function c(name:String, ?value:Bool):Bool {
		if (value != null) {
			cs(name, value);
		}
		return cg( name );
	}

/* === Computed Instance Fields === */

	public var player(get, never):Player;
	private inline function get_player():Player return list.player;

	public var session(get, never):PlayerSession;
	private inline function get_session():PlayerSession return list.session;

	public var playlist(get, never):Playlist;
	private inline function get_playlist():Playlist return list.playlist;
	
	public var li(get, never):ListItem;
	private inline function get_li():ListItem return cast this.parentWidget;

/* === Instance Fields === */

    public var needsRebuild:Bool = false;
	public var list : PlaylistView;
	public var track : Track;

	public var title : Pane;

	private var menuOpen : Bool = false;
	private var eventInitted : Bool = false;
	@:allow( pman.ui.PlaylistView )
	private var dragging : Bool = false;
}
