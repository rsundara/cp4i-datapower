<?xml version="1.0" encoding="UTF-8"?>
<!-- 
IDP_extractToken.xsl: This style sheet is used to extract security token for validating
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dp="http://www.datapower.com/extensions"
  xmlns:dpconfig="http://www.datapower.com/param/config"
  xmlns:dpfunc="http://www.datapower.com/extensions/functions"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="dp"
  exclude-result-prefixes="dp dpconfig dpfunc str">					

	<xsl:output method="html" omit-xml-declaration="yes" />
			
    <xsl:template match="/">

		<xsl:variable name="userName" select="//entry/username/text()"/>
		<xsl:variable name="securityToken" select="//entry/password/text()"/>
		
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### userName =[<xsl:copy-of select="$userName" />]
		</xsl:message>
		<!--  Save the userName in the context --> 
        <dp:set-variable name="'var://context/saved/userName'" value="$userName" />

		<xsl:choose>
        	<xsl:when test="string($userName) and string($securityToken)">
	        	<result>Username and Security Token are available</result>
				<!--  The string Base64("{"alg":"HS256"}") is added as a prefix to the Bearer JWT Token --> 
				<!--  This allows removing 20 bytes from the payload                                    --> 
	        	<dp:set-http-request-header name="'Authorization'" value="concat('Bearer eyJhbGciOiJIUzI1NiJ9.', $securityToken)"/> 
        	</xsl:when>
        	<xsl:otherwise>
        	</xsl:otherwise>
		</xsl:choose>
      		
    </xsl:template>
		       
</xsl:stylesheet>
