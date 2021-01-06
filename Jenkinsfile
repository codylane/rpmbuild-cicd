pipeline {
  agent any

  parameters {
    choice(choices: ['en_US.UTF-8'], description: 'Locale specific environment', name: 'LANG')

    string(name: 'RPM_NAME',    defaultValue: '',   description: 'The RPM name')
    string(name: 'RPM_VERSION', defaultValue: '',   description: 'The version of the RPM in format X.Y.Z')
    string(name: 'RPM_RELEASE', defaultValue: '-1', description: 'The release of the RPM')
    string(name: 'PATCH_SPEC',  defaultValue: '',   description: 'If provided, this value should be the short filename to specify that a the RPM spec file should be patched.')

    text(name: 'BUILD_PACKAGES', defaultValue: '',  description: 'Extra packages that need to be installed to in order to build the RPM')

    text(name: 'RPMBUILD_EXTRA_ARGS', defaultValue: '',  description: 'Extra arguments that you want to pass to rpmbuild')
    text(name: 'SRC_RPMS',            defaultValue: '',  description: 'If provided, should be a multiline list of URLs to download SRC rpms')

    string(name: 'QA_RPATHS', defaultValue: '$(( 0x0002 ))', description: 'Disables invalid require paths')
  }

  environment {
    BUILD_PACKAGES      = "${params.BUILD_PACKAGES}"
    LANG                = "en_US.UTF-8"
    PATCH_SPEC          = "${params.PATCH_SPEC}"
    RPM_NAME            = "${params.RPM_NAME}"
    RPM_VERSION         = "${params.RPM_VERSION}"
    RPM_RELEASE         = "${params.RPM_RELEASE}"
    RPMBUILD_EXTRA_ARGS = "${params.RPMBUILD_EXTRA_ARGS}"
    QA_RPATHS           = "${params.QA_RPATHS}"
    SRC_RPMS            = "${params.SRC_RPMS}"
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

    stage ('build-rpm') {
      steps {
        dir ('../workspace') {
          sh 'make rpm'
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
