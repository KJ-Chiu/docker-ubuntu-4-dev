# docker-ubuntu-4-dev
> 提供快速切換電腦，確保 Window、Mac、Server 間的開發環境相同

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