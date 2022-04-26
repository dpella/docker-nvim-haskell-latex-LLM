# lhs2Tex and latexmk 

Add the following as the first element in `latex-workshop.latex.tools`

```javascript
       {
            "name": "lhs2tex",
            "command": "lhs2TeX",
            "args": [
                "--output=main.tex",
                "main.lhs.tex"
            ],
            "env": {}
        },
```

and then add this as the first element in `latex-workshop.latex.recipes`

```javascript
       {
            "name": "lhs2tex+latexmk 🔃",
            "tools": [
                "lhs2tex",
                "lhs2tex-latexmk"
            ]
        }, 
```
