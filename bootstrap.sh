#!/bin/sh
set -e

GIT=$(which git)
if [ -z "${GIT}" ]; then
  echo "git required."
  exit 1
fi

VCSH=$(which vcsh)
if [ -z "${VCSH}" ]; then
  VCSH="${HOME}/.local/bin/vcsh"
  curl https://raw.githubusercontent.com/RichiH/vcsh/master/vcsh -o "${VCSH}"
fi

MR=$(which mr)
if [ -z "${MR}" ]; then
  MR="${HOME}/.local/bin/mr"
  curl https://raw.githubusercontent.com/RichiH/vcsh/master/vcsh -o "${VCSH}"
fi

#: ${VCSH_HOOK_D:="$XDG_CONFIG_HOME/vcsh/hooks-enabled"}
export VCSH_HOOK_D="${HOME}/.config/vcsh/hooks-enabled"
mkdir -p "${VCSH_HOOK_D}"
cd "${VCSH_HOOK_D}"

HOOK_SCRIPT="post-init.sparse-checkout"
cat > "${HOOK_SCRIPT}" << HOOK
#!/bin/sh
git config core.sparseCheckout true
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

${VCSH} clone https://github.com/marklee77/vcsh-homedir-test.git test
