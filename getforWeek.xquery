xquery version "3.0";
declare namespace fn = "http://www.w3.org/2005/xpath-functions";
declare namespace transform="http://exist-db.org/xquery/transform";
declare namespace p = "http://probe.com";
(:declare option exist:serialize "method=xhtml media-type=text/html indent=yes";:)
import module namespace functx = "functX" at "functX.xquery";
import module namespace local = "isinPat" at "isinPat.xquery";

declare function p:getEvents ($d as xs:date?, $i as xs:integer )  {
    if (($i=0) or ($i=8)) then ()
    else ((p:forDay($d)) | (p:getEvents(functx:next-day ($d), (($i)+1))))
  };
  
declare function p:getEventsForWeek($d, $i) {
    if ($i=1) then ((p:forDay($d)) | (p:getEvents(functx:next-day ($d), (($i)+1))))
    else (p:getEventsForWeek(functx:previous-day($d), (($i)-1)))};

declare function p:forDay ($d){
let $efd := <events>{local:getEventsForDay($d)}</events>
let $eventsforday := if(empty($efd)) then <events date="{$d}"></events> else <events date="{$d}"> {
        for $e in $efd/eventRule return
        element event {
                element datum {$d},
                element datumWochenTag {  if (functx:day-of-week($d) = 0) then 7 else functx:day-of-week($d)},
                element datumJahresTag {functx:day-in-year($d)},
                element startZeit {fn:data($e/@startTime)},
                element startZeitInMin {hours-from-time($e/@startTime) * 60 + minutes-from-time($e/@startTime)},
                element endZeit {fn:data($e/@endTime)},
                element endZeitInMin {hours-from-time($e/@endTime) * 60 + minutes-from-time($e/@endTime)},
                element beschreibung {fn:data($e/@description)},
                element tagZuvor {functx:previous-day($d)},
                element tagDanach {functx:next-day($d)},
                element location {$e/location/text()},
                element attendees {for $a in $e//attendee/text() return <attendee>{$a}</attendee>}
                }
         } </events>
return  $eventsforday
};

let $d := doc('aktuellesDatum.xml')/datum/text()
let $i := if (functx:day-of-week($d) = 0) then 7 else functx:day-of-week($d)
let $efw := <events>{p:getEventsForWeek($d, $i)}</events>
return  $efw