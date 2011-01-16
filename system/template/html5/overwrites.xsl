<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="entry" priority="1">
		<xsl:param name="permalink" select="concat('/',date/@year,'/',date/@month,'/',date/@day,'/',@path,'/')" />
		<article>
			<header>
				<h2><a href="{$permalink}" rel="bookmark"><xsl:value-of select="@title" /></a></h2>
				<time><xsl:apply-templates select="date" mode="date" /></time>
			</header>
			<xsl:apply-templates select="xhtml/*[name() != 'fold']" mode="html" />
			<xsl:if test="xhtml/fold">
				<p><a href="{$permalink}" rel="bookmark">Continue reading <xsl:value-of select="@title" />...</a></p>
			</xsl:if>
			<footer>
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
			</footer>
		</article>
	</xsl:template>
	
	<xsl:template match="entry" mode="full" priority="1">
		<xsl:param name="permalink" select="concat('/',date/@year,'/',date/@month,'/',date/@day,'/',@path,'/')" />
		<article>
			<header>
				<h2><a href="{$permalink}" rel="bookmark"><xsl:value-of select="@title" /></a></h2>
				<time><xsl:apply-templates select="date" mode="date" /></time>
			</header>
			<xsl:apply-templates select="xhtml/*" mode="html" />
			<xsl:if test="comment">
				<h2><a name="comments"></a>Comments</h2>
				<xsl:apply-templates select="comment" />
			</xsl:if>
			<xsl:apply-templates select="../../storeComment">
				<xsl:with-param name="entry_id" select="@entry_id" />
			</xsl:apply-templates>
		</article>
	</xsl:template>

</xsl:stylesheet>