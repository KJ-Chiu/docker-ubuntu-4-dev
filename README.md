# docker-ubuntu-4-dev
> A Ready-made docker image allow developers to switch between Window, Mac or any kind of server System easily.

## OS
Ubuntu, v16.04

## Language Provided
| Language | Version | Note |
| - | - | - |
| PHP | 7.3 | FPM included |
| Go | 1.13 | - |
| Node | 12.13.1 | Control by NVM |

## Package Provided
| Package | Version | Note |
| - | - | - |
| NVM | 0.35.1 | - |
| NPM | latest | Control by NVM |
| composer | latest | - |
| Nginx | latest | proxy pass php-fpm socket |
| Git | latest | - |

## Editor Provided
| Editor | Version | Note |
| - | - | - |
| Vim | - | - |

## Shell Provided
| Shell | Version | Note |
| - | - | - |
| zsh | - | Include oh-my-zsh |

## Notes
1. A user called `developer` is added for us to use command line comfortably without root
2. The Dockerfile automatically clone and link [shell-config](https://github.com/KJ-Chiu/shell-config) as `developer` basic env setting.

## Tips
1. If using `npm run dev` for developing, remember to add `--host 0.0.0.0` after `webpack-dev-server` inside ur *package.json* dev script. Otherwise u might not be able to access the port outside docker cause it default listening to localhost only.
2. Remember to volume projects into container. Any permanent change outside the volumed folder will disappear after container stopped.
3. In WSL, volume will only success by Windows' path ex: `C:\your\path`, `/mnt/c/your/path` won't work.