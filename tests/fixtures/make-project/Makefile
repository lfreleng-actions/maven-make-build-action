# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Linux Foundation

# The make front end the action drives. MVN and MVN_FLAGS can be
# overridden to build with another Maven; options Maven itself should
# see on every run, such as a local repository, go in MAVEN_ARGS.
MVN ?= mvn
MVN_FLAGS ?= -B

.PHONY: all test clean

# install rather than package: core must reach the local repository
# for a build of app alone to resolve it.
all:
	$(MVN) $(MVN_FLAGS) clean install

test:
	$(MVN) $(MVN_FLAGS) test

clean:
	$(MVN) $(MVN_FLAGS) clean
