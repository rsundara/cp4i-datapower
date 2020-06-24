<?xml version="1.0" encoding="UTF-8"?>
<!-- 
IDP_validateToken.xsl: This style sheet is used to validate the security token 

The subject included in the security Token and the userName defined in the Authorization header should match

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

		<xsl:variable name="userNameFromToken" select="//username-claim/sub/text()"/>
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### userNameFromToken =[<xsl:copy-of select="$userNameFromToken" />]
		</xsl:message>		


		<!-- Retrieve cookie from the context variable -->
        <xsl:variable name="userNameFromAuthHeader" select="dp:variable('var://context/saved/userName')"/>
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			###userNameFromAuthHeader =[<xsl:copy-of select="$userNameFromAuthHeader" />]
		</xsl:message>

		<xsl:variable name="userNameFromTokenFinal" select="substring-before($userNameFromToken, '@')"/>
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### userNameFromTokenFinal =[<xsl:copy-of select="$userNameFromTokenFinal" />]
		</xsl:message>

        <xsl:variable name="userNameFromAuthHeaderFinal" select="substring-before($userNameFromAuthHeader, '@')"/>
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### userNameFromAuthHeaderFinal =[<xsl:copy-of select="$userNameFromAuthHeaderFinal" />]
		</xsl:message>
				
		<xsl:choose>
        	<xsl:when test=" $userNameFromTokenFinal = $userNameFromAuthHeaderFinal">
				<result>User is authorized</result>
				<xsl:message dp:type="xsltmsg" dp:priority="warn">
					### User is authorized
				</xsl:message>				
        	</xsl:when>
        	<xsl:otherwise>
				<result>User is NOT authorized</result>
        		<dp:set-http-response-header name="'x-dp-response-code'" value="'401 Unauthorized'"/> 
				<xsl:message dp:type="xsltmsg" dp:priority="error">
					### User is NOT authorized
				</xsl:message>				
        	</xsl:otherwise>
		</xsl:choose>
      		
    </xsl:template>
		       
</xsl:stylesheet>
