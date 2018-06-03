# How-to build a simple blog site

## Goals

Setting up a simple blog for myself. Simple means for me small software, not many dependencies, no database.


## Requirements
The blogging software ...

- is easy to build, package and run everywhere. On my local laptop or any server.
- can be hostsed locally
- uses Markdown
- is able to use themes


## Investigation

First we are trying to find a suitable blog/wiki software to run our blog. I have tried these solutions:

* MDwiki - looks like a good software but installation failed on my pc at least.
* MkDocs - simple and works like a charm. 
* dokuwiki - good and well maintained software with a big list of plugins but it seems that it does not support plain markdown

At the end of my investigation choose for MkDocs because it is very simple, meeting my needs and can be configured very simple way.


## Workflow

### Prerequesites

* Running Linux like Ubuntu, Debian, Arch Linux, ...

### Prepae Python virtualenv

```
apt-get install python virtualenv
virtualenv .venv
```

### Install mkdocs

prepare file requirements.txt
```
pip
mkdocs
mkdocs-bootswatch
```

install software using pip
```
source .venv/bin/activate
pip install -U -r requirements.txt
```

### Create blog page

```
mkdocs new blog
cd blog
```

### Run

```
vi mkdocs.yml
vi docs/index.md
mkdocs serve
```

Point your browser to [http://localhost:8000](http://localhost:8080) to test it


## Conclusion

With mkdocs is it quite easy to setup simple websites like blogs and run this on any system.


## Links

* [https://mkdocs.org](https://mkdocs.org)


---------------------------------------
```
Created: 2018-05-27 
Updated: 2018-06-03
```
