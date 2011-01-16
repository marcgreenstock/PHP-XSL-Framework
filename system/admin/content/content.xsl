<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="menu">
		<h1>Content Management</h1>
	</xsl:template>

	<xsl:template match="config">
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=content">Content List</a>
		</p>
		<h1>Content List</h1>
		<table>
			<thead>
				<tr>
					<th scope="col">Path</th>
					<th scope="col">Title</th>
					<th scope="col">Template</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th colspan="3"><input type="button" value="Add content" onclick="document.location = '?page=content&amp;mode=content_edit'" /></th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:apply-templates select="content[@parent_id = '']" />
			</tbody>
		</table>
	</xsl:template>
		
	<xsl:template match="content">
		<xsl:param name="parent" select="''" />
		<xsl:variable name="path" select="concat(@path,'/')" />
		<tr>
			<td>
				<xsl:value-of select="concat($parent,$path)" />
				<br />
				<span class="options">
					<a href="?page=content&amp;mode=content_edit&amp;content_id={@content_id}">edit</a>
					<xsl:text> | </xsl:text>
					<a href="?page=content&amp;action=content_delete&amp;content_id={@content_id}" onclick="return(confirm('Did you really mean to click delete?'))">delete</a>
				</span>
			</td>
			<td><xsl:value-of select="@title" /></td>
			<td><xsl:value-of select="../template[@template_id = current()/@template_id]/@template" /></td>
		</tr>
		<xsl:apply-templates select="../content[@parent_id = current()/@content_id]">
			<xsl:with-param name="parent" select="concat($parent,$path)" />
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:include href="modes/content_edit.xsl" />
	<xsl:include href="modes/plugin_method_2_content_edit.xsl" />

</xsl:stylesheet>