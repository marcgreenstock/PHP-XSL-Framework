<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="config[@mode = 'content_edit']">
		<xsl:variable name="content" select="content[@content_id = current()/globals/item[@key = 'content_id']/@value]" />
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=content">Content List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=content&amp;mode=content_edit&amp;content_id={$content/@content_id}">
				<xsl:choose>
					<xsl:when test="$content"><xsl:value-of select="$content/@title" /></xsl:when>
					<xsl:otherwise>Add Content</xsl:otherwise>
				</xsl:choose>
			</a>
		</p>
		<h1>Add / Edit content</h1>
		<form method="post" action="">
			<input type="hidden" name="action" value="content_save" />
			<input type="hidden" name="content_id" value="{$content/@content_id}" />
			<table class="editTable">
				<tfoot>
					<tr>
						<th colspan="2"><input type="submit" value="Save content" /></th>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<th scope="row"><label for="parent-id">Parent:</label></th>
						<td>
							<select id="parent-id" name="parent_id">
								<option value="0">-- Root Level --</option>
								<xsl:apply-templates select="content[@parent_id = '']" mode="select">
									<xsl:with-param name="selected" select="$content/@parent_id" />
								</xsl:apply-templates>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="template-id">Template:</label></th>
						<td>
							<select id="template-id" name="template_id">
								<option value="0">-- Inherit --</option>
								<xsl:for-each select="template">
									<option value="{@template_id}">
										<xsl:if test="$content/@template_id = current()/@template_id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
										<xsl:value-of select="@template" />
									</option>
								</xsl:for-each>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="variables">Variables:</label></th>
						<td><input type="text" id="variables" name="variables" value="{$content/@variables}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="title">Title:</label></th>
						<td><input type="text" id="title" name="title" value="{$content/@title}" onkeyup="setPath(this.value,'path');" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="path">Path:</label></th>
						<td><input type="text" id="path" name="path" value="{$content/@path}" /></td>
					</tr>
					<tr>
						<th scope="col"><label for="xml">XML</label></th>
						<td><textarea id="xml" name="xml" rows="30" cols="45"><xsl:value-of select="$content/@xml" /></textarea></td>
					</tr>
					<tr>
						<th scope="col"><label for="xsl">XSL:</label></th>
						<td><textarea id="xsl" name="xsl" rows="30" cols="45"><xsl:value-of select="$content/@xsl" /></textarea></td>
					</tr>
				</tbody>
			</table>
		</form>
		<h1>Plugin Call List</h1>
		<table>
			<thead>
				<tr>
					<th scope="col">Plugin</th>
					<th scope="col">Method</th>
					<th scope="col">Inherit</th>
					<th scope="col">Sequence</th>
					<th scope="col">Position</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th colspan="5"><input type="button" value="Add Plugin Call" onclick="document.location = '?page=content&amp;mode=plugin_method_2_content_edit&amp;content_id={$content/@content_id}'" /></th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:for-each select="plugin_method_2_content[@content_id = $content/@content_id]">
					<xsl:sort select="@sequence" data-type="number" />
					<tr>
						<td>
							<xsl:value-of select="../plugin[@plugin_id = ../plugin_method[@plugin_method_id = current()/@plugin_method_id]/@plugin_id]/@plugin" />
							<br />
							<span class="options">
								<a href="?page=content&amp;mode=plugin_method_2_content_edit&amp;content_id={$content/@content_id}&amp;plugin_method_2_content_id={@plugin_method_2_content_id}">edit</a>
								<xsl:text> | </xsl:text>
								<a href="?page=content&amp;mode=content_edit&amp;action=plugin_method_2_content_delete&amp;content_id={$content/@content_id}&amp;plugin_method_2_content_id={@plugin_method_2_content_id}" onclick="return(confirm('Did you really mean to click delete?'))">delete</a>
							</span>
						</td>
						<td><xsl:value-of select="../plugin_method[@plugin_method_id = current()/@plugin_method_id]/@method" /></td>
						<td>
							<xsl:choose>
								<xsl:when test="@inherit = '1'">Yes</xsl:when>
								<xsl:otherwise>No</xsl:otherwise>
							</xsl:choose>
						</td>
						<td><xsl:value-of select="@sequence" /></td>
						<td><xsl:value-of select="@position" /></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	
	<xsl:template match="content" mode="select">
		<xsl:param name="selected" />
		<xsl:param name="parent" select="''" />
		<xsl:variable name="path" select="concat(@path,'/')" />
		<option value="{@content_id}">
			<xsl:if test="@content_id = $selected"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			<xsl:value-of select="concat($parent,$path)" />
		</option>
		<xsl:apply-templates select="../content[@parent_id = current()/@content_id]" mode="select">
			<xsl:with-param name="selected" select="$selected" />
			<xsl:with-param name="parent" select="concat($parent,$path)" />
		</xsl:apply-templates>
	</xsl:template>
	
</xsl:stylesheet>