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

End Topics 

## Pages in How To Folder 

This is a list of the How-To Folder

{%- assign filelist = site.static_files -%}
<ul>
  {%- for file in filelist -%}
    {%- if file.path contains 'how_to' -%}
      <li><a href="{{ site.baseurl }}/how_to/{{ file.basename | append: '.html' }}">{{ file.basename }}</a></li>
    {%- endif -%}
  {%- endfor -%}
</ul>

<hr>
<hr>
<hr>

## All Pages 

<hr>
<hr>
<hr>

{%- assign default_paths = site.pages | map: "path" -%}
{%- assign page_paths = site.header_pages | default: default_paths -%}
{%- assign titles_size = site.pages | map: 'title' | join: '' | size -%}
<ul>
{%- for path in page_paths -%}
  {%- assign my_page = site.pages | where: "path", path | first -%}
  {%- if my_page.title -%}
  <li><a class="page-link" href="{{ my_page.url | relative_url }}">{{ my_page.title | escape }}</a></li>
  {%- endif -%}
{%- endfor -%}
</ul>

<hr>
<hr>
<hr>

## Top Level Pages Only

<hr>
<hr>
<hr>

<ul>
  {%- for file in filelist -%}
  {%- if file.path == "." -%}
    <li><a href="{{ site.baseurl }}/{{ file.basename | append: '.html' }}">{{ file.basename }}</a></li>
  {%- else -%}
    <li>{{ file.path }} - <a href="{{ site.baseurl }}/{{ file.basename | append: '.html' }}">{{ file.basename }}</a></li>
  {%- endif -%}
  {%- endfor -%}
</ul>

[back](../)


{{ site.time }}