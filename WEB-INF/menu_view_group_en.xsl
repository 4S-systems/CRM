<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
        <xsl:variable name="context" select="menu_list/menu_rendering/context"/>
        <xsl:for-each select="menu_list/menu">
            <xsl:variable name="i" select="position() - 1"/>
            <xsl:variable name="id" select="@id"/>
            <tr>
                <td class="act_sub_heading" WIDTH="100" STYLE="text-align: left;padding-left:20;">
                    <xsl:apply-templates select="nameEn"/>
                </td>
                <td class="act_sub_heading">
                    <xsl:if test="display = 1">
                        <input type="checkbox" disabled="true" checked="true"/>
                    </xsl:if>
                    <xsl:if test="display = 0">
                        <input type="checkbox" disabled="true"/>
                    </xsl:if>
                </td>
            </tr>
            <xsl:if test="sub_menu">
                <xsl:for-each select="sub_menu">
                    <xsl:variable name="j" select="position() - 1"/>
                    <xsl:variable name="id" select="@id"/>
                    <xsl:if test="menu_element">
                        <tr>
                            <td class="act_sub_heading" WIDTH="100" STYLE="text-align: left; padding-left:40;">
                                <xsl:apply-templates select="titleEn"/>
                            </td>
                            <td  class="act_sub_heading" style="text-align:center;">
                                <xsl:if test="display = 1">
                                    <input type="checkbox" disabled="true" checked="true"/>
                                </xsl:if>
                                <xsl:if test="display = 0">
                                    <input type="checkbox" disabled="true"/>
                                </xsl:if>
                            </td>
                        </tr>
                        <xsl:for-each select="menu_element">
                            <xsl:variable name="k" select="position() - 1"/>
                            <xsl:variable name="id" select="@id"/>
                            <tr>
                                <td class="cell" STYLE="text-align:left; padding-left:60;">
                                    <div id="links">
                                        <xsl:apply-templates select="nameEn"/>
                                    </div>
                                </td>
                                <td class="cell" style="text-align:center;">
                                <xsl:if test="display = 1">
                                    <input type="checkbox" disabled="true" checked="true"/>
                                </xsl:if>
                                <xsl:if test="display = 0">
                                    <input type="checkbox" disabled="true"/>
                                </xsl:if>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="not(menu_element)">
                        <tr>
                            <td class="cell" WIDTH="100" STYLE="text-align: left; padding-left:40;">
                                <xsl:apply-templates select="titleEn"/>
                            </td>
                            <td class="cell" style="text-align:center;">
                                <xsl:if test="display = 1">
                                    <input type="checkbox" disabled="true" checked="true"/>
                                </xsl:if>
                                <xsl:if test="display = 0">
                                    <input type="checkbox" disabled="true" onclick="checkAll();"/>
                                </xsl:if>
                                
                            </td>
                        </tr>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
