xquery version "1.0";
module namespace local = "isinPat";

declare namespace fn = "http://www.w3.org/2005/xpath-functions";
import module namespace functx = "functX" at "functX.xquery";

  
 declare function local:isDateInPattern ($d as xs:date, $p as xs:string?) as xs:boolean
 {
 ((local:isInDaily($d, $p)) or (local:isInWeekly($d,$p))  or (local:isInUnion($d,$p)) or (local:isInIntersection($d,$p))or (local:isInDifference($d,$p)))
 };
 
 
 
  declare function local:isInDaily ($d as xs:date, $p as xs:string?) as xs:boolean  
 {
  let $dp := doc("sampleCalendarX.xml")//dailyPattern[@description = $p]
  return if (empty($dp)) then false() else (functx:between-inclusive ($d, $dp/@startDate ,$dp/@endDate))
  };

 declare function local:isInWeekly ($d as xs:date, $p as xs:string?) as xs:boolean
{
 let $wp := doc("sampleCalendarX.xml")//weeklyPattern[@description = $p]
 return if (empty($wp)) then false() else (functx:day-of-week-name-en ($d) eq $wp/@dayOfWeek)
 };


declare function local:isInUnion ($d as xs:date, $p as xs:string?) as xs:boolean
{
 let $union := doc("sampleCalendarX.xml")//unionPattern[@description = $p]
 return  if (empty($union)) then false() else ((local:isDateInPattern($d, ($union/firstPattern))) or (local:isDateInPattern($d, ($union//furtherPattern))))
 };


declare function local:isInDifference ($d as xs:date, $p as xs:string?) as xs:boolean
{
 let $differ := doc("sampleCalendarX.xml")//differencePattern[@description = $p]
 return  if (empty($differ)) then false() else ((local:isDateInPattern($d, fn:data($differ/firstPattern))) and fn:not(local:isDateInPattern($d, fn:data($differ//furtherPattern))))
 };
 
 declare function local:isInIntersection ($d as xs:date, $p as xs:string?) as xs:boolean
{
 let $intersec := doc("sampleCalendarX.xml")//intersectionPattern[@description = $p]
 return  if (empty($intersec)) then false() else ((local:isDateInPattern($d, ($intersec/firstPattern))) and (local:isDateInPattern($d, ($intersec//furtherPattern))))
 };
 

declare function local:getEventsForDay ($d as xs:date?)  {
  for $event in doc("sampleCalendarX.xml")//eventRule
  let $pattern:=$event/recurrencePattern
  let $evsfDay := if(local:isDateInPattern($d,$pattern))then $event else ()
  order by($evsfDay/@startTime)
  return if (empty($evsfDay)) then () else $evsfDay
  };
  
 declare function local:forDay ($d){
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
