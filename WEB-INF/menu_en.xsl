<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
        <xsl:variable name="context" select="menu_list/menu_rendering/context"/>
        <ul id="Main_Menu1" class="MM" style="margin: 0px;padding: 0px;">
            <xsl:for-each select="menu_list/menu">
                <xsl:if test="display = 1">
                    <li style="white-space: nowrap;">
                        <xsl:variable name="target" select="target"/>
                        <xsl:variable name="sora" select="sora"/>
                        <a href="#" style="min-width:80px;white-space: nowrap;">
                            <img alt=""  SRC="images/arrow_down_white.png" width="16" height="10" align="top" style="margin-top: 3px"/>
                        
                            <xsl:apply-templates select="nameEn"/>  
                        
                        </a>
                        <xsl:if test="sub_menu">
                            <ul>
                                <xsl:for-each select="sub_menu">
                                    <xsl:variable name="target" select="target"/>
                                    <xsl:if test="display = 1">
                                        <li style="white-space: nowrap;">
                                            <a href="{$context}{$target}" style="min-width:150px;white-space: nowrap; padding-left: 12px; display: block;">
                                                <img alt="" src="images/{$sora}" width="16" height="16" align="top" style="margin-top: 3px"/>
                                            
                                                <xsl:apply-templates select="titleEn"/>  
                                            
                                            </a>
                                            <xsl:if test="menu_element">
                                                <ul>
                                                    <xsl:for-each select="menu_element">
                                                        <xsl:variable name="target" select="target"/>
                                                        <xsl:if test="display = 1">
                                                            <li style="white-space: nowrap;">
                                                                <a href="{$context}{$target}" style="white-space: nowrap;">
                                                                    <img alt="" src="images/{$sora}" width="16" height="16" align="top" style="margin-top: 3px"/>
                                                            
                                                                    <xsl:apply-templates select="nameEn"/>  
                                                            
                                                                </a>
                                                            </li>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </ul>
                                            </xsl:if>
                                        </li>
                                    </xsl:if>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                    </li>
                </xsl:if>
            </xsl:for-each>
        </ul>
    </xsl:template>
</xsl:stylesheet>
