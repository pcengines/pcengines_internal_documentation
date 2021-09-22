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

## Pages

{% assign filelist = site.static_files  %}
<ul>
  {% for file in filelist %}
  {% if file.path contains 'how_to' %}
    <li><a href="{{ site.baseurl }}/how_to/{{ file.basename | append: '.html' }}">{{ file.basename }}</a></li>
  {% endif %}
  {% endfor %}
</ul>

<hr>
<hr>
<hr>

{%- assign default_paths = site.pages | map: "path" -%}
{%- assign page_paths = site.header_pages | default: default_paths -%}
{%- assign titles_size = site.pages | map: 'title' | join: '' | size -%}
{%- for path in page_paths -%}
  {%- assign my_page = site.pages | where: "path", path | first -%}
  {%- if my_page.title -%}
  <a class="page-link" href="{{ my_page.url | relative_url }}">{{ my_page.title | escape }}</a>
  {%- endif -%}
{%- endfor -%}
<a class="site-title" rel="author" href="{{ "/" | relative_url }}">{{ site.title | escape }}</a>

<hr>
<hr>
<hr>

[back](../)


{{ site.time }}