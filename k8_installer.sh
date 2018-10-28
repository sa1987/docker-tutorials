#On centos, kuberne doesn’t work if swarp is on. So disable it. 
#swapoff -a
#comment on /etc/fstab

yum install docker -y
systemctl start docker
systemctl enable docker
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum update  -y

yum -y install kubeadm kubectl kubelet

systemctl start kubelet
systemctl enable kubelet
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

kubeadm init --pod-network-cidr=10.192.168.0/24 --ignore-preflight-errors all
#manuall get the link and excite 
kubeadm join --token --discovery-token-ca-cert-hash sha256:
exit()
#if error kubeadm reset
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 
chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
