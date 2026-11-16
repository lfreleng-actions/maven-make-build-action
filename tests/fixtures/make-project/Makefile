# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Linux Foundation

# The make front end the action drives. MVN and MVN_FLAGS can be
# overridden to build with another Maven; options Maven itself should
# see on every run, such as a local repository, go in MAVEN_ARGS.
MVN ?= mvn
MVN_FLAGS ?= -B

.PHONY: all test clean check-env

comma := ,

# install rather than package: core must reach the local repository
# for a build of app alone to resolve it.
all:
	$(MVN) $(MVN_FLAGS) clean install

test:
	$(MVN) $(MVN_FLAGS) test

clean:
	$(MVN) $(MVN_FLAGS) clean

# Fails unless each variable named in the comma-separated REQUIRED_ENV
# is set and non-empty in the environment make runs in.
check-env:
	$(if $(REQUIRED_ENV),,$(error REQUIRED_ENV names no variables))
	@for name in $(subst $(comma), ,$(REQUIRED_ENV)); do \
		if [ -z "$$(printenv "$$name")" ]; then \
			echo "check-env: $$name is not set" >&2; \
			exit 1; \
		fi; \
		echo "check-env: $$name is set"; \
	done
