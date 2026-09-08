package require Tk

oo::class create app {
    variable endTime
    constructor {} {
        grid [ttk::label .time]
        set endTime [clock add [clock seconds] 5 seconds]
        my tick
    }
    method tick {} {
        set remainingTime [expr {$endTime - [clock seconds]}]
        .time configure -text $remainingTime
        wm title . "$remainingTime remaining"
        after 1000 "[self] tick"
    }
    method update {eventsIn} {
        set events [dict merge {} $eventsIn]
    }
}

set appO [app new]
$appO update {}

tkwait window .
