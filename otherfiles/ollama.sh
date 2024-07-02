#!/bin/sh

ollama serve & 
sleep 10
ollama pull mistral:instruct 
