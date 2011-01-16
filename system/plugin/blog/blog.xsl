<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/config/plugin[@plugin = 'blog'][@method = 'getEntries']">
		<xsl:param name="page_no" select="/config/pathSet/path[count(/config/pathSet/path[text() = 'page']/preceding-sibling::*)+2]" />
		<xsl:apply-templates select="/config/pathSet">
			<xsl:with-param name="page_no">
				<xsl:choose>
					<xsl:when test="$page_no"><xsl:value-of select="$page_no" /></xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="/config/pathSet">
		<xsl:param name="page_no" select="1" />
		<xsl:param name="limit" select="4" />
		<xsl:apply-templates select="/config/plugin/entries/entry
			[@published != '']
			[position() &gt; ($page_no - 1) * $limit]
			[position() &lt;= $limit]" />
		
		<xsl:if test="ceiling(count(/config/plugin/entries/entry) div $limit) &gt; $page_no">
			<p id="olderPosts"><a href="/page/{($page_no + 1)}/">&lt; Older posts</a></p>
		</xsl:if>
		<xsl:if test="$page_no &gt; 1">
			<p id="newerPosts"><a href="/page/{($page_no - 1)}/">Newer posts &gt;</a></p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/config/pathSet
		[path[1] = /config/plugin/topics/topic/@path]">
		<xsl:apply-templates select="/config/plugin/topics/topic
			[@path = current()/path[1]]" />
	</xsl:template>
	
	<xsl:template match="/config/pathSet
		[string-length(number(path[1])) = 4]">
		<xsl:apply-templates select="/config/plugin/entries/entry
			[@published != '']
			[date/@year = current()/path[1]]" />
	</xsl:template>
	
	<xsl:template match="/config/pathSet
		[string-length(number(path[1])) = 4]
		[string-length(path[2]) = 2]">
		<xsl:apply-templates select="/config/plugin/entries/entry
			[@published != '']
			[date/@year = current()/path[1]]
			[date/@month = current()/path[2]]" />
	</xsl:template>
	
	<xsl:template match="/config/pathSet
		[string-length(number(path[1])) = 4]
		[string-length(path[2]) = 2]
		[string-length(path[3]) = 2]">
		<xsl:apply-templates select="/config/plugin/entries/entry
			[@published != '']
			[date/@year = current()/path[1]]
			[date/@month = current()/path[2]]
			[date/@day = current()/path[3]]" />
	</xsl:template>
	
	<xsl:template match="/config/pathSet
		[string-length(number(path[1])) = 4]
		[string-length(path[2]) = 2]
		[string-length(path[3]) = 2]
		[path[4] = /config/plugin/entries/entry/@path]">
		<xsl:apply-templates select="/config/plugin/entries/entry
			[date/@year = current()/path[1]]
			[date/@month = current()/path[2]]
			[date/@day = current()/path[3]]
			[@path = current()/path[4]]" mode="full" />
	</xsl:template>
		
	<xsl:template match="/config/plugin[@plugin = 'blog'][@method = 'getEntries'][/config/globals/item[@key = 'q']]">
		<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<xsl:variable name="query" select="translate(/config/globals/item[@key = 'q']/@value,$lcletters,$ucletters)" />
		<xsl:apply-templates select="entries/entry[contains(translate(xhtml,$lcletters,$ucletters),$query) or contains(translate(@title,$lcletters,$ucletters),$query)]" />
	</xsl:template>
	
	<xsl:template match="/config/plugin[@plugin = 'blog'][@method = 'getTopics']/topics/topic[@path = /config/pathSet/path[1]]">
		<h2><xsl:value-of select="@topic" /></h2>
		<xsl:apply-templates select="xhtml/*" mode="html" />
		<xsl:apply-templates select="/config/plugin[@plugin = 'blog'][@method = 'getEntries']/entries/entry[topic/@topic_id = current()/@topic_id]" />
	</xsl:template>
	
	<xsl:template match="/config/pathSet
		[string-length(number(path[1])) = 4]
		[string-length(path[2]) = 2]
		[string-length(path[3]) = 2]
		[path[4] = /config/plugin/entries/entry/@path]" mode="title">
		<xsl:value-of select="/config/plugin/entries/entry
			[date/@year = current()/path[1]]
			[date/@month = current()/path[2]]
			[date/@day = current()/path[3]]
			[@path = current()/path[4]]/@title" />
		<xsl:text> - Marc Greenstock</xsl:text>
	</xsl:template>
	
	<xsl:template match="entry">
		<xsl:param name="permalink" select="concat('/',date/@year,'/',date/@month,'/',date/@day,'/',@path,'/')" />
		<div class="entry">
			<div class="title">
				<h2><a href="{$permalink}" rel="bookmark"><xsl:value-of select="@title" /></a></h2>
				<span><xsl:apply-templates select="date" mode="date" /></span>
			</div>
			<xsl:apply-templates select="xhtml/*[name() != 'fold']" mode="html" />
			<xsl:if test="xhtml/fold">
				<p><a href="{$permalink}" rel="bookmark">Continue reading <xsl:value-of select="@title" />...</a></p>
			</xsl:if>
			<div class="foot">
				<ul>
					<li><a href="{$permalink}" rel="bookmark">Permalink</a></li>
					<li>
						<a href="{$permalink}#comments" rel="bookmark">
							<xsl:choose>
								<xsl:when test="count(comment) = 1">1 Comment</xsl:when>
								<xsl:when test="count(comment) &gt; 1"><xsl:value-of select="count(comment)" /> Comments</xsl:when>
								<xsl:otherwise>No comments</xsl:otherwise>
							</xsl:choose>
						</a>
					</li>
				</ul>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="entry" mode="full">
		<xsl:param name="permalink" select="concat('/',date/@year,'/',date/@month,'/',date/@day,'/',@path,'/')" />
		<div class="entry">
			<div class="title">
				<h2><a href="{$permalink}" rel="bookmark"><xsl:value-of select="@title" /></a></h2>
				<span><xsl:apply-templates select="date" mode="date" /></span>
			</div>
			<xsl:apply-templates select="xhtml/*" mode="html" />
			<xsl:if test="comment">
				<h2><a name="comments"></a>Comments</h2>
				<xsl:apply-templates select="comment" />
			</xsl:if>
			<xsl:apply-templates select="../../storeComment">
				<xsl:with-param name="entry_id" select="@entry_id" />
			</xsl:apply-templates>
		</div>
	</xsl:template>
	
	<xsl:template match="storeComment[@success = 'yes']">
		<a name="comment-form"></a>
		<h2>Thanks for your comment</h2>
		<p>Thanks, your comment has been posted.</p>
	</xsl:template>
	
	<xsl:template match="storeComment">
		<xsl:param name="entry_id" />
		<a name="comment-form"></a>
		<h2>Post Your Comment</h2>
		<form method="post" action="#comment-form">
			<input type="hidden" name="action" value="post_comment" />
			<input type="hidden" name="entry_id" value="{$entry_id}" />
			<p>
				<xsl:choose>
					<xsl:when test="error[@field = 'name']">
						<xsl:attribute name="class">error</xsl:attribute>
						<label>
							<xsl:value-of select="error[@field = 'name']" />
							<br />
							<input type="text" name="name" />
						</label>
					</xsl:when>
					<xsl:otherwise>
						<label>
							<xsl:text>Name:</xsl:text>
							<br />
							<input type="text" name="name" value="{/config/globals/item[@key = 'name']/@value}" />
						</label>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<p>
				<xsl:choose>
					<xsl:when test="error[@field = 'email']">
						<xsl:attribute name="class">error</xsl:attribute>
						<label>
							<xsl:value-of select="error[@field = 'email']" />
							<br />
							<input type="text" name="email" />
						</label>
					</xsl:when>
					<xsl:otherwise>
						<label>
							<xsl:text>Email: (not displayed)</xsl:text>
							<br />
							<input type="text" name="email" value="{/config/globals/item[@key = 'email']/@value}" />
						</label>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<p>
				<xsl:choose>
					<xsl:when test="error[@field = 'url']">
						<xsl:attribute name="class">error</xsl:attribute>
						<label>
							<xsl:value-of select="error[@field = 'url']" />
							<br />
							<input type="text" name="url" />
						</label>
					</xsl:when>
					<xsl:otherwise>
						<label>
							<xsl:text>URL: (e.g. http://www.example.com/)</xsl:text>
							<br />
							<input type="text" name="url" value="{/config/globals/item[@key = 'url']/@value}" />
						</label>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<p>
				<xsl:choose>
					<xsl:when test="error[@field = 'comment']">
						<xsl:attribute name="class">error</xsl:attribute>
						<label>
							<xsl:value-of select="error[@field = 'comment']" />
							<br />
							<textarea name="comment" rows="8" cols="30"></textarea>
						</label>
					</xsl:when>
					<xsl:otherwise>
						<label>
							<xsl:text>Comment: (sorry no markup but URLs will be converted to links)</xsl:text>
							<br />
							<textarea name="comment" rows="8" cols="30"><xsl:value-of select="/config/globals/item[@key = 'comment']/@value" /></textarea>
						</label>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<xsl:apply-templates select="recaptcha" />
			<p style="text-align: center;"><input type="submit" value="Post Comment" /></p>
		</form>
	</xsl:template>

	<xsl:template match="comment">
		<div class="comment">
			<h3>
				<xsl:choose>
					<xsl:when test="@url != ''">
						<a href="{@url}">
							<xsl:value-of select="@name" />
							<xsl:text> </xsl:text>
							<img src="/_images/nw.gif" alt="Open in new window" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@name" />
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> said on </xsl:text>
				<xsl:apply-templates select="date" mode="date" />
				<xsl:text> @ </xsl:text>
				<xsl:apply-templates select="date" mode="time" />
			</h3>
			<xsl:apply-templates select="xhtml/*" mode="html" />
		</div>
	</xsl:template>

	<xsl:template match="fold" mode="html">
		<xsl:apply-templates mode="html" />
	</xsl:template>

	<xsl:template match="*" mode="date">
		<xsl:value-of select="concat(@year,'-',@month,'-',@day)" />
	</xsl:template>
	
	<xsl:template match="*" mode="time">
		<xsl:value-of select="@hour" />
		<xsl:text>:</xsl:text>
		<xsl:value-of select="@minute" />
	</xsl:template>

</xsl:stylesheet>