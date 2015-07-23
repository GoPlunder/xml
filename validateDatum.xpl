<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:px="http://www.example.org"
    version="1.0" name="getDate">
    
    <p:input  port="source" >
        <p:document href="aktuellesDatum.xml"></p:document>    
    </p:input>
    
    <p:output port="result">
        <p:pipe port="result" step="valCal"></p:pipe>
    </p:output> 
    
    <p:validate-with-xml-schema name="valCal"> 
        <p:input port="schema">
            <p:document href="aktuellesDatum.xsd"></p:document>   
        </p:input> 
    </p:validate-with-xml-schema> 
</p:declare-step>