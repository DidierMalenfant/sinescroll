# modplayer for Playdate

![](https://img.shields.io/github/license/DidierMalenfant/modplayer) ![](https://img.shields.io/badge/Lua-5.4-yellowgreen) ![](https://img.shields.io/badge/toybox.py-compatible-brightgreen) ![](https://img.shields.io/github/v/tag/DidierMalenfant/modplayer)

**modplayer** is a [**Playdate**](https://play.date) **toybox** which lets you play **Amiga Soundtracker/Protracker** modules, based off [lmp](https://github.com/evansm7/lmp).

You can add it to your **Playdate** project by installing [**toybox.py**](https://toyboxpy.io), going to your project folder in a Terminal window and typing:

```console
toybox add DidierMalenfant/modplayer
```

This **toybox** contains **Lua** toys for you to play with.

---

### module (Lua)

The `module` module provides functionality to load a tracker module.

##### `modplayer.module.new(path)`

Loads the module located at `path`. Returns a `module` object.

### player (Lua)

The `player` module provides functionality to play a `module` object.

##### `modplayer.player.new()`

Creates and return a new `player` object.

##### `modplayer.player.load(module)`

Loads `module` into the player.

##### `modplayer.player.play()`

Starts playing the module.

##### `modplayer.player.stop()`

Stops playing the module.

##### `modplayer.player.update()`

Updates the player. Needs to be called from within your `playdate.update()` method.

### Sample code

You can play a module like this:

```lua
module = modplayer.module.new('Sounds/Crystal_Hammer.mod')
assert(module)

player = modplayer.player.new()
assert(player)

player:load(module)
player:play()
```

Then make sure that you call `player:update()` in your `playdate.update()` method:

```lua
function playdate.update()
    ...
    
    player:update()
end
```

### Where can I get modules from?

#### The internet

[ModArchive](https://modarchive.org/) is a good place to start.  Look for `.MOD` 4-channel SoundTracker/ProTracker files. This won't play XM etc...

#### Write your own!

[MilkyTracker](https://milkytracker.org) is a great multi-platform tracker, complete with the old school tracker look and feel!

## TODO

 * There seems to be some glitches during the replay. Maybe at given buffer boundaries.
 * This renders the audio at 44100Hz, it's probably overkill since Soundtracker samples had a much lower sample rate IIRC.
 * There may be a possibility to use Playdate's sound SDK instead of rendering the audio on the fly. Not sure how effects would be supported.
 * Some effects are currently not supported because lmp does not support them (portamento for example). 

## License

`modplayer` is distributed under the terms of the [MIT](https://spdx.org/licenses/MIT.html) license.
