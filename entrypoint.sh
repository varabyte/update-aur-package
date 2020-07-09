#!/bin/bash

set -o errexit -o pipefail -o nounset

NEW_RELEASE=${GITHUB_REF##*/v}

export HOME=/home/builder

echo "::group::Setup"

echo "Getting AUR SSH Public keys"
ssh-keyscan aur.archlinux.org >> $HOME/.ssh/known_hosts

echo "Writing SSH Private keys to file"
echo -e "${INPUT_SSH_PRIVATE_KEY//_/\\n}" > $HOME/.ssh/aur

chmod 600 $HOME/.ssh/aur*

echo "Starting SSH Agent and adding the key"

eval $(ssh-agent)
expect << EOF
  spawn ssh-add $HOME/.ssh/aur
  expect "Enter passphrase"
  send "$INPUT_SSH_PRIVATE_KEY_PASSWORD\r"
  expect eof
EOF

echo "Setting up Git"
git config --global user.name "$INPUT_COMMIT_USERNAME"
git config --global user.email "$INPUT_COMMIT_EMAIL"

REPO_URL="ssh://aur@aur.archlinux.org/${INPUT_PACKAGE_NAME}.git"

echo "Cloning repo"
cd /tmp
git clone "$REPO_URL"
cd "$INPUT_PACKAGE_NAME"

echo "Setting version: ${NEW_RELEASE}"
sed -i "s/pkgver=.*$/pkgver=${NEW_RELEASE}/" PKGBUILD
sed -i "s/pkgrel=.*$/pkgrel=1/" PKGBUILD
perl -i -0pe "s/sha256sums=[\s\S][^\)]*\)/$(makepkg -g 2>/dev/null)/" PKGBUILD

echo "::endgroup::Setup"

echo "::group::Build"

echo "Building and installing dependencies"
makepkg --noconfirm -s

echo "Updating SRCINFO"
makepkg --printsrcinfo > .SRCINFO

echo "::endgroup::Build"

echo "::group::Publish"

echo "Publishing new version"
# Update aur
git add PKGBUILD .SRCINFO
git commit --allow-empty  -m "Update to $NEW_RELEASE"
git push

echo "Publish Done"

echo "::endgroup::Publish"
