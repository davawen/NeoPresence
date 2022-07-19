# NeoPresence

Not actually usable as a plugin yet

## Building

### Dependencies 

-   [Discord Game SDK](https://discord.com/developers/docs/game-sdk/sdk-starter-guide)

### Project Structure

SDK's C++ includes(`*.h`) should be in `include/discord` and sources(`*.{c, cpp}`) in `src/discord`.  
Shared library (`libdiscord_game_sdk.so`) should be in a linker accessible place (usually `/usr/lib64` or `/usr/local/lib64`)

From there, build as usual CMake project:
```sh
$ mkdir build && cd build
$ cmake -DCMAKE_BUILD_TYPE=Release ..
$ make
```

## Using

Currently needs manually requiring `plugin.lua` to work
