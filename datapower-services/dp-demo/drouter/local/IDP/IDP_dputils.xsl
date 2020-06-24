<?xml version="1.0" encoding="UTF-8"?>
<!-- 
IDP_dputils.xsl: This style sheet includes datapower utilities
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dp="http://www.datapower.com/extensions"
  xmlns:dpconfig="http://www.datapower.com/param/config"
  xmlns:dpfunc="http://www.datapower.com/extensions/functions"
  xmlns:str="http://exslt.org/strings"
  xmlns:func="http://exslt.org/functions"
  xmlns:regex="http://exslt.org/regular-expressions"
  extension-element-prefixes="dp regex"
  exclude-result-prefixes="dp dpconfig dpfunc func str">	


<!-- Extract a query parameter value from a URL -->
<func:function name="dpfunc:extractQueryParam">
	<xsl:param name="url"/>
	<xsl:param name="pname"/>

	<xsl:message dp:priority="debug">
	DEBUG: dpfunc:extractQueryParam( '<xsl:value-of select="$url"/>', '<xsl:value-of select="$pname"/>' ) 
	</xsl:message>

	<xsl:variable name="regexString" select="concat( '[;\?&amp;]', $pname, '=([^&amp;]+)' )"/>
	<xsl:variable name="value" select="regex:match( $url, $regexString )"/>
	<!-- 
	<xsl:message dp:priority="debug">
	DEBUG(): <dp:serialize select="$value"/> 
	</xsl:message>
	--> 
	<xsl:choose>
		<xsl:when test="count( $value ) = 0">
			<func:result select="''"/> 
		</xsl:when>
		<xsl:otherwise>
			<func:result select="$value[ 2 ]"/> 
		</xsl:otherwise>
	</xsl:choose>
</func:function>

</xsl:stylesheet>

