<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:functx="http://www.functx.com"
    xmlns="http://www.w3.org/1999/xhtml">
  
<!--xsl:import href="functions.xquery"/-->  

    <xsl:template match="/">
        <svg  height="200%" width="100%">
            
            <!-- Hier wird das oben definierte Template "tagessicht" aufgerufen -->
            <xsl:call-template name="tagessicht"/>
            
            <!-- Globale Variablen -->
            <xsl:variable name="aktuellesDatum" as="xs:date"
                select="document('aktuellesDatum.xml')/datum"/>
            
            <!-- Schreibe das Datum des Tages in die obere Mitte der Seite (festgelegt in aktuellesDatum.xml) -->
            <text x="600" y="25" text-anchor="middle" font-size="20" fill="red">
                <xsl:value-of select="$aktuellesDatum"/>
            </text>
            
            <!-- Falls vorhanden, trage die Termine für den Tag in das Template ein -->
            <xsl:for-each
                select="document('dayEvents.xml')/events/event[datum = $aktuellesDatum]">
                
                <xsl:variable name="startRechteck" select="80 + (startZeitInMin div 2)"/>
                <xsl:variable name="endeRechteck" select="80 + (endZeitInMin div 2)"/>
                
                <!-- Zeichne ein Rechteck für die Zeitspanne, in der ein Termin stattfindet -->
                <rect x="105" y="{$startRechteck}" width="1040"
                    height="{($endeRechteck)-$startRechteck}" fill="gainsboro"/>
                <!-- Schreibe Startzeit, Endzeit und die Beschreibung in das Rechteck -->
                <text x="115" y="{$startRechteck +15}">
                    <xsl:value-of select="startZeit"/> - <xsl:value-of select="endZeit"/> :
                    <xsl:value-of select="beschreibung"/>
                </text>
            </xsl:for-each>
            
            
            <!--text x= "200" y="200"><xsl:value-of select="local:getEventsForDate(document('aktuellesDatum.xml')/datum"/></text-->
        </svg>
        
    </xsl:template>
    
    
    <xsl:template name="tagessicht">
        <svg width="1300" height="1000" xmlns="http://www.w3.org/2000/svg"
            xmlns:xlink="http://www.w3.org/1999/xlink">
            <!-- Im defs-Container werden die Objekte definiert -->
            <defs>
                <!-- Linie horizontal-->
                <line x1="50" y1="50" x2="1150" y2="50" stroke-width="2" stroke="grey" id="li"/>
                <!-- Linie vertikal-->
                <line x1="100" y1="50" x2="100" y2="800" stroke-width="2" stroke="grey" id="li2"/>
            </defs>
            
            <!-- Zeichne die oben definierte Linie 25 mal mit Abstand 30 -->
            <use xlink:href="#li" y="30"/>
            <use xlink:href="#li" y="60"/>
            <use xlink:href="#li" y="90"/>
            <use xlink:href="#li" y="120"/>
            <use xlink:href="#li" y="150"/>
            <use xlink:href="#li" y="180"/>
            <use xlink:href="#li" y="210"/>
            <use xlink:href="#li" y="240"/>
            <use xlink:href="#li" y="270"/>
            <use xlink:href="#li" y="300"/>
            <use xlink:href="#li" y="330"/>
            <use xlink:href="#li" y="360"/>
            <use xlink:href="#li" y="390"/>
            <use xlink:href="#li" y="420"/>
            <use xlink:href="#li" y="450"/>
            <use xlink:href="#li" y="480"/>
            <use xlink:href="#li" y="510"/>
            <use xlink:href="#li" y="540"/>
            <use xlink:href="#li" y="570"/>
            <use xlink:href="#li" y="600"/>
            <use xlink:href="#li" y="630"/>
            <use xlink:href="#li" y="660"/>
            <use xlink:href="#li" y="690"/>
            <use xlink:href="#li" y="720"/>
            
            
            <!-- Schreibe bestimmte Uhrzeit auf jede Linie -->
                <text x="55" y="100">00:00</text>
                <text x="55" y="130">01:00</text>
                <text x="55" y="160">02:00</text>
                <text x="55" y="190">03:00</text>
                <text x="55" y="220">04:00</text>
                <text x="55" y="250">05:00</text>
                <text x="55" y="280">06:00</text>
                <text x="55" y="310">07:00</text>
                <text x="55" y="340">08:00</text>
                <text x="55" y="370">09:00</text>
                <text x="55" y="400">10:00</text>
                <text x="55" y="430">11:00</text>
                <text x="55" y="460">12:00</text>
                <text x="55" y="490">13:00</text>
                <text x="55" y="520">14:00</text>
                <text x="55" y="550">15:00</text>
                <text x="55" y="580">16:00</text>
                <text x="55" y="610">17:00</text>
                <text x="55" y="640">18:00</text>
                <text x="55" y="670">19:00</text>
                <text x="55" y="700">20:00</text>
                <text x="55" y="730">21:00</text>
                <text x="55" y="760">22:00</text>
                <text x="55" y="790">23:00</text>
            
            
            <!-- Zeichne vertikale Linie neben die Uhrzeiten -->
            <use xlink:href="#li2"/>
        </svg>
    </xsl:template>
</xsl:stylesheet>
