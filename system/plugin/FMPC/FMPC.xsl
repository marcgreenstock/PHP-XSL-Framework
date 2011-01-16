<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:marc="http://www.marcgreenstock.com/xsl"
	xmlns:math="http://exslt.org/math"
	xmlns:func="http://exslt.org/functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	extension-element-prefixes="math func"
	exclude-result-prefixes="math func">
	
	<func:function name="marc:formatMoney">
		<xsl:param name="monies" />
		<xsl:param name="currency" />
		<xsl:variable name="formated">
			<xsl:choose>
				<xsl:when test="$monies &gt;= 1000">
					<xsl:value-of select="format-number($monies,'#,###')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number($monies,'0.00')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<func:result>
			<xsl:choose>
				<xsl:when test="$currency/@position = 'before'">
					<xsl:value-of select="$currency/@symbol" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="$formated" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$formated" />
					<xsl:text> </xsl:text>
					<xsl:value-of select="$currency/@symbol" />
				</xsl:otherwise>
			</xsl:choose>
		</func:result>
	</func:function>

	<xsl:template  match="/config/plugin[@plugin = 'FMPC'][@method = 'calculator']">
		<xsl:variable name="monies" select="/config/globals/item[@key = 'monies']/@value" />
		<xsl:variable name="country" select="countries/country[@ISO = /config/globals/item[@key = 'country']/@value]" />
		<xsl:variable name="local_currency" select="currencies/currency[@currency_id = $country/@currency_id]" />
		<form method="get" action="">
			<fieldset class="border" style="width: 50%; margin: 0 auto;">
				<legend>Foreign Market Price Calculator</legend>
				<p>
					<label>
						<span>Benchmark country:</span>
						<br />
						<select name="country">
							<option value="">-- Select Country --</option>
							<xsl:for-each select="countries/country">
								<xsl:sort select="@country" />
								<option value="{@ISO}">
									<xsl:if test="$country/@ISO = current()/@ISO"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
									<xsl:value-of select="@country" />
								</option>
							</xsl:for-each>
						</select>
					</label>
				</p>
				<p>
					<label>
						<span>Monetary value in benchmark currency:</span>
						<br />
						<input type="text" name="monies" value="{$monies}" />
					</label>
				</p>
				<p class="center">
					<input type="submit" value="Calculate" />
				</p>
			</fieldset>
		</form>
		<xsl:if test="$monies and number($monies) and $country">
			<h3>Results by Country</h3>
			<table class="properties" style="width: 100%;">
				<col />
				<xsl:for-each select="indexes/index">
					<col style="width: 6em;" />
					<col style="width: 6em;" />
				</xsl:for-each>
				<col style="width: 6em;" />
				<thead>
					<tr>
						<th scope="col" rowspan="2">Country</th>
						<xsl:for-each select="indexes/index">
							<th scope="col" colspan="2" class="center"><xsl:value-of select="@index" /></th>
						</xsl:for-each>
						<th scope="col" rowspan="2" class="center">Exchange Rate</th>
					</tr>
					<tr>
						<xsl:for-each select="indexes/index">
							<th scope="col" class="center"><xsl:value-of select="$local_currency/@code" /></th>
							<th scope="col" class="center">Local Currency</th>
						</xsl:for-each>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="countries/country">
						<xsl:sort select="@country" />
						
						<xsl:variable name="country_row" select="." />
						<xsl:variable name="foreign_currency" select="../../currencies/currency[@currency_id = current()/@currency_id]" />
						<xsl:variable name="xr" select="(1 div $local_currency/@rate) * $foreign_currency/@rate" />
						
						<tr>
							<th scope="row"><xsl:value-of select="@country" /></th>
							<xsl:for-each select="../../indexes/index">
								<xsl:choose>
									<xsl:when test="$country_row[@country_id = current()/data/@country_id] and data[@country_id = $country/@country_id]">
										<xsl:variable name="local_index_price" select="data[@country_id = $country/@country_id]/@price" />
										<xsl:variable name="foreign_index_price" select="data[@country_id = $country_row/@country_id]/@price" />
										
										<xsl:variable name="ppp" select="($foreign_index_price div $local_index_price)" />
										<xsl:variable name="valuation" select="($ppp - $xr) div $xr" />
										
										<xsl:variable name="local_price" select="$monies + ($valuation * $monies)" />
										<xsl:variable name="foreign_price" select="$local_price * $xr" />
										
										<td class="right"><xsl:value-of select="marc:formatMoney($local_price,$local_currency)" disable-output-escaping="yes" /></td>
										<td class="right"><xsl:value-of select="marc:formatMoney($foreign_price,$foreign_currency)" disable-output-escaping="yes" /></td>
									</xsl:when>
									<xsl:otherwise>
										<td class="center">---</td>
										<td class="center">---</td>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
							<td class="right"><xsl:value-of select="format-number($xr,'0.000')" /></td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>