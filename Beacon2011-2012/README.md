# Saturn's Stratospheric Beacon

Leigh N. Fletcher, B.E. Hesman, R.K. Achterberg, P.G.J. Irwin, G. Bjoraker, N. Gorius, J. Hurley, J. Sinclair, G.S. Orton, J. Legarreta, E. García-Melendo, A. Sánchez-Lavega, P.L. Read, A.A. Simon-Miller, F.M. Flasar (2012), The origin and evolution of Saturn's 2011-2012 stratospheric vortex, Icarus, Volume 221, Issue 2, Pages 560-586,(https://doi.org/10.1016/j.icarus.2012.08.024)

Fig. 7 of that paper contained longitude-pressure cross sections of upper tropospheric and stratospheric temperatures throughout 2011 and 2012. Spectra were coadded between 30 and 50N. Blank sections indicated an absence of data at these longitudes. The drop in altitude during the merger can be seen by comparing 2011-March-04 with 2011-October-22. Post-merger, the altitude remained approximately constant but the longitudinal extent and peak temperatures cool with time.

In this directory, I provide the retrieved temperatures to generate those longitude-pressure cross-sections, along with some IDL code to read the output files (and to serve as a guide to their structure).  The retrievals were performed with datasets of different spectral resolution:  FIRMAPs (15 cm-1), MIRMAPs and MIRTMAPs (2.5 cm-1), and COMPSITs (0.5 cm-1), as described in the main article.  Each `results*.dat` file therefore contains a number of different dates (with apologies for subdividing in this way!).  Hopefully this will allow the user to reconstruct the contour plots in Fig. 7.

* FIRMAP:  dates=['2011aug21']
* MIRMAP:  dates=['2011mar15','2011may05','2011jul26','2011dec04','2012mar11']
* MIRTMAP: dates=['2010oct22','2011jan20','2011apr26','2011jul31','2011oct22']
* COMPSIT: dates=['2011jan02','2011mar04','2011jul08','2011sep10','2012jan13','2012jan20','2012feb16']

