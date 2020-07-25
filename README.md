# Create AUR Release

A simple yet powerful action to automatically update your AUR package to the version you just tagged on github.

## Inputs

| Input             | Required | Description                                                   |
| ----------------- | -------- | ------------------------------------------------------------- |
| `package_name`    | `true`   | The name of the AUR package to update.                        |
| `commit_username` | `true`   | The username to use when creating the new commit.             |
| `commit_email`    | `true`   | The email to use when creating the new commit.                |
| `ssh_private_key` | `true`   | The SSH private key with access to the specified AUR package. |

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
      - name: Publish AUR package
        uses: ATiltedTree/create-aur-release@v1
        with:
          package_name: my-awesome-package
          commit_username: "Github Action Bot"
          commit_email: github-action-bot@example.com
          ssh_private_key: ${{ secrets.AUR_SSH_PRIVATE_KEY }}
```
