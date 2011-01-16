<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/config/plugin[@plugin = 'widgets'][@method = 'getWidgets']">
		<xsl:param name="caller" />
		<xsl:apply-templates select="widgets/widget[@widget_id = $caller/@widget_id]/xml/*" mode="html" />
	</xsl:template>
	
</xsl:stylesheet>