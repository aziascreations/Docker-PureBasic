# Docker - PureBasic Compiler Images
Docker images with the PureBasic compiler to use in building stages for console programs. \
Both backends are directly on the `PATH`: `pbcompiler` (asm) and `pbcompilerc` (C).


## Limitations
* Must be hosted privately
  * Requires licensed PureBasic archives
* Cannot compile GUI programs
* No ARM64/X86 builds, yet


## Build

### Pre-requisites
You must frop the required archives in `Archives/` like so:
```
Archives/6.41/PureBasic_Linux3_X64_6.41.tgz
Archives/6.50_beta5/PureBasic_Linux3_beta5_X64_6.50.tgz
```

Check [docker-bake.hcl](docker-bake.hcl) for more details.


### Build options
| Argument               | Default              | Purpose                                                |
|------------------------|----------------------|--------------------------------------------------------|
| `PUREBASIC_ARCHIVE`    | *None*               | Archive path inside `Archives/`                        |
| `BASE_IMAGE`           | `debian:trixie-slim` | Base image                                             |
| `PUREBASIC_FIX_MEMCPY` | `1`                  | Fix for the `__wrap_memcpy` link error, `0` to disable |


### All at once
```sh
docker buildx bake            # build everything
docker buildx bake --print    # list targets and tags
```


### Single
```sh
docker build -t git.nibblepoker.lu/packages/purebasic:6.41-linux3-trixie-slim \
  --build-arg PUREBASIC_ARCHIVE=6.41/PureBasic_Linux3_X64_6.41.tgz .
```


### Tags
Tags will look like `6.41-linux3-trixie-slim`, `6.50-beta5-linux3-trixie-slim`, ...


### Publishing
This step varies depending on your setup. \
I'll put mine here for reference.

In order to push to a privated org on Gitea, you must change the image name and then run this: 
```sh
docker login git.nibblepoker.lu
docker buildx bake --push
```

For my case, the image name would be `git.nibblepoker.lu/packages/purebasic`.


## Usage
```sh
docker run --rm -v "$PWD":/src -w /src git.nibblepoker.lu/packages/purebasic:6.41-linux3-trixie-slim \
  pbcompiler -t Program.pb -e Build/Program
```


## License
All the code in this repo is released in the [Public Domain](LICENSE).

Please note that this doesn't apply to the required PureBasic archives.
