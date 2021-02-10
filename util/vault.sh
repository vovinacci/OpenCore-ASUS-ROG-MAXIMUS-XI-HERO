#!/usr/bin/env bash
#
# Replace '{{BOARDSERIAL}}', '{{MACADDRESS}}', '{{SERIAL}}' and '{{SMUUID}}'
# with actual values from vault.
#
# Requires Ansible.

# Write safe shell scripts
set -euf -o pipefail

# Set locale
export LC_ALL="en_US.UTF-8"

# Base directory
readonly BASE_DIR="$(dirname "$(realpath "$0")")"
# OpenCore configuration file
readonly OC_CONFIG_FILE="${BASE_DIR}/../EFI/OC/config.plist"

# Print out to STDERR
err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  exit 1
}

# Do we have ANSIBLE_VAULT_PASSWORD_FILE variable set?
if [[ -z "${ANSIBLE_VAULT_PASSWORD_FILE:+x}" ]]; then
  err "ANSIBLE_VAULT_PASSWORD_FILE variable not set."
fi

# Do we have generated template in EFI folder?
if [[ ! -f "$OC_CONFIG_FILE" ]]; then
  err "Cannot read '${OC_CONFIG_FILE}'."
fi

# Do we have ansible installed?
if ! ansible-vault --version >/dev/null; then
  err "Cannot execute 'ansible-vault'."
fi

echo "Reading 'config.plist' template contents..."
readonly OC_CONFIG_PLIST_TEMPLATE=$(<"$OC_CONFIG_FILE")

echo "Sourcing vault variables..."
# shellcheck disable=SC1090
source <(ansible-vault decrypt "${BASE_DIR}/oc_vars.enc" --output=-)

echo "Substituting template with values from vault"
OC_CONFIG_PLIST="${OC_CONFIG_PLIST_TEMPLATE//\{\{BOARDSERIAL\}\}/${VAULT_OC_BOARDSERIAL}}"
OC_CONFIG_PLIST="${OC_CONFIG_PLIST//\{\{MACADDRESS\}\}/${VAULT_OC_MACADDRESS}}"
OC_CONFIG_PLIST="${OC_CONFIG_PLIST//\{\{SERIAL\}\}/${VAULT_OC_SERIAL}}"
OC_CONFIG_PLIST="${OC_CONFIG_PLIST//\{\{SMUUID\}\}/${VAULT_OC_SMUUID}}"

echo "Removing template 'config.plist'..."
rm -f "${OC_CONFIG_FILE}"
echo "Writing back to 'config.plist'..."
echo "$OC_CONFIG_PLIST" >"${OC_CONFIG_FILE}"

echo "Done."
# EOF
