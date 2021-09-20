---
layout: default
---
# How To's

This repo contains documentation for internal use of PC Engines GmbH.

## Topics

<ul>
	{% for file in site.images %}
	     {% if file.extname == 'md' or file.extname == 'html'  %}
	         <li><a href="{{ file.url }}">{{ file.url | capitalize }}</a>
	     {% endif %}
	{% endfor %}
</ul>

<hr>

{% assign filelist = site.static_files  %}
<ul>
  {% for file in filelist %}
	{% unless file.path contains 'docinfo.html' %}
	      <li><a href="{{ site.baseurl }}{{ file.path }}">{{ file.name }}</a></li>
	{% endunless %}
  {% endfor %}
</ul>


[back](../)
