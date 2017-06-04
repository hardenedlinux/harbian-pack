# Deployment

In order to deploy the environment, these steps are needed:
- Create a clean Debian stretch environment (currently root permission is
  needed to make packages, containers or virtual machines are all Ok).
- Install `git` and `build-essential` packages:
```
apt-get install git build-essential
```
- Clone this git repository and enter the directory:
```
git clone https://github.com/hardenedlinux/harbian-pack.git
cd harbian-pack
```
- If the `make repo` facility is needed, the repository configuration should
  be set:
```
cp build_system/do_make_repo/do_make_repo.conf{.example,}
vi build_system/do_make_repo/do_make_repo.conf # Change the values as your want
```
- Then refer to other documents in doc/ directory.
