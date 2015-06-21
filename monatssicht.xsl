<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:functx="http://www.functx.com">

    <!-- Stylesheets -->
    <xsl:include href="wochensicht.xsl"/>

    <!-- Parameter -->
    <xsl:param name="count" as="xs:integer"/>
    <xsl:param name="wochentag"/>


    <xsl:template match="/">
        <svg width="1300" height="1000" xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink">

            <!-- Hier werden die Templates aufgerufen -->
            <xsl:call-template name="spaltenWochentage"/>
            <xsl:call-template name="zeilenMonat"/>
            <xsl:call-template name="schreibeKW"/>
            <xsl:call-template name="monatsTage"/>

        </svg>
    </xsl:template>


    <xsl:template name="zeilenMonat">
        <!-- Ein Monat kann maximal aus 6 angefangenen Wochen bestehen -->
        <svg width="1300" height="1000" xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink">

            <defs>
                <!-- Linie horizontal-->
                <line x1="50" y1="50" x2="1150" y2="50" stroke-width="2" stroke="grey" id="li"/>
            </defs>

            <!-- Zeichne die oben definierte Linie 6 mal mit Abstand 110 -->
            <use xlink:href="#li" y="30"/>
            <use xlink:href="#li" y="140"/>
            <use xlink:href="#li" y="250"/>
            <use xlink:href="#li" y="360"/>
            <use xlink:href="#li" y="470"/>
            <use xlink:href="#li" y="580"/>
            <use xlink:href="#li" y="690"/>

        </svg>

    </xsl:template>



    <xsl:template name="schreibeKW">
        <svg width="1300" height="1000" xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink">

            <!-- Schreibe bestimmte KW auf jede Linie -->
            <text x="55" y="100">KW _</text>
            <text x="55" y="210">KW _</text>
            <text x="55" y="320">KW _</text>
            <text x="55" y="430">KW _</text>
            <text x="55" y="540">KW _</text>
            <text x="55" y="650">KW _</text>


            <text x="250" y="300">
                <xsl:value-of
                    select="functx:first-day-of-month($aktuellesDatum) + functx:dayTimeDuration(1, 0, 0, 0)"
                />
            </text>

        </svg>

    </xsl:template>


    <!-- Füllt die Tage eines Monats mit den entsprechenden Daten -->
    <xsl:template name="monatsTage">
        <xsl:param name="count" as="xs:integer">0</xsl:param>
        <xsl:param name="wochentag">
            <xsl:value-of select="functx:first-day-of-month($aktuellesDatum)"/>
        </xsl:param>
        <xsl:param name="tageProMonat">
            <xsl:value-of select="functx:days-in-month($aktuellesDatum)"/>
        </xsl:param>

        <xsl:if test="functx:day-of-week($wochentag) = 0 and $count &lt; $tageProMonat">
            <text x="{150*7}" y="{100+110*floor($count div 7)}">
                <xsl:value-of select="$wochentag"/>
            </text>

            <xsl:call-template name="monatsTage">
                <xsl:with-param name="count">
                    <xsl:value-of select="$count + 1"/>
                </xsl:with-param>
                <xsl:with-param name="wochentag">
                    <xsl:value-of select="functx:next-day($wochentag)"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>


        <xsl:if test="functx:day-of-week($wochentag) > 0 and $count &lt; $tageProMonat">

            <text x="{150*functx:day-of-week($wochentag)}"
                y="{100+110*floor((7-(functx:day-of-week($wochentag))+$count) div 7)}">
                <xsl:value-of select="$wochentag"/>
            </text>

            <xsl:call-template name="monatsTage">
                <xsl:with-param name="count">
                    <xsl:value-of select="$count + 1"/>
                </xsl:with-param>
                <xsl:with-param name="wochentag">
                    <xsl:value-of select="functx:next-day($wochentag)"/>
                </xsl:with-param>
            </xsl:call-template>

        </xsl:if>

    </xsl:template>



</xsl:stylesheet>
