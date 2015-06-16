#!/bin/bash

nubis_build_dir=~/git/nubis-builder
export PATH="${nubis_build_dir}/bin:$PATH"

nubis-builder build
