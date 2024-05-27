# spdk

## Requirments
- Ubuntu 20.00
- Docker


## Setup Hugepages
- Edit `/etc/default/grub`
```
GRUB_CMDLINE_LINUX_DEFAULT="default_hugepagesz=1G hugepagesz=1G hugepages=3 hugepagesz=2M hugepages=1024"
``` 
- Update grub `sudo update-grub`
- `echo 3 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages`
- `echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages`
- Mount hugetlbfs, Prepare hugetlbfs individually for the host and each container. In order to mount hugetlbfs, edit `/etc/fstab` like below.
```
none /dev/hugepages hugetlbfs pagesize=1G,size=4G 0 0
# none /dev/hugepages2M hugetlbfs pagesize=2M,size=<SIZE> 0 0
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
➜  ~ hugeadm --pool-list
      Size  Minimum  Current  Maximum  Default
   2097152     1024     1024     1024        *
1073741824        3        3        3

➜  ~ hugeadm    --list-all-mounts

Mount Point          Options
/dev/hugepages       rw,relatime,pagesize=1024M,size=4294967296
```


Ref:
- https://github.com/xmrig/xmrig/blob/dev/scripts/enable_1gb_pages.sh
- https://github.com/lagopus/lagopus/blob/master/docs/how-to-allocate-1gb-hugepages.md
- https://doc.dpdk.org/guides/tools/hugepages.html
- https://doc.dpdk.org/guides/linux_gsg/sys_reqs.html
- Marco Bonelli Answer, https://stackoverflow.com/questions/72522360/why-doesnt-the-linux-kernel-use-huge-pages

## Getting Started (Docker)
```bash
$ docker run -it --name spdk --rm --privileged -v /dev:/dev --ipc host evalsocket/spdk:v5
$ docker exec -it spdk scripts/rpc.py nvmf_create_transport -t TCP -u 16384 -m 8 -c 8192
```
## Getting Started (K8S)

```bash
$ ./scripts/setup.sh # It will install the k3s cluster
$ kubectl get nodes -oyaml
...
    allocatable:
      cpu: "4"
      ephemeral-storage: "39358207765"
      hugepages-1Gi: 3Gi
      hugepages-2Mi: 2Gi
      memory: 11126996Ki
      pods: "110"
    capacity:
      cpu: "4"
      ephemeral-storage: 40458684Ki
      hugepages-1Gi: 3Gi
      hugepages-2Mi: 2Gi
      memory: 16369876Ki
      pods: "110"
...
$ kubectl apply -f pod.yaml
$ kubectl get pod spdk 
# Once pod is running then run this command 
$ kubectl exec spdk -- scripts/rpc.py nvmf_create_transport -t TCP -u 16384 -m 8 -c 8192
```


## Improvment 
- To target the deployment of SPDK  to specific nodes, you can add labels to your Kubernetes nodes using the `kubectl label nodes` command. 
- Plan SPDK app resource limit, Add host network if required
- Monitor Huge pages releated issue in k8s (https://github.com/google/cadvisor/blob/master/docs/storage/prometheus.md)
- For Github Action we need to fix linux-modules-extra for azure machine, Github runner use azure, I tested and build images on GCP machine. 

## Open Questions?
- Currently, the command sets the memory size to 1GB, but it's hardcoded. We require a method to dynamically pass this value instead.
```bash
nvmf_tgt -s 1024
```
we can use InitContainer to grab the memory and then use it inside the spdk container

- Need more understanding of spdk app(nvmf_tgt) to handle it correctly


## SPDK best practices for K8S
- TBD (Comming Soon)

## Thanks:
SPDK Community: https://spdk-team.slack.com/archives/CJE4C98G1/p1712931418068589
