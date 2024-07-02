#!/bin/sh

export OLLAMA_HOST="127.0.0.1:2022"

ollama serve & 
sleep 10
ollama pull mistral:instruct 
