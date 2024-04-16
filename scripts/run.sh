#!/bin/bash

modprobe uio_pci_generic

/src/spdk/scripts/setup.sh

/src/spdk/build/bin/nvmf_tgt  -s –mem-size 1G