# NAPE - Build, Deploy, and Release

The centralized repository with contains all of the integration, deploy, and release scripts for all NAPE projects.

## Repo Root

- ```Makefile```
  - The commands a build system would use to build any software artifacts used for the build, deploy, or release prrocesses
  - For example, this Makefile contains container build commands to build the various containers used for build process for the NAPE CLI

## Github Workflows

All of the centrally managed workflows that all NAPE repositories depend upon are contained within ```.github/```

## NAPE CLI

All of the following aspects are container within the ```nape-cli/```

- Build the NAPE CLI for various operating systems and CPU architecures,
- Verify the build operates on each OS/CPU combination, and
- Publish the compiled CLI to various pacakge managers and package targets

### Supported OS/CPU for NAPE CLI

| Operating System | x86_64    | aarch64           |
|------------------|-----------|-------------------|
| Linux (GNU)      | Supported | Supported         |
| Linux (MUSL)     | Supported | Supported         |
| Windows (GNU)    | Supported | **Not Supported** |
| macOS            | Supported | Supported         |

### Files

- ```Dockerfile```
  - The container file specification that contains all the tools to cross-compile the NAPE CLI for the above list of supported OS/CPU combinations.
- ```Makefile```
  - Contains all of the build commands to test, build, cross-compile, and verify the NAPE CLI

### Subdirectories

- ```action/```
  - Python scripts used by the ```./nape-cli/Makefile```
  - **DESIGN DECISION** - Python scripts are used because they can be independtly testable via a unit test to verify the behavior for each script, as opposed to manual push-and-click testing
- ```os-cpu-verification/```
  - Contains any os-specific test that is used to verify the complied NAPE CLI binary works on a given operating system.