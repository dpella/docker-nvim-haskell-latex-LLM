require "nvchad.options"

-- add yours here!

local o = vim.o

-- Bash as terminal
o.shell="/usr/bin/bash"

-- Highlight search matches
o.hlsearch = true 

-- Starts search before enter
o.incsearch = true  

-- Reads files again if they have been changed outside of vim
o.autoread = true 

-- Display line numbers
o.number = true  

-- To enable cursorline
o.cursorlineopt = 'both' 

-- UTF-8
o.encoding = "utf-8"

-- Identation 
o.smartindent = true 
o.autoindent  = true 
o.copyindent  = true 
o.shiftround  = true 

-- Ignore case in searches/replaces, except if they contain uppercase letters.
o.smartcase = true 
o.ignorecase = true 

-- Spaces and tabs 
o.tabstop = 4 
o.softtabstop = 4 
o.shiftwidth = 4 
o.expandtab = true 

