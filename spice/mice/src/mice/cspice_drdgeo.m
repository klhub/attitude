%-Abstract
%
%   CSPICE_DRDGEO computes the Jacobian matrix of the transformation from
%   geodetic to rectangular coordinates.
%
%-Disclaimer
%
%   THIS SOFTWARE AND ANY RELATED MATERIALS WERE CREATED BY THE
%   CALIFORNIA  INSTITUTE OF TECHNOLOGY (CALTECH) UNDER A U.S.
%   GOVERNMENT CONTRACT WITH THE NATIONAL AERONAUTICS AND SPACE
%   ADMINISTRATION (NASA). THE SOFTWARE IS TECHNOLOGY AND SOFTWARE
%   PUBLICLY AVAILABLE UNDER U.S. EXPORT LAWS AND IS PROVIDED
%   "AS-IS" TO THE RECIPIENT WITHOUT WARRANTY OF ANY KIND, INCLUDING
%   ANY WARRANTIES OF PERFORMANCE OR MERCHANTABILITY OR FITNESS FOR
%   A PARTICULAR USE OR PURPOSE (AS SET FORTH IN UNITED STATES UCC
%   SECTIONS 2312-2313) OR FOR ANY PURPOSE WHATSOEVER, FOR THE
%   SOFTWARE AND RELATED MATERIALS, HOWEVER USED.
%
%   IN NO EVENT SHALL CALTECH, ITS JET PROPULSION LABORATORY,
%   OR NASA BE LIABLE FOR ANY DAMAGES AND/OR COSTS, INCLUDING,
%   BUT NOT LIMITED TO, INCIDENTAL OR CONSEQUENTIAL DAMAGES OF
%   ANY KIND, INCLUDING ECONOMIC DAMAGE OR INJURY TO PROPERTY
%   AND LOST PROFITS, REGARDLESS OF WHETHER CALTECH, JPL, OR
%   NASA BE ADVISED, HAVE REASON TO KNOW, OR, IN FACT, SHALL
%   KNOW OF THE POSSIBILITY.
%
%   RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE
%   OF THE SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO
%   INDEMNIFY CALTECH AND NASA FOR ALL THIRD-PARTY CLAIMS RESULTING
%   FROM THE ACTIONS OF RECIPIENT IN THE USE OF THE SOFTWARE.
%
%-I/O
%
%   Given:
%
%      lon      geodetic longitude(s) of point(s) (radians).
%
%               [1,n] = size(lon); double = class(lon)
%
%      lat      geodetic latitude(s) of point(s) (radians).
%
%               [1,n] = size(lat); double = class(lat)
%
%      alt      Altitude(s) of point(s) above the reference spheroid. Units of
%               `alt' must match those of `re'.
%
%               [1,n] = size(alt); double = class(alt)
%
%      re       equatorial radius of a reference spheroid.
%
%               [1,1] = size(re); double = class(re)
%
%               This spheroid is a volume of revolution: its horizontal cross
%               sections are circular. The shape of the spheroid is defined by
%               an equatorial radius `re' and a polar radius `rp'. Units of
%               `re' must match those of `alt'.
%
%      f        the flattening coefficient
%
%               [1,1] = size(f); double = class(f)
%
%                   f = (re-rp) / re
%
%               where `rp' is the polar radius of the spheroid. (More
%               importantly rp = re*(1-f).) The units of `rp' match those
%               of `re'.
%
%   the call:
%
%      [jacobi] = cspice_drdgeo( lon, lat, alt, re, f )
%
%   returns:
%
%      jacobi   the matrix(es) of partial derivatives of the conversion between
%               geodetic and rectangular coordinates.
%
%               If [1,1] = size(lon) then [3,3]   = size(jacobi)
%               If [1,n] = size(lon) then [3,3,n] = size(jacobi)
%                                          double = class(jacobi)
%
%               It has the form
%
%                 .-                             -.
%                 |  dx/dlon   dx/dlat  dx/dalt   |
%                 |                               |
%                 |  dy/dlon   dy/dlat  dy/dalt   |
%                 |                               |
%                 |  dz/dlon   dz/dlat  dz/dalt   |
%                 `-                             -'
%
%               evaluated at the input values of `lon', `lat' and `alt'.
%
%               The formulae for computing `x', `y', and `z' from
%               geodetic coordinates are given below.
%
%                  x = [alt +        re/g(lat,f)]*cos(lon)*cos(lat)
%
%
%                  y = [alt +        re/g(lat,f)]*sin(lon)*cos(lat)
%
%                                    2
%                  z = [alt + re*(1-f) /g(lat,f)]*         sin(lat)
%
%               where
%
%                   re is the polar radius of the reference spheroid.
%
%                   f  is the flattening factor (the polar radius is
%                       obtained by multiplying the equatorial radius by 1-f).
%
%                   g( lat, f ) is given by
%
%                                2             2     2
%                      sqrt ( cos (lat) + (1-f) * sin (lat) )
%
%               `jacobi' returns with the same vectorization measure (N)
%               as `lon', `lat' and `alt'.
%
%-Parameters
%
%   None.
%
%-Examples
%
%   Any numerical results shown for this example may differ between
%   platforms as the results depend on the SPICE kernels used as input
%   and the machine specific arithmetic implementation.
%
%   1) Find the geodetic state of the earth as seen from
%      Mars in the IAU_MARS reference frame at January 1, 2005 TDB.
%      Map this state back to rectangular coordinates as a check.
%
%      Use the meta-kernel shown below to load the required SPICE
%      kernels.
%
%
%         KPL/MK
%
%         File name: drdgeo_ex1.tm
%
%         This meta-kernel is intended to support operation of SPICE
%         example programs. The kernels shown here should not be
%         assumed to contain adequate or correct versions of data
%         required by SPICE-based user applications.
%
%         In order for an application to use this meta-kernel, the
%         kernels referenced here must be present in the user's
%         current working directory.
%
%         The names and contents of the kernels referenced
%         by this meta-kernel are as follows:
%
%            File name                     Contents
%            ---------                     --------
%            de421.bsp                     Planetary ephemeris
%            pck00010.tpc                  Planet orientation and
%                                          radii
%            naif0009.tls                  Leapseconds
%
%
%         \begindata
%
%            KERNELS_TO_LOAD = ( 'de421.bsp',
%                                'pck00010.tpc',
%                                'naif0009.tls'  )
%
%         \begintext
%
%         End of meta-kernel
%
%
%      Example code begins here.
%
%
%      function drdgeo_ex1()
%
%         %
%         % Load SPK, PCK, and LSK kernels, use a meta kernel for
%         % convenience.
%         %
%         cspice_furnsh( 'drdgeo_ex1.tm' );
%
%         %
%         % Look up the radii for Mars.  Although we
%         % omit it here, we could first call badkpv_c
%         % to make sure the variable BODY499_RADII
%         % has three elements and numeric data type.
%         % If the variable is not present in the kernel
%         % pool, cspice_bodvrd will signal an error.
%         %
%         [radii] = cspice_bodvrd( 'MARS', 'RADII', 3 );
%
%         %
%         % Compute flattening coefficient.
%         %
%         re =  radii(1);
%         rp =  radii(3);
%         f  =  ( re - rp ) / re;
%
%         %
%         % Look up the apparent state of earth as seen from Mars at
%         % January 1, 2005 TDB, relative to the IAU_MARS reference
%         % frame.
%         %
%         [et] = cspice_str2et( 'January 1, 2005 TDB' );
%
%         [state, lt] = cspice_spkezr( 'Earth', et,    'IAU_MARS',         ...
%                                      'LT+S',  'Mars'           );
%
%         %
%         % Convert position to geodetic coordinates.
%         %
%         [lon, lat, alt] = cspice_recgeo( state(1:3), re, f );
%
%         %
%         % Convert velocity to geodetic coordinates.
%         %
%         [jacobi] = cspice_dgeodr( state(1), state(2), state(3), re, f );
%
%         geovel   = jacobi * state(4:6);
%
%         %
%         % As a check, convert the geodetic state back to
%         % rectangular coordinates.
%         %
%         [rectan] = cspice_georec( lon, lat, alt, re, f );
%
%         [jacobi] = cspice_drdgeo( lon, lat, alt, re, f );
%
%         drectn   = jacobi * geovel;
%
%         fprintf( ' \n' )
%         fprintf( 'Rectangular coordinates:\n' )
%         fprintf( ' \n' )
%         fprintf( ' X (km)                 =  %17.8e\n', state(1) )
%         fprintf( ' Y (km)                 =  %17.8e\n', state(2) )
%         fprintf( ' Z (km)                 =  %17.8e\n', state(3) )
%         fprintf( ' \n' )
%         fprintf( 'Rectangular velocity:\n' )
%         fprintf( ' \n' )
%         fprintf( ' dX/dt (km/s)           =  %17.8e\n', state(4) )
%         fprintf( ' dY/dt (km/s)           =  %17.8e\n', state(5) )
%         fprintf( ' dZ/dt (km/s)           =  %17.8e\n', state(6) )
%         fprintf( ' \n' )
%         fprintf( 'Ellipsoid shape parameters: \n' )
%         fprintf( ' \n' )
%         fprintf( ' Equatorial radius (km) =  %17.8e\n', re )
%         fprintf( ' Polar radius      (km) =  %17.8e\n', rp )
%         fprintf( ' Flattening coefficient =  %17.8e\n', f )
%         fprintf( ' \n' )
%         fprintf( 'Geodetic coordinates:\n' )
%         fprintf( ' \n' )
%         fprintf( ' Longitude (deg)        =  %17.8e\n', lon / cspice_rpd )
%         fprintf( ' Latitude  (deg)        =  %17.8e\n', lat / cspice_rpd )
%         fprintf( ' Altitude  (km)         =  %17.8e\n', alt )
%         fprintf( ' \n' )
%         fprintf( 'Geodetic velocity:\n' )
%         fprintf( ' \n' )
%         fprintf( ' d Longitude/dt (deg/s) =  %17.8e\n',                  ...
%                                    geovel(1)/cspice_rpd )
%         fprintf( ' d Latitude/dt  (deg/s) =  %17.8e\n',                  ...
%                                    geovel(2)/cspice_rpd )
%         fprintf( ' d Altitude/dt  (km/s)  =  %17.8e\n', geovel(3) )
%         fprintf( ' \n' )
%         fprintf( 'Rectangular coordinates from inverse mapping:\n' )
%         fprintf( ' \n' )
%         fprintf( ' X (km)                 =  %17.8e\n', rectan(1) )
%         fprintf( ' Y (km)                 =  %17.8e\n', rectan(2) )
%         fprintf( ' Z (km)                 =  %17.8e\n', rectan(3) )
%         fprintf( ' \n' )
%         fprintf( 'Rectangular velocity from inverse mapping:\n' )
%         fprintf( ' \n' )
%         fprintf( ' dX/dt (km/s)           =  %17.8e\n', drectn(1) )
%         fprintf( ' dY/dt (km/s)           =  %17.8e\n', drectn(2) )
%         fprintf( ' dZ/dt (km/s)           =  %17.8e\n', drectn(3) )
%         fprintf( ' \n' )
%
%         %
%         % It's always good form to unload kernels after use,
%         % particularly in Matlab due to data persistence.
%         %
%         cspice_kclear
%
%
%      When this program was executed on a Mac/Intel/Octave6.x/64-bit
%      platform, the output was:
%
%
%      Rectangular coordinates:
%
%       X (km)                 =    -7.60961826e+07
%       Y (km)                 =     3.24363805e+08
%       Z (km)                 =     4.74704840e+07
%
%      Rectangular velocity:
%
%       dX/dt (km/s)           =     2.29520749e+04
%       dY/dt (km/s)           =     5.37601112e+03
%       dZ/dt (km/s)           =    -2.08811490e+01
%
%      Ellipsoid shape parameters:
%
%       Equatorial radius (km) =     3.39619000e+03
%       Polar radius      (km) =     3.37620000e+03
%       Flattening coefficient =     5.88600756e-03
%
%      Geodetic coordinates:
%
%       Longitude (deg)        =     1.03202903e+02
%       Latitude  (deg)        =     8.10898757e+00
%       Altitude  (km)         =     3.36531823e+08
%
%      Geodetic velocity:
%
%       d Longitude/dt (deg/s) =    -4.05392876e-03
%       d Latitude/dt  (deg/s) =    -3.31899337e-06
%       d Altitude/dt  (km/s)  =    -1.12116015e+01
%
%      Rectangular coordinates from inverse mapping:
%
%       X (km)                 =    -7.60961826e+07
%       Y (km)                 =     3.24363805e+08
%       Z (km)                 =     4.74704840e+07
%
%      Rectangular velocity from inverse mapping:
%
%       dX/dt (km/s)           =     2.29520749e+04
%       dY/dt (km/s)           =     5.37601112e+03
%       dZ/dt (km/s)           =    -2.08811490e+01
%
%
%-Particulars
%
%   It is often convenient to describe the motion of an object in
%   the geodetic coordinate system. However, when performing
%   vector computations its hard to beat rectangular coordinates.
%
%   To transform states given with respect to geodetic coordinates
%   to states with respect to rectangular coordinates, one makes use
%   of the Jacobian of the transformation between the two systems.
%
%   Given a state in geodetic coordinates
%
%        ( lon, lat, alt, dlon, dlat, dalt )
%
%   the velocity in rectangular coordinates is given by the matrix
%   equation:
%
%                  t          |                                 t
%      (dx, dy, dz)   = jacobi|             * (dlon, dlat, dalt)
%                             |(lon,lat,alt)
%
%
%   This routine computes the matrix
%
%            |
%      jacobi|
%            |(lon,lat,alt)
%
%-Exceptions
%
%   1)  If the flattening coefficient is greater than or equal to one,
%       the error SPICE(VALUEOUTOFRANGE) is signaled by a routine in
%       the call tree of this routine.
%
%   2)  If the equatorial radius is non-positive, the error
%       SPICE(BADRADIUS) is signaled by a routine in the call tree of
%       this routine.
%
%   3)  If any of the input arguments, `lon', `lat', `alt', `re' or
%       `f', is undefined, an error is signaled by the Matlab error
%       handling system.
%
%   4)  If any of the input arguments, `lon', `lat', `alt', `re' or
%       `f', is not of the expected type, or it does not have the
%       expected dimensions and size, an error is signaled by the Mice
%       interface.
%
%   5)  If the input vectorizable arguments `lon', `lat' and `alt' do
%       not have the same measure of vectorization (N), an error is
%       signaled by the Mice interface.
%
%-Files
%
%   None.
%
%-Restrictions
%
%   None.
%
%-Required_Reading
%
%   MICE.REQ
%
%-Literature_References
%
%   None.
%
%-Author_and_Institution
%
%   J. Diaz del Rio     (ODC Space)
%   S.C. Krening        (JPL)
%   E.D. Wright         (JPL)
%
%-Version
%
%   -Mice Version 1.1.0, 01-NOV-2021 (EDW) (JDR)
%
%       Edited the header to comply with NAIF standard. Added complete code
%       example.
%
%       Added -Parameters, -Exceptions, -Files, -Restrictions,
%       -Literature_References and -Author_and_Institution sections.
%
%       Eliminated use of "lasterror" in rethrow.
%
%       Removed reference to the function's corresponding CSPICE header from
%       -Required_Reading section.
%
%   -Mice Version 1.0.0, 12-MAR-2012 (EDW) (SCK)
%
%-Index_Entries
%
%   Jacobian of rectangular w.r.t. geodetic coordinates
%
%-&

function [jacobi] = cspice_drdgeo( lon, lat, alt, re, f )

   switch nargin
      case 5

         lon = zzmice_dp(lon);
         lat = zzmice_dp(lat);
         alt = zzmice_dp(alt);
         re  = zzmice_dp(re);
         f   = zzmice_dp(f);

      otherwise

         error( ['Usage: [_jacobi(3,3)_] = '...
                 'cspice_drdgeo( _lon_, _lat_, _alt_, re, f)'] )

   end

   %
   % Call the MEX library.
   %
   try
      [jacobi] = mice('drdgeo_c', lon, lat, alt, re, f);
   catch spiceerr
      rethrow(spiceerr)
   end
