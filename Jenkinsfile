pipeline {
   agent none
   environment {
        ENV = "dev"
        NODE = "Build-server"
    }

   stages {
    stage('Build Image') {
        agent {
            node {
                label "Build-server"
                customWorkspace "/home/seta/receiptify/"
                }
            }
        environment {
            TAG = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()
        }
         steps {
            sh "docker build . -t receiptify-$ENV:latest --build-arg BUILD_ENV=$ENV -f Dockerfile"


            sh "cat docker.txt | docker login -u 29trxngxx --password-stdin"
            // tag docker image
            sh "docker tag receiptify-$ENV:latest 29trxngxx/receiptify:$TAG"

            //push docker image to docker hub
            sh "docker push 29trxngxx/receiptify:$TAG"

	    // remove docker image to reduce space on build server	
            sh "docker rmi -f 29trxngxx/receiptify:$TAG"

           }
         
       }
	  stage ("Deploy ") {
	    agent {
        node {
            label "Target-Server"
                customWorkspace "/home/ubuntu/receiptify-$ENV/"
            }
        }
        environment {
            TAG = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()
        }
	steps {
            sh "sed -i 's/{tag}/$TAG/g' /home/ubuntu/receiptify-$ENV/docker-compose.yaml"
            sh "docker-compose up -d"
        }      
       }
   }
    
}