#!/usr/bin/env bash
#
# Replace '{{BOARDSERIAL}}', '{{MACADDRESS}}', '{{SERIAL}}' and '{{SMUUID}}'
# with actual values from vault.
#
# Requires SOPS - https://github.com/mozilla/sops.

# Write safe shell scripts
set -euf -o pipefail

# Set locale
export LC_ALL="en_US.UTF-8"

# Base directory
BASE_DIR="$(dirname "$(realpath "$0")")"
readonly BASE_DIR
# OpenCore configuration file
OC_CONFIG_FILE="${BASE_DIR}/../EFI/OC/config.plist"
readonly OC_CONFIG_FILE

# Print error message to stderr and exit with code 1
# Arguments:
#   Error message
function fail() {
  (echo >&2 "[$(date +'%Y-%m-%dT%H:%M:%S%z')] [FATAL]: $*")
  exit 1
}

# Perform sanity checks prior doing anything
# Globals:
#   OC_CONFIG_FILE
function __preflight_checks() {
  # Check SOPS variables, required for secret decryption
  if [[ ! -v SOPS_AGE_KEY ]]; then
    fail "SOPS_AGE_KEY variable is not set."
  fi
  if [[ ! -v SOPS_AGE_RECIPIENTS ]]; then
    fail "SOPS_AGE_RECIPIENTS variable is not set."
  fi

  # Check generated OpenCore configuration template in EFI folder
  [[ -f "$OC_CONFIG_FILE" ]] ||
    fail "Cannot read '${OC_CONFIG_FILE}'."

  # Check if SOPS is available
  sops --version >/dev/null ||
    fail "Cannot execute 'sops'."
}

# Generate 'config.plist' from template
# Globals
#   BASE_DIR
#   OC_CONFIG_FILE
function generate_config_plist() {
  echo "Reading 'config.plist' template contents..."
  local -r OC_CONFIG_PLIST_TEMPLATE=$(<"$OC_CONFIG_FILE")

  echo "Sourcing vault variables..."
  # shellcheck disable=SC1090
  source <(sops --decrypt "${BASE_DIR}/oc_vars.enc")

  echo "Substituting template with values from vault"
  local OC_CONFIG_PLIST
  OC_CONFIG_PLIST="${OC_CONFIG_PLIST_TEMPLATE//\{\{BOARDSERIAL\}\}/${VAULT_OC_BOARDSERIAL}}"
  OC_CONFIG_PLIST="${OC_CONFIG_PLIST//\{\{MACADDRESS\}\}/${VAULT_OC_MACADDRESS}}"
  OC_CONFIG_PLIST="${OC_CONFIG_PLIST//\{\{SERIAL\}\}/${VAULT_OC_SERIAL}}"
  OC_CONFIG_PLIST="${OC_CONFIG_PLIST//\{\{SMUUID\}\}/${VAULT_OC_SMUUID}}"

  echo "Removing template 'config.plist'..."
  rm -f "${OC_CONFIG_FILE}"
  echo "Writing back to 'config.plist'..."
  echo "$OC_CONFIG_PLIST" >"${OC_CONFIG_FILE}"
}

## Start the ball
__preflight_checks
generate_config_plist

# EOF
