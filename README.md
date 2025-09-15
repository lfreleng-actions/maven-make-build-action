<!--
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2025 The Linux Foundation
-->

# 🛠️ Maven Make Build Action

Builds a Maven project using Make, with integrated JaCoCo coverage reporting
and flexible environment configuration.

This action sets up OpenJDK and Maven, exports custom environment variables
and secrets, then builds the project using Make targets. It also generates
JaCoCo test coverage badges and reports.

## maven-make-build-action

## Usage Example

<!-- markdownlint-disable MD046 -->

```yaml
steps:
  - name: "Build Maven project with Make"
    id: maven-make-build
    uses: lfreleng-actions/maven-make-build-action@main
    with:
      jdk-version: "17"
      mvn-version: "3.8.2"
      make-targets: "clean compile test"
      run-jacoco: "true"
```

<!-- markdownlint-enable MD046 -->

## Inputs

<!-- markdownlint-disable MD013 -->

| Name          | Required | Default | Description                             |
| ------------- | -------- | ------- | --------------------------------------- |
| path_prefix   | False    | "."     | Directory location containing project   |
|               |          |         | code                                    |
| jdk-version   | False    | "17"    | OpenJDK version to set up               |
| mvn-version   | False    | "3.8.2" | Maven version to set up                 |
| make-targets  | False    | "all"   | Targets for the make command (e.g.,     |
|               |          |         | "clean compile test")                   |
| env-vars      | False    | "{}"    | Pass GitHub variables as environment    |
|               |          |         | variables via `toJSON(vars)` or         |
|               |          |         | specific variables in JSON              |
| env-secrets   | False    | "{}"    | Pass GitHub secrets as environment      |
|               |          |         | variables via `toJSON(secrets)` or      |
|               |          |         | specific secrets in JSON                |
| run-jacoco    | False    | "true"  | Boolean defining whether JaCoCo         |
|               |          |         | coverage reporting runs                 |

<!-- markdownlint-enable MD013 -->

## Outputs

This action does not produce explicit outputs, but generates the following
artifacts:

- Compiled Maven project artifacts
- JaCoCo coverage reports (if enabled)
- JaCoCo coverage badges in `badges/` directory
- Test results and coverage metrics in logs

## Implementation Details

The action performs the following steps:

1. **Environment Setup**: Validates the project directory path
2. **JDK Setup**: Installs the specified OpenJDK version using Temurin
   distribution
3. **Maven Setup**: Installs the specified Maven version
4. **Environment Variables**: Exports custom GitHub variables as environment
   variables
5. **Environment Secrets**: Exports custom GitHub secrets as environment
   variables
6. **Build Execution**: Changes to the project directory and runs the
   specified Make targets
7. **Coverage Analysis**: Generates JaCoCo coverage badges and reports
   (if enabled)
8. **Coverage Logging**: Outputs coverage percentages to build logs

## Environment Variables and Secrets

You can pass custom environment variables and secrets using JSON format:

```yaml
with:
  env-vars: |
    {
      "CUSTOM_VAR": "value",
      "BUILD_ENV": "production"
    }
  env-secrets: |
    {
      "API_KEY": "${{ secrets.MY_API_KEY }}",
      "DATABASE_URL": "${{ secrets.DB_CONNECTION }}"
    }
```

Or pass all GitHub variables/secrets at once:

```yaml
with:
  env-vars: ${{ toJSON(vars) }}
  env-secrets: ${{ toJSON(secrets) }}
```

## JaCoCo Coverage Reporting

When `run-jacoco` has the value `true` (default), the action will:

- Generate coverage badges for both line and branch coverage
- Create a coverage summary
- Place badges in the `badges/` directory
- Log coverage percentages to the build output

Coverage reporting automatically skips during local testing with
[act](https://github.com/nektos/act).

## Make Integration

This action expects your project to have a `Makefile` with appropriate
targets. Common Make targets include:

- `all` - Default target (builds everything)
- `clean` - Removes build artifacts
- `compile` - Compiles the source code
- `test` - Runs unit tests
- `package` - Creates distributable packages

You can specify more than one target:

```yaml
with:
  make-targets: "clean compile test package"
```

## Notes

- The action uses SHA-pinned versions of all external actions for security
- JDK and Maven versions allow customization based on project requirements
- The action automatically handles Maven repository caching through the
  setup actions
- All environment variables and secrets have proper masking in logs for
  security
