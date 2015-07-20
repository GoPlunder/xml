xquery version "3.0";

declare namespace fn = "http://www.w3.org/2005/xpath-functions";
import module namespace functx = "functX" at "functX.xquery";
import module namespace local = "isinPat" at "isinPat.xquery";

  let $d:=doc("aktuellesDatum.xml")/datum/text()
  for $events in doc("sampleCalendarX.xml")//eventRule
  let $evsfDay :=  $events[fn:filter ( function($a){if (local:isDateInPattern ($d,$a)) then true() else false()}, $events//recurrencePattern )]
  order by($evsfDay/@startTime)
  return if (empty($evsfDay)) then () else $evsfDay
