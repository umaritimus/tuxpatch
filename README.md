# tuxpatch

Apply Tuxedo Patch

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with tuxpatch](#setup)
    * [Setup requirements](#setup-requirements)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Since Oracle continues to botch INFRA-DPK release timelines, please see if this module might help apply the tuxedo patches to DPK

## Setup


### Setup Requirements **OPTIONAL**

Make sure that your psft_patches section is set. Particularly tuxedo_patches needs to be populated, e.g.

```yaml
---
jdk_patches:
  27838191: "//share/patches/27838191 - Oracle JDK 11/p27838191_110000_MSWIN-x86-64.zip"

tuxedo_patches:
  34100725: "//share/patches/34100725 - RP090 L(WINDOWS 64-BIT VS2017)/p34100725_122200_MSWIN-x86-64.zip"
```


## Usage

To properly call tuxpatch, please add it to your appropriate puppet role.  For ad-hoc application simply call it via command line, e.g.

```cmd
puppet.bat apply -e "include tuxpatch" --debug --verbose
```


## Limitations

This module currently only works on Windows platform

## Development

Please contribute

## Release Notes/Contributors/Etc. **Optional**

[1]: https://puppet.com/docs/pdk/latest/pdk_generating_modules.html
[2]: https://puppet.com/docs/puppet/latest/puppet_strings.html
[3]: https://puppet.com/docs/puppet/latest/puppet_strings_style.html
