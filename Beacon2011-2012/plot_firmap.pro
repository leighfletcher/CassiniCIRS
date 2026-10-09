resfile='results.dat'
npro=120
nref=npro+13
nobs=file_lines(resfile)/nref
c2h6scale=fltarr(nobs,2)
c2h2scale=fltarr(nobs,2)
c3h8scale=fltarr(nobs,2)
c4h2scale=fltarr(nobs,2)
c3h4scale=fltarr(nobs,2)
ph3vmr=fltarr(nobs,2)
ph3fsh=fltarr(nobs,2)

temp=fltarr(nobs,3,npro)
chisq=fltarr(nobs)

lon=fltarr(nobs)
openr,1,resfile


for iobs=0,nobs-1 do begin
    print,iobs
         res=strarr(10,nref)

    for iref=0,nref-1 do begin  
         input=''
         readf,1,input
         res1=strsplit(input,' ',/extract)
         n=size(res1)
         n1=n(1)
         if (n1 gt 0) then res[0:n1-1,iref]=res1
    endfor
     
     if res[3,2] ge 0 then lon[iobs]=res[3,2]
    if res[3,2] le 0 then lon[iobs]=360.+res[3,2]
        temp[iobs,*,*]=res[1:3,3:npro+2]
        ph3vmr[iobs,*]=res[1:2,npro+4]
        ph3fsh[iobs,*]=res[1:2,npro+5]


    c2h6scale[iobs,*]=0.44478E-05*res[1:2,npro+9]/1e-6
    c2h2scale[iobs,*]=0.31654E-06*res[1:2,npro+7]/1e-6
    c3h8scale[iobs,*]=1.25829e-07*res[1:2,npro+11]/1e-9
    ;c4h2scale[iobs,*]=0.64023E-10*res[1:2,npro+13]/1e-9
    ;c3h4scale[iobs,*]=0.98813E-10*res[1:2,npro+11]/1e-9
     chisq[iobs]=res[5,npro+12]
endfor

close,/all



long=float([-80 , -70 , -62 , -45 , -40 , -35 , -30 , -25 , -20 , -15 , -10 , -5 , 0 ,2 , 7 , 10 , 15 , 20 , 25 , 30 , 35 , 40 , 45 , 70])
nlon=n_elements(long)

;;   openr,1,'/home/fletcher/Saturn/MASTER/guerlet/methane_profile.txt'
;;   n=file_lines('/home/fletcher/Saturn/MASTER/guerlet/methane_profile.txt')
;;   data=fltarr(2,n)
;;   readf,1,data
;;   close,1
;;   press_bar=data[0,*]
;;   pressg=data[0,*]/1.01325
;;   data=fltarr(nlon,n)
;;
;;   openr,1,'/home/fletcher/Saturn/MASTER/guerlet/ethane_variations_nov08.txt'
;;   readf,1,data
;;   close,1
;;   c2h6g=data
;;   openr,1,'/home/fletcher/Saturn/MASTER/guerlet/acetylene_variations_nov08.txt'
;;   readf,1,data
;;   close,1
;;   c2h2g=data
;;   openr,1,'/home/fletcher/Saturn/MASTER/guerlet/propane_variations_nov08.txt'
;;   readf,1,data
;;   close,1
;;   c3h8g=data




xsize=18.0
ysize=8.0
xoffset=0.0
yoffset=0.0
outfile='hydrocarbons.eps'
set_plot,'ps'
device,filename=outfile,encapsulated=0,/color,xsize=xsize,ysize=ysize,xoffset=xoffset,yoffset=yoffset,bits_per_pixel=24
!p.multi=[0,1,1]
!p.font=0
charsize=1.1
!p.charsize=1.1


lonS=0
lonN=360




p=[-100,100]
e=[-32.1,-48.9,-60.3,-73.5]
w=[-40.7,-53.7,-69.2]
plot_lines=0

lon_keep=where(lon le lonN and lon ge lonS)

press=temp[0,0,*]
levels=[value_locate(press,0.2),value_locate(press,0.1),value_locate(press,5e-3),value_locate(press,1e-3),value_locate(press,5e-4)]
nlevels=n_elements(levels)
for ilevel=0,nlevels-1 do begin
    level=levels[ilevel]

    title=strcompress('Temperature Variation at '+string(sigfig(1000*temp(0,0,level),2))+' mbar')

    yrange=[min(temp(lon_keep,1,level)-temp(lon_keep,2,level)),max(temp(lon_keep,1,level)+temp(lon_keep,2,level))]
    plot,lon,temp[*,1,level],psym=2,thick=1.5,xstyle=1,ystyle=1,$
    xrange=[lonN,lonS],yrange=yrange,charsize=charsize,$
    xtitle='System III West Longitude',ytitle='Temperature (K)',$
    title=title,xtickinterval=20,xthick=2,ythick=2;,color=iobs*2
    errplot,lon,temp[*,1,level]-temp[*,2,level],temp[*,1,level]+temp[*,2,level],thick=1.5,color=100;
    oplot,[0,0],[0,1000],linestyle=2
    if (plot_lines eq 1) then begin
    for ie=0,3 do begin
        jet=[e[ie],e[ie]]
        oplot,jet,p,linestyle=2
    endfor
    for iw=0,2 do begin
        jet=[w[iw],w[iw]]
        oplot,jet,p,linestyle=1
    endfor
    endif

if sigfig(1000*temp(0,0,level),2) eq 1.1 then begin
            print,'Interpolating:'
            ilon=0.1*findgen(3601.)
            intemp=temp[*,1,level]
            inlon=lon
            s=sort(inlon)
            inlon=inlon(s)
            intemp=intemp(s)
            itemp=interpol(intemp,inlon,ilon,/spline)
            oplot,ilon,itemp,linestyle=1
        
            z=where(itemp ge 160.)
            if z[0] ge 0 then print,max(ilon(z)),min(ilon(z)),max(ilon(z))-min(ilon(z)),float(n_elements(z))/float(n_elements(itemp))*360.
            z=where(itemp ge 170.)
            if z[0] ge 0 then print,max(ilon(z)),min(ilon(z)),max(ilon(z))-min(ilon(z)),float(n_elements(z))/float(n_elements(itemp))*360.
        endif


endfor







nplots=7
for iplot=0,nplots-1 do begin
	if iplot eq 0 then data=c2h2scale
	if iplot eq 1 then data=c2h6scale
	if iplot eq 2 then data=c3h8scale
	if iplot eq 3 then data=c4h2scale
	if iplot eq 4 then data=c3h4scale
	if iplot eq 5 then data=ph3vmr
	if iplot eq 6 then data=ph3fsh

if iplot eq 0 then title='Acetylene (C!d2!nH!d2!n) Mole Fraction at 1.0 mbar'
if iplot eq 1 then title='Ethane (C!d2!nH!d6!n) Mole Fraction at 2.0 mbar'
if iplot eq 2 then title='Propane (C!d3!nH!d8!n) Mole Fraction at 1.0 mbar'
if iplot eq 3 then title='Diacetylene (C!d4!nH!d2!n) Mole Fraction at 1.0 mbar'
if iplot eq 4 then title='Methylacetylene (C!d3!nH!d4!n) Mole Fraction at 1.0 mbar'
if iplot eq 5 then title='Phosphine Mole Fraction at 1 bar'
if iplot eq 6 then title='Phosphine Fractional Scale Height'

if iplot eq 0 then ytitle='Mole Fraction (ppm)'
if iplot eq 1 then ytitle='Mole Fraction (ppm)'
if iplot eq 2 then ytitle='Mole Fraction (ppb)'
if iplot eq 3 then ytitle='Mole Fraction (ppb)'
if iplot eq 4 then ytitle='Mole Fraction (ppb)'
if iplot eq 5 then ytitle='Mole Fraction (ppm)'
if iplot eq 6 then ytitle='Fractional Scale Height'



yrange=[min(data[*,0]-data[*,1]),max(data[*,0]+data[*,1])]
if iplot eq 6 then yrange=[0,1]

plot,lon,data[*,0],psym=2,thick=1.5,xstyle=1,$
    xrange=[360,0],yrange=yrange,charsize=charsize,$
    xtitle='System III West Longitude',ytitle=ytitle,$
    title=title,xtickinterval=20,xthick=2,ythick=2;,color=iobs*2
    errplot,lon,data[*,0]-data[*,1],data[*,0]+data[*,1],thick=1.5,color=100;
oplot,[0,0],[0,1e3],linestyle=1

pcircle
;if iplot eq 0 then begin
;	res=min(abs(pressg-1e-3),ref)
;	print,pressg(ref)
;	oplot,long,c2h2g[*,ref]/1e-6,color=4,psym=8,symsize=0.6
;endif


;if iplot eq 1 then begin
;res=min(abs(pressg-2e-3),ref)
;print,pressg(ref)
;	oplot,long,c2h6g[*,ref]/1e-6,color=4,psym=8,symsize=0.6
;endif

;if iplot eq 2 then begin
;	res=min(abs(pressg-1e-3),ref)
;	print,pressg(ref)
;	oplot,long,c3h8g[*,ref]/1e-9,color=4,psym=8,symsize=0.6
;endif




endfor

plot,lon,chisq,psym=2,thick=1.5,xstyle=1,$
    xrange=[360,0],charsize=charsize,$
    xtitle='System III West Longitude',ytitle='!Mc!X!u2!n',$
    title='Goodness of Fit',xtickinterval=20,xthick=2,ythick=2;,color=iobs*2

; Contour Plot
; ########################################################################
; Colour Temperature


;!p.font=0

nlevels=30
clev = indgen(nlevels+1)


sorted=sort(lon)
newlon=lon(sorted)

newtemp=fltarr(n_elements(sorted),npro)
newtemp[*,*]=temp[sorted,1,*]


press=temp[0,0,*]

pmin=min(press)
pmax=max(press)
pmin=0.0001
pmax=1.0
;lonS=lon_start
;lonN=lon_stop

nlevels=30
clev = indgen(nlevels+1)
levels = 70+5*findgen(nlevels)
;levels=80+2*findgen(nlevels)
loadct,0
contour,newtemp,newlon,press,/ylog,/follow,title='Temperature from FP3/4',$
yrange=[pmax,pmin],xrange=[lonN,lonS],xstyle=1,ystyle=1,xtickinterval=20,$     
levels = levels,xtitle='System III West Longitude',ytitle='Pressure (bar)',$
xthick=2,ythick=2

loadct,33,ncolors=nlevels
contour,newtemp,newlon,press,/ylog,/follow,title='Temperature from FP3/4',$
yrange=[pmax,pmin],xrange=[lonN,lonS],xstyle=1,ystyle=1,xtickinterval=20,$     
levels = levels,xtitle='System III West Longitude',ytitle='Pressure (bar)',$
c_colors=clev,/overplot,thick=2,xthick=2,ythick=2,/cell_fill


loadct,0
contour,newtemp,newlon,press,/ylog,/follow,title=title,$
yrange=[pmax,pmin],xrange=[lonN,lonS],xstyle=1,ystyle=1,$     
levels = levels,xtitle='Latitude',ytitle='Pressure (bar)',/overplot



;polyfill,[lonN,lonS,lonS,lonN],[0.035,0.035,0.006,0.006],transparent=5,color=250
;xyouts,-60,0.02,'No Information',charsize=0.8

lr=[lonN,lonS]
axis,xaxis=0,xtickinterval=20,xthick=2,xstyle=1,xrange=lr
axis,yaxis=0,ythick=2,yrange=[pmax,pmin],ystyle=1
axis,xaxis=1,xtickinterval=20,xthick=2,xstyle=1,xrange=lr,xtickname=REPLICATE(' ', 20)
axis,yaxis=1,yrange=[pmax,pmin],ystyle=1,ytickname=REPLICATE(' ', 10),ythick=2

plotjets = 0
if (plotjets eq 1) then begin
p=[10,0.01]
e=[-32.1,-48.9,-60.3,-73.5]
w=[-40.7,-53.7,-69.2]

for ie=0,3 do begin
    jet=[e[ie],e[ie]]
    oplot,jet,p,linestyle=2
endfor
for iw=0,2 do begin
    jet=[w[iw],w[iw]]
    oplot,jet,p,linestyle=1
endfor
endif
; ########################################################################
; BW Temperature



press=temp[0,0,*]


;############################################

nlevels=30
clev = indgen(nlevels+1)
levels = 70+5*findgen(nlevels)
;levels=80+2*findgen(nlevels)


loadct,33,ncolors=nlevels
contour,newtemp,newlon,press,/ylog,$
yrange=[pmax,pmin],xrange=[lonN,lonS],xstyle=1,ystyle=1,xtickinterval=40,$     
levels = levels,xtitle='System III West Longitude',ytitle='Pressure (bar)',$
c_colors=clev,thick=3,xthick=2,ythick=2,/follow


loadct,0
contour,newtemp,newlon,press,/ylog,$
yrange=[pmax,pmin],xrange=[lonN,lonS],xstyle=1,ystyle=1,xtickinterval=40,$     
levels = levels,$
xthick=2,ythick=2,/nodata,c_colors=0,/overplot


lr=[lonN,lonS]
axis,xaxis=0,xtickinterval=40,xthick=2,xstyle=1,xrange=lr,xtitle='System III West Longitude'
axis,yaxis=0,ythick=2,yrange=[pmax,pmin],ystyle=1,ytitle='Pressure (bar)'
axis,xaxis=1,xtickinterval=40,xthick=2,xstyle=1,xrange=lr,xtickname=REPLICATE(' ', 20)
axis,yaxis=1,yrange=[pmax,pmin],ystyle=1,ytickname=REPLICATE(' ', 10),ythick=2


;############################################
plotjets = 0
if (plotjets eq 1) then begin
p=[10,0.01]
e=[-32.1,-48.9,-60.3,-73.5]
w=[-40.7,-53.7,-69.2]

for ie=0,3 do begin
    jet=[e[ie],e[ie]]
    oplot,jet,p,linestyle=2
endfor
for iw=0,2 do begin
    jet=[w[iw],w[iw]]
    oplot,jet,p,linestyle=1
endfor
endif


; ########################################################################


device,/close



end
