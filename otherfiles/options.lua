require "nvchad.options"

-- add yours here!

local o = vim.o

-- Bash as terminal
o.shell = "/usr/bin/bash"

-- Cursor line
o.cursorline = true

-- Highlight search matches
o.hlsearch = true

-- Starts search before enter
o.incsearch = true

-- Reads files again if they have been changed outside of vim
o.autoread = true

-- UTF-8
o.encoding = "utf-8"

-- Identation
o.smartindent = true
o.autoindent = true
o.copyindent = true
o.shiftround = true

-- Column limit
o.colorcolumn = "100"

-- When scrolling up or down, leave at least this amount of lines
o.scrolloff = 8

-- Line numbers on and being relative 
o.nu = true
o.relativenumber = true
