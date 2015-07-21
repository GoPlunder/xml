xquery version "3.0";

declare namespace fn = "http://www.w3.org/2005/xpath-functions";
import module namespace functx = "functX" at "functX.xquery";
import module namespace local = "isinPat" at "isinPat.xquery";


let $d := doc('aktuellesDatum.xml')/datum/text()
return local:forDay($d)