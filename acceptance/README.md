Acceptance Testing
==================

The acceptance testing framework is a custom build of ruby 2.5.8 + serverspec + rspec specific to CentOS 8

# Helpful Links

* [Servspec Home](https://serverspec.org/)
* [Serverspec Tutorial](https://serverspec.org/tutorial.html)
* [Serverspec Resource Types](https://serverspec.org/resource_types.html)
* [Advanced tips with Serverspec](https://serverspec.org/advanced_tips.html)

# Directory schema layout

* The variables listed below are used in the `Makefile` to facilitate invoking your acceptance tests if you choose
  to define them

```
.
└── spec
    └── ${RPM_NAME}
         |- ${RPM_NAME}-${RPM_VERSION}-${RPM_RELEASE}_spec.rb
```
