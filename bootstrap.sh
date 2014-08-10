#!/bin/sh
set -e

: ${BOOTSTRAP_REPOS:="test"}

: ${XDG_CONFIG_HOME:="${HOME}/.config"}
: ${BIN_DIR:="${HOME}/.local/bin"}

GIT=$(which git || true)
if [ -z "${GIT}" ]; then
  echo "git required."
  exit 1
fi

VCSH=$(which vcsh || true)
if [ -z "${VCSH}" ]; then
  echo "installing vcsh to ${BIN_DIR}"
  mkdir -p ${BIN_DIR}
  VCSH="${BIN_DIR}/vcsh"
  curl -s https://raw.githubusercontent.com/RichiH/vcsh/master/vcsh -o "${VCSH}"
  chmod 700 ${VCSH}
fi

MR=$(which mr || true)
if [ -z "${MR}" ]; then
  echo "installing mr to ${BIN_DIR}"
  mkdir -p ${BIN_DIR}
  MR="${BIN_DIR}/mr"
  curl -s https://raw.githubusercontent.com/joeyh/myrepos/master/mr -o "${MR}"
  chmod 700 ${MR}
fi

echo "installing vcsh sparse checkout hook..."
: ${VCSH_HOOK_D:="${XDG_CONFIG_HOME}/vcsh/hooks-enabled"}
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


echo "cloning bootstrap vcsh repositories..."
for repo in ${BOOTSTRAP_REPOS}; do
  if [ ! -d "${XDG_CONFIG_HOME}/vcsh/repo.d/${repo}.git" ]; then
    ${VCSH} clone https://github.com/marklee77/vcsh-homedir-${repo}.git ${repo}
  fi
done
