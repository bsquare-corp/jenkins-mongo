#!/usr/bin/env groovy

@Library('pipeline-library-maven-docker-builder') _

/* To avoid confusion, the repo name will always be the same as the GIT repo name under the project,
 * and the ECR registry for the repo will also be named the same.
 */

doDockerServiceBuild {
    /* Which branch when built gets push to 'latest' */
    stageFromBranch = 'r4.7.0-musl'
    skipDeploy = true
    squashBuild = true
    dockerBuildKit = true

    timeoutMinutes = 180
}
