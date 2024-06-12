# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [2.0.11] - 2024-06-12

### Fixed

- Fix gnome extension installation.

## [2.0.10] - 2023-12-19

### Fixed

- Fix variety and diff-so-fancy ppa: install.

## [2.0.9] - 2023-07-13

### Fixed

- Add ansible info launching into readme.

## [2.0.8] - 2023-07-10

### Fixed

- Allow to luch ansible-info drom desktop.

## [2.0.7] - 2023-06-12

### Fixed

- Add reboot shrtcut dialog

## [2.0.6] - 2023-06-12

### Fixed

- Hide desktop overview on startup.
- Power off dialog not showing restart button: added Alt+Shift+End shortcut to restart.

## [2.0.5] - 2023-06-12

### Fixed

- Generating ansible-info shortcut keeps failing

## [2.0.4] - 2023-06-12

### Fixed

- Ansible info file link 404.

## [2.0.3] - 2023-06-10

### Fixed

- Improve clone instructions readability

## [2.0.2] - 2023-06-10

### Fixed

## [2.0.1] - 2023-06-09

### Changed

- Change ansible info shortcut to Ctrl+Alt+i

## [2.0.0] - 2023-06-07

_Stable release based on [2.0.0-rc.1]._

## [2.0.0-rc.1] - 2023-06-07

## [1.4.0] - 2022-03-21
### Added
 - Add discord
 - Add bashcfg also into .bashrc
 - Initialize `~/work` dir with sample files for current user
 - Install `ubuntu-dev` only for current user
 - Popcorn Time
 - diff-so-fancy

### Changed
 - Set favorite apps only if not set
 - MPV player instead of VLC

### Removed
 - Use bash instead of fish

## [1.3.0] - 2020-12-11
### Added
 - Add tags to distinguish user and global installation

### Changed
 - Show username and host in prompt
 - Apply ansible for all users process does not manipulate with passwords.

## [1.2.0] - 2020-11-30
### Added
 - Run commands for all users at once by `./all_users.sh 'command'`
 - Check installed version to prevent downgrade
 - Starship prompt
 - Fish shell
 - Sublime Text editor with shared settings
 - How to restore Variety default configuration

### Changed
 - Variety default configuration

### Removed
 - Zsh shell and oh-my-zsh
 - Remove Visual Studio Code

## [1.1.0] - 2020-10-15
### Added
 - Add `avahi-daemon` to `basic_enviroment.yml`

### Fixed
 - Ansible forces VirtualBox version to 6.0

[2.0.11]: https://https://github.com/internetguru/ansible/compare/v2.0.10...v2.0.11
[2.0.10]: https://https://github.com/internetguru/ansible/compare/v2.0.9...v2.0.10
[2.0.9]: https://https://github.com/internetguru/ansible/compare/v2.0.8...v2.0.9
[2.0.8]: https://https://github.com/internetguru/ansible/compare/v2.0.7...v2.0.8
[2.0.7]: https://https://github.com/internetguru/ansible/compare/v2.0.6...v2.0.7
[2.0.6]: https://https://github.com/internetguru/ansible/compare/v2.0.5...v2.0.6
[2.0.5]: https://https://github.com/internetguru/ansible/compare/v2.0.4...v2.0.5
[2.0.4]: https://https://github.com/internetguru/ansible/compare/v2.0.3...v2.0.4
[2.0.3]: https://https://github.com/InternetGuru/ansible/compare/v2.0.2...v2.0.3
[2.0.2]: https://https://github.com/InternetGuru/ansible/compare/v2.0.1...v2.0.2
[2.0.1]: https://https://github.com/internetguru/ansible/compare/v2.0.0...v2.0.1
[2.0.0]: https://https://github.com/internetguru/ansible/compare/v1.4.0...v2.0.0
[2.0.0-rc.1]: https://github.com/internetguru/ansible/releases/tag/v1.4.0
[1.4.0]: https://github.com/InternetGuru/ansible/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/InternetGuru/ansible/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/InternetGuru/ansible/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/InternetGuru/ansible/compare/v1.0.0...v1.1.0
