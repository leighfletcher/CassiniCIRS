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
date=strarr(nobs)

temp=fltarr(nobs,3,npro)

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
     
     date[iobs]=res[0,1]
     
     if res[3,2] ge 0 then lon[iobs]=res[3,2]
    if res[3,2] le 0 then lon[iobs]=360.+res[3,2]
        temp[iobs,*,*]=res[1:3,3:npro+2]
        ph3vmr[iobs,*]=res[1:2,npro+4]
        ph3fsh[iobs,*]=res[1:2,npro+5]


    c2h6scale[iobs,*]=0.44478E-05*res[1:2,npro+7]/1e-6
    c2h2scale[iobs,*]=0.31654E-06*res[1:2,npro+9]/1e-6
    c3h8scale[iobs,*]=1.25829e-07*res[1:2,npro+11]/1e-9
  ;  c4h2scale[iobs,*]=0.64023E-10*res[1:2,npro+13]/1e-9
  ;  c3h4scale[iobs,*]=0.98813E-10*res[1:2,npro+11]/1e-9

endfor

close,/all



long=float([-80 , -70 , -62 , -45 , -40 , -35 , -30 , -25 , -20 , -15 , -10 , -5 , 0 ,2 , 7 , 10 , 15 , 20 , 25 , 30 , 35 , 40 , 45 , 70])
nlon=n_elements(long)



dates=['2010oct22','2011jan20','2011apr26','2011jul31','2011oct22']


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


for id=0,4 do begin
    if id eq 0 then kd=where(date eq '2010oct22')
    if id eq 1 then kd=where(date eq '2011jan20')
    if id eq 2 then kd=where(date eq '2011apr26')
    if id eq 3 then kd=where(date eq '2011jul31')
    if id eq 4 then kd=where(date eq '2011oct22')


    temp1=temp[kd,*,*]
    ph3vmr1=ph3vmr[kd,*]
    ph3fsh1=ph3fsh[kd,*]
    lon1=lon[kd]
    c2h6scale1=c2h6scale[kd,*]
    c2h2scale1=c2h2scale[kd,*]
    c3h8scale1=c3h8scale[kd,*]





press=temp1[0,0,*]
levels=[value_locate(press,0.2),value_locate(press,0.1),value_locate(press,5e-3),value_locate(press,1e-3),value_locate(press,5e-4)]


nlevels=n_elements(levels)
for ilevel=0,nlevels-1 do begin
    level=levels[ilevel]

    title=strcompress(dates[id]+' Temperature Variation at '+string(sigfig(1000*temp1(0,0,level),2))+' mbar')

    yrange=[min(temp1(lon_keep,1,level)-temp1(lon_keep,2,level)),max(temp1(lon_keep,1,level)+temp1(lon_keep,2,level))]
    plot,lon1,temp1[*,1,level],psym=2,thick=1.5,xstyle=1,ystyle=1,$
    xrange=[lonN,lonS],yrange=yrange,charsize=charsize,$
    xtitle='System III West Longitude',ytitle='Temperature (K)',$
    title=title,xtickinterval=20,xthick=2,ythick=2;,color=iobs*2
    errplot,lon1,temp1[*,1,level]-temp1[*,2,level],temp1[*,1,level]+temp1[*,2,level],thick=1.5,color=100;
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

if sigfig(1000*temp1(0,0,level),2) eq 1.1 then begin
            print,'Interpolating:',dates[id]
            ilon=0.1*findgen(3601.)
            intemp=temp1[*,1,level]
            inlon=lon1
            s=sort(inlon)
            inlon=inlon(s)
            intemp=intemp(s)
            itemp=interpol(intemp,inlon,ilon)
            oplot,ilon,itemp,linestyle=1
        
            z=where(itemp ge 160.)
            if z[0] ge 0 then print,max(ilon(z)),min(ilon(z)),max(ilon(z))-min(ilon(z)),float(n_elements(z))/float(n_elements(itemp))*360.
            z=where(itemp ge 170.)
            if z[0] ge 0 then print,max(ilon(z)),min(ilon(z)),max(ilon(z))-min(ilon(z)),float(n_elements(z))/float(n_elements(itemp))*360.
        
        endif

endfor







nplots=7
for iplot=0,nplots-1 do begin
	if iplot eq 0 then data=c2h2scale1
	if iplot eq 1 then data=c2h6scale1
	if iplot eq 2 then data=c3h8scale1
	if iplot eq 3 then data=c3h8scale1
	if iplot eq 4 then data=c3h8scale1
	if iplot eq 5 then data=ph3vmr1
	if iplot eq 6 then data=ph3fsh1

if iplot eq 0 then title=dates[id]+' Acetylene (C!d2!nH!d2!n) Mole Fraction at 1.0 mbar'
if iplot eq 1 then title=dates[id]+' Ethane (C!d2!nH!d6!n) Mole Fraction at 2.0 mbar'
if iplot eq 2 then title=dates[id]+' Propane (C!d3!nH!d8!n) Mole Fraction at 1.0 mbar'
if iplot eq 3 then title=dates[id]+' Diacetylene (C!d4!nH!d2!n) Mole Fraction at 1.0 mbar'
if iplot eq 4 then title=dates[id]+' Methylacetylene (C!d3!nH!d4!n) Mole Fraction at 1.0 mbar'
if iplot eq 5 then title=dates[id]+' Phosphine Mole Fraction at 1 bar'
if iplot eq 6 then title=dates[id]+' Phosphine Fractional Scale Height'

if iplot eq 0 then ytitle='Mole Fraction (ppm)'
if iplot eq 1 then ytitle='Mole Fraction (ppm)'
if iplot eq 2 then ytitle='Mole Fraction (ppb)'
if iplot eq 3 then ytitle='Mole Fraction (ppb)'
if iplot eq 4 then ytitle='Mole Fraction (ppb)'
if iplot eq 5 then ytitle='Mole Fraction (ppm)'
if iplot eq 6 then ytitle='Fractional Scale Height'



yrange=[min(data[*,0]-data[*,1]),max(data[*,0]+data[*,1])]
if iplot eq 6 then yrange=[0,1]

plot,lon1,data[*,0],psym=2,thick=1.5,xstyle=1,$
    xrange=[360,0],yrange=yrange,charsize=charsize,$
    xtitle='System III West Longitude',ytitle=ytitle,$
    title=title,xtickinterval=20,xthick=2,ythick=2;,color=iobs*2
    errplot,lon1,data[*,0]-data[*,1],data[*,0]+data[*,1],thick=1.5,color=100;
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


; Contour Plot
; ########################################################################
; Colour Temperature


;!p.font=0

nlevels=30
clev = indgen(nlevels+1)


sorted=sort(lon1)
newlon=lon1(sorted)

newtemp=fltarr(n_elements(sorted),npro)
newtemp[*,*]=temp1[sorted,1,*]


press=temp1[0,0,*]

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
contour,newtemp,newlon,press,/ylog,/follow,title=dates[id]+' Temperature from FP3/4',$
yrange=[pmax,pmin],xrange=[lonN,lonS],xstyle=1,ystyle=1,xtickinterval=20,$     
levels = levels,xtitle='System III West Longitude',ytitle='Pressure (bar)',$
xthick=2,ythick=2

loadct,33,ncolors=nlevels
contour,newtemp,newlon,press,/ylog,/follow,title=dates[id]+' Temperature from FP3/4',$
yrange=[pmax,pmin],xrange=[lonN,lonS],xstyle=1,ystyle=1,xtickinterval=20,$     
levels = levels,xtitle='System III West Longitude',ytitle='Pressure (bar)',$
c_colors=clev,/overplot,thick=2,xthick=2,ythick=2,/cell_fill


loadct,0
contour,newtemp,newlon,press,/ylog,/follow,title=title,$
yrange=[pmax,pmin],xrange=[lonN,lonS],xstyle=1,ystyle=1,$     
levels = levels,xtitle='Latitude',ytitle='Pressure (bar)',/overplot


if id eq 0 then lonA=180    ;d=where(date eq '2010oct22')
if id eq 1 then lonA=80    ;d=where(date eq '2011jan20')
if id eq 2 then lonA=155    ;d=where(date eq '2011apr26')
if id eq 3 then lonA=360    ;d=where(date eq '2011jul31')
if id eq 4 then lonA=265    ;d=where(date eq '2011oct22')
if id eq 0 then lonB=20    ;d=where(date eq '2010oct22')
if id eq 1 then lonB=40    ;d=where(date eq '2011jan20')
if id eq 2 then lonB=0    ;d=where(date eq '2011apr26')
if id eq 3 then lonB=320    ;d=where(date eq '2011jul31')
if id eq 4 then lonB=55    ;d=where(date eq '2011oct22')


polyfill,[lonA,lonB,lonB,lonA],[1.,1.,0.0001,0.0001],transparent=5,color=250
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



press=temp1[0,0,*]

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

if id eq 0 then lonA=180    ;d=where(date eq '2010oct22')
if id eq 1 then lonA=80    ;d=where(date eq '2011jan20')
if id eq 2 then lonA=155    ;d=where(date eq '2011apr26')
if id eq 3 then lonA=360    ;d=where(date eq '2011jul31')
if id eq 4 then lonA=265    ;d=where(date eq '2011oct22')
if id eq 0 then lonB=20    ;d=where(date eq '2010oct22')
if id eq 1 then lonB=40    ;d=where(date eq '2011jan20')
if id eq 2 then lonB=0    ;d=where(date eq '2011apr26')
if id eq 3 then lonB=320    ;d=where(date eq '2011jul31')
if id eq 4 then lonB=55    ;d=where(date eq '2011oct22')


polyfill,[lonA,lonB,lonB,lonA],[1.,1.,0.0001,0.0001],transparent=5,color=250

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


endfor

; ########################################################################


device,/close



end
