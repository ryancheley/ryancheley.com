<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
    <!-- Match the root element -->
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    RSS Feed | <xsl:value-of select="/atom:feed/atom:title"/>
                </title>
                <link rel="stylesheet" href="/theme/css/clean-blog.css"/>
            </head>
            <body>
                <h1>Recent blog posts</h1>
                    <xsl:for-each select="/atom:feed/atom:entry">
                        <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="atom:link/@href"/>
                        </xsl:attribute>
                        <xsl:value-of select="atom:title"/>
                        </a>
                        Last updated:
                        <xsl:value-of select="substring(atom:updated, 0, 11)" />
                    </xsl:for-each>
            </body>
        </html>
    </xsl:template>

    <!-- Match atom:category elements -->
    <xsl:template match="atom:category">
        <li><xsl:value-of select="@term"/></li>
    </xsl:template>

</xsl:stylesheet>
