#!/bin/sh
set -e

#: ${VCSH_HOOK_D:="$XDG_CONFIG_HOME/vcsh/hooks-enabled"}
export VCSH_HOOK_D="${HOME}/.config/vcsh/hooks-enabled"
mkdir -p "${VCSH_HOOK_D}"
cd "${VCSH_HOOK_D}"

HOOK_SCRIPT="post-init.sparse-checkout"
cat > "${HOOK_SCRIPT}" << HOOK
#!/bin/sh
if ! test "\$(git config core.sparseCheckout)" = "true"; then
    git config core.sparseCheckout true
fi
cat >> \$GIT_DIR/info/sparse-checkout << EOF
*
!README*
!LICENSE*
!.gitignore
!Vagrantfile
!.travis.yml
!travis
EOF
HOOK

chmod 755 "${HOOK_SCRIPT}"

vcsh clone https://github.com/marklee77/vcsh-homedir-test.git test
