<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="config[@mode = 'index_list']">
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=ppp&amp;mode=index_list">Index List</a>
		</p>
		<table>
			<thead>
				<tr>
					<th scope="col">Index</th>
					<th scope="col">Data Points</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th colspan="2"><input type="button" value="Add Index" onclick="document.location = '?page=ppp&amp;mode=index_edit';" /></th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:for-each select="indexes/index">
					<tr>
						<td>
							<xsl:value-of select="@index" />
							<br />
							<span class="options">
								<a href="?page=ppp&amp;mode=index_edit&amp;index_id={@index_id}">edit</a>
								<xsl:text> | </xsl:text>
								<a href="?page=ppp&amp;mode=index_list&amp;action=index_delete&amp;index_id={@index_id}" onclick="return(confirm('Did you really mean to click delete?'))">delete</a>
							</span>
						</td>
						<td><xsl:value-of select="count(data)" /></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

</xsl:stylesheet>