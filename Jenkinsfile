pipeline {
  agent any

  parameters {
    string(name: 'RPM_NAME',    defaultValue: '',   description: 'The RPM name')
    string(name: 'RPM_VERSION', defaultValue: '',   description: 'The version of the RPM in format X.Y.Z')
    string(name: 'RPM_RELEASE', defaultValue: '-1', description: 'The release of the RPM')

    text(
      name: 'RPMBUILD_EXTRA_ARGS',
      defaultValue: '''
        --define 'debug_package %{nil}'
        --define '_build_number ${RPM_RELEASE}'
        --define 'package_version ${RPM_VERSION}'
      ''',
      description: 'Extra arguments that you want to pass to rpmbuild',
    )

    string(name: 'QA_RPATHS', defaultValue: '$(( 0x0002 ))', description: 'Disables invalid require paths')

  }

  environment {
    LANG                = "en_US.UTF-8"
    RPM_NAME            = "${params.RPM_NAME}"
    RPM_VERSION         = "${params.RPM_VERSION}"
    RPM_RELEASE         = "${params.RPM_RELEASE}"
    SOURCE              = "${params.RPM_NAME}-${params.RPM_VERSION}-static-amd64.tar.gz"
    RPMBUILD_EXTRA_ARGS = "${params.RPMBUILD_EXTRA_ARGS}"
    QA_RPATHS           = "${params.QA_RPATHS}"
  }

  stages {

    stage ('build-rpmbuild-container') {
      steps {
        dir ('../workspace') {
          sh 'make build'
          sh 'docker tag rpmbuild-cicd_centos8-build docker-registry.cmfl.net:5000/rpmbuild-cicd_centos8-build'
          sh 'docker push docker-registry.cmfl.net:5000/rpmbuild-cicd_centos8-build'
        }
      }
    }

  }


//  post {
//    always {
//      cleanWs()
//    }
//  }
}