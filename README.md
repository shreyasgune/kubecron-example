# kubecron-example
Ready to go kube-cron example

[Documentation](https://kubernetes.io/docs/tasks/job/automated-tasks-with-cron-jobs/)

[Another good resource](https://luludansmarue.github.io/kubernetes-docker-lab/k8s/deployment/cron.html)

## Pre-reqs 
[Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) 

[Skaffold](https://skaffold.dev/docs/install/) `Optional`

## Steps 
1. Create your script , in this case, its `myscript.sh`
2. Create your Dockerfile, build and test the image locally.
    ``` 
        docker build -t <org>/<repo-name>:tag .
        docker run <org>/<reponame>:tag 
        >> output of the script
    ```
3. Push your image to your image registry : dockerhub, gcr, quay etc
    `docker push <org>/<reponame>:tag` 
4. `minikube start`
5. Kubectl commands to test your cron.
```
kubectl create -f cronjob.yaml

kubectl get cronjob <cronjob_name>

kubectl get jobs --watch 


kubectl get pods --watch                                                                                                                                ✔  minikube/default ⎈   11:17    03.30.20
NAME                            READY   STATUS    RESTARTS   AGE
cron-example-1585581480-bkwp7   0/1     Pending   0          0s
cron-example-1585581480-bkwp7   0/1     Pending   0          0s
cron-example-1585581480-bkwp7   0/1     ContainerCreating   0          0s
cron-example-1585581480-bkwp7   0/1     Completed           0          3s


Check it out in the logs:
kubectl logs cron-example-1585581480-bkwp7                                                                                                                     ✔  minikube/default ⎈   11:16    03.30.20
Mon Mar 30 15:18:04 UTC 2020
My bash script is running!

```

## Skaffold Run/Dev 
```
╰ skaffold dev                                                                                                                                              ✔  minikube/default ⎈   11:18    03.30.20
Listing files to watch...
 - shreyasgune/kubecron-demo
Generating tags...
 - shreyasgune/kubecron-demo -> shreyasgune/kubecron-demo:5cd7ddf-dirty
Checking cache...
 - shreyasgune/kubecron-demo: Not found. Building
Found [minikube] context, using local docker daemon.
Building [shreyasgune/kubecron-demo]...
Sending build context to Docker daemon   5.12kB
Step 1/8 : FROM alpine:latest
 ---> e7d92cdc71fe
Step 2/8 : RUN apk add bash
 ---> Running in 4e86bb67da28
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
(1/4) Installing ncurses-terminfo-base (6.1_p20200118-r2)
(2/4) Installing ncurses-libs (6.1_p20200118-r2)
(3/4) Installing readline (8.0.1-r0)
(4/4) Installing bash (5.0.11-r1)
Executing bash-5.0.11-r1.post-install
Executing busybox-1.31.1-r9.trigger
OK: 8 MiB in 18 packages
 ---> 1406bae4c824
Step 3/8 : RUN addgroup -S cron-group && adduser -S cron-user -G cron-group
 ---> Running in da7826ee95a7
 ---> 9d4ee0d95e60
Step 4/8 : WORKDIR /app
 ---> Running in 861d17b9bf24
 ---> 44573cc5c413
Step 5/8 : COPY myscript.sh /app/myscript.sh
 ---> 4deb412359b8
Step 6/8 : RUN chmod +x /app/myscript.sh
 ---> Running in 414b03ec5086
 ---> ea6099703318
Step 7/8 : USER cron-user
 ---> Running in 59144a3ed905
 ---> bae758fecc4a
Step 8/8 : CMD ["/app/myscript.sh"]
 ---> Running in 3b0e72836470
 ---> d2ef5f8f1bbe
Successfully built d2ef5f8f1bbe
Successfully tagged shreyasgune/kubecron-demo:5cd7ddf-dirty
Tags used in deployment:
 - shreyasgune/kubecron-demo -> shreyasgune/kubecron-demo:d2ef5f8f1bbe04896cb0a1a0b8e11e25e76e678afcf129f53840b9d44ac4dd06
   local images can't be referenced by digest. They are tagged and referenced by a unique ID instead
Starting deploy...
 - cronjob.batch/cron-example created
Watching for changes...
[cron-example-1585581660-frx2v cron-example] Mon Mar 30 15:21:02 UTC 2020
[cron-example-1585581660-frx2v cron-example] My bash script is running!
^CCleaning up...
 - cronjob.batch "cron-example" deleted
There is a new version (1.6.0-docs) of Skaffold available. Download it at https://storage.googleapis.com/skaffold/releases/latest/skaffold-darwin-amd64

```