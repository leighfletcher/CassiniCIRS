pro zreadspx,ifile,fwhm,xlat,xlon,ngeom,nconv,nav,wave,angles,spec,error


tmp = fltarr(4)
readf,ifile,tmp
fwhm=tmp(0)
xlat=tmp(1)
xlon=tmp(2)
ngeom = long(tmp(3))

;print,'NGEOM: ',ngeom
;iav = long(tmp(4))

;nloc = 1
;fovav = 0
;if(iav eq 1) then begin
; nloc = ngeom
; ngeom = 1
; fovav = 1
;endif

nconv=fltarr(ngeom)
wave = dblarr(ngeom,60000)
spec = fltarr(ngeom,60000)
error = fltarr(ngeom,60000)


   
for igeom=0,ngeom-1 do begin
    tmp=0.0
    ;print,igeom,ngeom
 readf,ifile,tmp
 nconv(igeom)=tmp
 ;print,nconv
 nav=0.0
 readf,ifile,nav
 if(igeom eq 0) then begin
  angles = fltarr(6,ngeom*nav)
  ang1 = fltarr(6)
 endif
 ;ang1 = fltarr(6)
 for a=0,nav-1 do begin
 	ang1 = fltarr(6)
 	readf,ifile,ang1
	;print,ang1
	j=igeom*nav+a
	;print,j
	angles[*,j]=ang1
 endfor
 spe=dblarr(3,nconv(igeom))
 readf,ifile,spe
 ;if(igeom eq 0) then wave = spe(0,*)
 wave(igeom,0:nconv(igeom)-1)=spe(0,*)
 spec(igeom,0:nconv(igeom)-1)=spe(1,*)
 error(igeom,0:nconv(igeom)-1)=spe(2,*)
endfor

maxi=max(nconv)
wave=wave(*,0:maxi-1)
spec=spec(*,0:maxi-1)
error=error(*,0:maxi-1)



;if(fovav eq 1) then ngeom = nloc

return

end
