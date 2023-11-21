<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/shared.xsl"/>


    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:title[@type='main'][1]/text()"/>
        </xsl:variable>


    
        <html class="h-100">
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column h-100">
            <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="container-md">                        
                        <h1 class="display-3 text-center">
                            <xsl:value-of select="$doc_title"/>
                        </h1>    
                        <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>
                        <p style="text-align:center;">
                            <xsl:for-each select=".//tei:note">
                                <div class="footnotes">
                                    <xsl:attribute name="id">
                                        <xsl:text>fn</xsl:text>
                                        <xsl:number level="any" format="1"
                                            count="tei:note"/>
                                    </xsl:attribute>
                                    <xsl:element name="a">
                                        <xsl:attribute name="name">
                                          <xsl:text>fn</xsl:text>
                                          <xsl:number level="any" format="1"
                                              count="tei:note"/>
                                        </xsl:attribute>
                                    </xsl:element>
                                    <a>
                                        <xsl:attribute name="href">
                                        <xsl:text>#fna_</xsl:text>
                                        <xsl:number level="any" format="1"
                                            count="tei:note"/>
                                        </xsl:attribute>
                                        <span
                                            style="font-size:7pt;vertical-align:super; margin-right: 0.4em">
                                        <xsl:number level="any" format="1"
                                            count="tei:note"/>
                                        </span>
                                    </a>
                                    <xsl:for-each select="./tei:p">
                                        <xsl:apply-templates />
                                    </xsl:for-each>
                                </div>
                            </xsl:for-each>
                        </p>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

 <!--   <xsl:template match="tei:graphic" name="img">
        <img src="{'img/'||tokenize(data(@url), '/')[last()]}" class="pb-1"/>
    </xsl:template>-->
    
    <xsl:template match="tei:figure">
        <xsl:variable name="imgurl">
            <xsl:value-of select="./tei:graphic/@url"/>
        </xsl:variable>
        <img class="pb-1">
            <xsl:attribute name="src">
                <xsl:value-of select="'img/'||tokenize(data($imgurl), '/')[last()]"/>
            </xsl:attribute>
        </img>
        <xsl:if test=".//tei:desc">
            <figcaption><xsl:apply-templates select=".//tei:desc"/></figcaption>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend]">
        <xsl:choose>
            <xsl:when test="data(@rend) eq 'italic bold'">
                <em><bold><xsl:apply-templates/></bold></em>
            </xsl:when>
            <xsl:when test="data(@rend) eq 'bold'">
                <strong><xsl:apply-templates></xsl:apply-templates></strong>
            </xsl:when>
            <xsl:when test="data(@rend) eq 'italic'">
                <em><xsl:apply-templates></xsl:apply-templates></em>
            </xsl:when>
            <xsl:when test="data(@rend) eq 'underline'">
                <u><xsl:apply-templates></xsl:apply-templates></u>
            </xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
        
       
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul><xsl:apply-templates/></ul>
    </xsl:template>

    <xsl:template match="tei:item">
        <li><xsl:apply-templates/></li>
    </xsl:template>
   
    <xsl:template match="tei:head">
        <xsl:variable name="level">
            <xsl:value-of select="count(ancestor-or-self::tei:div)"/>
        </xsl:variable>
        <xsl:element name="{concat('h', $level + 1)}">
            <xsl:attribute name="class">
                <xsl:value-of select="concat('text-center display-', $level + 4)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
   
   
    <xsl:template match="tei:p">
        <p id="{generate-id()}">
            <xsl:if test="@ana">
                <xsl:attribute name="class">
                    <xsl:value-of select="@ana" disable-output-escaping="yes"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{generate-id()}"><xsl:apply-templates/></div>
    </xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <abbr title="unclear"><xsl:apply-templates/></abbr>
    </xsl:template>
    <xsl:template match="tei:del">
        <del><xsl:apply-templates/></del>
    </xsl:template>
    <xsl:template match="tei:ref">
        <a>
            <xsl:if test="@target">
                <xsl:attribute name="href">
                    <xsl:value-of select="@target"/>
                </xsl:attribute>
                <xsl:attribute name="style">
                    text-decoration: underline;
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </a>
    </xsl:template>
    
    
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:text>table table-bordered table-striped table-condensed table-hover</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>