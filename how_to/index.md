---
layout: default
---
# How To's

This repo contains documentation for internal use of PC Engines GmbH.

## Topics

{% assign filelist = site.static_files  %}
<ul>
  {% for file in filelist %}
     {% if file.extname == 'md' or file.extname == 'html'   %}
	      <li><a href="{{ site.baseurl }}{{ file.basename | append: '.html' }}">{{ file.basename | capitalize }}</a></li>
	{% endif %}
  {% endfor %}
</ul>


[back](../)
