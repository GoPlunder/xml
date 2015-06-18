<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
    <!-- erzeugt eine Zwischendatei mit den für die Sicht relevanten Elementen, sortiert nach Datum und Anfangszeit -->


    <xsl:template match="/">
        
            <html>
                <body>                  
                    <xsl:result-document href="events_sortiert.xml" method="xml">
                    <events>
                        <xsl:for-each select="events/event">
                        <xsl:sort select="@date"/>
                        <xsl:sort select="@startTime"/>
                        <event>
                            <datum>
                                <xsl:value-of select="@date"/>
                            </datum>
                            <startZeit>
                                <xsl:value-of select="@startTime"/>
                            </startZeit>
                            <startZeitInMin>
                                <xsl:value-of select="hours-from-time(@startTime)*60 + minutes-from-time(@startTime)"/>
                            </startZeitInMin>
                            <endZeit>
                                <xsl:value-of select="@endTime"/>
                            </endZeit>
                            <endZeitInMin>
                                <xsl:value-of select="hours-from-time(@endTime)*60 + minutes-from-time(@endTime)"/>
                            </endZeitInMin>
                            <beschreibung>
                                <xsl:value-of select="@description"/>
                            </beschreibung>
                            <kategorie>
                                <xsl:value-of select="@categories"/>
                            </kategorie>
                        </event>
                    </xsl:for-each>   
                    </events>
                    </xsl:result-document>
                </body>
            </html>
        
    </xsl:template>
</xsl:stylesheet>
