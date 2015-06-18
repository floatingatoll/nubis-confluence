#!/bin/bash

nubis_build_dir=${HOME}/nubis/nubis-builder
export PATH="${nubis_build_dir}/bin:$PATH"

nubis-builder build
