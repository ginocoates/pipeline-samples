[
   {
     "volumesFrom": [],
     "memory": null,
     "extraHosts": [],
     "dnsServers": [],
     "disableNetworking": null,
     "dnsSearchDomains": [],
     "portMappings": [
       {
         "hostPort": 0,
         "containerPort": 80,
         "protocol": "tcp"
       }
     ],
     "hostname": null,
     "essential": true,
     "entryPoint": [],
     "mountPoints": [],
     "name": "${container}",
     "ulimits": [],
     "dockerSecurityOptions": [],
     "environment": [
       {
         "name": "NODE_ENV",
         "value": "production"
       },
       {
         "name": "PORT",
         "value": "80"
       }
     ],
     "links": [],
     "workingDirectory": null,
     "readonlyRootFilesystem": false,
     "image": "${container-image}:${BUILD}",
     "command": [],
     "user": null,
     "dockerLabels": {},
     "logConfiguration": null,
     "cpu": 0,
     "privileged": false,
     "memoryReservation": 500
   }
 ]
