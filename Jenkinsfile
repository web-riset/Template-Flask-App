pipeline{
  
  options {
    ansiColor('xterm')
  }

  environment {
    nameImage = "batik50-cnn"
    registry = "$URL_REGISTRY"+ "$nameImage"
    dockerImage = ""
  }
  agent none

  stages {
    stage('Build') {
      agent { node { label 'built-in'}}
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }

    stage('push') {
      agent { node { label 'built-in'}}
      steps{
        script {
          docker.withRegistry( "" ) {
            dockerImage.push()
          }
        }
      }
    }    

    stage('Deploy App to Kubernetes') {     
      agent {
        kubernetes {
          yamlFile 'builder.yaml'
        }
      }
      steps {
        container('kubectl') {
          withKubeConfig([credentialsId: 'jenkins-kubernetes', serverUrl: 'https://10.10.11.232:6443']) {
            // sh 'kubectl delete -f deployment.yaml'
            sh 'sed -i "s~<IMAGE>~${registry}:${BUILD_NUMBER}~" deployment.yaml'
            sh 'kubectl apply -f deployment.yaml'
          }
        }
      }
    }
  }
}

