xquery version "3.0";

declare namespace functx = "http://www.functx.com";
declare namespace fn = "http://www.w3.org/2005/xpath-functions";
declare namespace local = "http://www.w3.org/2005/xquery-local-functions";

declare function functx:day-of-week
  ( $date as xs:anyAtomicType? )  as xs:integer? {

  if (empty($date))
  then ()
  else xs:integer((xs:date($date) - xs:date('1901-01-06'))
          div xs:dayTimeDuration('P1D')) mod 7
 } ;
declare function functx:day-of-week-name-en
  ( $date as xs:anyAtomicType? )  as xs:string? {

   ('Sunday', 'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday')
      [functx:day-of-week($date) + 1]
 } ;
declare function functx:between-inclusive
  ( $value as xs:anyAtomicType? ,
    $minValue as xs:anyAtomicType ,
    $maxValue as xs:anyAtomicType )  as xs:boolean {

   $value >= $minValue and $value <= $maxValue
 } ;
declare function functx:next-day
  ( $date as xs:anyAtomicType? )  as xs:date? {

   xs:date($date) + xs:dayTimeDuration('P1D')
 } ;
 
 
 
 
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
  for $events in doc("sampleCalendarX.xml")//eventRule
  let $patterns := $events//recurrencePattern
  let $patsfDay := fn:filter ( function($a){if (local:isDateInPattern ($d,$a)) then true() else false()}, $patterns )
  let $evsfDay := $events[//$patterns = $patsfDay]
  order by($evsfDay/@startTime)
  return if (empty($evsfDay)) then () else $evsfDay
  };


let $d := doc('aktuellesDatum.xml')/datum/text()
let $efd := <events>{local:getEventsForDay($d)}</events>
let $eventsforday := if(empty($efd)) then <events></events> else <events> {
        for $e in $efd/eventRule return
        element event {
                element datum {$d},
                element datumWochenTag {  if (functx:day-of-week($d) = 0) then 7 else functx:day-of-week($d)},
                (:element datumJahresTag {functx:day-in-year($d)},:)
                element startZeit {fn:data($e/@startTime)},
                element startZeitInMin {hours-from-time($e/@startTime) * 60 + minutes-from-time($e/@startTime)},
                element endZeit {fn:data($e/@endTime)},
                element endZeitInMin {hours-from-time($e/@endTime) * 60 + minutes-from-time($e/@endTime)},
                element beschreibung {fn:data($e/@description)},
               (: element tagZuvor {functx:previous-day($d)},:)
                element tagDanach {functx:next-day($d)},
                element location {$e/location/text()},
                element attendees {for $a in $e//attendee/text() return <attendee>{$a}</attendee>}
                }
         } </events>
return  $eventsforday
