---
layout: default
---
# How To's

This repo contains documentation for internal use of PC Engines GmbH.

## Pages

{% assign filelist = site.static_files  %}
<ul>
  {% for file in filelist %}
	{% if file.path contains 'how_to' %}
		<li><a href="{{ site.baseurl }}/how_to/{{ file.basename | append: '.html' }}">{{ file.basename | capitalize }}</a></li>
	{% endif %}
  {% endfor %}
</ul>



[back](../)


{{ site.time }}