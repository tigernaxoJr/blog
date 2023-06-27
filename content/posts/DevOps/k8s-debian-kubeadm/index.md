---
title: "[K8s] 安裝"
date: 2023-06-16T11:11:00+08:00
draft: false
hero: 
menu:
  sidebar:
    name: "[K8S] K8S 安裝"
    identifier: devops-k8s-debian-kubeadm
    parent: devops
    weight: 1000
---
## Prerequest
已安裝 Debian 11，並且 ssh 可連線



### disable swap 
```bash
sed -i '/\/swap/s/^/#/' /etc/fstab
swapoff -a
```


## Container Runtime (CRI-O)
Forwarding IPv4 and letting iptables
```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sysctl --system
```

```bash
#!/bin/bash
OS=Debian_11
VERSION=1.27

echo 'deb http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list.d/backports.list
apt update
apt install -y -t buster-backports libseccomp2 || apt update -y -t buster-backports libseccomp2
apt install -y gnupg gnupg2 curl

echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

mkdir -p /usr/share/keyrings
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

apt-get update
apt-get install -y cri-o cri-o-runc

systemctl daemon-reload
systemctl enable crio
systemctl start crio
```

## Install kubeadm
```bash
apt-get update
apt-get install -y apt-transport-https ca-certificates curl

mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
```

## Creating a cluster with kubeadm
```bash
# 設定 k8s server上網路
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket=unix:///var/run/crio/crio.sock
```

## kubectl 設定
### root
```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```
### non-root user
make user sudor
```bash
apt install sudo
usermod -aG sudo $username
```
give user kubectl config
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## Installing a Pod network add-on
```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```
讓 cni0 跟 flannel 的 ip 一致，不知道為什麼 kubeadm init 的時候指定了 cni0 的 ip 卻還是不對。
```bash
ip link set cni0 down
ip link delete cni0
ip link add cni0 type bridge
ip link set cni0 up
```
## 其他
讓 control plane 所在 node 可以部屬
```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```
## Reference
- [Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [Container Runtimes](https://kubernetes.io/docs/setup/production-environment/container-runtimes/)
- [CRI-O Installation Instructions](https://github.com/cri-o/cri-o/blob/main/install.md)
- [Running CRI-O with kubeadm](https://github.com/cri-o/cri-o/blob/main/tutorials/kubeadm.md)
- [Network Plugins](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/)
- [Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)