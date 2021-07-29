#!/bin/zsh
east=`terraform output -raw East_public_ip`
west=`terraform output -raw West_public_ip`

print ssh terraform@$east -i tf-packer "cd go/src/github.com/hashicorp/learn-go-webapp-demo;nohup go run webapp.go 2>&1 &"
print ssh terraform@$west -i tf-packer "cd go/src/github.com/hashicorp/learn-go-webapp-demo;nohup go run webapp.go 2>&1 &"
