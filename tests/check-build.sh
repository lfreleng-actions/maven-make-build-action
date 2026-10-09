#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Linux Foundation

# Checks a build of a Maven reactor ran on the JDK asked for. What is
# on PATH after the action proves only what got installed; the jar
# manifests and Surefire reports record the JDK that packaged and
# tested the code, so a build that fell back to another JDK, or that
# ran no tests, fails here.
#
# Every module the parent POM lists must have a jar under target/
# whose manifest carries Build-Jdk-Spec: <java-version>. The Surefire
# reports must record that java.specification.version, at least one
# test must pass, and none may fail or error.
#
# Usage: check-build.sh <project-dir> <java-version>

set -euo pipefail

project="${1:?project directory}"
java="${2:?Java feature version, such as 21}"

status=0
fail() {
  echo "::error::$1"
  status=1
}

# The value of attribute $1 in the testsuite element $2.
count() {
  sed -n "s/.* $1=\"\([0-9]*\)\".*/\1/p" <<< "$2"
}

modules="$(sed -n 's|.*<module>\(.*\)</module>.*|\1|p' "${project}/pom.xml")"
if [ -z "${modules}" ]; then
  echo "::error::${project}/pom.xml lists no modules"
  exit 1
fi

while IFS= read -r module; do
  target="${project}/${module}/target"
  jars="$(find "${target}" -maxdepth 1 -type f -name '*.jar' 2>/dev/null \
    || true)"
  if [ -z "${jars}" ]; then
    fail "${module}: no jar under ${target}"
    continue
  fi
  while IFS= read -r jar; do
    # Manifests end lines with CRLF.
    spec="$(unzip -p "${jar}" META-INF/MANIFEST.MF | tr -d '\r' \
      | sed -n 's/^Build-Jdk-Spec: //p')"
    if [ "${spec}" = "${java}" ]; then
      echo "${jar}: Build-Jdk-Spec ${spec}"
    else
      fail "${jar}: Build-Jdk-Spec '${spec:-missing}', expected ${java}"
    fi
  done <<< "${jars}"
done <<< "${modules}"

reports="$(find "${project}" -type f -path '*/target/surefire-reports/*' \
  -name 'TEST-*.xml' | sort)"
if [ -z "${reports}" ]; then
  fail "no Surefire reports under ${project}"
else
  marker="name=\"java.specification.version\" value=\"${java}\""
  passed=0
  while IFS= read -r report; do
    if ! grep -qF "${marker}" "${report}"; then
      fail "${report}: tests did not run on JDK ${java}"
    fi
    suite="$(grep -o '<testsuite [^>]*>' "${report}" | head -n 1)"
    tests="$(count tests "${suite}")"
    failures="$(count failures "${suite}")"
    errors="$(count errors "${suite}")"
    skipped="$(count skipped "${suite}")"
    if [ -z "${tests}" ] || [ -z "${failures}" ] || [ -z "${errors}" ] \
      || [ -z "${skipped}" ]; then
      fail "${report}: no test counts in its testsuite element"
      continue
    fi
    echo "${report}: ${tests} tests, ${failures} failures," \
      "${errors} errors, ${skipped} skipped"
    if [ "${failures}" -ne 0 ] || [ "${errors}" -ne 0 ]; then
      fail "${report}: ${failures} failures, ${errors} errors"
    fi
    passed=$((passed + tests - failures - errors - skipped))
  done <<< "${reports}"
  if [ "${passed}" -lt 1 ]; then
    fail "no test passed"
  fi
fi

if [ "${status}" -eq 0 ]; then
  echo "The build ran on JDK ${java} ✅"
fi
exit "${status}"
