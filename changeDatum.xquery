xquery version "1.0";
 declare namespace request="http://exist-db.org/xquery/request";
 declare namespace util="http://exist-db.org/xquery/util";
 declare namespace fn = "http://www.w3.org/2005/xpath-functions";
                        
let $data:= request:get-data()
let $date := fn:string($data/date-selected)
return update value doc('/db/apps/calendar/CalendarX/aktuellesDatum.xml')//datum/text() with $date