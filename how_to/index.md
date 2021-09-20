---
layout: default
---
# How To's

This repo contains documentation for internal use of PC Engines GmbH.

## Topics

{% assign filelist = site.static_files  %}
<ul>
  {% for file in filelist %}
	{% unless file.path contains 'docinfo.html' %}
	      <li><a href="{{ site.baseurl }}{{ file.path }}">{{ file.name }}</a></li>
	{% endunless %}
  {% endfor %}
</ul>


{% assign filelist = site.static_files  %}
{% for file in filelist %}
	{% unless file.path contains 'docinfo.html' %}
	    *   [ {{ file.name }} ]( {{ site.baseurl }}{{ file.path }})
	{% endunless %}
{% endfor %}


*   [Disk Images](./disk_images.html)
*   [Add-On Cards](./addon_cards.html)

[back](../)
