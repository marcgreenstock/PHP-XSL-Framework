<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		omit-xml-declaration="no"
		indent="yes"
		media-type="text/xml"
		cdata-section-elements="description" />

	<xsl:template match="/">
		<rss version="2.0">
			<channel>
				<title>Marc Greenstock</title>
				<link>http://marcgreenstock.com/</link>
				<description>Marc Greenstock's endless rantings of motorbikes, web development, politics and the environment</description>
				<language>en-AU</language>
				<pubDate><xsl:value-of select="/config/plugin/entry[1]/@published" /></pubDate>
				<lastBuildDate><xsl:value-of select="/config/plugin/entry[1]/@published" /></lastBuildDate>
				<managingEditor>webmaster@marcgreenstock.com</managingEditor>
				<webMaster>webmaster@marcgreenstock.com</webMaster>
				<ttl>5</ttl>
				<xsl:apply-templates select="/config/plugin/entries/entry" mode="rss" />
			</channel>
		</rss>
	</xsl:template>
	
	<xsl:template match="/config/plugin/entries/entry[@published != '']" mode="rss">
		<item>
			<title><xsl:value-of select="@title" /></title>
			<link>http://marcgreenstock.com/<xsl:value-of select="concat(date/@year,'/',date/@month,'/',date/@day,'/',@path,'/')" /></link>
			<description><xsl:value-of select="xhtml/p[1]" /></description>
			<pubDate><xsl:value-of select="@published" /></pubDate>
		</item>
	</xsl:template>
	
</xsl:stylesheet>