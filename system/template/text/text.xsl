<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:output
		method="text"
		encoding="UTF-8"
		omit-xml-declaration="yes" />
	
	<xsl:template match="/">
		<xsl:apply-templates select="/config/content/*" mode="html" />
	</xsl:template>

	<xsl:template match="plugin" mode="html">
		<xsl:apply-templates select="/config/plugin[@plugin = current()/@name and @method = current()/@method]" />
	</xsl:template>
	
	<xsl:template match="*" mode="html">
		<xsl:element name="{name(.)}">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates mode="html" />
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>