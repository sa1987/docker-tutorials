cat << EOF > sleepy.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: busybox
spec:
  template:
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ["sleep", "10"]
      restartPolicy: Never
  backoffLimit: 4
  EOF
  
  kubectl create -f sleepy.yaml
  
  kubectl describe <pod-name>
  
