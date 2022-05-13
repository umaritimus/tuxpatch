# tuxpatch

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with tuxpatch](#setup)
    * [Setup requirements](#setup-requirements)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

As an alternative to INFRA-DPK, tuxpatch puppet module will assist you
in application of the latest patched to Tuxedo middleware as installed via DPK

## Setup

### Setup Requirements

Make sure that your `tuxedo_patches` hash is specified according to the templates as
prescribed by `psft_patches` section, e.g.

```yaml
---
tuxedo_patches:
  34100725: "//share/patches/34100725 - RP090 L(WINDOWS 64-BIT VS2017)/p34100725_122200_MSWIN-x86-64.zip"
```


## Usage

To properly call tuxpatch, please add it to your appropriate puppet profile.  For ad-hoc application,
simply call it via command line, e.g.

```cmd
puppet.bat apply -e "include tuxpatch" --debug --verbose
```

## Limitations

This module currently only works on Windows platform

## Development

Please contribute
