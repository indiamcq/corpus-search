<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     	present-search-corpus.xslt
    # Purpose:  	reformat for presentation.
    # Part of:  	Xrunner - https://github.com/indiamcq/corpus-search
    # Author:   	Ian McQuay <india.mcq@gmail.com>
    # Created:  	2026-09-12; 2026-10-06; 2026-10-31
    # Copyright:	(c) 2026 Ian McQuay
    # Version:		4
    # Licence:  	<MIT>
    ################################################################ -->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
    <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" name="xml"/>
    <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" suppress-indentation="div"/>
    <xsl:param name="type"/>
    <xsl:param name="searchword"/>
    <xsl:param name="nosp"/>
    <xsl:param name="target"/>
    <xsl:variable name="spacedsearchwords" select="translate($searchword,$nosp,' ')"/>
    <xsl:variable name="barsearchwords" select="translate($searchword,$nosp,'|')"/>
    <xsl:variable name="regexsearchwords" select="translate($searchword,$nosp,' ')"/>
    <xsl:variable name="wd2find" select="tokenize($spacedsearchwords,' ')"/>
    <xsl:variable name="wd2findlc" select="tokenize(lower-case($spacedsearchwords),' ')"/>
    <xsl:variable name="wd2findcount" select="count($wd2find)"/>
    <xsl:variable name="found">
        <xsl:apply-templates select="/*/text"/>
    </xsl:variable>
    <xsl:template match="/*">
        <html lang="en">
            <head>
                <title>
                    <xsl:value-of select="$searchword"/>
                </title>
                <meta charset='utf-8'/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <link rel="stylesheet" href="../result.css"/>
            </head>
            <body>
                <xsl:element name="h1">
                    <xsl:text>Search results for: </xsl:text>
                    <xsl:value-of select="replace($searchword,$nosp,' ')"/>
                    <xsl:apply-templates select="$found/text" mode="html"/>
                </xsl:element>
            </body>
        </html>
        <xsl:result-document href="found.xml" format="xml">
            <xsl:element name="found">
                <xsl:sequence select="$found"/>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="text">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="p">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="r|l">
        <xsl:variable name="lctext" select="lower-case(text())"/>
        <xsl:variable name="text" select="text()"/>
        <xsl:choose>
            <xsl:when test="$type = 'phrase' and matches(.,$spacedsearchwords,'i')">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="$type = 'multi' and $wd2findcount = 1 
				and matches(.,$wd2find[1],'i')">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="$type = 'multi' and $wd2findcount = 2 
				and matches(.,$wd2find[1],'i') 
				and matches(.,$wd2find[2],'i')">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="$type = 'multi' and $wd2findcount = 3 
				and matches(.,$wd2find[1],'i') 
				and matches(.,$wd2find[2],'i') 
				and matches(.,$wd2find[3],'i')">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="$type = 'multi' and $wd2findcount = 4 
				and matches(.,$wd2find[1],'i') 
				and matches(.,$wd2find[2],'i') 
				and matches(.,$wd2find[3],'i') 
				and matches(.,$wd2find[4],'i')">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="$type = 'multi' and $wd2findcount &gt; 4">
                <xsl:comment select="'Too many Words'"/>
            </xsl:when>
            <xsl:when test="$type = 'regex' and matches(text(),$regexsearchwords)">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="text" mode="html">
        <xsl:if test="p/r or p/l">
            <xsl:element name="p">
                <xsl:attribute name="class">
                    <xsl:text>corpus</xsl:text>
                </xsl:attribute>
                <xsl:element name="h4">
                    <xsl:value-of select="@name"/>
                </xsl:element>
                <xsl:apply-templates select="p" mode="html"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <xsl:template match="p" mode="html">
        <xsl:if test="r or l">
            <xsl:element name="div">
                <xsl:text>Page: </xsl:text>
                <xsl:value-of select="@pg"/>
            </xsl:element>
            <xsl:apply-templates select="*" mode="html"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="r|l" mode="html">
        <xsl:element name="div">
            <xsl:element name="b">
                <xsl:value-of select="@n"/>
                <xsl:text>: </xsl:text>
            </xsl:element>
            <xsl:choose>
                <xsl:when test="matches(text(),$spacedsearchwords,'i') and $type = 'phrase'">
                    <xsl:variable name="markedsearchwords" select="replace(text(),concat('(',$spacedsearchwords,')'),'«$1«','i')"/>
                    <xsl:sequence select="f:parsemarked($markedsearchwords,$spacedsearchwords,'phrase')"/>
                </xsl:when>
                <xsl:when test="matches(text(),$barsearchwords,'i') and $type = 'multi'">
                    <xsl:variable name="markedsearchwords" select="replace(text(),concat('(',$barsearchwords,')'),'«$1«','i')"/>
                    <xsl:sequence select="f:parsemarked($markedsearchwords,$wd2findlc,'multi')"/>
                </xsl:when>
                <xsl:when test="matches(text(),$regexsearchwords) and $type = 'regex'">
                    <xsl:variable name="markedsearchwords" select="replace(text(),concat('(',$regexsearchwords,')'),'«$1«')"/>
                    <xsl:sequence select="f:parsemarked($markedsearchwords,$regexsearchwords,'regex')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="text()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:function name="f:parsemarked">
        <xsl:param name="markedtext"/>
        <xsl:param name="match"/>
        <xsl:param name="type"/>
        <xsl:variable name="textarray" select="tokenize($markedtext,'«')"/>
        <xsl:variable name="matchcount" select="count($match)"/>
        <xsl:for-each select="$textarray">
                <xsl:choose>
                <xsl:when test="contains(lower-case(.),lower-case($match)) and $type = 'phrase'">
                    <span>
                            <xsl:attribute name="class">
                            <xsl:text>hilite</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                    </span>
                    </xsl:when>
                <xsl:when test="lower-case(.) = $match and $type = 'multi'">
                    <span>
                            <xsl:attribute name="class">
                            <xsl:text>hilite</xsl:text>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                    </span>
                    </xsl:when>
                <xsl:when test="matches(. ,$match) and $type = 'regex'">
                <span>
                    <xsl:attribute name="class">
                        <xsl:text>hilite</xsl:text>
                    </xsl:attribute>
                        <xsl:value-of select="."/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                    <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
            </xsl:for-each>
    </xsl:function>
</xsl:stylesheet>
