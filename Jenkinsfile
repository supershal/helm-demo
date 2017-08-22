pipeline {
  agent none

  environment {
    IMAGE_NAME = 'supershal/helm-demo'
  }

  stages {
    stage('Build') {
      agent any

      steps {
        checkout scm
        sh 'make docker VERSION=$BUILD_ID'
      }
    }
    stage('Test') {
      agent any

      steps {
        echo 'TODO: add tests'
      }
    }
    stage('Image Release') {
      agent any

      when {
        expression { env.BRANCH_NAME == 'master' }
      }

      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
          sh '''
            docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
            make push VERSION=$BUILD_ID
          '''
        }
      }
    }
    stage('Staging Deployment') {
      agent any

      when {
        expression { env.BRANCH_NAME == 'master' }
      }

      environment {
        RELEASE_NAME = 'demo-staging'
        SERVER_HOST = 'staging.helm.demo.com'
      }

      steps {
        sh '''
          . ./helm/init.sh
          helm upgrade --install --namespace staging $RELEASE_NAME ./helm/helm-demo --set image.tag=$BUILD_ID,ingress.host=$SERVER_HOST,env.DEMO_ENV=staging,env.JENKINS_BUILD_ID=$BUILD_ID
        '''
      }
    }
    stage('Deploy to Production?') {
      when {
        expression { env.BRANCH_NAME == 'master' }
      }

      steps {
        // Prevent any older builds from deploying to production
        milestone(1)
        input 'Deploy to Production?'
        milestone(2)
      }
    }
    stage('Production Deployment') {
      agent any

      when {
        expression { env.BRANCH_NAME == 'master' }
      }

      environment {
        RELEASE_NAME = 'demo-production'
        SERVER_HOST = 'production.helm.demo.com'
      }

      steps {
        sh '''
          . ./helm/helm-init.sh
          helm dependencies build ./helm/todo
          helm upgrade --install --namespace production $RELEASE_NAME ./helm/helm-demo --set image.tag=$BUILD_ID,ingress.host=$SERVER_HOST,env.DEMO_ENV=staging,env.JENKINS_BUILD_ID=$BUILD_ID
        '''
      }
    }
  }
}