
## Colorpicker

A pretty basic HSV and RGB colorpicker that outputs the 0-1 vector4s that Defold uses for colors. Try the web version [here](https://www.defold.com/community/projects/94298/)

Thanks to [this guy](http://blog.programster.org/html5-copy-to-clipboard) for the web code for copying stuff to the clipboard.

On non-web platforms, this uses [Britzl's clipboard extension](https://www.defold.com/community/projects/83154/) to copy the color vector to your clipboard every time you change the color. The extension doesn't support Linux yet, so if you want build this for Linux, rename the "ext.manifest" file in the "clipboard" folder to disable the extension.

If you actually use this and want more features, let me know and I will probably do them (or you can fork and modify it yourself).