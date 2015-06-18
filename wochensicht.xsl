<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- Beinhaltet das unten aufgerufene Template tagessicht -->
    <xsl:include href="tagessicht.xsl"/>

    <!-- Globale Variablen -->
    <xsl:variable name="aktuellesDatum" as="xs:date" select="document('aktuellesDatum.xml')/datum"/>
    <xsl:variable name="datumWochenTag" select="document('events_sortiert.xml')/events/event[datum = $aktuellesDatum]/datumWochenTag"/>
    <xsl:variable name="datumJahresTag" select="document('events_sortiert.xml')/events/event[datum = $aktuellesDatum]/datumJahresTag"/>

    <xsl:template name="wochentage">
        <svg width="1300" height="1000" xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink">
            <!-- Schreibe die Wochentage zwischen die vertikalen Linien -->
            <text x="175" y="75" text-anchor="middle">Montag</text>
            <text x="315" y="75" text-anchor="middle">Dienstag</text>
            <text x="475" y="75" text-anchor="middle">Mittwoch</text>
            <text x="615" y="75" text-anchor="middle">Donnerstag</text>
            <text x="775" y="75" text-anchor="middle">Freitag</text>
            <text x="915" y="75" text-anchor="middle">Samstag</text>
            <text x="1075" y="75" text-anchor="middle">Sonntag</text>
        </svg>
    </xsl:template>

    <xsl:template match="/">

        <svg width="1300" height="1000" xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink">
            <defs>
                <!-- Linie vertikal-->
                <line x1="100" y1="50" x2="100" y2="800" stroke-width="2" stroke="grey" id="li2"/>
            </defs>

            <!-- Hier werden die Templates aufgerufen -->
            <xsl:call-template name="tagessicht"/>
            <xsl:call-template name="wochentage"/>

            <!-- Zeichne vertikale Linien neben die Uhrzeiten und Wochentage -->
            <use xlink:href="#li2"/>
            <use xlink:href="#li2" x="150"/>
            <use xlink:href="#li2" x="300"/>
            <use xlink:href="#li2" x="450"/>
            <use xlink:href="#li2" x="600"/>
            <use xlink:href="#li2" x="750"/>
            <use xlink:href="#li2" x="900"/>
            <use xlink:href="#li2" x="1050"/>
            
            <!-- Rufe die rekursive Funktion auf -->
            <xsl:call-template name="fuelleWoche"></xsl:call-template>
        </svg>

    </xsl:template>
    
    <xsl:param name="counter">1</xsl:param>
   
    
    <xsl:template name="fuelleWoche">
         <xsl:param name="counter">1</xsl:param>
         <xsl:for-each select="document('events_sortiert.xml')/events/event[datumJahresTag = $datumJahresTag -$datumWochenTag +$counter]">
             
             <xsl:variable name="startRechteck" select="80 + (startZeitInMin div 2)"/>
             <xsl:variable name="endeRechteck" select="80 + (endZeitInMin div 2)"/>
             
             <!-- Zeichne ein Rechteck für die Zeitspanne, in der ein Termin stattfindet -->
             <rect x="{105+datumWochenTag*150-150}" y="{$startRechteck}" width="140"
                 height="{($endeRechteck)-$startRechteck}" fill="gainsboro"/>
             <!-- Schreibe Startzeit, Endzeit und die Beschreibung in das Rechteck -->
           
        </xsl:for-each>
        <xsl:if test="$counter &lt; 8">
            <xsl:call-template name="fuelleWoche">
                <xsl:with-param name="counter"><xsl:value-of select="$counter+1"/></xsl:with-param>
            </xsl:call-template>   
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
