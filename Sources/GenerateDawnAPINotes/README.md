# apinotes generation

Swift can consume C APIs directly. The Swift compiler synthesizes a Swift interface based
on the C headers. It is possible to influence what API the Swift compiler generates using
an "apinotes" file. That is a YAML sidecar for the module.modulemap file.

This compiler plugin generates an apinotes file for Dawn based on the Dawn API as
described in the dawn.json file.
