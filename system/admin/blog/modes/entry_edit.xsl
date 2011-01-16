<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="config[@mode = 'entry_edit']">
		<xsl:variable name="entry" select="entries/entry[@entry_id = current()/globals/item[@key = 'entry_id']/@value]" />
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=blog">Entry List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=blog&amp;mode=entry_edit&amp;entry_id={$entry/@entry_id}">
				<xsl:choose>
					<xsl:when test="$entry"><xsl:value-of select="$entry/@title" /></xsl:when>
					<xsl:otherwise>Add Entry</xsl:otherwise>
				</xsl:choose>
			</a>
		</p>
		<h1>Add / Edit Entry</h1>
		<form method="post" action="">
			<input type="hidden" name="action" value="entry_save" />
			<input type="hidden" name="entry_id" value="{$entry/@entry_id}" />
			<input type="hidden" name="created" value="{$entry/@created}" />
			<table class="editTable">
				<tfoot>
					<tr>
						<th colspan="2">
							<input type="submit" value="Save Entry" />
							<xsl:if test="$entry">
								<input type="button" value="Preview" onclick="window.open('/{$entry/date/@year}/{$entry/date/@month}/{$entry/date/@day}/{$entry/@path}/');" />
							</xsl:if>
						</th>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<th scope="row"><label for="published">Published:</label></th>
						<td><input type="text" id="published" name="published" value="{$entry/@published}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="title">Title:</label></th>
						<td><input type="text" id="title" name="title" value="{$entry/@title}" onkeyup="setPath(this.value,'path');" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="path">Path:</label></th>
						<td><input type="text" id="path" name="path" value="{$entry/@path}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="body">Body:</label><br />(XHTML)</th>
						<td><textarea id="body" name="body" rows="20" cols="45"><xsl:value-of select="$entry/text" /></textarea></td>
					</tr>
					<tr>
						<th scoe="row">Topics:</th>
						<td>
							<xsl:for-each select="topics/topic">
								<label>
									<input type="checkbox" name="topic[]" value="{@topic_id}">
										<xsl:if test="$entry/topic[@topic_id = current()/@topic_id]"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
									</input>
									<xsl:value-of select="@topic" />
								</label>
								<br />
							</xsl:for-each>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<xsl:if test="$entry">
			<h1>Comment List</h1>
			<table>
				<thead>
					<tr>
						<th scope="col">Comment</th>
						<th scope="col">Timestamp</th>
						<th scope="col">Status</th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th colspan="3"><input type="button" value="Add Comment" onclick="document.location = '?page=blog&amp;mode=comment_edit&amp;entry_id={$entry/@entry_id}'" /></th>
					</tr>
				</tfoot>
				<tbody>
					<xsl:for-each select="$entry/comment">
						<tr>
							<td>
								<xsl:value-of select="text" disable-output-escaping="yes" /><br />
								<span class="options">
									<a href="?page=blog&amp;mode=comment_edit&amp;entry_id={$entry/@entry_id}&amp;comment_id={@comment_id}">edit</a>
									<xsl:text> | </xsl:text>
									<a href="?page=blog&amp;mode=entry_edit&amp;action=comment_delete&amp;entry_id={$entry/@entry_id}&amp;comment_id={@comment_id}" onclick="return(confirm('Did you really mean to click delete?'))">delete</a>
								</span>
							</td>
							<td><xsl:value-of select="@timestamp" /></td>
							<td><xsl:value-of select="@status" /></td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>