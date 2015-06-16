<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
<!-- erzeugt eine Zwischendatei mit den für die Sicht relevanten Elementen, sortiert nach Datum und Anfangszeit -->    
    <xsl:template match="/">
        <html>
            <body>
                <h2>My Events</h2>
                <table border="1">
                    <tr>
                        <th>Date</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Description</th>
                        <th>Kategorie</th>
                    </tr>
                    <xsl:for-each select="events/event">
                        <xsl:sort select="@date"/>
                        <xsl:sort select="@startTime"/>
                        <tr>
                            <td><xsl:value-of select="@date"/></td>
                            <td><xsl:value-of select="@startTime"/></td>
                            <td><xsl:value-of select="@endTime"/></td>
                            <td><xsl:value-of select="@description"/></td>
                            <td><xsl:value-of select="@categories"/></td>
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>