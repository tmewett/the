package require Tk

oo::class create app {
    variable endTime remainingS
    constructor {} {
        grid [ttk::entry .entry]
        bind .entry <Key-Return> "[self] set"
        focus .entry
        grid [ttk::label .time -font "normal 48" -text "00:00"]
    }
    method tick {} {
        my update
        if {$remainingS > 0} {
            after 1000 "[self] tick"
        } else {
            .entry state !disabled
            .entry selection range 0 end
            focus .entry
        }
    }
    method set {} {
        set endTime [clock add [clock seconds] [.entry get] seconds]
        my tick
        .entry state disabled
        wm iconify .
    }
    method update {} {
        set remainingS [expr {$endTime - [clock seconds]}]
        puts $remainingS
        set display "[format %02u [expr {$remainingS / 60}]]:[format %02u [expr {$remainingS % 60}]]"
        .time configure -text $display
        wm title . $display
    }
}

set appO [app new]

tkwait window .
