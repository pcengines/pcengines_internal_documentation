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
{%- for file in filelist -%}
  {%- assign filepath = "/" | append: file.basename | append: ".md" -%}
  {%- if file.path == filepath -%}
    {%- unless file.path contains "copy" or file.path contains "README" -%}
      <li><a href="{{ site.baseurl }}/{{ file.basename | append: '.html' }}">{{ file.basename }}</a></li>
    {%- endunless -%}
  {%- endif -%}
{%- endfor -%}
</ul>

## Pages in Sub-Folders 

<ul>
{%- assign filelist = site.static_files -%}
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

[back](../)


{{ site.time }}