# docker-ubuntu-4-dev
> A Ready-made docker image allow developers to switch between Window, Mac or any kind of server System easily.

## Requirement
* [docker](https://www.docker.com/)

## Installation
1. Clone the repo

    `git clone git@github.com:KJ-Chiu/docker-ubuntu-4-dev.git ./`

2. Build the image with the name *ubuntu-4-dev*

    `docker build ubuntu-4-dev ./`

    Remember to change the container name inside scripts if trying to give ur image a new name

3. Create the file *volume-paths* in the same directory of shell

    `echo "-v /path/of/your/folder:/path/of/your/destination" >> volume-paths`

4. Start the container

    `./docker-run.sh`

5. Get inside and start working!

    `./get-inside.sh`

6. Normally the container will keep running in the background unless the computer restart or just trying to shut it down

    `./docker-stop.sh`

Basically, everything can still work without those scripts. They are just easy and convenient to me.

## Introduction
> The following will list the equipment this image has.
> It might not be completed and please feel free to read the Dockerfile.

### OS
Ubuntu, v16.04

### Language Provided
| Language | Version | Note |
| - | - | - |
| PHP | 7.3 | FPM included |
| Go | 1.13 | - |
| Node | 12.13.1 | Control by NVM |

### Package Provided
| Package | Version | Note |
| - | - | - |
| NVM | 0.35.1 | - |
| NPM | latest | Control by NVM |
| composer | latest | - |
| Nginx | latest | proxy pass php-fpm socket |
| Git | latest | - |

### NPM Global Package Provided
| Package | Version | Note |
| - | - | - |
| @vue/cli | ^4.1.1 | - |

### Editor Provided
| Editor | Version | Note |
| - | - | - |
| Vim | - | Include Vundle |

### Shell Provided
| Shell | Version | Note |
| - | - | - |
| zsh | - | Include oh-my-zsh |

### Session Manager Provided
| Manager | Version | Note |
| - | - | - |
| Tmux | - | - |
| Screen | - | - |

## Notes
1. A user called `developer` is added for us to use command line comfortably without root
2. The Dockerfile automatically clone and link [shell-config](https://github.com/KJ-Chiu/shell-config) as `developer` basic env setting.

## Tips
1. For Vue Cli ^2: If using `npm run dev` for developing, remember to add `--host 0.0.0.0` after `webpack-dev-server` inside ur *package.json* dev script. Otherwise u might not be able to access the port outside docker cause it default listening to localhost only. (Vue Cli >3 will detect the container environment automatically)
2. Remember to volume projects into container. Any permanent change outside the volumed folder will disappear after container stopped.
3. In WSL, volume will only success by Windows' path ex: `C:\your\path`, `/mnt/c/your/path` won't work.