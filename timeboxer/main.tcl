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
        after 1000 "[self] tick"
        if {$remainingS > 0} {
        } else {
            focus .entry
        }
    }
    method set {} {
        set endTime [clock add [clock seconds] [.entry get] seconds]
        my tick
        wm iconify .
    }
    method update {} {
        set remainingS [expr {$endTime - [clock seconds]}]
        puts $remainingS
        if {$remainingS >= 0} {
            set display "[format %02u [expr {$remainingS / 60}]]:[format %02u [expr {$remainingS % 60}]]"
            .entry state disabled
        } else {
            set display "-[format %02u [expr {-$remainingS / 60}]]:[format %02u [expr {-$remainingS % 60}]]"
            .entry state !disabled
            .entry selection range 0 end
        }
        .time configure -text $display
        wm title . $display
    }
}

set appO [app new]

tkwait window .
