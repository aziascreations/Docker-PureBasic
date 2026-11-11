# Docker - PureBasic Compiler Images
Docker images with the PureBasic compiler intended to be used a building stages for building console programs.
Both backends are on the `PATH`: `pbcompiler` (asm) and `pbcompilerc` (C).


## Limitations
* Requires access to official PureBasic release archives
* Cannot compile GUI programs
* No ARM64/X86 builds yet


## Build

### All at once
```sh
docker buildx bake            # build everything
docker buildx bake --print    # list targets and tags
```
Tags will look like `git.nibblepoker.lu/aziascreations/purebasic:6.41-linux3-trixie-slim`, `git.nibblepoker.lu/aziascreations/purebasic:6.50-beta5-linux3-trixie-slim`, ...\
Set `IMAGE` to use another name, e.g. `IMAGE=purebasic docker buildx bake`.

### Single
```sh
docker build -t git.nibblepoker.lu/aziascreations/purebasic:6.41-linux3-trixie-slim \
  --build-arg PUREBASIC_ARCHIVE=6.41/PureBasic_Linux3_X64_6.41.tgz .
```

| Argument | Default | Purpose |
|---|---|---|
| `PUREBASIC_ARCHIVE` | | Archive path inside `Archives/` |
| `BASE_IMAGE` | `debian:trixie-slim` | Base image |
| `PUREBASIC_FIX_MEMCPY` | `1` | Fix for the `__wrap_memcpy` link error, `0` to disable |


### Publish
Images go to the Gitea container registry, as described in [Gitea's docs](https://docs.gitea.com/usage/packages/container/).\
Log in with a personal access token if you use 2FA, then build and push everything:
```sh
docker login git.nibblepoker.lu
docker buildx bake --push
```


## Usage
```sh
docker run --rm -v "$PWD":/src -w /src git.nibblepoker.lu/aziascreations/purebasic:6.41-linux3-trixie-slim \
  pbcompiler -t Program.pb -e Build/Program
```


## Archives
PureBasic is licensed, so its archives aren't in git. \
Put them in `Archives/`, one folder per release:

```
Archives/6.41/PureBasic_Linux3_X64_6.41.tgz
Archives/6.50_beta5/PureBasic_Linux3_beta5_X64_6.50.tgz
```

Only X64 archives are supported.
