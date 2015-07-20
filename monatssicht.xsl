<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:functx="http://www.functx.com"
    xmlns:fn="http://www.w3.org/2005/xpath-functions">

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
            <xsl:call-template name="monatsTage"/>
            <xsl:call-template name="berechneKW">
                <xsl:with-param name="nrErsterTagWoche">
                    <xsl:value-of
                        select="functx:day-of-week(functx:first-day-of-year($aktuellesDatum))"/>
                </xsl:with-param>
                <xsl:with-param name="nrBetrachteterTagWoche">
                    <xsl:value-of
                        select="functx:day-of-week(functx:first-day-of-month($aktuellesDatum))"/>
                </xsl:with-param>
                <xsl:with-param name="nrBetrachteterTagJahr">
                    <xsl:value-of
                        select="functx:day-in-year(functx:first-day-of-month($aktuellesDatum))"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="fuelleMonat"/>

            <text x="55" y="75">KW</text>

            <text x="600" y="25" text-anchor="middle" font-size="20" fill="red">
                <xsl:value-of select="fn:concat(functx:month-name-en($aktuellesDatum),' ',  fn:year-from-date($aktuellesDatum))"/>
            </text>

        </svg>
    </xsl:template>

    <xsl:template name="fuelleMonat">

        <xsl:param name="count" as="xs:integer">0</xsl:param>
        <xsl:param name="wochentag">
            <xsl:value-of select="functx:first-day-of-month($aktuellesDatum)"/>
        </xsl:param>
        <xsl:param name="tageProMonat">
            <xsl:value-of select="functx:days-in-month($aktuellesDatum)"/>
        </xsl:param>

        <xsl:for-each select="document('monthEvents.xml')/events/events/event">
            
            <xsl:if
                test="datum = $wochentag and functx:day-of-week($wochentag) = 0 and $count &lt; $tageProMonat">
                <rect x="{150*7-40}" y="{120+110*floor($count div 7)}" width="130" height="25"
                    fill="gainsboro"/>
                <text x="{150*7-40}" y="{120+110*floor($count div 7)+15}"><xsl:value-of select="beschreibung"/></text>
                
            </xsl:if>

            <xsl:if
                test="datum = $wochentag and $count &lt; $tageProMonat and functx:day-of-week($wochentag) > 0">
                <rect x="{150*functx:day-of-week($wochentag)-40}"
                    y="{120+110*floor((7-(functx:day-of-week($wochentag))+$count) div 7)}"
                    width="130" height="25" fill="gainsboro"/>
                <text x="{150*functx:day-of-week($wochentag)-40}" y="{120+110*floor((7-(functx:day-of-week($wochentag))+$count) div 7)+15}"><xsl:value-of select="beschreibung"/></text>
            </xsl:if>
                   
        </xsl:for-each>

        <xsl:if test="$count &lt; $tageProMonat">
            <xsl:call-template name="fuelleMonat">
                <xsl:with-param name="count">
                    <xsl:value-of select="$count + 1"/>
                </xsl:with-param>
                <xsl:with-param name="wochentag">
                    <xsl:value-of select="functx:next-day($wochentag)"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

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
            <text x="{150*7-40}" y="{100+110*floor($count div 7)}">
                <xsl:value-of select="format-date($wochentag, '[D01]')"/>
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

            <text x="{150*functx:day-of-week($wochentag)-40}"
                y="{100+110*floor((7-(functx:day-of-week($wochentag))+$count) div 7)}">
                <xsl:value-of select="format-date($wochentag, '[D01]')"/>
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

    <xsl:param name="nrBetrachteterTagJahr">
        <xsl:value-of select="functx:day-in-year(functx:first-day-of-month($aktuellesDatum))"/>
    </xsl:param>
    <xsl:param name="nrBetrachteterTagWoche">
        <xsl:value-of select="functx:day-of-week(functx:first-day-of-month($aktuellesDatum))"/>
    </xsl:param>
    <xsl:param name="nrErsterTagWoche">
        <xsl:value-of select="functx:day-of-week(functx:first-day-of-year($aktuellesDatum))"/>
    </xsl:param>

    <xsl:template name="berechneKW">
        <xsl:param name="nrBetrachteterTagJahr">
            <xsl:value-of select="functx:day-in-year(functx:first-day-of-month($aktuellesDatum))"/>
        </xsl:param>
        <xsl:param name="nrBetrachteterTagWoche">
            <xsl:value-of select="functx:day-of-week(functx:first-day-of-month($aktuellesDatum))"/>
        </xsl:param>
        <xsl:param name="nrErsterTagWoche">
            <xsl:value-of select="functx:day-of-week(functx:first-day-of-year($aktuellesDatum))"/>
        </xsl:param>

        <xsl:if test="$nrBetrachteterTagWoche = 0 and $nrErsterTagWoche > 0">
            <xsl:call-template name="berechneKW">
                <xsl:with-param name="nrBetrachteterTagWoche">7</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$nrErsterTagWoche = 0 and $nrBetrachteterTagWoche > 0">
            <xsl:call-template name="berechneKW">
                <xsl:with-param name="nrErsterTagWoche">7</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$nrErsterTagWoche = 0 and $nrBetrachteterTagWoche = 0">
            <xsl:call-template name="berechneKW">
                <xsl:with-param name="nrErsterTagWoche">7</xsl:with-param>
                <xsl:with-param name="nrBetrachteterTagWoche">7</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="$nrBetrachteterTagWoche > 0 and $nrErsterTagWoche > 0">
            <xsl:variable name="kalenderWoche">
                <xsl:value-of
                    select="floor(($nrBetrachteterTagJahr + 1 + (7 - $nrBetrachteterTagWoche) - (7 - $nrErsterTagWoche)) div 7) + 1"
                />
            </xsl:variable>

            <text x="55" y="100">
                <xsl:value-of select="$kalenderWoche"/>
            </text>
            <text x="55" y="210">
                <xsl:value-of select="$kalenderWoche + 1"/>
            </text>
            <text x="55" y="320">
                <xsl:value-of select="$kalenderWoche + 2"/>
            </text>
            <text x="55" y="430">
                <xsl:value-of select="$kalenderWoche + 3"/>
            </text>
            <text x="55" y="540">
                <xsl:value-of select="$kalenderWoche + 4"/>
            </text>
            <text x="55" y="650">
                <xsl:value-of select="$kalenderWoche + 5"/>
            </text>

        </xsl:if>

    </xsl:template>

</xsl:stylesheet>
