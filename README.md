# NvChad Customization 

This repository builds a docker image of NvChad -- a customization of Neo Vim. 

You have all of NvChad with the addition of severals plugins and configurations to:

1. Develop in Haskell (language server) 
2. Write markdown documents (language server) 
3. Write, compile, and visualize Latex documents (`<leader> cl`)
4. Manage repositories and commits (Lazygit, `<leager gg>`)
5. Auto-indentation when saving files (`*.hs`, `*.tex`, `*.lua`)
6. Dictionary and writting suggestion by ltex 
7. Multi-cursor editing capabilities (`<C-m>`)
8. Keeping tracks of comments of the form `TODO:`, `HACK:`, and `BUG:` (`]t` and `[t` for next an prev comment)
9. Save and restore sessions (`<leader> z`)
10. LLM Support (Ollama) with Mistral model (`<leader> ww`)
11. Welcome screen of DPella (the company where I work)

All of the docker images will have a volume associated with it and mounted in `/vol`.
This is the directory where you should put all your persisten data.

# Configuration 

## SSH Keys:

Once you clone this repo, you should get into `ssh` and add your private /
public keys to connect to Github or Bitbucket.

File `key` is the private key file which is **not** passphrase protected. File
`key.pub` is your public key.

## To create a key

Run the following command inside the `ssh` directory, and just press enter when asked for a password.

```bash
ssh-keygen -t ed25519 -C <your_email> -f ./key
```
Don't forget to upload the public keys to Github or Bitbucket. 
 
## Git 

In file `./dockerfiles/neo-h.docker`, change the following lines with your name and email address. 

```bash
RUN echo 'git config --global user.name "Alejandro Russo"' >> ${WORKINGDIR}/.bashrc
RUN echo 'git config --global user.email alejandro@dpella.io' >> ${WORKINGDIR}/.bashrc
```

# Launch 

```bash
./launch neo-h
```

If the image does not exist, it will create it and launch the container. If the image exits, 
it will launch it inside a container. 

After the image is launched, simply type

```bash 
docker attach <4 first letters of the container created>
```

Once inside the container, type 

```bash 
nvim 
```

Enjoy! 
