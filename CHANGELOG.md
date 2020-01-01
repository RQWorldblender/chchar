# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Pre-release] - Starting from 2019-12-28
* Initial working version based on code from the [skinsdb](https://github.com/minetest-mods/skinsdb) mod. This includes the code and directory structure. All previous code is gone with this change.
* License changed to GPLv3 from LGPLv3.
* Out-of-the-box support for the inventory mods *sfinv* and *unified_inventory*, with the former already shipping with Minetest.
* Other mods that alter the player model may come into conflict with *chchar*, and should be disabled before using this mod.
* Assigning models to specific players is currently untested. All models loaded are assumed to be public for all players.
* Translation support with *intllib* included, but there are no translations yet.
* Additional chat command `/chchar reset` allows to quickly go back to the default model.

### Changes from *skinsdb*
* Drop support for Minetest 0.4 versions.
* Drop optional support for the *3d_armor* and *clothing* mods. This support can be reintroduced at a later time.
* Disable the online downloader, as there are currently no places to download pre-made 3D models for use with this mod. If such a place appears, it can be re-enabled.
* Rename some files to be more relevant for 3D models and not for skins.
* Alter the meta file format to include more fields, including those that can changed with *player_api*.
* Add more information to be displayed in formspecs, and make images and model buttons square sizes.
