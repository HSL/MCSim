proc xgpl_Window3D { w } {

  global Xgpl

  catch {destroy $w}
  toplevel $w ; set title "Plot: 3D"
  wm title $w $title
  wm iconname $w $title
  wm iconbitmap $w @$Xgpl(bitmap)
  wm group $w .



  pack [frame $w.sur -relief groove -borderwidth 2] \
    -side top -fill x -padx 4 -pady 8
  pack [label $w.sur.map -text "  Mapping:  " -width 15 \
	      -anchor w -relief flat] -side left -anchor w -pady 4
  pack [radiobutton $w.sur.map1 -text "cartesian" -value cartesian \
	      -width 10 -relief flat -anchor w -variable Xgpl(smap)] \
      -side left -anchor w -pady 4
  pack [radiobutton $w.sur.map2 -text "spherical" -value spherical \
	      -width 10 -relief flat -anchor w -variable Xgpl(smap)] \
      -side left -anchor w -pady 4
  pack [radiobutton $w.sur.map3 -text "polar" -value polar \
	      -width 10 -relief flat -anchor w -variable Xgpl(smap)] \
      -side left -anchor w -pady 4
  pack [label $w.sur.iso -text "  Sampling:  " -width 10 \
	      -anchor e -relief flat] -side left -anchor w -pady 4
  pack [entry $w.sur.isos -relief sunken -width 8 -background white\
	      -textvariable Xgpl(isamp)] -side left -anchor w -pady 4
  
  pack [frame $w.cont -relief groove -borderwidth 2] \
      -side top -fill x -padx 4 -pady 4
  pack [frame $w.cont.top -relief flat] -side top -fill x -padx 2 -pady 2
  pack [checkbutton $w.cont.top.surf -text "Surface" \
	      -width 13 -relief flat -anchor w -variable Xgpl(surf)] \
      -side left -anchor w
#  pack [checkbutton $w.cont.top.hide -text "Hidden Line" \
 	      -width 13 -relief flat -anchor w -variable Xgpl(hidden)] \
       -side left -anchor w
  pack [checkbutton $w.cont.top.cont -text "Contour" \
	      -width 13 -relief flat -anchor w -variable Xgpl(cont)] \
      -side left -anchor w
  pack [checkbutton $w.cont.top.clabel -text "Label contours" \
	      -width 13 -relief flat -anchor w -variable Xgpl(clabel)] \
      -side left -anchor w

  pack [frame $w.cont.mid1 -relief flat] -side top -fill x -padx 2 -pady 2
  pack [label $w.cont.mid1.ctype -text "Contour type:" -width 15 \
	      -anchor w -relief flat] -side left -anchor w
  pack [radiobutton $w.cont.mid1.ctbase -text "Base" -value base \
	      -width 13 -relief flat -anchor w -variable Xgpl(ctype)] \
      -side left -anchor w
  pack [radiobutton $w.cont.mid1.ctsurface -text "Surface" -value surface\
	      -width 13 -relief flat -anchor w -variable Xgpl(ctype)] \
      -side left -anchor w
  pack [radiobutton $w.cont.mid1.ctboth -text "Both" -value both \
	      -width 13 -relief flat -anchor w -variable Xgpl(ctype)] \
      -side left -anchor w

  pack [frame $w.cont.lev1 -relief flat] -side top -fill x -padx 2 -pady 2
  pack [label $w.cont.lev1.cmeth -text "Contour method:" -width 15 \
	      -anchor w -relief flat] -side left -anchor w
  pack [radiobutton $w.cont.lev1.lin -text "Linear" -value linear \
	      -width 13 -relief flat -anchor w -variable Xgpl(cmode)] \
      -side left -anchor w
  pack [radiobutton $w.cont.lev1.bs -text "BSpline" -value bspline \
	      -width 13 -relief flat -anchor w -variable Xgpl(cmode)] \
      -side left -anchor w
  pack [radiobutton $w.cont.lev1.cs -text "CubicSpline" -value cubicspline \
	      -width 13 -relief flat -anchor w -variable Xgpl(cmode)] \
      -side left -anchor w

  pack [frame $w.cont.lev2 -relief flat] -side top -fill x -padx 2 -pady 2
  pack [label $w.cont.lev2.n -text "Number:" -width 15 \
	      -anchor w -relief flat] -side left -anchor w
  pack [entry $w.cont.lev2.ne -width 10 -relief sunken -background white\
	      -textvariable Xgpl(cont:n) ] -side left -anchor w
  pack [label $w.cont.lev2.pts -text "Points:" -width 15 \
	      -anchor c -relief flat] -side left -anchor w 
  pack [entry $w.cont.lev2.ptse -width 10 -relief sunken -background white\
	      -textvariable Xgpl(cont:points) ] -side left -anchor w
  pack [label $w.cont.lev2.ord -text "Order:" -width 15 \
	      -anchor c -relief flat] -side left -anchor w
  pack [entry $w.cont.lev2.orde -width 10 -relief sunken -background white\
	      -textvariable Xgpl(cont:order) ] -side left -anchor w

  pack [frame $w.cont.levs -relief flat] -side top -fill x -padx 2 -pady 6
  pack [radiobutton $w.cont.levs.auto -text "Automatic" -value auto \
	    -width 13 -relief flat -anchor w -variable Xgpl(cont:levm)] \
      -side left -anchor w
  pack [radiobutton $w.cont.levs.incr -text "Incremental" -value incremental \
	    -width 13 -relief flat -anchor w -variable Xgpl(cont:levm)] \
      -side left -anchor w
  pack [entry $w.cont.levs.incr1 -relief sunken -width 8 -background white\
	       -textvariable Xgpl(cont:lev1) ] -side left -anchor w -padx 2
  pack [entry $w.cont.levs.incr2 -relief sunken -width 8 -background white\
	       -textvariable Xgpl(cont:lev2) ] -side left -anchor w -padx 2
  pack [entry $w.cont.levs.incr3 -relief sunken -width 8 -background white\
	       -textvariable Xgpl(cont:lev3) ] -side left -anchor w -padx 2

  pack [frame $w.cont.levs2 -relief flat] -side top -fill x -padx 2 -pady 4
  pack [radiobutton $w.cont.levs2.desc -text "Discrete" -value discrete \
	       -width 15 -relief flat -anchor w -variable Xgpl(cont:levm)] \
      -side left -anchor w 
  pack [entry $w.cont.levs2.descr -relief sunken -width 30 \
	    -textvariable Xgpl(cont:levs) -background white] \
      -side left -anchor w  -padx 2 -fill x -expand 1

  pack [frame $w.view -relief groove -borderwidth 2] \
        -side top -fill x -padx 4 -pady 4
  pack [label $w.view.xrot -text "X-Rotation: " -width 12 \
          -anchor c -relief flat] -side left -anchor w -pady 4
  pack [entry $w.view.xrote -width 8 -relief sunken -background white\
          -textvariable Xgpl(view:xrot) ] -side left -anchor w -pady 4
  pack [label $w.view.zrot -text "Z-Rotation: " -width 12 \
          -anchor c -relief flat] -side left -anchor w -pady 4
  pack [entry $w.view.zrote -width 8 -relief sunken -background white\
          -textvariable Xgpl(view:zrot) ] -side left -anchor w -pady 4
  pack [label $w.view.xsc -text "X-Scale: " -width 10 \
	    -anchor c -relief flat] -side left -anchor w -pady 4
  pack [entry $w.view.xsce -width 8 -relief sunken -background white\
          -textvariable Xgpl(view:xsc) ] -side left -anchor w -pady 4
  pack [label $w.view.zsc -text "Z-Scale: " -width 10 \
          -anchor c -relief flat] -side left -anchor w -pady 4
  pack [entry $w.view.zsce -width 8 -relief sunken -background white\
          -textvariable Xgpl(view:zsc) ] -side left -anchor w -pady 4

  pack [frame $w.bar -relief flat] -side top -fill x -padx 2 -pady 2
  pack [button $w.bar.cancel -text Cancel -command "destroy $w" \
	      -width 10 -borderwidth 1 -relief raised] \
    -side left -expand 1 -pady 5
  pack [button $w.bar.ok -text OK -command "destroy $w" \
	    -width 10 -relief groove] \
    -side left -expand 1 -pady 5

  bind $w <Return> "tkButtonInvoke $w.bar.ok" 

  return
}
