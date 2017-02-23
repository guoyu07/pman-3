
## PMan 

---

PMan is a desktop media player, written in the [Haxe](http://haxe.org) language, running on [Electron](http://electron.atom.io).


PMan is just a prototype at this stage, and plays only those codecs which are supported by Electron. 

---

#### Features

- sleek user interface
- reasonable performance
- save your session (currently only one saved session allowed, and it is automatically restored on-launch)
- open entire directory (always recursive, need to change that)
- drag 'n drop files onto window to open them
- freely rearrange your playlist
- shuffle

#### Planned Features

- allowing multiple saved sessions
- drag 'n drop folders to open them
- history
- bookmarks
- favorites
- progress through video is saved, so that user can resume to that position next time the video is opened
- tabs
- multiple windows
- send online media to chromecast
- stream local media to chromecast

---

#### Possible(?) Features

These are some features I'd love to see PMan have eventually, but that I either don't currently
know how to implement, don't have time to implement, or am simply unconvinced are feasible.

- using WebGL for the display, instead of 2D Canvas
- polyfilling some of the missing codecs with pure-Haxe implementations
- stream media via AirPlay
- scriptability, or support for extensions

