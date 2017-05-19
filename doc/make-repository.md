# Create an APT repository

Before create an APT repository, please ensure there is one GPG key pair in
your current user's GPG keyring -- it will be used for signing the
repository. The public key of this key pair should be available for all
users of this repository. To import the publiv key into APT, run the
following command (assume the repo.gpg is the public key file):
```
apt-key add repo.gpg
```

First enter the environment according to the commands in enter-environment.md.

Then run `do_make_repo` command, an APT repository will then be available in
repo/ directory.

Such a repository can be reference in source.list like this: (Please replace
the path with the correct value)
```
deb file:/tmp/test/repo ./
```
