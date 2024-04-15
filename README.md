# spdk

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
none /dev/hugepages hugetlbfs pagesize=1G,size=4G 0 0
```
- Reboot
- Check Hugepages 
```
grep Huge /proc/meminfo
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:    1024
HugePages_Free:     1024
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:         4194304 kB
```

## Getting Started

```bash
./setup.sh # It will install the k3s cluster
# Configure kube ctx for the cluster 
kubectl apply -f pod.yaml
```

## NOTES:

- To target the deployment of SPDK  to specific nodes, you can add labels to your Kubernetes nodes using the `kubectl label nodes` command. For example:
