<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings">

	<xsl:template match="config[@mode = 'comment_edit']">
		<xsl:variable name="entry" select="entries/entry[@entry_id = current()/globals/item[@key = 'entry_id']/@value]" />
		<xsl:variable name="comment" select="$entry/comment[@comment_id = current()/globals/item[@key = 'comment_id']/@value]" />
		<xsl:call-template name="menu" />
		<p id="breadcrumb">
			<xsl:text>You are here: </xsl:text>
			<a href="?page=blog">Entry List</a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=blog&amp;mode=entry_edit&amp;entry_id={$entry/@entry_id}"><xsl:value-of select="$entry/@title" /></a>
			<xsl:text> &gt; </xsl:text>
			<a href="?page=blog&amp;mode=comment_edit&amp;entry_id={$entry/@entry_id}&amp;comment_id={$comment/@comment_id}">Add / Edit Comment</a>
		</p>
		<h1>Add / Edit Comment</h1>
		<form method="post" action="">
			<input type="hidden" name="action" value="comment_save" />
			<input type="hidden" name="comment_id" value="{$comment/@comment_id}" />
			<input type="hidden" name="entry_id" value="{$entry/@entry_id}" />
			<table class="editTable">
				<tfoot>
					<tr>
						<th colspan="2"><input type="submit" value="Save Comment" /></th>
					</tr>
				</tfoot>
				<tbody>
					<tr>
						<th scope="row"><label for="timestamp">Timestamp:</label></th>
						<td><input type="text" id="timestamp" name="timestamp" value="{$comment/@timestamp}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="status">Status:</label></th>
						<td>
							<select id="status" name="status">
								<xsl:for-each select="str:tokenize('new,approved,spam',',')">
									<option value="{.}">
										<xsl:if test=". = $comment/@status"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
										<xsl:value-of select="." />
									</option>
								</xsl:for-each>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row"><label for="ip-address">IP Address:</label></th>
						<td><input type="text" id="ip-address" name="ip_address" value="{$comment/@ip_address}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="host-address">Host:</label></th>
						<td><input type="text" id="host-address" name="host_address" value="{$comment/@host_address}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="useragent">User Agent:</label></th>
						<td><input type="text" id="useragent" name="useragent" value="{$comment/@useragent}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="email">Email:</label></th>
						<td><input type="text" id="email" name="email" value="{$comment/@email}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="name">Name:</label></th>
						<td><input type="text" id="name" name="name" value="{$comment/@name}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="url">URL:</label></th>
						<td><input type="text" id="url" name="url" value="{$comment/@url}" /></td>
					</tr>
					<tr>
						<th scope="row"><label for="comment">Comment:</label></th>
						<td><textarea id="comment" name="comment" rows="8" cols="45"><xsl:value-of select="$comment/text" /></textarea></td>
					</tr>
				</tbody>
			</table>
		</form>
	</xsl:template>
	
</xsl:stylesheet>