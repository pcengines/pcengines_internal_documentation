---
layout: default
---
# How To's

This repo contains How-To's.

## Pages

{% assign filelist = site.static_files  %}
<ul>
  {% for file in filelist %}
	{% if file.path contains 'how_to' %}
		{% assign nicename = file.basename | split: "_" | join: " " %}
		<li><a href="{{ site.baseurl }}/how_to/{{ file.basename | append: '.html' }}">{{ nicename | capitalize }}</a></li>
	{% endif %}
  {% endfor %}
</ul>



[back](../)


{{ site.time }}