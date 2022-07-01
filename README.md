# Repository to create docker images 

- GHC 8.6.5
- Latex (all packages)

# SSH Keys:

Once you clone this repo, you should get into `ssh` and add your private / public keys to connect to Github or Bitbucket. 
File `key` is the private key file which is **not** passphrase protected. File `key.pub` is your public key. 

# To create / launch an image 

- File `./ghc865.sh` creates / launches a docker images with GHC 8.6.5.
- File `./latex.sh` creates / launches a docker with texlive in its full version. 

All of the docker images will have a volume associated with it and mounted in `/vol`. 
This is the directory where you should put all your persisten data. 

# VS Code

Install the extension "Remote - Containers" to attach the editor to the container.

# To create a key

Run the following command inside the `ssh` directory, and just press enter when asked for a password. 

```bash
ssh-keygen -t ed25519 -C <your_email> -f ./key
```
# Where to find the files /vol in Windows 

```
\\wsl$\docker-desktop-data\version-pack-data\community\docker
```
