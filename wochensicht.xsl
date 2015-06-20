<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:functx="http://www.functx.com">

    <!-- Stylesheets -->
    <xsl:include href="tagessicht.xsl"/>
    <xsl:include href="functX.xsl"/>

    <!-- Globale Variablen -->
    <xsl:variable name="aktuellesDatum" as="xs:date" select="document('aktuellesDatum.xml')/datum"/>
    <xsl:variable name="datumWochenTag" select="functx:day-of-week($aktuellesDatum)"/>
    <xsl:variable name="datumJahresTag" select="functx:day-in-year($aktuellesDatum)"/>

    <!-- Globale Parameter -->
    <xsl:param name="counter">1</xsl:param>
    <xsl:param name="nummerAktuellerTag"/>
    <xsl:param name="betrachtetesDatum"/>
    <xsl:param name="zaehler"/>


    <xsl:template match="/">
        <svg width="1300" height="1000" xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink">            

            <!-- Hier werden die Templates aufgerufen -->
            <xsl:call-template name="tagessicht"/>
            <xsl:call-template name="spaltenWochentage"/>
            <xsl:call-template name="fuelleWoche"/>
            <xsl:call-template name="schreibeWochenTage"/>

        </svg>
    </xsl:template>



    <!-- Schreibe für jeden Wochentag eine Spalte -->
    <xsl:template name="spaltenWochentage">

        <svg width="1300" height="1000" xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink">
            
            <defs>
                <!-- Linie vertikal-->
                <line x1="100" y1="50" x2="100" y2="800" stroke-width="2" stroke="grey" id="li2"/>
            </defs>
            
            
            <!-- Zeichne vertikale Linien neben die Uhrzeiten und Wochentage -->
            <use xlink:href="#li2"/>
            <use xlink:href="#li2" x="150"/>
            <use xlink:href="#li2" x="300"/>
            <use xlink:href="#li2" x="450"/>
            <use xlink:href="#li2" x="600"/>
            <use xlink:href="#li2" x="750"/>
            <use xlink:href="#li2" x="900"/>
            <use xlink:href="#li2" x="1050"/>
            
            <text x="175" y="75" text-anchor="middle">Montag</text>
            <text x="315" y="75" text-anchor="middle">Dienstag</text>
            <text x="475" y="75" text-anchor="middle">Mittwoch</text>
            <text x="615" y="75" text-anchor="middle">Donnerstag</text>
            <text x="775" y="75" text-anchor="middle">Freitag</text>
            <text x="915" y="75" text-anchor="middle">Samstag</text>
            <text x="1075" y="75" text-anchor="middle">Sonntag</text>
        </svg>
    </xsl:template>


    <!-- Falls vorhanden, fülle die Woche mit den entsprechenden Terminen -->
    <xsl:template name="fuelleWoche">
        <xsl:param name="counter">1</xsl:param>
        <xsl:param name="nummerAktuellerTag">
            <xsl:value-of select="functx:day-of-week($aktuellesDatum)"/>
        </xsl:param>

        <xsl:for-each select="document('events_sortiert.xml')/events/event">

            <xsl:if
                test="datumJahresTag = ($datumJahresTag - $nummerAktuellerTag + $counter) and $nummerAktuellerTag > 0">
                <xsl:variable name="startRechteck" select="80 + (startZeitInMin div 2)"/>
                <xsl:variable name="endeRechteck" select="80 + (endZeitInMin div 2)"/>
                <xsl:variable name="wochenTagNummer" select="datumWochenTag"/>

                <!-- Zeichne ein Rechteck für die Zeitspanne, in der ein Termin stattfindet -->
                <rect x="{105+$wochenTagNummer*150-150}" y="{$startRechteck}" width="140"
                    height="{($endeRechteck)-$startRechteck}" fill="gainsboro"/>
                <!-- Schreibe Startzeit, Endzeit und die Beschreibung in das Rechteck -->
                <text x="{105+$wochenTagNummer*150-150 +15}" y="{$startRechteck+15}">
                    <xsl:value-of select="beschreibung"/>
                </text>
                <text x="{105+$wochenTagNummer*150-150 +15}" y="{$startRechteck+35}"><xsl:value-of
                        select="startZeit"/>-<xsl:value-of select="endZeit"/></text>
            </xsl:if>

        </xsl:for-each>
        <xsl:if test="$counter &lt; 7 and $nummerAktuellerTag > 0">
            <xsl:call-template name="fuelleWoche">
                <xsl:with-param name="counter">
                    <xsl:value-of select="$counter + 1"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <!-- Der Fall, dass der aktuelle Tag ein Sonntag ist muss extra behandelt werden -->
        <xsl:if test="$nummerAktuellerTag = 0">
            <xsl:call-template name="fuelleWoche">
                <xsl:with-param name="nummerAktuellerTag">7</xsl:with-param>
                <xsl:with-param name="counter">
                    <xsl:value-of select="$counter"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Schreibe das Datum über jeden Wochentag -->
    <xsl:template name="schreibeWochenTage">
        <xsl:param name="betrachtetesDatum">
            <xsl:value-of select="$aktuellesDatum"/>
        </xsl:param>
        <xsl:param name="nummerAktuellerTag">
            <xsl:value-of select="functx:day-of-week($aktuellesDatum)"/>
        </xsl:param>
        <xsl:param name="zaehler">0</xsl:param>

        <xsl:choose>

            <!-- Der Sonntag muss extra behandelt werden -->
            <xsl:when test="$nummerAktuellerTag = 0 or $zaehler = 7 - $nummerAktuellerTag">
                <text x="{150*7}" y="50">
                    <xsl:value-of select="$betrachtetesDatum"/>
                </text>
                <xsl:call-template name="schreibeWochenTageVor">
                    <xsl:with-param name="betrachtetesDatum">
                        <xsl:value-of select="functx:previous-day($aktuellesDatum)"/>
                    </xsl:with-param>
                    <xsl:with-param name="nummerAktuellerTag">
                        <xsl:value-of select="7"/>
                    </xsl:with-param>
                    <xsl:with-param name="zaehler">
                        <xsl:value-of select="$zaehler + 1"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>

            <!-- Hier werden alle Tage NACH dem aktuellen Datum beschriftet -->
            <xsl:when test="$nummerAktuellerTag > 0 and $zaehler &lt; 7 - $nummerAktuellerTag">
                <text x="{150*functx:day-of-week($betrachtetesDatum)}" y="50">
                    <xsl:value-of select="$betrachtetesDatum"/>
                </text>
                <xsl:call-template name="schreibeWochenTage">
                    <xsl:with-param name="betrachtetesDatum">
                        <xsl:value-of select="functx:next-day($betrachtetesDatum)"/>
                    </xsl:with-param>
                    <xsl:with-param name="zaehler">
                        <xsl:value-of select="$zaehler + 1"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>

            <!-- Wenn der aktuelle Tag und alle nachfolgenden Tage der Woche beschriftet sind, dann rufe das Template auf, das alle vorherigen Tage beschriftet -->
            <xsl:otherwise>
                <xsl:call-template name="schreibeWochenTageVor">
                    <xsl:with-param name="betrachtetesDatum">
                        <xsl:value-of select="functx:previous-day($aktuellesDatum)"/>
                    </xsl:with-param>
                    <xsl:with-param name="nummerAktuellerTag">
                        <xsl:value-of select="functx:day-of-week($aktuellesDatum)"/>
                    </xsl:with-param>
                    <xsl:with-param name="zaehler">
                        <xsl:value-of select="$zaehler + 1"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template>

    <!-- Hier werden alle Tage VOR dem aktuellen Tag beschriftet -->
    <xsl:template name="schreibeWochenTageVor">
        <xsl:param name="betrachtetesDatum">
            <xsl:value-of select="$aktuellesDatum"/>
        </xsl:param>
        <xsl:param name="nummerAktuellerTag">
            <xsl:value-of select="functx:day-of-week($aktuellesDatum)"/>
        </xsl:param>
        <xsl:param name="zaehler">0</xsl:param>

        <xsl:if
            test="$nummerAktuellerTag > 0 and $zaehler > 7 - $nummerAktuellerTag and $zaehler &lt; 7">
            <text x="{150*functx:day-of-week($betrachtetesDatum)}" y="50">
                <xsl:value-of select="$betrachtetesDatum"/>
            </text>

            <xsl:call-template name="schreibeWochenTageVor">
                <xsl:with-param name="betrachtetesDatum">
                    <xsl:value-of select="functx:previous-day($betrachtetesDatum)"/>
                </xsl:with-param>
                <xsl:with-param name="nummerAktuellerTag">7</xsl:with-param>
                <xsl:with-param name="zaehler">
                    <xsl:value-of select="$zaehler + 1"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

</xsl:stylesheet>
