php-htmlfilter
==============

Html filter extension written in Zephir

The purpose of this extension is to remove malicious code from small portions of html.

It is not a full-fledged html parser, nor is it a super secure filter.
Also, it surelly does not validate the html, nor will it aim to

it aims to be compliant, and to be add some security for filtering html, 
if you have to actually allow inputed html back to your site.

If you have security concerns, use html purifier, the lib is awesome in that way. 
It is not, however, the fastest lib. So consider this lib a tradeof between 
super secure and fast. You have been advised. 

The code follows under MIT license, and a copy should be acompaning the code.
May that not be the case, feel free to contact me.

Instalation
===========
You will need zephir to build this. (https://github.com/phalcon/zephir)

after you have it:

`cd htmlfilter && zephir build`

add the extension file to your modules
restart your webserver

```php
<?php

$dirtyHtml = '<span>this should have nothing more<script>alert(1);</script></span>';

$filter = new Htmlfilter\Filter();
$cleanHtml = $filter->filterHtml($dirtyHtml);

//this should produce: '<span>this should have nothing more</span>'
echo "<pre>$cleanHtml</pre>"; 
```

To configure the filter you may pass a new config parameter into filter:
```php
//disable all usage of <script>, and enables <aside>
$config = array(
    'configureElements' => array(
        array('name'=>'script', 'permission' => 0),
        array('name'=>'aside', 'permission' => 1),
    )
);

$filter = new HtmlFilter\Filter($config);
```

Or you may simply pass them into configureElements method:
```php
$filter = new HtmlFilter\Filter();

$elementConfiguration = array(
    array('name'=>'script', 'permission' => 0),
    array('name'=>'aside', 'permission' => 1),
);

$filter->configureElements($elementConfiguration);
```
