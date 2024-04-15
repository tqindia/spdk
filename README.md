# spdk

## Requirments
- Ubuntu 20.00
- 6 core and 8 GB RAM 

## Install Extra dependancy 
```bash
sudo apt install linux-modules-extra
```

## Setup env
```bash
ulimit -l
```
- Setup huge pages https://github.com/lagopus/lagopus/blob/master/docs/how-to-allocate-1gb-hugepages.md / https://help.ubuntu.com/community/KVM%20-%20Using%20Hugepages (Feel free to follow your own guide.)

## Dev Tools

```bash
sudo apt-get install libhugetlbfs-bin numactl hugeadm
```

