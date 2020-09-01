pipeline {
  agent {
    node {
      label 'php70'
    }
  }
  stages {
    stage('Composer Install') {
      steps {
        sh 'composer install --prefer-dist --no-interaction'
        sh 'composer dumpautoload --no-interaction'
      }
    }
    stage('Analyse Code') {
      steps {
        sh 'php -d zend_extension=xdebug.so ./vendor/bin/spbuilder analyze --ignore-tool visualization'
      }
    }
    stage('Publish Results') {
      steps {
        checkstyle(pattern: 'build/logs/checkstyle.xml,build/logs/smileanalyser.xml')
        pmd(pattern: 'build/logs/pmd.xml')
        dry(pattern: 'build/logs/cpd.xml')
        sh './vendor/bin/spbuilder push --job-url ${JOB_URL} --build-id ${BUILD_NUMBER}'
      }
    }
    stage('Package') {
      steps {
        sshagent (credentials: ['jenkins-private-key']) {
          sh './vendor/bin/spbuilder package --force-name="[git_group_name]-[git_project_name]" --force-version="${BUILD_TAG}"'
        }
      }
    }
    stage('Provision') {
      steps {
        sshagent (credentials: ['jenkins-private-key']) {
          sh './architecture/scripts/provision.sh inte'
        }
      }
    }
    stage('Deploy') {
      steps {
        sshagent (credentials: ['jenkins-private-key']) {
          sh './architecture/scripts/deploy.sh inte -p "${BUILD_TAG}" -s'
          sh './architecture/scripts/magento.sh inte smilereconfigure:apply-conf -e inte -c y'
          sh './architecture/scripts/cache-clean.sh inte'
        }
      }
    }
    stage('Clean Workspace') {
      steps {
        sh 'rm -rf ./build/dist'
        sh 'rm -rf ./pub'
        sh 'rm -rf ./vendor'
      }
    }
  }
}
