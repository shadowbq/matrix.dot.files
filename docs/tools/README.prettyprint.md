# Pretty Print

There are lots of ways to pretty print things on the CLI

Some of the most powerful are when they are tied to language-server. (lint, colorize, keywords, etc.)

* https://microsoft.github.io/language-server-protocol/

## JSON 

### JQ

Using `jq` to format json to expanded 

`cat deploymentTemplate.min.json | jq '.' |less -R > deploymentTemplate.json`

This uses less -R to remove the coloroutput

### Ruby 

`ruby -e "require 'json'; puts JSON.pretty_generate(JSON.parse(ARGF.read))" datafile.json`

## YAML

* https://github.com/redhat-developer/vscode-yaml
* https://github.com/redhat-developer/yaml-language-server

## Python

## Ruby

https://aneta-bielska.github.io/blog/rails-c-5-ways-to-get-pretty-output.html

## Bash

## Golang

## HTML, JS, CSS, SASS

hookyqr.beautify - javascript, JSON, CSS, Sass, and HTML in Visual Studio Code.

## Markdown

mervin.markdown-formatter
