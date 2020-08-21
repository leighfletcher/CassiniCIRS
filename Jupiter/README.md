**Repository of Jupiter Cassini Observations, 2000**

This directory contains retrieved atmospheric properties and input CIRS spectra
from the ATMOS2A map of Jupiter obtained by Cassini CIRS in December 2000 (Fletcher et al. (2016,
https://arxiv.org/abs/1606.05498).  

* `atmos2A_v4.2_temp.eps` is a version of the T(p) profile compared to the
locations of the cloud-tracked wind jets.

* `atmos2A_v4.2_results.eps` is a multi-level EPS file containing the retrieved
temperatures at multiple levels, parameters representing the ammonia and
phosphine distrutions, a scaled cumulative aerosol opacity, and scaled profiles
of ethane and acetylene.  I will upload text-based versions of this figure in
the future.

* `atmos2A_v4.2/` contains the spectra used in the retrieval, binned by latitude from the
raw binaries extracted from the CIRS database.  These consist of two large
arrays (3 x nconv, where nconv is the number of points in the spectrum), one for
FP3 (600-1100 cm-1) and one for FP4 (1100-1400 cm-1).  These are separate
because the viewing geometry (given by the row immediately above each 3xnconv
array) is slightly different for the two focal planes. The top row gives the FWHM of the spectrum, the
mean latitude, the mean longitude, and the number of spectra in the file (2).  The
next row gives nconv for the following array.  Then the viewing geometry is a
6-element array containing the latitude, longitude, solar angle, emission angle,
 azimuthal angle, and a weight (usually one) for that spectrum.  The 3xnconv
 array contains the wavenumber, spectral radiance (W/cm2/sr/cm-1) and its
 uncertainty.
 
* `zreadspx.pro` is a subroutine that gives a better idea of how to read the
 individual spectra.
 
* `rawbinaries_v4.2/` contains the raw output from a vanilla query to the CIRS
database (this needs better commenting).  All four of the 2.5 cm-1 ATMOS maps
from December-January 2000 are stored here.


