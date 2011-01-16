<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template match="/config/plugin[@plugin = 'contact'][@method = 'contactForm']">
		<xsl:apply-templates select="formSubmit" />
	</xsl:template>
	
	<xsl:template match="formSubmit">
		<h2>Contact Marc Greenstock</h2>
		<p>Unless you know me, this form is the quickest way to get in-touch with me, plus I don't have to put up with spam or people cold calling.</p>
		<form method="post" action="">
			<input type="hidden" name="action" value="send_message" />
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
							<xsl:text>Email:</xsl:text>
							<br />
							<input type="text" name="email" value="{/config/globals/item[@key = 'email']/@value}" />
						</label>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<p>
				<xsl:choose>
					<xsl:when test="error[@field = 'subject']">
						<xsl:attribute name="class">error</xsl:attribute>
						<label>
							<xsl:value-of select="error[@field = 'subject']" />
							<br />
							<input type="text" name="subject" />
						</label>
					</xsl:when>
					<xsl:otherwise>
						<label>
							<xsl:text>Subject:</xsl:text>
							<br />
							<input type="text" name="subject" value="{/config/globals/item[@key = 'subject']/@value}" />
						</label>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<p>
				<xsl:choose>
					<xsl:when test="error[@field = 'message']">
						<xsl:attribute name="class">error</xsl:attribute>
						<label>
							<xsl:value-of select="error[@field = 'message']" />
							<br />
							<textarea name="message" rows="8" cols="30"></textarea>
						</label>
					</xsl:when>
					<xsl:otherwise>
						<label>
							<xsl:text>Message:</xsl:text>
							<br />
							<textarea name="message" rows="8" cols="30"><xsl:value-of select="/config/globals/item[@key = 'message']/@value" /></textarea>
						</label>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<xsl:apply-templates select="recaptcha" />
			<p style="text-align: center;"><input type="submit" value="Send Message" /></p>
		</form>
	</xsl:template>
	
	<xsl:template match="formSubmit[@success = 'yes']">
		<h2>Contact Marc Greenstock</h2>
		<p>Woot! I got your message, it it merits a response I'll be in touch.</p>
	</xsl:template>
	
</xsl:stylesheet>