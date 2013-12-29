# GRProKit

AppKit "replacement" to replicate the Pro App look

## Currently Available Controls

## GRProWindow

NSWindow subclass, uses custom Theme Frame drawing to draw the dark window frame

## GRProBox

A simple NSView subclass that has a header and footer, and a title which appears in the header

## GRProSlider

NSSlider replacement, with pro look

## GRProProgressIndicator

NSProgressIndicator replacement, with pro look

## GRProSplitView

A NSSplitView subclass that doesn't draw any dividers

## GRProAlert

NSAlert replacement, has a slightly different API (see demo app)

## GRProLabel

NSTextField subclass, basically a label with the Helvetica font and a subtle shadow

## GRProButton

NSButton and NSButtonCell subclasses for Push Button, Pop Up Button, Checkbox and Radio Button
The cell class must be set in interface builder (see demo app)

## GRProTableView

NSTableView subclass with custom look, NSTableHeaderCell's drawing methods are overwritten and a custom NSTextFieldCell needs to be set in the xib file.
Support for view based table views coming soon.

## How the images are stored

To manage the theme's images I've created a file format which encapsulates all the images used by the custom controls,
this is good because:
- It is compressed, so the framework size is smaller
- It keeps all files inside this container, making organization easier

I've created a command line utility to package a set of resources to this custom file format,
the source code of this utility will be released soon

## Screenshots

![screenshot](https://raw.github.com/insidegui/GRProKit/master/screenshot_5.png)
![screenshot](https://raw.github.com/insidegui/GRProKit/master/screenshot_1.png)
![screenshot](https://raw.github.com/insidegui/GRProKit/master/screenshot_2.png)
![screenshot](https://raw.github.com/insidegui/GRProKit/master/screenshot_3.png)
![screenshot](https://raw.github.com/insidegui/GRProKit/master/screenshot_4.png)