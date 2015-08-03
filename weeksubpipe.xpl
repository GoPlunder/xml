<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:px="http://www.example.org" version="1.0" name="getWeek">
    
    <!-- Bind on input the sampleCalendarX.xml file to be queried with getforWeek.xquery  -->
    <p:input port="source">
        <p:document href="xmldb:///db/apps/CalendarX/sampleCalendarX.xml"/>
    </p:input>
    <p:input port="parameters" kind="parameter"/>
    
    <!-- Declare the output port. -->
    <p:output port="result" sequence="true">
        <p:pipe port="result" step="transform"/>
    </p:output>   
    
    <!-- query -->
    <p:xquery name="getEv">
        <p:input port="source"/>
        <p:input port="query">
            <p:data href="xmldb:///db/apps/CalendarX/getforWeek.xquery" content-type="application/xquery"/>
        </p:input>
    </p:xquery>
    <!-- store the intermediate result to be transformed with wochensicht.xsl -->
    <p:store href="xmldb:///db/apps/CalendarX/weekEvents.xml"/>    
    
    <!-- Apply transformation. -->
    <p:xslt name="transform">
        <p:input port="source">
            <p:pipe port="result" step="getEv"/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="xmldb:///db/apps/CalendarX/wochensicht.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    <!-- store the html file that will show in browser by selecting it as output option in Transformation scenario -->
    <p:store href="xmldb:///db/apps/CalendarX/weekEvents.html"/>
</p:declare-step>