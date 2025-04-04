# NvChad Customization 

This repository builds a docker image of NvChad -- a customization of Neo Vim. 

You have all of NvChad with the addition of severals plugins and configurations to:

1. Develop in Haskell (language server) 
	- `<leader>ld` shows all the errors/suggestions 
	- `<leader>lt` shows all tags 
	- `<leader>ls` shows all symbols
	- `<leader>lb` shows all buffers
	- `<leader>ca` shows recommendations for the code 
	- `<leader>dd` shows the error/suggestion 
	- `<leader>rr` evaluate the expression under `-- >>>`
	- `<leader>ra` evaluate all the expressions under `-- >>>`
	- `<leader>rp` GHCi for the package 
	- `<leader>rf` GHCi for the current file
	- `<leader>rq` close GHCi 
	- `]d` next suggestion/error
	- `[d` previous suggestion/error 
	- `<leader>ts` provides type-signatures that fit a type-hole using Hoogle
2. Write markdown documents (language server) 
3. Write, compile, and visualize Latex documents (`<leader> cl`)
4. Manage repositories and commits (Lazygit, `<leader>gg`)
5. Auto-indentation when saving files (`*.hs`, `*.tex`, `*.lua`)
6. Dictionary and writting suggestion by ltex 
7. Multi-cursor editing capabilities (`<C-m>`, then `n` to move to next one, `q` to skip that occurence)
8. Smart rename (position in a word and hit `<leader>sr`)
9. Keeping tracks of comments of the form `TODO:`, `HACK:`, and `BUG:` (`]t` and `[t` for next an prev comment)
10. Save and restore sessions (`<leader> z`)
11. LLM Support (Ollama) with Mistral model (`<leader>ww`)
12. Welcome screen of DPella (the company where I work)
13. Toggle autoformat (`<leader>tt`)
14. Adding symbols around a word `v iw S{` will take `foo` into `{ foo }`
15. `viw` select the current word 
15. `vi{` select the text around `{`
16. `vac{` select the text around `{`, but including the brackets. It can be changed to `vac[` and so on
17. `O` in visual mode changes to the other extreme
18. `gq%` does autowrapped until finding character `%`
19. `%` goes from an open marker (e.g., `{`) to the closing one
20. `W` jumps to the next word with space. Useful when having `list.get(10)`
21. `Ctrl+w` for all windows related things (resize, swap, etc.)
22. `:tabe .` to select a file an open it in a different tab
23. `za` folds/opens code
24. If something is not working, write `:checkhealth` for the whole nvim, or `:checkhealth <pluginname>`

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
LLM_PORT=<port where Ollama is listening, default 2022>
SSH_USER=<your username to login into the remote machine>
SSH_PORT=<the port where SSH is listening>
```
If you want to change the LLM model or use another port (that is not 2022), you
should also need to change the file `otherfiles/init.lua`: 

```lua 
{
    "David-Kunz/gen.nvim",
    lazy = false,
    opts = {
      model = "mistral:instruct",
      port = 2022,
    },
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
./llm.sh
```
to start the LLM locally or to connect to the remote server. 

then, 

```bash 
nvim 
```
Enjoy! 

# Customization 

- Welcome banner: `./otherfiles/chadrc.lua` 
- Key mappings: `./otherfiles/mappings.lua`
