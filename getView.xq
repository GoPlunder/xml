import module namespace xproc="http://exist-db.org/xproc";
let $view_data := request: get-data()
let $view := $view_data/ViewSelected
let $day-proc := doc ('/db/apps/CalendarX/daysubpipe.xpl')
let $week-proc := doc ('/db/apps/CalendarX/weeksubpipe.xpl')
let $month-xproc := doc('/db/apps/CalendarX/monthsubpipe.xpl')
return xproc:process(if ($view="day") then $day-proc
                        else (if ($view = "week") then $week-proc
                            else $month-xproc))