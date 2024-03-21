# Update AUR Package

A simple yet powerful action to automatically update your AUR package to the version you just tagged on github. Minorly
tweaked variant of [ATiltedTree/create-aur-release](https://github.com/ATiltedTree/create-aur-release) and also
[aksh1618/update-aur-package](https://github.com/aksh1618/update-aur-package).

## Inputs

| Input             | Required | Description                                                                              |
|-------------------| -------- |------------------------------------------------------------------------------------------|
| `dry_run`         | `false`  | If set to `true`, the action will not push the changes to AUR but will instead just log. |
| `version`         | `true`   | The version of the release.                                                              |
| `package_name`    | `true`   | The name of the AUR package to update.                                                   |
| `commit_username` | `true`   | The username to use when creating the new commit.                                        |
| `commit_email`    | `true`   | The email to use when creating the new commit.                                           |
| `ssh_private_key` | `true`   | The SSH private key with access to the specified AUR package.                            |

## Example

```yaml
name: Publish

on:
  push:
    tags:
      - "v*"

jobs:
  aur-publish:
    runs-on: ubuntu-latest
    steps:
      - name: Extract version
        id: extract_version
        run: echo "VERSION=${GITHUB_REF#refs/tags/v}" >> $GITHUB_ENV
        env:
          GITHUB_REF: ${{ github.ref }}

      - name: Publish AUR package
        uses: aksh1618/update-aur-package@v1.0.5
        with:
          version: "$VERSION"
          package_name: my-awesome-package
          commit_username: "Github Action Bot"
          commit_email: github-action-bot@example.com
          ssh_private_key: ${{ secrets.AUR_SSH_PRIVATE_KEY }}
```
