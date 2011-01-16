<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:php="http://php.net/xsl"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="config[@mode = 'widget_edit']">
		<xsl:variable name="widget" select="widgets/widget[@widget_id = /config/globals/item[@key = 'widget_id']/@value]" />
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=widgets&amp;mode=widget_list">Widget List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=widgets&amp;mode=widget_edit&amp;widget_id={$widget/@widget_id}">
				<xsl:choose>
					<xsl:when test="$widget"><xsl:value-of select="$widget/@name" /></xsl:when>
					<xsl:otherwise>Add widget</xsl:otherwise>
				</xsl:choose>
			</a>
		</p>
		<h1>Add / Edit widget</h1>
		<form method="post" action="">
			<input type="hidden" name="action" value="widget_save" />
			<input type="hidden" name="widget_id" value="{$widget/@widget_id}" />
			<table class="editTable">
				<tfoot>
					<tr>
						<th colspan="2"><input type="submit" value="Save widget" /></th>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<th scope="row"><label for="name">Widget Name:</label></th>
						<td><input type="text" id="name" name="name" value="{$widget/@name}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="xml">XML:</label></th>
						<td><textarea id="xml" name="xml" rows="5" cols="45"><xsl:value-of select="$widget/text" /></textarea></td>
					</tr>
				</tbody>
			</table>
		</form>
	</xsl:template>
	
</xsl:stylesheet>