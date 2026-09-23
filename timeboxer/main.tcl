package require Tk

proc mmss {seconds} {
    if {$seconds >= 0} {
        return "[format %02u [expr {$seconds / 60}]]:[format %02u [expr {$seconds % 60}]]"
    } else {
        return "-[format %02u [expr {-$seconds / 60}]]:[format %02u [expr {-$seconds % 60}]]"
    }
}

oo::class create app {
    variable taskEndTime sessionEndTime
    constructor {} {
        set taskEndTime false
        my restartSession
        grid [ttk::label .sessionTime -font "normal 48" -text "00:00"]
        grid [ttk::entry .entry]
        grid [ttk::label .taskTime -font "normal 48" -text "00:00"]
        bind . <Key-Escape> "[self] esc"
        bind . <Control-Key-r> "[self] restartSession"
        bind .entry <Key-Return> "[self] set"
        focus .entry
    }
    method restartSession {} {
        set sessionEndTime [clock add [clock seconds] 60 minutes]
    }
    method tick {} {
        my update
        after 500 "[self] tick"
    }
    method esc {} {
        set taskEndTime false
        my update
        focus .entry
        .entry selection range 0 end
    }
    method set {} {
        set taskEndTime [clock add [clock seconds] [.entry get] minutes]
        wm iconify .
    }
    method update {} {
        set ms [clock milliseconds]
        if {$taskEndTime} {
            set taskRemS [expr {$taskEndTime - $ms / 1000}]
            set taskDisplay [mmss $taskRemS]
            .entry state disabled
        } else {
            set taskRemS 0
            set taskDisplay "00:00"
            .entry state !disabled
        }
        set sessionRemS [expr {$sessionEndTime - $ms / 1000}]
        set sessionDisplay [mmss $sessionRemS]
        set title "$taskDisplay ($sessionDisplay)"
        if {$ms % 1000 >= 500} {
            if {$sessionRemS < 0} {
                set title "Session over!"
            } elseif {$taskRemS < 0} {
                set title "Task over!"
            }
        }
        .sessionTime configure -text $sessionDisplay
        .taskTime configure -text $taskDisplay
        wm title . $title
    }
}

set appO [app new]
$appO tick

tkwait window .
