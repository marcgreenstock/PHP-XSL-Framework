<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="menu">
		<h1>Blog Management</h1>
		<ul id="tabs">
			<li><a href="?page=blog">Entry List</a></li>
			<li><a href="?page=blog&amp;mode=topic_list">Topic List</a></li>
		</ul>
		<br class="clear" />
	</xsl:template>

	<xsl:template match="config">
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=blog">Entry List</a>
		</p>
		<h1>Entry List</h1>
		<table>
			<thead>
				<tr>
					<th scope="col">Title</th>
					<th scope="col">Created</th>
					<th scope="col">Published</th>
					<th scope="col">Comments</th>
				</tr>
			</thead>
			<tfoot>
				<tr>
					<th colspan="4"><input type="button" value="Add Entry" onclick="document.location = '?page=blog&amp;mode=entry_edit'" /></th>
				</tr>
			</tfoot>
			<tbody>
				<xsl:for-each select="entries/entry">
					<tr>
						<td>
							<xsl:value-of select="@title" /><br />
							<span class="options">
								<a href="?page=blog&amp;mode=entry_edit&amp;entry_id={@entry_id}">edit</a>
								<xsl:text> | </xsl:text>
								<a href="?page=blog&amp;action=entry_delete&amp;entry_id={@entry_id}" onclick="return(confirm('Did you really mean to click delete?'))">delete</a>
							</span>
						</td>
						<td><xsl:value-of select="@created" /></td>
						<td><xsl:value-of select="@published" /></td>
						<td><xsl:value-of select="count(comment)" /></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:include href="modes/topic_edit.xsl" />
	<xsl:include href="modes/topic_list.xsl" />
	<xsl:include href="modes/comment_edit.xsl" />
	<xsl:include href="modes/entry_edit.xsl" />

</xsl:stylesheet>