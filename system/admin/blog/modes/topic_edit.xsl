<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="config[@mode = 'topic_edit']">
		<xsl:variable name="topic" select="topic[@topic_id = current()/globals/item[@key = 'topic_id']/@value]" />
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=blog">Entry List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=blog&amp;mode=topic_list">Topic List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=blog&amp;mode=topic_edit&amp;topic_id={$topic/@topic_id}">
				<xsl:choose>
					<xsl:when test="$topic"><xsl:value-of select="$topic/@topic" /></xsl:when>
					<xsl:otherwise>Add Topic</xsl:otherwise>
				</xsl:choose>
			</a>
		</p>
		<h1>Add / Edit Topic</h1>
		<form method="post" action="">
			<input type="hidden" name="action" value="topic_save" />
			<input type="hidden" name="topic_id" value="{$topic/@topic_id}" />
			<table class="editTable">
				<tfoot>
					<tr>
						<th colspan="2"><input type="submit" value="Save Topic" /></th>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<th scope="row"><label for="title">Topic:</label></th>
						<td><input type="text" id="title" name="topic" value="{$topic/@topic}" onkeyup="setPath(this.value,'path');" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="path">Path:</label></th>
						<td><input type="text" id="path" name="path" value="{$topic/@path}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="xhtml">Description:<br />(XHTML)</label></th>
						<td><textarea id="xhtml" name="xhtml" rows="8" cols="45"><xsl:value-of select="$topic/@xhtml" /></textarea></td>
					</tr>
				</tbody>
			</table>
		</form>
	</xsl:template>
	
</xsl:stylesheet>