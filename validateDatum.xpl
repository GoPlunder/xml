<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:px="http://www.example.org" version="1.0" name="getDate">
    <p:input port="source">
        <p:document href="aktuellesDatum.xml"/>
    </p:input>
    <p:output port="result">
        <p:pipe port="result" step="valDate"/>
    </p:output>
    <p:xquery name="saveDate">
        <p:input port="source"/>
        <p:with-param name="date" select="//text()"/>
        <p:input port="query">
            <p:data href="changeDatum.xquery" content-type="application/xquery"/>
        </p:input>
    </p:xquery>
    <p:validate-with-xml-schema name="valDate">
        <p:input port="schema">
            <p:document href="aktuellesDatum.xsd"/>
        </p:input>
    </p:validate-with-xml-schema>
</p:declare-step>