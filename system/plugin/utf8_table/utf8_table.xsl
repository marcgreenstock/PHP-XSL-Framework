<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/config/plugin[@plugin = 'utf8_table'][@method = 'getTable']">
		<h2>Useful UTF-8 Character Codes</h2>
		<table class="properties">
			<thead>
				<tr>
					<th scope="col">Description</th>
					<th scope="col">Character</th>
					<th scope="col">UTF-8 Code</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="keyCode">
					<tr>
						<th scope="row"><xsl:value-of select="@desc" /></th>
						<td><xsl:value-of select="concat('&amp;#',@code,';')" disable-output-escaping="yes" /></td>
						<td><xsl:value-of select="concat('&amp;#',@code,';')" disable-output-escaping="no" /></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		<h2>Full UTF-8 Character Table</h2>
		<table id="utf8-table">
			<xsl:call-template name="utf8-table-row" />
		</table>
	</xsl:template>
	
	<xsl:template name="utf8-table-row">
		<xsl:param name="row" select="0" />
		<tr>
			<xsl:call-template name="utf8-table-col">
				<xsl:with-param name="row" select="$row" />
			</xsl:call-template>
		</tr>
		<xsl:if test="$row &lt; 39">
			<xsl:call-template name="utf8-table-row">
				<xsl:with-param name="row" select="$row + 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="utf8-table-col">
		<xsl:param name="row" select="0" />
		<xsl:param name="col" select="0" />
		
		<th><xsl:value-of select="concat('&amp;#',$col * 40 + $row + 1,';')" disable-output-escaping="no" /></th>
		<td><xsl:value-of select="concat('&amp;#',$col * 40 + $row + 1,';')" disable-output-escaping="yes" /></td>
		
		<xsl:if test="$col &lt; 9">
			<xsl:call-template name="utf8-table-col">
				<xsl:with-param name="row" select="$row" />
				<xsl:with-param name="col" select="$col + 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>