#
#
# Main windows support for the interface of Gnuplot
#


proc xgpl_WindowMain { w } {

    global Xgpl
    
    # open gnuplot connection
    xgpl_Open

    # create command bar
    frame $w
    frame $w.bar -relief flat
    set width 7

    pack [menubutton $w.bar.file -text "File" -width $width -relief raised \
  	      -borderwidth 1 -menu $w.bar.file.m -underline 0] \
	-side left -anchor w 

    menu $w.bar.file.m

    $w.bar.file.m add command -label "Quit" \
 	-command "xgpl_Exit" -underline 0

    pack [menubutton $w.bar.opts -text "Options" \
  	-width $width -relief raised -borderwidth 1 \
  	      -menu $w.bar.opts.m -underline 0] \
  	-side left -anchor w -expand 1

    menu $w.bar.opts.m
    $w.bar.opts.m add command -label "Plot options..."\
  	-command "xgpl_WindowOpts $w.opts" -underline 0
    $w.bar.opts.m add command -label "3D..." \
	-command "xgpl_Window3D $w.d3" -underline 0
    $w.bar.opts.m add command -label "Polar..." \
	-command "xgpl_WindowPolar $w.polar" -underline 1
    $w.bar.opts.m add command -label "Command line..."\
	-command "xgpl_ComLine $w.com" -underline 0
    	
    pack [button $w.bar.plot -text "Plot" -width $width \
	      -relief raised -borderwidth 1 -command "xgpl_Plot" \
	      -underline 0] -side left -anchor w

    pack [button $w.bar.help -text "Help" -width $width \
	      -relief raised -borderwidth 1 -command "xgpl_help" \
	      -underline 0] -side left -anchor w

    # make the widget

    pack $w.bar -side top -fill x -padx 2 -pady 2

    xgpl_setWindowAllLines $w

    bind Entry <Return> " "

}


proc xgpl_lineReset { w n } {
    
    global Xgpl gpl_line

    set gpl_line(style,$n) lines
    set gpl_line(line,$n) $n
    set gpl_line(point,$n) $n
    set gpl_line(title,$n) {}
    
}



proc xgpl_Open { } {

    global Xgpl
    set Xgpl(fidX) [open "|gnuplot" w+]

}



proc xgpl_Close { } {
    
    global Xgpl
    catch {close $Xgpl(fidX)}

}



proc xgpl_setWindowAllLines { w } {

    global Xgpl
    catch {destroy $w.ll}

    if {$Xgpl(show:lines)} then {

	xgpl_WindowAllLines $w 350 500 1200
    }
}



proc xgpl_WindowOpts { w } {

    global Xgpl gpl_line

    # create window of main options to plot
    toplevel $w ; set title "Plot: Main Options"
    wm title $w $title
    wm iconname $w $title
    wm iconbitmap $w @$Xgpl(bitmap)
    wm geometry $w +0+100
    wm group $w .

    set ww $w
    pack [frame $ww.ttl -relief groove -borderwidth 2] \
	-padx 2 -pady 2 -fill x -ipady 8

    pack [label $ww.ttl.l -text "Main Title: " \
	      -width 12 -anchor w \
	      -relief flat] -side left -anchor w
    pack [entry $ww.ttl.e -relief sunken -width 20 \
	-textvariable Xgpl(main:title) -background white] \
	-side left -anchor w -expand 1 -fill x

    pack [label $ww.ttl.l1 -relief flat -text " Offset:" \
	      -width 8] -side left -anchor w

    pack [label $ww.ttl.l2 -relief flat -text "X:" -width 3] \
	-side left -anchor w
    pack [entry $ww.ttl.e1 -relief sunken -width 4 \
	-textvariable Xgpl(main:ofsx) -background white] \
	-side left -padx 1 -anchor w -fill x -expand 0

    pack [label $ww.ttl.l3 -relief flat -text "Y:" -width 3] \
	-side left -anchor w
    pack [entry $ww.ttl.e2 -relief sunken -width 4 \
	-textvariable Xgpl(main:ofsy) -background white] \
	-side left -padx 1 -anchor w -fill x

    pack [label $ww.ttl.l4 -relief flat -text {} -width 1] \
	-side left -anchor w

    pack [checkbutton $ww.ttl.grid -text "Grid" -width 4 \
	      -relief flat -variable Xgpl(grid) -anchor w] \
	-side left -anchor w -padx 2
    pack [checkbutton $ww.ttl.keyon -text "Key" -width 4 \
	      -relief flat -variable Xgpl(key:on) -anchor w] \
	-side left -anchor w -padx 2

    pack [label $ww.ttl.keypos -text "At:" -width 4 \
	      -relief flat -anchor e ] \
	-side left -anchor w -padx 2
    pack [entry $ww.ttl.keypz -relief sunken -width 4 \
	      -textvariable Xgpl(key:z) -background white] \
	-side right -anchor e -padx 2
    pack [entry $ww.ttl.keypy -relief sunken -width 4 \
	      -textvariable Xgpl(key:y) -background white] \
	-side right -anchor e -padx 2
    pack [entry $ww.ttl.keypx -relief sunken -width 4 \
	      -textvariable Xgpl(key:x) -background white] \
	-side right -anchor e -padx 2    
    
    pack [frame $ww.c -relief groove -borderwidth 2] \
	-padx 2 -pady 2 -fill x
    pack [xgpl_WindowCoord $ww.c.x "X Axis" x] \
	-side left -fill both -padx 4 -pady 6
    pack [xgpl_WindowCoord $ww.c.y "Y Axis" y] \
	-side left -fill both -padx 4 -pady 6
    pack [xgpl_WindowCoord $ww.c.z "Z Axis" z] \
	-side left -fill both -padx 4 -pady 6

    pack [frame $w.bar -relief flat] -side top -fill x -padx 1 -pady 1
    
    pack [button $w.bar.cancel -text Cancel -command "destroy $w"\
	-width 6 -borderwidth 1 -relief raised] -side left -expand 1 
    pack [button $w.bar.ok -relief groove -width 6 -text OK \
	      -command "destroy $w"]\
	-side left -expand 1
    bind $w <Return> "tkButtonInvoke $w.bar.ok"

}



proc xgpl_Send { args } {
    
    global Xgpl

    foreach n $args {append line " $n"}
    if $Xgpl(debug) then {
	
	puts "Sending $Xgpl(debug) puts $Xgpl(fidX) $line"
    }
    puts $Xgpl(fidX) $line
    puts $Xgpl(fidX) "\r"
    flush $Xgpl(fidX)
    
}



proc xgpl_WindowAllLines { w  xh xw xl } {

    global Xgpl gpl_line

    set n 1
    pack [xgpl_WindowLine $w.l$n $n] -side top -fill x -padx 10 -pady 15\
             -ipady 5
   
}


proc fileDialog { w e operation } {

  #   Type names		Extension(s)	Mac File Type(s)
  #
  #---------------------------------------------------------

  set types {
    {"All files"		*}    
    {"Model files"		{.mod*} 	TEXT}
    {"Text files"		{.txt .doc .dat}	}
    {"Text files"		{}		TEXT}
    {"Tcl Scripts"		{.tcl}		TEXT}
    {"C Source Files"	{.c .h}		}
    {"All Source Files"	{.tcl .c .h}	}
    {"Image Files"		{.gif}		}
    {"Image Files"		{.jpeg .jpg}	}
    {"Image Files"		""		{GIFF JPEG}}
  }

  if {$operation == "open"} {
    set file [tk_getOpenFile -filetypes $types -parent $w]
  } else {
    set file [tk_getSaveFile -filetypes $types -parent $w \
      -initialfile Untitled -defaultextension .txt]
  }

  if [string compare $file ""] {
    $e delete 0 end
    $e insert 0 $file
  }
}



proc xgpl_fichier { w n label } {

    global Xgpl gpl_line

    if {$gpl_line(entry,$n) != ""} then {

	# read the first line of file
	set i 0
	set F [open $gpl_line(entry,$n) r]
	set ligne1 [gets $F]

	foreach mot $ligne1 {
	    
	    if {$mot != "Results"} then {	
		set i [incr i]
		
		pack [frame $w.va$label$i -relief flat] \
		    -side top -fill x 
		pack [button $w.va$label$i.n -text "$mot" \
			  -relief flat -borderwidth 1\
			  -width 15 -foreground sienna -command "
			  set Xgpl($label:title) $mot
			  set gpl_line($label,$n) $i " ] \
		    -side left -fill x	
		
	    } else {
		set ligne2 [gets $F]
		set ligne3 [gets $F]
	    
		foreach mot $ligne3 {
		    set i [incr i]

		    pack [frame $w.va$label$i -relief flat]\
			-side top -fill x 
		    pack [button $w.va$label$i.n -text "$mot" \
			      -relief flat -borderwidth 1\
			      -width 15 -foreground sienna -command "
			  set Xgpl($label:title) $mot
			  set gpl_line($label,$n) $i " ] \
			-side left -fill x
		}
		return {}
	    }
	}
    } 
}



proc xgpl_var { w n label } {

   global Xgpl gpl_line

   # create scrollable 

   catch {destroy $w}
   toplevel $w ; set title "Variable names"
   wm title $w $title
   wm maxsize $w 150 200
   wm geometry $w +400+100
   wm iconname $w $title
   wm iconbitmap $w @$Xgpl(bitmap)

   pack [frame $w.canva$label -relief groove] \
       -side top -fill y -padx 2 -pady 2

   pack [scrollbar $w.canva$label.scrolly -orient vertical -width 10\
	     -command "$w.canva$label.c yview"]\
       -side right -fill y

   pack [canvas $w.canva$label.c -scrollregion "0 0 50 50000"\
	     -yscrollcommand "$w.canva$label.scrolly set"]\
       -side top -fill y -expand 1

   frame $w.canva$label.c.f -relief flat
   $w.canva$label.c create window 60 5 -anchor n -window $w.canva$label.c.f
   set ww $w.canva$label.c.f
   
   # insert variable names
   xgpl_fichier $ww $n $label

}



proc xgpl_confirm { n label } {

    global Xgpl gpl_line

    if {$gpl_line($label,$n) != ""} then {

	set i 0
	set F [open $gpl_line(entry,$n) r]
	set ligne1 [gets $F]

	if {$Xgpl($label:title) != "" } then {

	    foreach mot $ligne1 {

		if {$mot != "Results"} then { 

		    set i [incr i]
	       
		    if {$gpl_line($label,$n) == $i} then {
		       
			    set Xgpl($label:title) $mot
		    }
		} else {

		    set ligne2 [gets $F]
		    set ligne3 [gets $F]

		    foreach mot $ligne3 {
			set i [incr i]
			if {$gpl_line($label,$n) == $i} then {
		       
				set Xgpl($label:title) $mot
			}
		    }
		    return {}
		}
	    }
	} else {
	    foreach mot $ligne1 {

		if {$mot != "Results"} then { 

		    set i [incr i]
		    if {$gpl_line($label,$n) == $i} then {
			set Xgpl($label:title) $mot
		    }
		} else {

		    set ligne2 [gets $F]
		    set ligne3 [gets $F]
		    foreach mot $ligne3 {
			set i [incr i]
			if {$gpl_line($label,$n) == $i} then {
		       
				set Xgpl($label:title) $mot
			}
		    }
		    return {}
		}    
	    }
	    if {$Xgpl($label:title) == ""} then {
		tk_dialog .dialog "Column not found" \
		"Error: this column doesn't exist." \
			  error 0 "OK"
	    }
	}
    }

    if {$Xgpl($label:title) != ""} then {
	    
	set i 0
	set F [open $gpl_line(entry,$n) r]
	set ligne1 [gets $F]

	foreach mot $ligne1 {
		
	    if {$mot != "Results"} then {

		set i [incr i]
		if {$Xgpl($label:title) == $mot} then {
		    set gpl_line($label,$n) $i
		}
	    } else {

		set ligne2 [gets $F]
		set ligne3 [gets $F]
		foreach mot $ligne3 {
		    set i [incr i]
		    if {$Xgpl($label:title) == $mot} then {
			set gpl_line($label,$n) $i
		    }
		}
		return {}
	    }
	}
    }
}



proc xgpl_WindowLine { w n } {

    global Xgpl
    global Xgpl gpl_line
    global entryWidth
    global selectedOutput
    set entryWidth 30

    set gpl_line(x,$n) {1}
    set gpl_line(y,$n) {2}
    set gpl_line(z,$n) {3}
    set gpl_line(titleon,$n) 0
    set gpl_line(ploton,$n) 0

    # make container frame
    frame $w -relief groove -borderwidth 2

    # setup defaults
    xgpl_lineReset $w $n

    pack [frame $w.top0 -relief flat] -side top -fill x -padx 10 -pady 3
    pack [label $w.top0.type2 -text "File : "] -side left -anchor w

    pack [entry $w.top0.e -width 30 -relief sunken -background white\
	      -textvariable gpl_line(entry,$n)] \
	-side left -anchor w -expand 1 -fill x -padx 4

    pack [button $w.top0.b -text "Browse" -relief raised \
	      -borderwidth 1 -command "fileDialog $w $w.top0.e open" \
	      -width 6 -foreground brown]\
   	-side left -anchor w -padx 10

    pack [frame $w.cols1 -relief flat] -fill x -side top -pady 5

    pack [label $w.cols1.cols -text "Columns  " -width 8 ] \
	-side left -fill x -anchor w -padx 5

    pack [label $w.cols1.cl1 -text " X : " -width 3 -relief flat] \
	-side left -anchor w
    pack [entry $w.cols1.e1 -relief sunken -width 4 -background white\
	      -textvariable gpl_line(x,$n)] -side left -anchor w
    pack [button $w.cols1.ok -text "OK" -width 2 -relief raised \
	      -borderwidth 1 -command "xgpl_confirm $n x" ] \
	-side left -anchor w -padx 4

    pack [entry $w.cols1.e2 -relief sunken -width 30 -background white\
	      -textvariable Xgpl(x:title)] -side left -anchor w
    pack [button $w.cols1.browse -text "Browse" -width 6 \
	      -relief raised -borderwidth 1 -foreground brown \
	      -command "xgpl_var $w.vx $n x"] \
	-side left -anchor w -padx 5

	
    pack [frame $w.cols2 -relief flat] -fill x -side top -pady 5 -padx 72

    pack [label $w.cols2.cl2 -text " Y : " -width 3 -relief flat] \
	-side left -anchor w
    pack [entry $w.cols2.ce2 -relief sunken -width 4 -background white\
	      -textvariable gpl_line(y,$n)] -side left -anchor w
    pack [button $w.cols2.ok -text "OK" -width 2 -relief raised \
	      -borderwidth 1 -command "xgpl_confirm $n y" ] \
	-side left -anchor w -padx 4

    pack [entry $w.cols2.ce2a -relief sunken -width 30 -background white\
 	      -textvariable Xgpl(y:title)] -side left -anchor w
    pack [button $w.cols2.browse -text "Browse" -width 6 \
	      -relief raised -borderwidth 1 -foreground brown \
	      -command "xgpl_var $w.vy $n y" ] \
	-side left -anchor w -padx 5

    pack [frame $w.cols3 -relief flat] -fill x -side top -pady 5 -padx 72

    pack [label $w.cols3.cl3 -text " Z : " -width 3 -relief flat] \
	-side left -anchor w
    pack [entry $w.cols3.ce3 -relief sunken -width 4 -background white\
	      -textvariable gpl_line(z,$n)] -side left -anchor w
    pack [button $w.cols3.ok -text "OK" -width 2 -relief raised \
	      -borderwidth 1 -command "xgpl_confirm $n z" ] \
	-side left -anchor w -padx 4

    pack [entry $w.cols3.ce3a -relief sunken -width 30 \
	      -background white -textvariable Xgpl(z:title)] \
	-side left -anchor w
    pack [button $w.cols3.browse -text "Browse" -width 6 \
	      -relief raised -borderwidth 1 -foreground brown \
	      -command "xgpl_var $w.vz $n z" ] \
	-side left -anchor w -padx 5


    pack [frame $w.top1 -relief flat] -side top -fill x -padx 2 -pady 3

    pack [menubutton $w.top1.with -text "Style :" -width 8 \
	      -menu $w.top1.with.m -relief raised -borderwidth 1] \
	-side left -padx 1 -pady 10 -anchor w
    pack [label $w.top1.lwith -textvariable gpl_line(style,$n) \
	      -width 10 -relief flat -foreground brown] \
	-side left -padx 0 -anchor w

    menu $w.top1.with.m

    foreach m {lines points linespoint impulses dots steps boxes} {
	$w.top1.with.m add radiobutton -label $m \
	    -variable gpl_line(style,$n) -value $m
    }

    pack [radiobutton $w.top1.dim2 -text "2D Data" -width 10 \
	      -relief raised -borderwidth 2 -relief flat \
	      -variable Xgpl(dimension) -value 2]\
	-side left -anchor w

    pack [radiobutton $w.top1.dim3 -text "3D Data" -width 10 \
	      -relief raised -borderwidth 2 -relief flat \
	      -variable Xgpl(dimension) -value 3]\
	-side left -anchor w


    pack [checkbutton $w.top1.replot -text "Overlay" -anchor w \
	      -relief flat -width 8 -variable gpl_line(ploton,$n) \
	      -foreground blue]\
	-side right -anchor w -padx 30

    pack [frame $w.mid1 -relief flat] -side top -fill x -padx 2 -pady 3

    pack [label $w.mid1.title -text "Legend of the curve:" -relief flat \
  	      -width 20 ] \
  	-side left -anchor w
    pack [entry $w.mid1.etitle -relief sunken -width 20 \
	      -textvariable gpl_line(title,$n) -background white]\
	-side left -anchor w -padx 4 -fill x -expand 1

    pack [button $w.mid1.b2 -text "Reset" -relief raised -borderwidth 1 \
 	      -command "xgpl_lineReset $w $n" -width 6] \
 	-side right -anchor w -padx 10

    return $w

}




proc xgpl_Plot { } {

    global Xgpl gpl_line
    xgpl_Update
    set clist {}
    
    set n 1

	if [string length $gpl_line(entry,$n)] then {	    

	    if [string length $clist] {append clist ,}

	    append clist '$gpl_line(entry,$n)'
		
	    if {$Xgpl(dimension) == 2} then {
		append clist " using $gpl_line(x,$n):$gpl_line(y,$n)"
	    } else {
		append clist \
		    " using $gpl_line(x,$n):$gpl_line(y,$n):$gpl_line(z,$n)"
	    }
	
	    if {$gpl_line(title,$n) != ""} then {

		    append clist " title '$gpl_line(title,$n)'"

	    } else {
		append clist " notitle"
	    }

	    append clist " with $gpl_line(style,$n)"

	}

    if {$gpl_line(ploton,$n)} then {

	xgpl_Send replot $clist

    } elseif {$Xgpl(dimension) == 2} then {
	xgpl_Send plot $clist

    } else {
	xgpl_Send splot $clist
    }

}



proc xgpl_Exit { } {
    
    global Xgpl
    xgpl_Close
    exit
}



proc xgpl_cd { dir } {cd $dir ; xgpl_Send cd $dir}


proc xgpl_Update { } {

    global Xgpl
    
    foreach coord {x y z} {
	
	# setup scaling of axes
	if {$Xgpl($coord:auto)} then {
	    xgpl_Send set autoscale $coord
	} else { 
	    xgpl_Send set nautoscale $coord
	    if {[string length $Xgpl($coord:rngfrom)] && \
 		    [string length $Xgpl($coord:rngto)]} then {
		xgpl_Send set ${coord}range \
 		    \[$Xgpl($coord:rngfrom):$Xgpl($coord:rngto)\]
	    }	
	}

	if {$Xgpl($coord:logon)} then {
	    xgpl_Send set logscale $coord $Xgpl($coord:logbase)
	} else {
	    xgpl_Send set nologscale $coord
	}

	if [string length $Xgpl($coord:ofsx)] then {
	    set clist $Xgpl($coord:ofsx)
	} else {
	    set clist {}
	}

	if [string length $Xgpl($coord:ofsy)] then {
	    append clist ",$Xgpl($coord:ofsy)"
	} 
	
	# set axes titles
	if [string length $Xgpl($coord:title)] then {
	    xgpl_Send set ${coord}label '$Xgpl($coord:title)' $clist
	} else {
	    xgpl_Send set ${coord}label $clist
	}
	
	# set axes tick marks and axes
	if {$Xgpl($coord:axis)} then {
	    xgpl_Send set ${coord}zeroaxis
	} else {
	    xgpl_Send set no${coord}zeroaxis
	}

	if !{$Xgpl($coord:ticks)} then {
	    xgpl_Send set no${coord}tics

	} else {

	    if $Xgpl($coord:tickron) then {

		if {[string length $Xgpl($coord:tickrs)] && \
			[string length $Xgpl($coord:tickri)] } then {
		    set clist "$Xgpl($coord:tickrs),$Xgpl($coord:tickri)"
		    if [string length $Xgpl($coord:tickre)] then {
			append clist ",$Xgpl($coord:tickre)"
		    }
		    xgpl_Send set ${coord}tics $clist
		}
	    } elseif $Xgpl($coord:ticklon) then {
		if {[string length $Xgpl($coord:tickll)]} then {
		    xgpl_Send set ${coord}tics ( $Xgpl($coord:tickll) )
		}
	    } else {
		xgpl_Send set ${coord}tics
	    }
	}
    }
    
    if [string length $Xgpl(main:ofsx)] then {
	set clist $Xgpl(main:ofsx)
    } else {
	set clist {}
    }

    if [string length $Xgpl(main:ofsy)] then {
	append clist ",$Xgpl(main:ofsy)"
    } 

    if [string length $Xgpl(main:title)] then {
	xgpl_Send set title '$Xgpl(main:title)' $clist
    } else {
	xgpl_Send set title $clist
    }

    if {$Xgpl(border)} then {
	xgpl_Send set border
    } else {
	xgpl_Send set noborder
    }

    if {$Xgpl(grid)} then {
	xgpl_Send set grid
    } else {
	xgpl_Send set nogrid
    }

    xgpl_Send set tics in

    foreach m {points one two} {
	if {$Xgpl(clip:$m)} then {
	    xgpl_Send set clip $m
	} else {
	    xgpl_Send set noclip $m
	}
    }

    if {[string length Xgpl(size:x)]&&[string length Xgpl(size:y)]} then {
	xgpl_Send set size $Xgpl(size:x),$Xgpl(size:y)
    }

    if {[string length Xgpl(sampling)]} then {
	xgpl_Send set samples $Xgpl(sampling)
    }

    if {[string length $Xgpl(space:x1)] && \
	    [string length $Xgpl(space:x2)] && \
	    [string length $Xgpl(space:y1)] && \
	    [string length $Xgpl(space:y2)] } then {
	xgpl_Send set offsets \
	    $Xgpl(space:x1),$Xgpl(space:x2),$Xgpl(space:y1),\
	    $Xgpl(space:y2)
    }

    if {$Xgpl(key:on)} then {
	set clist {} 
	if {[string length $Xgpl(key:x)] && \
		[string length $Xgpl(key:y)]} then {
	    append clist " $Xgpl(key:x),$Xgpl(key:y)"
	    if {$Xgpl(dimension) == 2} then {
		if {[string length $Xgpl(key:z)]} then {
		    append clist ",$Xgpl(key:z)"
		}
	    }
	}
	xgpl_Send set key $clist

    } else {
	xgpl_Send set nokey
    }

    if {$Xgpl(polar)} then {

	xgpl_Send set polar
	xgpl_Send set angles $Xgpl(angle)
	if {[string length $Xgpl(polar:r1)] && \
		[string length $Xgpl(polar:r2)] } then {
	    xgpl_Send set rrange \[$Xgpl(polar:r1):$Xgpl(polar:r2)\]
	}

    } else {
	xgpl_Send set nopolar
    }

    if {$Xgpl(dimension) == 3} then {
	xgpl_Send set view $Xgpl(view:xrot),$Xgpl(view:zrot),\
	    $Xgpl(view:xsc),$Xgpl(view:zsc)
	xgpl_Send set mapping $Xgpl(smap)

	if {$Xgpl(surf)} then {
	    xgpl_Send set surface
	    xgpl_Send set isosamples $Xgpl(isamp)

	} else {
	    xgpl_Send set nosurface
	}

	if {$Xgpl(cont)} then {
	    xgpl_Send set contour $Xgpl(ctype)
	    if {$Xgpl(clabel)} then {
		xgpl_Send set clabel
	    } else {
		xgpl_Send set noclabel
	    }
	    xgpl_Send set cntrparam $Xgpl(cmode)
	    xgpl_Send set cntrparam points $Xgpl(cont:points)
	    xgpl_Send set cntrparam order $Xgpl(cont:order)
	    xgpl_Send set cntrparam levels $Xgpl(cont:n)

	    switch $Xgpl(cont:levm) {
		{auto}        {xgpl_Send set cntrparam levels auto}
		{incremental} {
		    if {[string length $Xgpl(cont:lev1)] && \
		    [string length $Xgpl(cont:lev2)]} then {
			set clist "$Xgpl(cont:lev1),$Xgpl(cont:lev2)"
			if {[string length $Xgpl(cont:lev3)]} then {
			    append clist ",$Xgpl(cont:lev3)"
			}
			xgpl_Send set cntrparam levels incremental $clist
		    }
		} 
		{discrete}   {
		    xgpl_Send set cntrparam levels discrete $Xgpl(cont:levs)
		}
	    }
	} else {
	    xgpl_Send set nocontour
	}
    }
}



proc xgpl_WindowCoord { w title label } {

    global Xgpl


    frame $w -relief sunken -borderwidth 2
    pack [label $w.l -text $title -relief flat] \
	-side top -fill x -padx 2 -pady 1


    pack [frame $w.t -relief flat] -side top -fill x -padx 4 -pady 3
    pack [label $w.t.l -text "Title:" -width 6 -anchor w -relief flat] \
	-side left -anchor w
    pack [entry $w.t.e -relief sunken -width 20 -background white\
	      -textvariable Xgpl($label:title)] \
	-side left -anchor w -expand 1 -fill x

    pack [frame $w.ofs -relief flat] -side top -fill x -padx 4 -pady 3
    pack [label $w.ofs.l1 -relief flat -text "Offset:" -width 6] \
	-side left -anchor w
    pack [label $w.ofs.l2 -relief flat -text "X:" -width 4] \
	-side left -anchor w
    pack [entry $w.ofs.e1 -relief sunken -width 6 -background white\
	      -textvariable Xgpl($label:ofsx)] \
	-side left -padx 1 -anchor w -fill x -expand 1
    pack [label $w.ofs.l3 -relief flat -text "Y:" -width 3] \
	-side left -anchor w
    pack [entry $w.ofs.e2 -relief sunken -width 6 -background white\
	      -textvariable Xgpl($label:ofsy)] \
	-side left -padx 1 -anchor w -fill x -expand 1

    pack [frame $w.sp1 -relief flat] -side top -fill x -padx 2 -pady 5

    pack [frame $w.as -relief flat] -side top -fill x
    pack [checkbutton $w.as.as -relief flat -text "Autoscale" \
	      -width 10 -anchor w -variable Xgpl($label:auto)] \
	-side left -anchor w -fill x
    pack [entry $w.as.lb -relief sunken -width 4 -background white\
	      -textvariable Xgpl($label:logbase)] \
	-side right -anchor e -fill x -padx 5
    pack [checkbutton $w.as.ls -relief flat -text "Logscale" \
	      -width 10 -anchor w -variable Xgpl($label:logon)] \
	-side right -anchor e -fill x


    pack [frame $w.rng -relief flat] -side top -fill x -padx 4 -pady 3
    pack [label $w.rng.l1 -relief flat -text "Range:" -width 6] \
	-side left -anchor w
    pack [label $w.rng.l2 -relief flat -text "from" -width 4] \
	-side left -anchor w
    pack [entry $w.rng.e1 -relief sunken -width 6 -background white\
	      -textvariable Xgpl($label:rngfrom)] \
	-side left -padx 1 -anchor w -fill x -expand 1
    pack [label $w.rng.l3 -relief flat -text "to" -width 3] \
	-side left -anchor w
    pack [entry $w.rng.e2 -relief sunken -width 6 -background white\
	      -textvariable Xgpl($label:rngto)] \
	-side left -padx 1 -anchor w -fill x -expand 1

    pack [frame $w.sp2 -relief flat] -side top -fill x -padx 2 -pady 5
    pack [frame $w.ticks  -relief flat] -side top -fill x -padx 4 -pady 3
    pack [frame $w.ticks.top  -relief flat] -side top -fill x 
    pack [checkbutton $w.ticks.top.on -relief flat \
	      -text "Display tick marks" -variable Xgpl($label:ticks) \
	      -anchor w] -side left -anchor w -fill x

    pack [radiobutton $w.ticks.top.no -relief flat -text "Normal" \
	      -width 6 -anchor w -variable Xgpl($label:tickt) \
	      -value tics] -side left -anchor w -fill x -expand 1

    pack [frame $w.ticks.r  -relief flat] -side top -fill x
    pack [checkbutton $w.ticks.r.on -text "Increment:" -width 10 \
	      -anchor w -relief flat -variable Xgpl($label:tickron)] \
	-side left -anchor w -fill x
    pack [entry $w.ticks.r.e1 -relief sunken -width 6\
	      -textvariable Xgpl($label:tickrs) -background white]\
	-side left -anchor w -fill x -expand 1
    pack [entry $w.ticks.r.e2 -relief sunken -width 6\
	      -textvariable Xgpl($label:tickri) -background white]\
	-side left -anchor w -fill x -expand 1
    pack [entry $w.ticks.r.e3 -relief sunken -width 6\
	      -textvariable Xgpl($label:tickre) -background white]\
	-side left -anchor w -fill x -expand 1
    pack [frame $w.ticks.l  -relief flat] -side top -fill x
    pack [checkbutton $w.ticks.l.on -text "List ticks:" -width 10 \
	      -anchor w -relief flat -variable Xgpl($label:ticklon)] \
	-side left -anchor w -fill x
    pack [entry $w.ticks.l.e1 -relief sunken -width 6\
	      -textvariable Xgpl($label:tickll) -background white]\
	-side left -anchor w -fill x -expand 1

    return $w
}


proc xgpl_WindowPolar { w } {

  global Xgpl

  catch {destroy $w}
  toplevel $w ; set title "Polar Plots"
  wm title $w $title
  wm iconname $w $title
  wm geometry $w +250+250
  wm iconbitmap $w @$Xgpl(bitmap)
  wm group $w .

  pack [frame $w.top -relief flat] -side top -fill x -padx 5 -pady 5
  pack [checkbutton $w.top.polar -text "Polar plotting" \
	    -width 20 -relief flat -anchor w -variable Xgpl(polar)] \
      -side left -anchor w
  pack [frame $w.top1 -relief flat] -side top -fill x -padx 5 -pady 5
  pack [radiobutton $w.top1.angrad -text "Radians" -value radians\
	    -width 10 -relief flat -anchor w -variable Xgpl(angle)] \
      -side left -anchor w
  pack [radiobutton $w.top1.angdeg -text "Degrees" -value degrees\
	    -width 10 -relief flat -anchor w -variable Xgpl(angle)] \
      -side left -anchor w
  pack [frame $w.mid -relief flat] -side top -fill x -padx 5 -pady 5
  pack [label $w.mid.trng -text "  Range:" -width 12 \
          -relief flat -anchor w] \
      -side left -anchor w
  pack [entry $w.mid.rr1 -relief sunken -width 8 -background white\
	    -textvariable Xgpl(polar:r1)] -side left -anchor w -padx 2
  pack [entry $w.mid.rr2 -relief sunken -width 8 -background white\
	    -textvariable Xgpl(polar:r2)] -side left -anchor w -padx 2

  pack [frame $w.bar -relief flat] -side top -fill x -padx 5 -pady 8
  pack [button $w.bar.cancel -text Cancel -command "destroy $w" \
	    -width 6 -borderwidth 1 -relief raised] -side left -expand 1

  pack [button $w.bar.ok -text OK -command "destroy $w" \
	    -width 6 -relief groove] -side left -expand 1 

  bind $w <Return> "tkButtonInvoke $w.bar.ok"

}


proc xgpl_lineplot { w } {

    global Xgpl

    if {$Xgpl(com) != "" } {
	xgpl_Send $Xgpl(com)
    }
    destroy $w
}


proc xgpl_linereset { w } {

    global Xgpl

    set Xgpl(com) {}

}


proc xgpl_ComLine { w } {

  global Xgpl

  catch {destroy $w}
  toplevel $w ; set title "Plot: command line"
  wm title $w $title
  wm iconname $w $title
  wm iconbitmap $w @$Xgpl(bitmap)
  wm group $w .


  pack [frame $w.line -relief flat] -side top -fill x -padx 5 -pady 5

  pack [label $w.line.ent -text " Enter your command line: " -width 22 \
          -anchor c -relief flat] -side left -anchor w -pady 6
  pack [entry $w.line.entc -width 40 -relief sunken -background white \
	    -textvariable Xgpl(com) ] -side left -anchor w

  pack [button $w.line.reset -text "Reset" -relief raised -borderwidth 1 \
 	      -command "xgpl_linereset $w" -width 6] \
 	-side right -anchor w -padx 10

  pack [frame $w.valid -relief flat] -side top -fill x -padx 5 -pady 5
  pack [button $w.valid.cancel -text "Cancel" -width 6 -relief raised \
	    -borderwidth 1 -command "destroy $w"] -side left -expand 1

  pack [button $w.valid.ok -text "OK" -width 6 -relief groove \
	    -command "xgpl_lineplot $w" ] -side left -expand 1

  bind $w <Return> "tkButtonInvoke $w.valid.ok"

}



proc xgpl_help { } {

    global Xgpl
    set w .help
    catch {destroy $w} ; toplevel $w
    wm title $w "Plot Install Help"
    wm iconname $w "Plot Install Help"

    frame $w.t -relief groove -borderwidth 2
    pack [scrollbar $w.t.scroll -width 3m -command "$w.t.text yview" \
	      -relief sunken -borderwidth 2] -side right -fill y
    pack [text $w.t.text -relief flat -width 70\
	      -setgrid 1 -yscroll "$w.t.scroll set"] \
        -side top -fill both -expand 1 -padx 5 -pady 5
    pack $w.t -side top -padx 10 -pady 10 -expand 1 -fill both

    frame $w.c -relief groove -borderwidth 2
    pack [button $w.c.quit -text Quit -width 10 -relief raised\
	      -borderwidth 1 -command "destroy $w"] \
        -side left -anchor c -expand 1 -pady 10

    pack [button $w.c.info -text "Further information about Gnuplot" \
	      -width 30 -relief raised -borderwidth 1 -command {
		  if ![catch {exec which gnuplot}] {
		      exec xterm -e info gnuplot &
		  } else {
		      tk_dialog .dialog "File not found" \
		"Error: the gnuplot program is not available to you." \
			  error 0 "OK"
		  }
	      } ] \
        -side left -anchor c -expand 1 -pady 10

    pack $w.c -side top -fill x -padx 10 -pady 10

    if [file exists $Xgpl(src)/xgpl.doc] then {
	set fid [open $Xgpl(src)/xgpl.doc r]
	$w.t.text insert 0.0 [read $fid]
	close $fid
    }

    $w.t.text configure -state disabled
}
