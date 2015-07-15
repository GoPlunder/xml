xquery version "1.0";
declare namespace df = "data-functions.xquery";


declare function df:getEventsForDate($date as xs:date?) as element()*
{
for $d in doc("events_sortiert.xml")/events/event
let $d := datum
where $d = $date
return <datum>
{$d/description/text()}
</datum>
};
