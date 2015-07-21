xquery version "3.0";
declare namespace fn = "http://www.w3.org/2005/xpath-functions";
declare namespace m = "http://month.com";
import module namespace functx = "functX" at "functX.xquery";
import module namespace local = "isinPat" at "isinPat.xquery";

declare function m:getEvents ($d as xs:date?, $i as xs:date, $j as xs:date )  {
    if (($d=functx:previous-day($i)) or ($d=functx:next-day($j))) then ()
    else ((local:forDay($d)) | (m:getEvents(functx:next-day ($d), $i, $j)))
  };
  
declare function m:getEventsForMonth($d, $i, $j) {
    if ($d= $i) then ((local:forDay($d)) | (m:getEvents(functx:next-day ($d), $i, $j)))
    else (m:getEventsForMonth(functx:previous-day($d), $i, $j))
    };


let $d := doc('aktuellesDatum.xml')/datum/text()
let $i := functx:first-day-of-month($d)
let $j := functx:last-day-of-month($d)
let $efm := <events>{m:getEventsForMonth($d, $i, $j)}</events>
return  $efm
