# NvChad Customization 

This repository builds a docker image of NvChad -- a customization of Neo Vim. 

You have all of NvChad with the addition of severals plugins and configurations to:

- Develop in Haskell (language server) 
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
- Write markdown documents (language server) 
- Write, compile, and visualize Latex documents (`<leader> cl`)
- Manage repositories and commits (Lazygit, `<leader>gg`)
- Auto-indentation when saving files (`*.hs`, `*.tex`, `*.lua`)
- Dictionary and writting suggestion by ltex 
- Smart rename (position in a word and hit `<leader>sr`)
- Global rename (position in a word and hit `<leader>s`)
- Keeping tracks of comments of the form `TODO:`, `HACK:`, and `BUG:` (`]t` and `[t` for next an prev comment)
- Save and restore sessions (`<leader> z`)
- LLM Support (OpenAI) 
	- with CodeCompanion (`<leader>at` toggle prompt, `<leader>aa` to ask (visual mode)) 
  - `<leader> ga` while in the code companion will change the "adapter" (i.e., chatGPT, Claude, etc.)
  - `ga` accept proposals 
  - `gr` reject proposals
- Welcome screen of DPella (the company where I work)
- Editing tips
	- `<C-\><C-n>` to get out of the terminal mode back into nvim 
	- `viw` select the current word 
	- `vi{` select the text around `{`
	- `vac{` select the text around `{`, but including the brackets. It can be changed to `vac[` and so on
	- `O` in visual mode changes to the other extreme
	- `gq%` does autowrapped until finding character `%`
	- `%` goes from an open marker (e.g., `{`) to the closing one
	- `W` jumps to the next word with space. Useful when having `list.get(10)`
        - `M` puts the cursor at the middle of the screen
        - `zz` puts the current line in the middle 
        - `f<character>` finds the next `<character>` in the current line, `F<character>` does it backwards. 
          `;` repeats the find and `,` in opposite direction

- `Ctrl+w` for all windows related things (resize, swap, etc.)
- `:tabe .` to select a file an open it in a different tab
- `za` folds/opens code
- If something is not working, write `:checkhealth` for the whole nvim, or `:checkhealth <pluginname>`
- Latex
	- `<leader> bb` searching in bibliography
- Tmux 
	- `<C-q>` Main horizontal 
  - `<C-w>` Main vertical 
  - `<C-a>` Even horizontal 
  - `<C-s>` Even vertical

All of the docker images will have a volume associated with it and mounted in `/vol`.
This is the directory where you should put all your persisten data.

# Configuration 

## SSH Keys:

Once you clone this repo, you should get into the folder `ssh` and add your private /
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
## Keys for AI services 

After clonning the repo, you should go into the folder `ssh` and add your API keys for 
different AI services. 

- For ChatGPT, write the key in the file `openai_key`
- For Claude, write the key in the file `antropic_key`

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
