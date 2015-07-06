xquery version "1.0";

declare namespace functx = "http://www.functx.com";
declare namespace fn = "http://www.w3.org/2005/xpath-functions";
declare namespace local = "http://www.w3.org/2005/xquery-local-functions";

declare function local:getEventsForDay ($d as xs:date?)  {
  let $events := doc("sampleCalendarX.xml")/eventRules/eventRule
  for $patterns in doc("sampleCalendarX.xml")/eventRules/eventRule/recurrencePattern


  (fn:filter ($events, $filt) )
  functx:sort($events/@startTime)
  
 return  
};


(:Hilfsfunktionen. We check our date regarding simple patterns - daily and weekly:)

 declare function local:isInDaily ($d as xs:date, $p as xs:string?) as xs:boolean  
 {
  for $dp in doc("sampleCalendarX.xml")/dailyPattern[@description eq $p]
  return(functx:between-inclusive ($d, $dp/@startDate ,$dp/@endDate))
  };

declare function local:isInWeekly ($d as xs:date, $p as xs:string?) as xs:boolean
{
 for $wp in doc("sampleCalendarX.xml")/weeklyPattern[@description eq $p]
 return (functx:day-of-week-name-en ($d) eq $wp/@dayOfWeek)
 };


(:Hilfsfunktionen. We check our date with regard to complex patterns - difference, union and intersection. 
 These call function isDateInPattern recursively. If the pattern is not simple, the function applies to its first and following
 patterns respectively and compare these according to the pattern:)

declare function local:isInUnion ($d as xs:date, $p as xs:string?) as xs:boolean
{
 for $union in doc("sampleCalendarX.xml")/unionPattern[@description eq $p]
 return ((local:isDateInPattern($d, fn:data($union/firstPattern))) or (local:isDateInPattern($d, fn:data($union/furtherPattern))))
 };

declare function local:isInDifference ($d as xs:date, $p as xs:string?) as xs:boolean
{
 for $differ in doc("sampleCalendarX.xml")/differencePattern[@description eq $p]
 return ((local:isDateInPattern($d, fn:data($differ/firstPattern))) and fn:not(local:isDateInPattern($d, fn:data($differ/furtherPattern))))
 };
 
 declare function local:isInIntersection ($d as xs:date, $p as xs:string?) as xs:boolean
{
 for $intersec in doc("sampleCalendarX.xml")/intersectionPattern[@description eq $p]
 return ((local:isDateInPattern($d, fn:data($intersec/firstPattern))) and (local:isDateInPattern($d, fn:data($intersec/furtherPattern))))
 };
 
 
(: Recursive checking : If one of the functions returns true then the return value of isDateInPattern will be true :)

declare function local:isDateInPattern ($d as xs:date, $p as xs:string?) as xs:boolean
 {
  ((local:isInDaily($d, $p)) or (local:isInWeekly($d,$p)) or (local:isInDifference($d,$p)) or (local:isInIntersection($d,$p)) or (local:isInUnion($d,$p)))
 };
 
 (:Calling the actual function based on "aktuellesDatum" - XForms Intergation to do!!:)
local:getEventsForDay(doc('aktuellesDatum.xml')/datum)