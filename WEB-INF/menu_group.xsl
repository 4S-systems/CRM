<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html"/>
    <xsl:template match="/">
        <xsl:variable name="context" select="menu_list/menu_rendering/context"/>
            <xsl:for-each select="menu_list/menu">
                <xsl:variable name="i" select="position() - 1"/>
                <xsl:variable name="id" select="@id"/>
                <tr>
                    <td class="act_sub_heading" WIDTH="100" STYLE="text-align: right;padding-right:20;">
                        <xsl:apply-templates select="nameAr"/>
                    </td>
                    <td class="act_sub_heading">
                        <input class="menuCheck{$i}" type="checkbox" name="{$id}" value ="{$i}" id="menuCheck{$i}"
                               onclick="checkAllSub('{$i}',this);"/>
                    </td>
                </tr>
                <xsl:if test="sub_menu">
                    <xsl:for-each select="sub_menu">
                        <xsl:variable name="j" select="position() - 1"/>
                        <xsl:variable name="id" select="@id"/>
                        <xsl:if test="menu_element">
                            <tr>
                                <td class="act_sub_heading" WIDTH="100" STYLE="text-align: right; padding-right:40;">
                                    <xsl:apply-templates select="titleAr"/>
                                </td>
                                <td class="act_sub_heading" style="text-align:center;">
                                    <input class="mainMenu{$i}" type="checkbox" name="{$id}" value ="{$j}" id="mainMenu{$i}_{$j}"
                                           onclick="checkAllElement('{$i}','{$j}',this); getCheckedSubParent('{$i}',this);"/>
                                </td>
                            </tr>
                            <xsl:for-each select="menu_element">
                                <xsl:variable name="k" select="position() - 1"/>
                                <xsl:variable name="id" select="@id"/>
                                <tr>
                                    <td  class="cell" STYLE="text-align:right; padding-right:60;">
                                        <div id="links">
                                            <xsl:apply-templates select="nameAr"/>
                                        </div>
                                    </td>
                                    <td class="cell" style="text-align:center;">
                                        <input class="mainMenu{$i}_{$j}" type="checkbox" name="{$id}" value ="{$k}" id="mainMenu{$i}_{$j}_{$k}" onclick="getChecked('{$i}','{$j}',this);"/>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="not(menu_element)">
                            <tr>
                                <td class="cell" WIDTH="100" STYLE="text-align: right; padding-right:40;">
                                    <xsl:apply-templates select="titleAr"/>
                                </td>
                                <td class="cell" style="text-align:center;">
                                    <input class="mainMenu{$i}" type="checkbox" name="{$id}" value ="{$j}" id="mainMenu{$i}_{$j}" onclick="getCheckedSubParent('{$i}',this);"/>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
