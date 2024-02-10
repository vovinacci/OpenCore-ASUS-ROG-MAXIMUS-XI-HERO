#!/usr/bin/env bats
#
# 'util/vault.sh' tests.

TEST_BREW_PREFIX="$(brew --prefix)"
readonly TEST_BREW_PREFIX

load "${TEST_BREW_PREFIX}/lib/bats-support/load.bash"
load "${TEST_BREW_PREFIX}/lib/bats-assert/load.bash"

@test "util/vault.sh: unset SOPS_AGE_KEY variable should fail the script" {
  export SOPS_AGE_RECIPIENTS="test"
  unset SOPS_AGE_KEY
  run ./util/vault.sh
  assert_failure 1
  assert_output --partial 'SOPS_AGE_KEY variable is not set.'
}

@test "util/vault.sh: unset SOPS_AGE_RECIPIENTS variable should fail the script" {
  export SOPS_AGE_KEY="test"
  unset SOPS_AGE_RECIPIENTS
  run ./util/vault.sh
  assert_failure 1
  assert_output --partial 'SOPS_AGE_RECIPIENTS variable is not set.'
}

@test "util/vault.sh: unset SOPS_AGE_KEY and SOPS_AGE_RECIPIENTS variables should fail the script" {
  unset SOPS_AGE_KEY
  unset SOPS_AGE_RECIPIENTS
  run ./util/vault.sh
  assert_failure 1
  assert_output --partial 'SOPS_AGE_KEY variable is not set.'
}
