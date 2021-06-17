# Saturn Seasonal Temperatures
Repository for Cassini Saturn temperature data based on Fletcher et al., 2018

**This is an update, based on work preparing for a new book chapter, Fletcher et al. (2020) https://arxiv.org/abs/2012.09288.

Fletcher et al. (2018) used data from Cassini's Composite Infrared Spectrometer (CIRS) to investigate the dynamics and composition of Saturn's atmosphere from 2004-2017.  This repository contains the interpolated temperature and composition field over the entire time series.  All CIRS interferograms were curtailed so that they all had the same spectral resolution (15 cm-1), and both PRIME observations and RIDERs (where CIRS observed simultaneously with other Cassini instruments) were included in this analysis.

Cassini/CIRS spectra were extracted from v4.3.4 of the database via a series of vanilla queries, and then averaged onto a monthly time grid and a 2-degree resolution latitude grid (stepped every 1 degree).  These averages were used to generate individual spectral files for input to the NEMESIS optimal estimation retrieval algorithm.  

# Reconstructed Temperatures
As described by Fletcher et al., 2018, the individual retrievals were used to generate a "reconstructed" temperature field, using tensioned splines to interpolate the temperatures with time.  These outputs are stored as `reconst_temp2020.sav'`, an IDL 'save' file.  

These contain the interpolated temperatures (FINALTEMP) as an NPROxNLATxNDAYS array, where NPRO=120 is the number of pressure levels (in atm) in the PRESS array; NLAT=181 is the number of latitudes in the NEWLAT array (planetographic); NDAYS=474 is the number of days (Julian date) in the NEWDAYS array.  

Note that dates before and after the Cassini/CIRS time series have been set to zero to avoid the temptation to extrapolate to other dates.

# Reconstructed Ethane and Acetylene
Finally, vertical distributions of ethane and acetylene were retrieved at the same time as temperature, and can be used to estimate the latitudinal and temporal changes in these hydrocarbons at a single pressure level.  This is the key change from 2018 - instead of simply scaling the profiles, I allowed the full profile to vary, so that pressures far away from the weighting function peak would stick to the prior.  In the `reconst_c2h2_2020.sav` and  `reconst_c2h6_2020.sav` files, we provide estimates of the abundance of each species in ppmv as a function of latitude, pressure, and time:

FINALCOMP       FLOAT     = Array[120, 181, 474]

NEWDAYS         FLOAT     = Array[474]

NEWLAT          FLOAT     = Array[181]

PRESS           FLOAT     = Array[120]



