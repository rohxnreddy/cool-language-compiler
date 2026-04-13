<div align="center">
<pre>
:'######:::'#######:::'#######::'##:::::::
'##... ##:'##.... ##:'##.... ##: ##:::::::
 ##:::..:: ##:::: ##: ##:::: ##: ##:::::::
 ##::::::: ##:::: ##: ##:::: ##: ##:::::::
 ##::::::: ##:::: ##: ##:::: ##: ##:::::::
 ##::: ##: ##:::: ##: ##:::: ##: ##:::::::
. ######::. #######::. #######:: ########:
:......::::.......::::.......:::........::
</pre>
</div>

<h1 align="center">
COOL LANGUAGE COMPILER CONSTRUCTION
</h1>

## About

This project implements a compiler for the **Classroom Object-Oriented Language (COOL)**. It is designed to handle the various stages of compilation including lexical analysis, parsing, semantic analysis, and code generation.

## Project Structure

The project is organized into modular components for each stage of the compilation process:

```bash
COOL-LANGUAGE-COMPILER/
├── cfg
│   └── CFG.md
├── codegenerator
│   ├── codegenerator.md
│   ├── tac.c
│   └── tac.h
├── inputs
│   ├── invalid_phase2.cl
│   ├── invalidprogram.cl
│   ├── valid_phase2.cl
│   └── validprogram.cl
├── lexer
│   ├── cool.l
│   ├── cool_printer.l
│   ├── lexical-specification.md
│   └── lex.yy.c
├── main.c
├── Makefile
├── parser
│   ├── ast.c
│   ├── ast.h
│   ├── cool.y
│   ├── parser.md
│   └── parsetree.md
├── report
│   ├── latex
│   │   ├── bits_logo.png
│   │   └── main.tex
│   └── midsem_report.pdf
└── tac_runner.py
```

## Documentation

Detailed documentation for each module can be found in their respective directories:

* [Context Free Grammar](cfg/CFG.md)
* [Lexical Specification](lexer/lexical-specification.md)
* [Parser Design](parser/parser.md)
* [Code Generation](codegenerator/codegenerator.md)

## Contributors

| GitHub ID | Name            | ID Number |
| --------- | --------------- | --------- |
| [venusai24](https://github.com/venusai24)| Venu Sai Yelesvarapu | 2023A7PS0149H         |
| [rohxnreddy](https://github.com/rohxnreddy) | Rohan Reddy Devarapalli | 2023A7PS0138H|
| [Trenbolone17](https://github.com/Trenbolone17)|Albert Sebastain |2023A7PS0118H|
| [Crisp79](https://github.com/Crisp79)|Akshith Vuppala  |2023A7PS0032H|
| [Parallax-Ace](https://github.com/Parallax-Ace)         |Adithya Nama|2023A7PS0171H|
