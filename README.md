# HTML Data plugin
> based on Mogan Research v1.2.9.5 LTS

## How to develop
First of all, you need to learn about the TEXMACS_HOME_PATH:
```
cd $TEXMACS_HOME_PATH/plugins
git clone git@github.com:XmacsLabs/html.git
```
see https://mogan.app/guide/Mogan_versus_TeXmacs.html#texmacs-home-path

## How to test
Here is the command line on linux:
```
/usr/bin/MoganResearch --headless -b tests/24_11.scm -x "(24_11)" -q
```
