#!/bin/sh

: ${XDG_CONFIG_HOME:="${HOME}/.config"}
: ${BIN_DIR:="${HOME}/.local/bin"}
export PATH="${BIN_DIR}:${PATH}"

set -e

GIT=$(which git || true)
if [ -z "${GIT}" ]; then
  echo "git required."
  exit 1
fi

PIP=$(which pip || true)
if [ -z "${PIP}" ]; then
  echo "installing pip to ${BIN_DIR}"
  mkdir -p ${BIN_DIR}
  export PATH="${BIN_DIR}:${PATH}"
  PIP="${BIN_DIR}/pip"
  curl -s https://bootstrap.pypa.io/get-pip.py | python - --user
fi

VCSH=$(which vcsh || true)
if [ -z "${VCSH}" ]; then
  echo "installing vcsh to ${BIN_DIR}"
  mkdir -p ${BIN_DIR}
  export PATH="${BIN_DIR}:${PATH}"
  VCSH="${BIN_DIR}/vcsh"
  curl -s https://raw.githubusercontent.com/RichiH/vcsh/master/vcsh -o "${VCSH}"
  chmod 700 ${VCSH}
fi

MR=$(which mr || true)
if [ -z "${MR}" ]; then
  echo "installing mr to ${BIN_DIR}"
  mkdir -p ${BIN_DIR}
  export PATH="${BIN_DIR}:${PATH}"
  MR="${BIN_DIR}/mr"
  curl -s https://raw.githubusercontent.com/joeyh/myrepos/master/mr -o "${MR}"
  chmod 700 ${MR}
fi

echo "preparing vcsh hook directories..."
: ${VCSH_HOOK_A:="${XDG_CONFIG_HOME}/vcsh/hooks-available"}
: ${VCSH_HOOK_E:="${XDG_CONFIG_HOME}/vcsh/hooks-enabled"}
mkdir -p ${VCSH_HOOK_A} ${VCSH_HOOK_E}

echo "installing vcsh sparse checkout hook..."
HOOK_SCRIPT="post-init.sparse-checkout"
cd ${VCSH_HOOK_A}
cat > "${HOOK_SCRIPT}" << HOOK
#!/bin/sh
git config core.sparseCheckout true
cat >> \$GIT_DIR/info/sparse-checkout << EOF
*
!.gitignore
!.travis.yml
!LICENSE*
!README*
!Vagrantfile
!docs
!travis
EOF
HOOK
chmod 755 "${HOOK_SCRIPT}"
cd ${VCSH_HOOK_E}
ln -s ../hooks-available/${HOOK_SCRIPT} ${HOOK_SCRIPT}

