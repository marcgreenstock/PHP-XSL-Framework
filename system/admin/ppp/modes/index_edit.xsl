<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="config[@mode = 'index_edit']">
		<xsl:variable name="index" select="indexes/index[@index_id = /config/globals/item[@key = 'index_id']/@value]" />
		
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=ppp&amp;mode=index_list">Index List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=ppp&amp;mode=index_edit&amp;index_id={$index/@index_id}">
				<xsl:choose>
					<xsl:when test="$index"><xsl:value-of select="$index/@index" /></xsl:when>
					<xsl:otherwise>Add Index</xsl:otherwise>
				</xsl:choose>
			</a>
		</p>
		<h1>Add / Edit Index</h1>
		<form method="post" action="">
			<input type="hidden" name="action" value="index_save" />
			<input type="hidden" name="index_id" value="{$index/@index_id}" />
			<table class="editTable">
				<tfoot>
					<tr>
						<th colspan="2"><input type="submit" value="Save Index" /></th>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<th scope="row"><label for="index">Index Name:</label></th>
						<td><input type="text" id="index" name="index" value="{$index/@index}" /></td>
					</tr>
				</tbody>
			</table>
		</form>
		<xsl:if test="$index">
			<h1>Index Data List</h1>
			<table>
				<thead>
					<tr>
						<th scope="col">Country</th>
						<th scope="col">Price</th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th colspan="2"><input type="button" value="Add Index Data" onclick="document.location = '?page=ppp&amp;mode=index_data_edit&amp;index_id={$index/@index_id}';" /></th>
					</tr>
				</tfoot>
				<tbody>
					<xsl:for-each select="$index/data">
						<tr>
							<td>
								<xsl:value-of select="/config/countries/country[@country_id = current()/@country_id]/@country" />
								<br />
								<span class="options">
									<a href="?page=ppp&amp;mode=index_data_edit&amp;index_id={@index_id}&amp;index_data_id={@index_data_id}">edit</a>
									<xsl:text> | </xsl:text>
									<a href="?page=ppp&amp;mode=index_edit&amp;action=index_data_delete&amp;index_id={@index_id}&amp;index_data_id={@index_data_id}" onclick="return(confirm('Did you really mean to click delete?'))">delete</a>
								</span>
							</td>
							<td><xsl:value-of select="@price" /></td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>