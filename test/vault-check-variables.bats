#!/usr/bin/env bats

load '/usr/local/lib/bats-support/load.bash'
load '/usr/local/lib/bats-assert/load.bash'

@test "util/vault.sh: unset ANSIBLE_VAULT_PASSWORD_FILE variable fails script" {
  unset ANSIBLE_VAULT_PASSWORD_FILE
  run util/vault.sh
  assert_failure 1
  assert_output --partial 'ANSIBLE_VAULT_PASSWORD_FILE variable not set.'
}
