<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:functx="http://www.functx.com">
    <!-- erzeugt eine Zwischendatei mit den für die Sicht relevanten Elementen, sortiert nach Datum und Anfangszeit -->

    <xsl:include href="tagessicht.xsl"/>
    <xsl:include href="functX.xsl"/>


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
                                <datumWochenTag>
                                    <xsl:choose>
                                        <xsl:when test="functx:day-of-week(@date) = 0">7</xsl:when>
                                        <xsl:otherwise><xsl:value-of select="functx:day-of-week(@date)"/></xsl:otherwise>
                                    </xsl:choose>


                                </datumWochenTag>
                                <datumJahresTag>
                                    <xsl:value-of select="functx:day-in-year(@date)"/>
                                </datumJahresTag>
                                <startZeit>
                                    <xsl:value-of select="@startTime"/>
                                </startZeit>
                                <startZeitInMin>
                                    <xsl:value-of
                                        select="hours-from-time(@startTime) * 60 + minutes-from-time(@startTime)"
                                    />
                                </startZeitInMin>
                                <endZeit>
                                    <xsl:value-of select="@endTime"/>
                                </endZeit>
                                <endZeitInMin>
                                    <xsl:value-of
                                        select="hours-from-time(@endTime) * 60 + minutes-from-time(@endTime)"
                                    />
                                </endZeitInMin>
                                <beschreibung>
                                    <xsl:value-of select="@description"/>
                                </beschreibung>
                                <tagZuvor>
                                    <xsl:value-of select="functx:previous-day(@date)"/>
                                </tagZuvor>
                                <tagDanach>
                                    <xsl:value-of select="functx:next-day(@date)"/>
                                </tagDanach>
                            </event>
                        </xsl:for-each>
                    </events>
                </xsl:result-document>
            </body>
        </html>

    </xsl:template>
</xsl:stylesheet>
