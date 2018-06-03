# How-to deploy mkdocs site to github pages

## Goals

I want to run my blog publicly using a service with it I am able to manage my data using markdown files, git but don't need to host the blog on my own. After some investigation I have seen that github pages are meeting my requirements well. Luckily supports mkdocs github pages deployments.


## Investigation

First I read some documentation like:

* [MkDocs: Deploying](https://www.mkdocs.org/#deploying)
* [MkDocs: Deploy your Markdown documents on GitHub Pages](https://vinta.ws/code/using-mkdocs-to-deploy-your-markdown-documents-on-github-pages.html)
* [Creating a GitHub pages site with MkDocs](https://workbook.craftingdigitalhistory.ca/supporting%20materials/gh-pages/)


## Workflow

Then I have set this up using this workflow.

### Prerequesites

* Running mkdocs installation. I have described [here on my blog](2018_05_27_How-to-build-a-simple-blog-site.md) how to setup a simple mkdocs site.


### Preparing mkdocs.yml

Add these lines to your mkdocs.yml

```
site_name: YOUR SITE NAME
site_url: https://YOURNAME.github.io/
repo_url: https://github.com/YOURNAME/YOURREPO/
```

### Running mkdocs deployment

```
mkdocs gh-deploy --clean
```

Point your browser to [https://YOURNAME.github.io/YOURREPO](https://YOURNAME.github.io/YOURREPO)

### Creating a redirect from github pages to your blog

I at least dont like to have a contect root for "/blog" like [https://bboortz.github.io/blog](https://bboortz.github.io/blog). 
So that I have decided to create a redirect from [https://bboortz.github.io/](https://bboortz.github.io/) to [https://bboortz.github.io/blog](https://bboortz.github.io/blog)

You simply need to create a file index.html at the root of your gitpub pages directory and push it. My repository is: [https://github.com/bboortz/bboortz.github.io](https://github.com/bboortz/bboortz.github.io)


The content of the index.html looks like this:
```
<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="0; url=https://bboortz.github.io/blog">
        <script type="text/javascript">
            window.location.href = "https://bboortz.github.io/blog"
        </script>
        <title>Page Redirection</title>
    </head>
    <body>
        <!-- Note: don't tell people to `click` the link, just tell them that it is a link. -->
        If you are not redirected automatically, follow this <a href='https://bboortz.github.io/blog'>link to benni's blog</a>.
    </body>
</html>

```

Now you are able to use [https://YOURNAME.github.io/](https://YOURNAME.github.io/) for your mkdocs site.


## Conclusion

As we can see it is not very hard to push your mkdocs site as github pages. Unfortunately I was not able to push the pages directly to the contect root "/". So that have created a redirect using the index.html


## Links

* [stackoverflow: Redirect from an HTML page](https://stackoverflow.com/questions/5411538/redirect-from-an-html-page)


---------------------------------------
```
Created: 2018-06-03
Updated: 2018-06-03
```
