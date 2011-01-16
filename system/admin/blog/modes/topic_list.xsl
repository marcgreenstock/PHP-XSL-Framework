<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="config[@mode = 'topic_list']">
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=blog">Entry List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=blog&amp;mode=topic_list">Topic List</a>
		</p>
		<h1>Topic List</h1>
		<table>
			<col />
			<col style="width: 10em;" />
			<thead>
				<tr>
					<th scope="col">Topic</th>
					<th scope="col">No. of Entries</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th colspan="2"><input type="button" value="Add Topic" onclick="document.location = '?page=blog&amp;mode=topic_edit'" /></th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:for-each select="topic">
					<tr>
						<td>
							<xsl:value-of select="@topic" /><br />
							<span class="options">
								<a href="?page=blog&amp;mode=topic_edit&amp;topic_id={@topic_id}">edit</a>
								<xsl:text> | </xsl:text>
								<a href="?page=blog&amp;mode=topic_list&amp;action=topic_delete&amp;topic_id={@topic_id}" onclick="return(confirm('Did you really mean to click delete?'))">delete</a>
							</span>
						</td>
						<td><xsl:value-of select="count(../entry[@entry_id = ../entry_2_topic[@topic_id = current()/@topic_id]/@entry_id])" /></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>