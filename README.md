# spdk

[![asciicast](https://asciinema.org/a/cZZw7xG0xxPEQgRZkNjrnyC2V.svg)](https://asciinema.org/a/cZZw7xG0xxPEQgRZkNjrnyC2V)

## Requirments
- Ubuntu 20.00

## Setup Hugepages
- Edit `/etc/default/grub`
```
GRUB_CMDLINE_LINUX_DEFAULT="default_hugepagesz=1G hugepagesz=1G hugepages=3"
``` 
- Update grub `sudo update-grub`
- `echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages`
- Mount hugetlbfs, Prepare hugetlbfs individually for the host and each container. In order to mount hugetlbfs, edit `/etc/fstab` like below.
```
none /dev/hugepages hugetlbfs pagesize=1G,size=4G 0 0
```
- Reboot
- Check Hugepages 
```
grep Huge /proc/meminfo
```

Dev Tools:
```
sudo apt-get install hugeadm
```

Troubleshoot:
Check Huge Pages 
```
➜  ~ hugeadm --pool-list
      Size  Minimum  Current  Maximum  Default
   2097152        0        0        0        *
1073741824        3        3        3
```


Ref:
- https://github.com/xmrig/xmrig/blob/dev/scripts/enable_1gb_pages.sh
- Marco Bonelli Answer, https://stackoverflow.com/questions/72522360/why-doesnt-the-linux-kernel-use-huge-pages

## Getting Started

```bash
$ ./setup.sh # It will install the k3s cluster
# Configure kube ctx for the cluster 
$ kubectl get nodes -oyaml
...
    allocatable:
      cpu: "4"
      ephemeral-storage: "39358207765"
      hugepages-1Gi: 3Gi
      hugepages-2Mi: "0"
      memory: 13224148Ki
      pods: "110"
    capacity:
      cpu: "4"
      ephemeral-storage: 40458684Ki
      hugepages-1Gi: 3Gi
      hugepages-2Mi: "0"
      memory: 16369876Ki
      pods: "110"
...
$ kubectl apply -f pod.yaml
```

## nvmf_create_transport
```bash
kubectl exec spdk -- scripts/rpc.py nvmf_create_transport -t TCP -u 16384 -m 8 -c 8192
```

## Improvment 
- To target the deployment of SPDK  to specific nodes, you can add labels to your Kubernetes nodes using the `kubectl label nodes` command. 
- Monitor Huge pages releated issue in k8s (https://github.com/google/cadvisor/blob/master/docs/storage/prometheus.md)

## Open Questions?
- Currently, the command sets the memory size to 1GB, but it's hardcoded. We require a method to dynamically pass this value instead.
```bash
nvmf_tgt -s -mem-size 1Gb
```
we can use InitContainer to grab the memory and then use it inside the spdk container

## SPDK best practices for K8S
- TBD

## Thanks:
SPDK Community: https://spdk-team.slack.com/archives/CJE4C98G1/p1712931418068589
