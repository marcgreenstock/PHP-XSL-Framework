<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="config[@mode = 'index_data_edit']">
		<xsl:variable name="index" select="indexes/index[@index_id = /config/globals/item[@key = 'index_id']/@value]" />
		<xsl:variable name="index_data" select="$index/data[@index_data_id = /config/globals/item[@key = 'index_data_id']/@value]" />
		
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=ppp&amp;mode=index_list">Index List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=ppp&amp;mode=index_edit&amp;index_id={$index/@index_id}"><xsl:value-of select="$index/@index" /></a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=ppp&amp;mode=index_data_edit&amp;index_id={$index/@index_id}&amp;index_data_id={$index_data/@index_data_id}">
				<xsl:choose>
					<xsl:when test="$index_data"><xsl:value-of select="countries/country[@country_id = $index_data/@country_id]/@country" /></xsl:when>
					<xsl:otherwise>Add Index Data</xsl:otherwise>
				</xsl:choose>
			</a>
		</p>
		<h1>Add / Edit Index Data</h1>
		<form method="post" action="">
			<input type="hidden" name="action" value="index_data_save" />
			<input type="hidden" name="index_id" value="{$index/@index_id}" />
			<input type="hidden" name="index_data_id" value="{$index_data/@index_data_id}" />
			<table class="editTable">
				<tfoot>
					<tr>
						<th colspan="2"><input type="submit" value="Save Index Data" /></th>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<th scope="row"><label for="country-id">Country:</label></th>
						<td>
							<select id="country-id" name="country_id">
								<xsl:for-each select="countries/country">
									<option value="{@country_id}">
										<xsl:if test="$index_data/@country_id = current()/@country_id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
										<xsl:value-of select="concat(@country,' - ',@ISO)" />
									</option>
								</xsl:for-each>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="price">Price:</label></th>
						<td><input type="text" id="price" name="price" value="{$index_data/@price}" /></td>
					</tr>
				</tbody>
			</table>
		</form>
	</xsl:template>
	
</xsl:stylesheet>