PointCache-Tool
===============

PointCache tool for 3ds Max is a basic pointcache managing tool. It allows to save, in a simple database, an asset’s datas (objects and path). Then it’s possible, in any animation file, to export pointcache of the selected asset, if present in the scene.

The second part of the script allows to merge the asset from its source in the current scene, and to apply the pointcaches (world space modifier or object space modifier). If it is a space object modifier, « Pointcache » must be added to the modifier’s stack in the source file.

This is a production tool, so it’s based on a shot/sequence system. These informations are parsed from the filename (but it can be manually overwritten), based on a (customizable) pattern.
