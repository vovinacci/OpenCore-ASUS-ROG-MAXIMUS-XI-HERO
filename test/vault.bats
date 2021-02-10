#!/usr/bin/env bats
#
# 'util/vault.sh' tests.

load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

@test "util/vault.sh: unset ANSIBLE_VAULT_PASSWORD_FILE variable should fail the script" {
  unset ANSIBLE_VAULT_PASSWORD_FILE
  run util/vault.sh
  assert_failure 1
  assert_output --partial 'ANSIBLE_VAULT_PASSWORD_FILE variable not set.'
}
