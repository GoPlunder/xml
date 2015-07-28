xquery version "1.0";
declare namespace fn = "http://www.w3.org/2005/xpath-functions";
declare namespace w = "http://week.com";
import module namespace functx = "functX" at "functX.xquery";
import module namespace local = "isinPat" at "isinPat.xquery";

declare function w:getEvents ($d as xs:date?, $i as xs:integer )  {
    if (($i=0) or ($i=8)) then ()
    else ((local:forDay($d)) | (w:getEvents(functx:next-day ($d), (($i)+1))))
  };
  
declare function w:getEventsForWeek($d, $i) {
    if ($i=1) then ((local:forDay($d)) | (w:getEvents(functx:next-day ($d), (($i)+1))))
    else (w:getEventsForWeek(functx:previous-day($d), (($i)-1)))};


let $d := doc('aktuellesDatum.xml')/datum/text()
let $i := if (functx:day-of-week($d) = 0) then 7 else functx:day-of-week($d)
let $efw := <events>{w:getEventsForWeek($d, $i)}</events>
return  $efw