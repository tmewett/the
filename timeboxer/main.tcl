package require Tk

oo::class create app {
    variable endTime
    constructor {} {
        set endTime false
        grid [ttk::entry .entry]
        bind . <Key-Escape> "[self] esc"
        bind .entry <Key-Return> "[self] set"
        focus .entry
        grid [ttk::label .time -font "normal 48" -text "00:00"]
    }
    method tick {} {
        my update
        if {$endTime} {
            after 500 "[self] tick"
        }
    }
    method esc {} {
        set endTime false
        my update
        focus .entry
        .entry selection range 0 end
    }
    method set {} {
        set endTime [clock add [clock seconds] [.entry get] minutes]
        my tick
        wm iconify .
    }
    method update {} {
        if {$endTime} {
            set ms [clock milliseconds]
            set remainingS [expr {$endTime - $ms / 1000}]
            if {$remainingS >= 0} {
                set display "[format %02u [expr {$remainingS / 60}]]:[format %02u [expr {$remainingS % 60}]]"
                set title $display
            } else {
                set display "-[format %02u [expr {-$remainingS / 60}]]:[format %02u [expr {-$remainingS % 60}]]"
                if {$ms % 1000 >= 500} {
                    set title "Timer done!"
                } else {
                    set title $display
                }
            }
            .entry state disabled
        } else {
            set display "00:00"
            set title "Timeboxer"
            .entry state !disabled
        }
        .time configure -text $display
        wm title . $title
    }
}

set appO [app new]
$appO update

tkwait window .
