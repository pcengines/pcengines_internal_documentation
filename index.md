---
layout: default
---
# PC Engines - Internal Documentation

This repo contains documentation for internal use of PC Engines GmbH.

## Topics 

*   [How To's](./how_to/index.html)
*   [Customer Images](./customers/index.html)
*   [WNC Production Tests](./wnc/index.html)
*   [Board Modifications](./board_mods/index.html)
*   [ECN](./ecn/index.html)

## Top Level Pages Only


<ul>
{%- assign filelist = site.static_files -%}
{%- for file in filelist -%}
  {%- assign filepath = "/" | append: file.basename | append: ".md" -%}
  {%- if file.path == filepath -%}
    <li><a href="{{ site.baseurl }}/{{ file.basename | append: '.html' }}">{{ file.basename }}</a></li>
  {%- else -%}
    <!-- <li>{{ file.path }} != {{ filepath }}<a href="{{ site.baseurl }}/{{ file.basename | append: '.html' }}">{{ file.basename }}</a></li> -->
  {%- endif -%}
{%- endfor -%}
</ul>

## Pages in Sub-Folders 

<ul>
{%- assign default_paths = site.pages | map: "path" -%}
{%- assign page_paths = site.header_pages | default: default_paths -%}
{%- assign titles_size = site.pages | map: 'title' | join: '' | size -%}

{%- for path in page_paths -%}
  {%- assign my_page = site.pages | where: "path", path | first -%}
  {%- if my_page.title -%}
    <li><a class="page-link" href="{{ my_page.url | relative_url }}">{{ my_page.title | escape }}</a></li>
  {%- endif -%}
{%- endfor -%}
</ul>

## Top Folders 

<ul>
{%- assign default_paths = site.static_files | map: "path" -%}

{%- assign topfolders = ''|split:'' -%}
{%- for file in filelist -%}
  {%- assign topfolder = file.path | split: "/" -%}
  {%- unless topfolder[1] contains ".md" or topfolder[1] contains "LICENSE" or topfolder[1] contains "assets" or topfolder[1] contains "thumbnail.png" or topfolder[1] contains "script" or topfolder[1] contains "jekyll-theme-tactile.gemspec" -%}
  {%- assign topfolders = topfolders | push: topfolder[1] -%}
   <li>{{ topfolder }} :: {{ topfolder[1] }}</li>
  {%- endunless -%}
{%- endfor -%}
</ul>
<hr>
<ul>
{%- assign topfolders = topfolders | uniq -%}
{%- for folder in topfolders -%}
  <li>{{ folder }}</li>
{%- endfor -%}
</ul>

[back](../)


{{ site.time }}