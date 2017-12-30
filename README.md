
## Colorpicker

My internet is very patchy and I got annoyed with relying on online colorpickers (I only found two that support 0 to 1 rgb values, one of which was recently shut down) so I made my own. Right now it's very basic, but I will periodically add stuff. If you actually use this and want more features, let me know and I will probably do them (or you can fork and modify it yourself).

This uses [Britzl's clipboard extension](https://www.defold.com/community/projects/83154/) to copy the color vector to your clipboard every time you change the color. The extension doesn't support Linux yet, so if you want to use this on Linux, bug him! :) _(Or you can remove the dependency link from game.project and line 181 of `colorpicker.script` and just copy the vector by hand.)_
