# spdk

[![asciicast](https://asciinema.org/a/cZZw7xG0xxPEQgRZkNjrnyC2V.svg)](https://asciinema.org/a/cZZw7xG0xxPEQgRZkNjrnyC2V)

## Requirments
- Ubuntu 20.00

## Setup Hugepages
- Edit `/etc/default/grub`
```
GRUB_CMDLINE_LINUX_DEFAULT="default_hugepagesz=1G hugepagesz=1G hugepages=2"
```
- Update grub `sudo update-grub`
- Mount hugetlbfs, Prepare hugetlbfs individually for the host and each container. In order to mount hugetlbfs, edit `/etc/fstab` like below.
```
none /dev/hugepages hugetlbfs pagesize=1G,size=2G 0 0
```
- Reboot
- Check Hugepages 
```
grep Huge /proc/meminfo
```

## Getting Started

```bash
./setup.sh # It will install the k3s cluster
# Configure kube ctx for the cluster 
kubectl apply -f pod.yaml
```

## nvmf_create_transport
```bash
scripts/rpc.py nvmf_create_transport -t TCP -u 16384 -m 8 -c 8192
```

## NOTES:

- To target the deployment of SPDK  to specific nodes, you can add labels to your Kubernetes nodes using the `kubectl label nodes` command. For example:
