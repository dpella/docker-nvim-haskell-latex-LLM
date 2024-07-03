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

In file `./ssh/gituser`, complete the following lines with your name and email address. 

```bash
git config --global user.name "Your name here" 
git config --global user.email you@email.address
```
## LLM (Mistral)

You can run LLM inside nvim! The image will be preconfigured with [Mistral AI model](https://mistral.ai/) 
run via [Ollama](https://ollama.com/). You can run the LLM locally or connect to a remote server via SSH. 

Go to the file `./ssh/llm` 

```bash
LLM_MODE=0  # 0 for local, and 1 for connecting with a remote server via SSH tunneling

# For remote only  
LLM_SERVER=<your Ollama server>
LLM_PORT=<port where Ollama is listening>
SSH_USER=<your username to login into the remote machine>
SSH_PORT=<the port where SSH is listening>
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

# Customization 

- Welcome banner: `./otherfiles/chadrc.lua` 
- Key mappings: `./otherfiles/mappings.lua`
