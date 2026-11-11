# Builds every release x distro x base combination: docker buildx bake
# Archive used: Archives/<version>[_<beta>]/PureBasic_<distro>[_<beta>]_X64_<version>.tgz
# Tag: <IMAGE>:<version>[-<beta>]-<distro>-<base name>

variable "IMAGE" {
  default = "git.nibblepoker.lu/aziascreations/purebasic"
}

group "default" {
  targets = ["purebasic"]
}

target "purebasic" {
  name = join("-", compact([lower(distro), replace(rel.version, ".", "_"), rel.beta, base.name]))
  matrix = {
    rel = [
      { version = "6.41", beta = "" },
      { version = "6.50", beta = "beta5" },
    ]
    distro = ["Linux", "Linux2", "Linux3"]
    # image: used by FROM, name: used in the tag.
    base = [
      { image = "debian:trixie-slim", name = "trixie-slim" },
    ]
  }

  args = {
    BASE_IMAGE        = base.image
    PUREBASIC_ARCHIVE = format("%s/%s.tgz",
      join("_", compact([rel.version, rel.beta])),
      join("_", compact(["PureBasic", distro, rel.beta, "X64", rel.version])))
  }
  tags = ["${IMAGE}:${join("-", compact([rel.version, rel.beta, lower(distro), base.name]))}"]
}
