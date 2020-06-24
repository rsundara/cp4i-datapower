<?xml version="1.0" encoding="UTF-8"?>
<!-- 
IDP_getToken.xsl: This style sheet is used to get security token for accessing IBM API Connect
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

    <xsl:import href="IDP_dputils.xsl"/> 
			
    <xsl:template match="/">

		<xsl:variable name="AuthorizationHeaderValue" select="dp:http-response-header('Authorization')"/>

		<xsl:variable name="userName" select="dp:variable('var://context/WSM/identity/username')"/>
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### userName =[<xsl:copy-of select="$userName" />]
		</xsl:message>
		
		<xsl:variable name="sn">
			<xsl:choose>
				<xsl:when test="contains($userName, 'admin')">
				<xsl:copy-of select="'Administrator'" />
				</xsl:when>
				<xsl:when test="contains($userName, 'student')">
				<xsl:copy-of select="'Student'" />
				</xsl:when>
				<xsl:otherwise>
				<xsl:copy-of select="'Consumer'" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>			
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### sn =[<xsl:copy-of select="$sn" />]
		</xsl:message>

		<xsl:variable name="givenName">
			<!-- Compute the cookie value as tokens -->
			<xsl:variable name="userNameTokens" select="str:split($userName,'@')"/>
			<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### userNameTokens =[ <xsl:copy-of select="$userNameTokens" /> ]
			</xsl:message>
			<xsl:for-each select="$userNameTokens">
				<xsl:variable name="currentUserNameToken" select="string(current())" />
				
				<xsl:message dp:type="xsltmsg" dp:priority="debug">
				### currentUserNameToken =[ <xsl:value-of select="$currentUserNameToken" /> ]
				</xsl:message>
				<xsl:variable name="currentUserNameTokenIndex" select="position()"/>
				
				<!-- Check if the token position is one --> 
				<xsl:if test="contains($currentUserNameTokenIndex, '1')">

					<xsl:copy-of select="$currentUserNameToken" />
	
				</xsl:if>		
			</xsl:for-each>
		</xsl:variable>
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### givenName =[<xsl:copy-of select="$givenName" />]
		</xsl:message>		

		<xsl:variable name="securityToken">
			<!-- Compute the cookie value as tokens -->
			<xsl:variable name="AuthorizationHeaderValueTokens" select="str:split($AuthorizationHeaderValue,' ')"/>
			<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### AuthorizationHeaderValueTokens =[ <xsl:copy-of select="$AuthorizationHeaderValueTokens" /> ]
			</xsl:message>
			<xsl:for-each select="$AuthorizationHeaderValueTokens">
				<xsl:variable name="currentAuthorizationHeaderValueToken" select="string(current())" />
				
				<xsl:message dp:type="xsltmsg" dp:priority="debug">
				### currentAuthorizationHeaderValueToken =[ <xsl:value-of select="$currentAuthorizationHeaderValueToken" /> ]
				</xsl:message>
				<xsl:variable name="currentAuthorizationHeaderValueTokenIndex" select="position()"/>
				
				<!-- Check if the token position is two --> 
				<xsl:if test="contains($currentAuthorizationHeaderValueTokenIndex, '2')">

					<xsl:copy-of select="$currentAuthorizationHeaderValueToken" />
	
				</xsl:if>		
			</xsl:for-each>
		</xsl:variable>
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### securityToken =[<xsl:copy-of select="$securityToken" />]
		</xsl:message>

		<!--  Remove first 21 bytes from the JWT Token --> 
		<xsl:variable name="securityTokenFinal" select="substring($securityToken, 22)" />
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### securityTokenFinal =[<xsl:copy-of select="$securityTokenFinal" />]
		</xsl:message>

		<xsl:variable name="samlAttributeResult">
		<result> 
			<attribute-value name="uid"> <xsl:value-of select="$userName" /> </attribute-value> 
			<attribute-value name="securityToken"> <xsl:value-of select="$securityTokenFinal" /> </attribute-value> 
			<attribute-value name="sn"> <xsl:value-of select="$sn" /> </attribute-value> 
			<attribute-value name="givenName"> <xsl:value-of select="$givenName" /> </attribute-value> 
		</result>
		</xsl:variable>
		<xsl:message dp:type="xsltmsg" dp:priority="debug">
			### samlAttributeResult =[<xsl:copy-of select="$samlAttributeResult" />]
		</xsl:message>		
		<!--  Save the securityToken in the context --> 
        <dp:set-variable name="'var://context/saved/samlAttributeResult'" value="$samlAttributeResult" />
		<!--  Save the userName in the context --> 
        <dp:set-variable name="'var://context/saved/userName'" value="$userName" />
		<!--  Save the securityTokenFinal in the context --> 
        <dp:set-variable name="'var://context/saved/securityTokenFinal'" value="$securityTokenFinal" />

		<!--  Compute the originUrl - Used for form-based login--> 
		<xsl:variable name="RefererHeaderValue" select="dp:http-request-header('Referer')"/>
		<xsl:variable name="refererLink" select="str:decode-uri($RefererHeaderValue)"/>
		<xsl:variable name="originalUrl" select="string(dpfunc:extractQueryParam($RefererHeaderValue, 'originalUrl'))"/>
		<xsl:variable name="original_urlDecoded">
			<xsl:choose>
				<xsl:when test="$originalUrl">
					<xsl:variable name="originalUrlDecoded" select="str:decode-uri($originalUrl)"/>
					<xsl:variable name="original_url" select="string(dpfunc:extractQueryParam($originalUrlDecoded, 'original-url'))"/>
					<xsl:value-of select="str:decode-uri($original_url)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="incomingUrl" select="dp:variable('var://service/routing-url')"/>
					<xsl:variable name="original_url" select="string(dpfunc:extractQueryParam($incomingUrl, 'original-url'))"/>
					<xsl:value-of select="str:decode-uri($original_url)" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>	
		<!--  Save the originUrl in the context --> 
		<dp:set-variable name="'var://context/saved/originalUrl'" value="string($original_urlDecoded)" />
<html>
<body>	
<p>
Your security token for accessing the backend services:
<br/>
<br/>
<xsl:copy-of select="$securityTokenFinal" />
</p>
</body>		
</html>
		
    </xsl:template>
		       
</xsl:stylesheet>