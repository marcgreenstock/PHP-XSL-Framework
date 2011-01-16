<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output
		method="xml"
		version="1.0"
		encoding="UTF-8"
		omit-xml-declaration="no"
		indent="yes"
		media-type="text/xml" />

	<xsl:template match="/">
		<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
			<url>
				<loc>http://marcgreenstock.com/</loc>
				<lastmod><xsl:apply-templates select="/config/plugin/entries/entry[1]/date" /></lastmod>
				<changefreq>daily</changefreq>
				<priority>1.0</priority>
			</url>
			<url>
				<loc>http://marcgreenstock.com/about/</loc>
			</url>
			<url>
				<loc>http://marcgreenstock.com/contact/</loc>
			</url>
			<url>
				<loc>http://marcgreenstock.com/source-code/</loc>
			</url>
			<url>
				<loc>http://marcgreenstock.com/utf8-character-set/</loc>
			</url>
			<url>
				<loc>http://marcgreenstock.com/foreign-market-price-calculator/</loc>
			</url>
			<xsl:for-each select="/config/plugin/topics/topic">
				<url>
					<loc>http://marcgreenstock.com/<xsl:value-of select="@path" />/</loc>
					<lastmod>
						<xsl:choose>
							<xsl:when test="/config/plugin/entry[topic/@topic_id = current()/@topic_id][1]">
								<xsl:apply-templates select="/config/plugin/entry[topic/@topic_id = current()/@topic_id][1]/date" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>2009-06-01T21:12:43+10:00</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</lastmod>
				</url>
			</xsl:for-each>
			<xsl:for-each select="/config/plugin/entries/entry[@published != '']">
				<url>
					<loc>http://marcgreenstock.com/<xsl:value-of select="concat(date/@year,'/',date/@month,'/',date/@day,'/',@path,'/')" /></loc>
					<lastmod><xsl:apply-templates select="date" /></lastmod>
				</url>
			</xsl:for-each>
		</urlset>
	</xsl:template>
	
	<xsl:template match="/config/plugin/entries/entry/date">
		<xsl:value-of select="concat(@year,'-',@month,'-',@day,'T',@hour,':',@minute,':',@second,'+10:00')" />
	</xsl:template>
	
</xsl:stylesheet>