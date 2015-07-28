<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:px="http://www.example.org"
    version="1.0" name="getMonth">
    
    <!-- Bind on input the sampleCalendarX.xml file to be queried with getforMonth.xquery  --> 
    <p:input  port="source" >
        <p:document href="sampleCalendarX.xml"></p:document>    
    </p:input>
    <p:input port="parameters" kind="parameter"/>
    
    <!-- Declare the output port. -->     
    <p:output port="result" sequence="true">
        <p:pipe port="result" step="transform"></p:pipe>
    </p:output>   
    
    <!-- query -->
    <p:xquery name="getEv"> 
        <p:input port="source"/>  
        <p:input port="query">
            <p:data href="getforMonth.xquery" content-type="application/xquery"></p:data>
        </p:input>
    </p:xquery>
    <!-- store the intermediate result to be transformed with monatssicht.xsl -->
    <p:store href="monthEvents.xml"></p:store>    
    
    <!-- Apply transformation. -->
    <p:xslt name="transform">
        <p:input port="source">
            <p:pipe port="result" step="getEv"/>
        </p:input> 
        <p:input port="stylesheet">
            <p:document href="monatssicht.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>
    <!-- store the html file that will show in browser by selecting it as output option in Transformation scenario -->
    <p:store href="monthEvents.html"></p:store>
    
</p:declare-step>
