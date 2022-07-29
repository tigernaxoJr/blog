---
title: "[K8S] 自架 Kubernetes 使用 VM 模擬多台 Server"
date: 2022-07-23T20:51:00+08:00
hero: 
draft: false
menu:
  sidebar:
    name: "[K8S] 自架 K8S 腳本"
    identifier: k8s-basc-install
    parent: container
    weight: 2000
---

準備/安裝兩台 Server ( 使用 VM clone 然後修改 hostname )
一台為 Master (主控)，另外一台為 Node ( 節點 )
安裝 kubelet/kubeadm ( Master 與 node 皆要執行此步驟 )

```bash
# 設定 k8s server上網路
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

# 安裝 kubeadm / kubelet
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# 安裝 Docker
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt-get install docker-ce -y
docker --version
sudo systemctl start docker
sudo chmod 666 /var/run/docker.sock
sudo systemctl enable docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

sudo systemctl restart docker

# 關閉 swap
sudo swapoff -a
sudo sed -i '/\/swap/s/^/#/' /etc/fstab

# 設定服務自動重啟
systemctl enable kubelet

# Master Node 啟動
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
kubectl taint nodes --all node-role.kubernetes.io/master-

# kubeconfig
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploying a pod network
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```