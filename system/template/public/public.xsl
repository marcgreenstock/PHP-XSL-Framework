<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:marc="http://www.marcgreenstock.com/xsl"
	xmlns:php="http://php.net/xsl"
	xmlns:dyn="http://exslt.org/dynamic"
	xmlns:exsl="http://exslt.org/common"
	xmlns:func="http://exslt.org/functions"
	xmlns:math="http://exslt.org/math"
	xmlns:regexp="http://exslt.org/regular-expressions"
	xmlns:set="http://exslt.org/sets"
	xmlns:str="http://exslt.org/strings"
	extension-element-prefixes="marc php dyn exsl func math regexp set str"
	exclude-result-prefixes="marc php dyn exsl func math regexp set str">
	
	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		omit-xml-declaration="no"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		indent="yes"
		media-type="text/html" />
	
	<xsl:param name="current_nav_item" select="/config/navigation//item[@content_id = /config/breadcrumb/item[last()]/@content_id]" />
	<xsl:param name="columns">
		<xsl:choose>
			<xsl:when test="$current_nav_item/variable[@name = 'columns']">
				<xsl:value-of select="$current_nav_item/variable[@name = 'columns']/@value" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$current_nav_item/ancestor::item/variable[@name = 'columns'][last()]/@value" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>	
	
	<xsl:template match="/config/content">
		<xsl:choose>
			<xsl:when test="$columns = 2">
				<div id="col-1">
					<xsl:apply-templates select="child::*" mode="html" />
				</div>
				<div id="col-2">
<script type="text/javascript"><xsl:comment>
google_ad_client = "pub-3262693031528441";
/* 250x250, created 10/19/09 */
google_ad_slot = "4760190324";
google_ad_width = 250;
google_ad_height = 250;
//</xsl:comment>
</script>
					<script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js"></script>
					<h2>Topics <a href="http://feeds2.feedburner.com/MarcGreenstock" rel="alternate" type="application/rss+xml"><img src="/_images/rss.png" alt="RSS Feed" width="14" height="14" /></a></h2>
					<ul>
						<xsl:for-each select="/config/plugin[@plugin = 'blog'][@method = 'getTopics']/topics/topic">
							<li><a href="/{@path}/"><xsl:value-of select="@topic" /></a></li>
						</xsl:for-each>
					</ul>
					<xsl:apply-templates select="/config/plugin[@plugin = 'widgets']/widgets/widget[@widget_id = 2]/xml/*" mode="html" />
					<xsl:apply-templates select="/config/plugin[@plugin = 'widgets']/widgets/widget[@widget_id = 1]/xml/*" mode="html" />
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="child::*" mode="html" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="plugin" mode="html">
		<xsl:apply-templates select="/config/plugin[@plugin = current()/@name and @method = current()/@method]">
			<xsl:param name="caller" select="*" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*" mode="html">
		<xsl:element name="{name(.)}">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates mode="html" />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="a[@xpath]" mode="html">
		<a>
			<xsl:copy-of select="@*[name() != 'xpath']" />
			<xsl:attribute name="href">
				<xsl:value-of select="dyn:evaluate(@xpath)" />
			</xsl:attribute>
			<xsl:apply-templates mode="html" />
		</a>
	</xsl:template>
	
	<xsl:template match="/config/pathSet" mode="title">
		<xsl:value-of select="$current_nav_item/@title" />
	</xsl:template>
	
	<xsl:template match="recaptcha">
		<div id="recaptcha_widget">
			<div id="recaptcha_image" style="float: left; padding: 0.5em 4em 0 0;"></div>
			<a style="float: left; text-align: center;" href="javascript:Recaptcha.reload()"><img src="/_images/refresh.gif" alt="Reload CAPTCHA" /><br />Reload<br />CAPTCHA</a>
			<br class="clear" />
			<p>
				<xsl:if test="@error = 'yes'">
					<xsl:attribute name="class">error</xsl:attribute>
					The reCAPTCHA wasn't entered correctly.<br />
				</xsl:if>
				<label for="recaptcha_response_field">
					<span class="recaptcha_only_if_image">Please enter the words above:</span>
					<span class="recaptcha_only_if_audio">Please enter the words you hear:</span>
				</label>
				<br />
				<input type="text" id="recaptcha_response_field" name="recaptcha_response_field" />
			</p>
			<ul>
				<li class="recaptcha_only_if_image"><a href="javascript:Recaptcha.switch_type('audio')">Get an audio CAPTCHA</a></li>
				<li class="recaptcha_only_if_audio"><a href="javascript:Recaptcha.switch_type('image')">Get an image CAPTCHA</a></li>
				<li><a href="javascript:Recaptcha.showhelp()">Help</a></li>
			</ul>
		</div>
		<script type="text/javascript" src="http://api.recaptcha.net/challenge?k={@public_key}"></script>
	</xsl:template>
	
	<xsl:template match="/">
		<html lang="en-AU" xml:lang="en-AU">
			<head>
				<title><xsl:apply-templates select="/config/pathSet" mode="title" /></title>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<meta http-equiv="imagetoolbar" content="no" />
				<meta name="verify-v1" content="znDJfy/gvQ9JYoeCmWKAmP2eB7akFH5+5Uz42eoZ+BM=" />
				<link type="application/rss+xml" rel="alternate" href="/rss/" title="Marc Greenstock RSS Feed" />
				<link type="text/css" rel="stylesheet" media="all" href="/_styles/reset-min.css" />
				<link type="text/css" rel="stylesheet" media="screen" href="/_styles/layout.css" />
				<script type="text/javascript" src="/_scripts/general.js"></script>
				<script type="text/javascript" src="/_scripts/boot.js"></script>
			</head>
			<body>
				<div id="head">
					<h1><a href="/"><img src="/_images/head.jpg" width="0" height="0" alt="" />Marc Greenstock</a></h1>
					<ul id="nav">
						<li><a href="/">Home</a></li>
						<li><a href="/about/">About</a></li>
						<li><a href="/source-code/">Source Code</a></li>
						<li>
							<a href="javascript:;">Resources</a>
							<ul>
								<li><a href="/utf8-character-set/">UTF-8 Character Set</a></li>
								<li><a href="/foreign-market-price-calculator/">Foreign Market Price Calculator</a></li>
								<li><a href="/random-password-generator/">Random Password Generator</a></li>
							</ul>
						</li>
						<li><a href="/contact/">Contact</a></li>
					</ul>
					<form method="get" action="/">
						<label>
							<strong>Query:</strong>
							<input type="text" name="q" value="{/config/globals/item[@key = 'q']/@value}" />
						</label>
						<input type="submit" value="Search" />
					</form>
				</div>
				<div id="main">
					<xsl:apply-templates select="/config/content" />
				</div>
				<div id="foot">
					<div>
						<p><a href="http://creativecommons.org/licenses/by/3.0/"><img src="/_images/cc.png" alt="Creative Commons" width="88" height="31" /></a>Except where otherwise noted, content on this site is<br />licensed under a <a href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution 3.0 License</a></p>
					</div>
				</div>
				<div id="foot2">
					<ul>
						<li><a href="?template=html5">Switch to HTML5</a></li>
						<li><a href="/source-code/">Source Code</a></li>
						<li><a href="http://validator.w3.org/check?uri=referer">Vaid XHTML</a></li>
						<li><del><a href="http://jigsaw.w3.org/css-validator/check/referer">Valid CSS</a></del> - <a href="http://marcgreenstock.com/2009/12/18/css3-magic/">Why?</a></li>
					</ul>
				</div>
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-9106448-1");
pageTracker._trackPageview();
} catch(err) {}
</script>
			</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>