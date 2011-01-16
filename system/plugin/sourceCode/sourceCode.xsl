<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/config/plugin[@plugin = 'sourceCode'][@method = 'getFiles']">
		<ul>
			<xsl:apply-templates select="fileList/file">
				<xsl:sort select="@name" />
			</xsl:apply-templates>
			<xsl:apply-templates select="fileList/dir">
				<xsl:sort select="@name" />
			</xsl:apply-templates>
		</ul>
	</xsl:template>

	<xsl:template match="/config/plugin[@plugin = 'sourceCode'][@method = 'getSource']">
		<xsl:choose>
			<xsl:when test="source/@error = 'yes'">
				<h2>File Not Found</h2>
				<p>You seem to be looking for the source code of "<xsl:value-of select="/config/globals/item[@key = 'file']/@value" />", but it's not here, sorry.</p>
				<p><a href="/source-code/">&lt;&lt; Return to file list</a></p>
			</xsl:when>
			<xsl:otherwise>
				<h2>Source Code of "<xsl:value-of select="/config/globals/item[@key = 'file']/@value" />"</h2>
				<p>You are viewing the source code for <strong>"<xsl:value-of select="/config/globals/item[@key = 'file']/@value" />"</strong> on marcgreenstock.com, you haven't found a bug, this is perfectly normal behaviour, I've made it available to you as a demonstration of XSLT templating with PHP. Please enjoy and if you have any comments you can <a href="/contact/">contact me here</a>.</p>
				<p><a href="/source-code/">&lt;&lt; Return to file list</a></p>
				<pre><xsl:value-of select="source" disable-output-escaping="yes" /></pre>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dir">
		<xsl:param name="path">
			<xsl:for-each select="ancestor::*[name() = 'dir']">
				<xsl:value-of select="concat('/',@name)" />
			</xsl:for-each>
			<xsl:value-of select="concat('/',@name,'/')" />
		</xsl:param>
		<xsl:if test="descendant::*[name() = 'file']">
			<li>
				<xsl:value-of select="$path" />
				<ul>
					<xsl:apply-templates select="file">
						<xsl:sort select="@name" />
						<xsl:with-param name="path" select="$path" />
					</xsl:apply-templates>
					<xsl:apply-templates select="dir">
						<xsl:sort select="@name" />
					</xsl:apply-templates>
				</ul>
			</li>
		</xsl:if>
	</xsl:template>

	<xsl:template match="file">
		<xsl:param name="path" select="'/'" />
		<li>
			<a href="/source-code/source/?file={concat($path,@name)}"><xsl:value-of select="@name" /></a>
		</li>
	</xsl:template>
	
</xsl:stylesheet>