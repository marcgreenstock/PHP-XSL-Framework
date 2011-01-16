<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="config[@mode = 'widget_list']">
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=widgets&amp;mode=widget_list">Widget List</a>
		</p>
		<table>
			<thead>
				<tr>
					<th scope="col">Name</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th colspan="2"><input type="button" value="Add Widget" onclick="document.location = '?page=widgets&amp;mode=widget_edit';" /></th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:for-each select="widgets/widget">
					<tr>
						<td>
							<xsl:value-of select="@name" />
							<br />
							<span class="options">
								<a href="?page=widgets&amp;mode=widget_edit&amp;widget_id={@widget_id}">edit</a>
								<xsl:text> | </xsl:text>
								<a href="?page=widgets&amp;mode=widget_list&amp;action=widget_delete&amp;widget_id={@widget_id}" onclick="return(confirm('Did you really mean to click delete?'))">delete</a>
							</span>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

</xsl:stylesheet>