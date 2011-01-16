<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="config[@mode = 'plugin_method_2_content_edit']">
		<xsl:variable name="content" select="content[@content_id = current()/globals/item[@key = 'content_id']/@value]" />
		<xsl:variable name="plugin_method_2_content" select="plugin_method_2_content[@plugin_method_2_content_id = current()/globals/item[@key = 'plugin_method_2_content_id']/@value]" />
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=content">Content List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=content&amp;mode=content_edit&amp;content_id={$content/@content_id}"><xsl:value-of select="$content/@title" /></a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=content&amp;mode=plugin_method_2_content_edit&amp;content_id={$content/@content_id}&amp;plugin_method_2_content_id={$plugin_method_2_content/@plugin_method_2_content_id}">
				<xsl:choose>
					<xsl:when test="$plugin_method_2_content">Edit Plugin Call</xsl:when>
					<xsl:otherwise>Add Plugin Call</xsl:otherwise>
				</xsl:choose>
			</a>
		</p>
		<h1>Add / Edit Plugin Call</h1>
		<form method="post" action="">
			<input type="hidden" name="action" value="plugin_method_2_content_save" />
			<input type="hidden" name="plugin_method_2_content_id" value="{$plugin_method_2_content/@plugin_method_2_content_id}" />
			<input type="hidden" name="content_id" value="{$content/@content_id}" />
			<table class="editTable">
				<tfoot>
					<tr>
						<th colspan="2"><input type="submit" value="Save Plugin Call" /></th>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<th scope="row"><label for="plugin-method-id">Plugin:</label></th>
						<td>
							<select id="plugin-method-id" name="plugin_method_id">
								<xsl:for-each select="plugin">
									<xsl:sort select="@plugin" data-type="text" />
									<optgroup label="{@plugin}">
										<xsl:for-each select="../plugin_method[@plugin_id = current()/@plugin_id]">
											<option value="{@plugin_method_id}">
												<xsl:if test="@plugin_method_id = $plugin_method_2_content/@plugin_method_id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
												<xsl:value-of select="@method" />
											</option>
										</xsl:for-each>
									</optgroup>
								</xsl:for-each>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="inherit">Inherit:</label></th>
						<td>
							<input type="hidden" name="inherit" value="0" />
							<label>
								<input type="checkbox" name="inherit" value="1">
									<xsl:if test="$plugin_method_2_content/@inherit = '1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
								</input>
								<xsl:text> Yes</xsl:text>
							</label>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="sequence">Sequence:</label></th>
						<td>
							<input type="text" id="sequence" name="sequence" value="{$plugin_method_2_content/@sequence}" />
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</xsl:template>

</xsl:stylesheet>