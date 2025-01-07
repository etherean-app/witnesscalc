#!/usr/bin/env bash

BINDIR="${PWD}/package_macos_arm64/bin"

"${BINDIR}/passportVerificationValidity" \
  "${BINDIR}/PassportVerificationValidity.dat" \
  "${PWD}/passportVerificationValidity.inputs.json" \
  "${PWD}/passportVerificationValidity.wtns"
