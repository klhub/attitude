%-Abstract
%
%   MICE_SUBPNT computes the rectangular coordinates of the
%   sub-observer point on a target body at a specified epoch,
%   optionally corrected for light time and stellar aberration.
%
%   The surface of the target body may be represented by a triaxial
%   ellipsoid or by topographic data provided by DSK files.
%
%   This routine supersedes mice_subpt, which does not have an input
%   argument for the target body-fixed frame name.
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
%      method   a short string providing parameters defining
%               the computation method to be used.
%
%               [1,c1] = size(method); char = class(method)
%
%                  or
%
%               [1,1] = size(method); cell = class(method)
%
%               In the syntax descriptions below, items delimited by brackets
%               are optional.
%
%               `method' may be assigned the following values:
%
%                  'NEAR POINT/ELLIPSOID'
%
%                     The sub-observer point computation uses a
%                     triaxial ellipsoid to model the surface of the
%                     target body. The sub-observer point is defined
%                     as the nearest point on the target relative to
%                     the observer.
%
%                     The word 'NADIR' may be substituted for the phrase
%                     'NEAR POINT' in the string above.
%
%                     For backwards compatibility, the older syntax
%
%                        'Near point: ellipsoid'
%
%                     is accepted as well.
%
%
%                  'INTERCEPT/ELLIPSOID'
%
%                     The sub-observer point computation uses a
%                     triaxial ellipsoid to model the surface of the
%                     target body. The sub-observer point is defined
%                     as the target surface intercept of the line
%                     containing the observer and the target's
%                     center.
%
%                     For backwards compatibility, the older syntax
%
%                        'Intercept: ellipsoid'
%
%                     is accepted as well.
%
%
%                  'NADIR/DSK/UNPRIORITIZED[/SURFACES = <surface list>]'
%
%                     The sub-observer point computation uses DSK data
%                     to model the surface of the target body. The
%                     sub-observer point is defined as the intercept, on
%                     the surface represented by the DSK data, of the
%                     line containing the observer and the nearest point
%                     on the target's reference ellipsoid. If multiple
%                     such intercepts exist, the one closest to the
%                     observer is selected.
%
%                     Note that this definition of the sub-observer
%                     point is not equivalent to the "nearest point on
%                     the surface to the observer." The phrase 'NEAR
%                     POINT' may NOT be substituted for 'NADIR' in the
%                     string above.
%
%                     The surface list specification is optional. The
%                     syntax of the list is
%
%                        <surface 1> [, <surface 2>...]
%
%                     If present, it indicates that data only for the
%                     listed surfaces are to be used; however, data
%                     need not be available for all surfaces in the
%                     list. If absent, loaded DSK data for any surface
%                     associated with the target body are used.
%
%                     The surface list may contain surface names or
%                     surface ID codes. Names containing blanks must
%                     be delimited by double quotes, for example
%
%                        'SURFACES = "Mars MEGDR 128 PIXEL/DEG"'
%
%                     If multiple surfaces are specified, their names
%                     or IDs must be separated by commas.
%
%                     See the -Particulars section below for details
%                     concerning use of DSK data.
%
%
%                  'INTERCEPT/DSK/UNPRIORITIZED[/SURFACES = <surface list>]'
%
%                     The sub-observer point computation uses DSK data
%                     to model the surface of the target body. The
%                     sub-observer point is defined as the target
%                     surface intercept of the line containing the
%                     observer and the target's center.
%
%                     If multiple such intercepts exist, the one closest
%                     to the observer is selected.
%
%                     The surface list specification is optional. The
%                     syntax of the list is identical to that for the
%                     NADIR option described above.
%
%
%               Neither case nor white space are significant in
%               `method', except within double-quoted strings. For
%               example, the string ' eLLipsoid/nearpoint ' is valid.
%
%               Within double-quoted strings, blank characters are
%               significant, but multiple consecutive blanks are
%               considered equivalent to a single blank. Case is
%               not significant. So
%
%                  "Mars MEGDR 128 PIXEL/DEG"
%
%               is equivalent to
%
%                  " mars megdr  128  pixel/deg "
%
%               but not to
%
%                  "MARS MEGDR128PIXEL/DEG"
%
%      target   the name of the target body.
%
%               [1,c2] = size(target); char = class(target)
%
%                  or
%
%               [1,1] = size(target); cell = class(target)
%
%               The target body is an ephemeris object (its trajectory is
%               given by SPK data), and is an extended object.
%
%               The string `target' is case-insensitive, and leading
%               and trailing blanks in `target' are not significant.
%               Optionally, you may supply a string containing the
%               integer ID code for the object. For example both
%               'MOON' and '301' are legitimate strings that indicate
%               the moon is the target body.
%
%               When the target body's surface is represented by a
%               tri-axial ellipsoid, this routine assumes that a
%               kernel variable representing the ellipsoid's radii is
%               present in the kernel pool. Normally the kernel
%               variable would be defined by loading a PCK file.
%
%      et       the epoch(s), expressed as seconds past
%               J2000 TDB, of the observer: `et' is
%               the epoch at which the observer's state is computed.
%
%               [1,n] = size(et); double = class(et)
%
%               When aberration corrections are not used, `et' is also
%               the epoch at which the position and orientation of
%               the target body are computed.
%
%               When aberration corrections are used, `et' is the epoch
%               at which the observer's state relative to the solar
%               system barycenter is computed; in this case the
%               position and orientation of the target body are
%               computed at et-lt or et+lt, where `lt' is the one-way
%               light time between the sub-observer point and the
%               observer, and the sign applied to `lt' depends on the
%               selected correction. See the description of `abcorr'
%               below for details.
%
%      fixref   the name of a body-fixed reference frame centered
%               on the target body.
%
%               [1,c3] = size(fixref); char = class(fixref)
%
%                  or
%
%               [1,1] = size(fixref); cell = class(fixref)
%
%               `fixref' may be any such frame supported by the SPICE system,
%               including built-in frames (documented in the Frames Required
%               Reading) and frames defined by a loaded frame kernel (FK).
%               The string `fixref' is case-insensitive, and leading and
%               trailing blanks in `fixref' are not significant.
%
%               The output sub-observer point `spoint' and the
%               observer-to-sub-observer point vector `srfvec' will be
%               expressed relative to this reference frame.
%
%      abcorr   the aberration correction to apply when computing the
%               observer-target state and the orientation of the target body.
%
%               [1,c4] = size(abcorr); char = class(abcorr)
%
%                  or
%
%               [1,1] = size(abcorr); cell = class(abcorr)
%
%               For remote sensing applications, where the apparent
%               sub-observer point seen by the observer is desired,
%               normally either of the corrections
%
%                     'LT+S'
%                     'CN+S'
%
%               should be used. These and the other supported options
%               are described below. `abcorr' may be any of the
%               following:
%
%                     'NONE'     Apply no correction. Return the
%                                geometric sub-observer point on the
%                                target body.
%
%               Let `lt' represent the one-way light time between the
%               observer and the sub-observer point (note: NOT
%               between the observer and the target body's center).
%               The following values of `abcorr' apply to the
%               "reception" case in which photons depart from the
%               sub-observer point's location at the light-time
%               corrected epoch et-lt and *arrive* at the observer's
%               location at `et':
%
%                     'LT'       Correct for one-way light time (also
%                                called "planetary aberration") using a
%                                Newtonian formulation. This correction
%                                yields the location of sub-observer
%                                point at the moment it emitted photons
%                                arriving at the observer at `et'.
%
%                                The light time correction uses an
%                                iterative solution of the light time
%                                equation. The solution invoked by the
%                                'LT' option uses one iteration.
%
%                                Both the target position as seen by the
%                                observer, and rotation of the target
%                                body, are corrected for light time.
%
%                     'LT+S'     Correct for one-way light time and
%                                stellar aberration using a Newtonian
%                                formulation. This option modifies the
%                                state obtained with the 'LT' option to
%                                account for the observer's velocity
%                                relative to the solar system
%                                barycenter. The result is the apparent
%                                sub-observer point as seen by the
%                                observer.
%
%                     'CN'       Converged Newtonian light time
%                                correction. In solving the light time
%                                equation, the 'CN' correction iterates
%                                until the solution converges. Both the
%                                position and rotation of the target
%                                body are corrected for light time.
%
%                     'CN+S'     Converged Newtonian light time and
%                                stellar aberration corrections. This
%                                option produces a solution that is at
%                                least as accurate at that obtainable
%                                with the 'LT+S' option. Whether the 'CN+S'
%                                solution is substantially more accurate
%                                depends on the geometry of the
%                                participating objects and on the
%                                accuracy of the input data. In all
%                                cases this routine will execute more
%                                slowly when a converged solution is
%                                computed.
%
%               The following values of `abcorr' apply to the
%               "transmission" case in which photons *depart* from
%               the observer's location at `et' and arrive at the
%               sub-observer point at the light-time corrected epoch
%               et+lt:
%
%                     'XLT'      "Transmission" case: correct for
%                                one-way light time using a Newtonian
%                                formulation. This correction yields the
%                                sub-observer location at the moment it
%                                receives photons emitted from the
%                                observer's location at `et'.
%
%                                The light time correction uses an
%                                iterative solution of the light time
%                                equation. The solution invoked by the
%                                'LT' option uses one iteration.
%
%                                Both the target position as seen by the
%                                observer, and rotation of the target
%                                body, are corrected for light time.
%
%                     'XLT+S'    "Transmission" case: correct for
%                                one-way light time and stellar
%                                aberration using a Newtonian
%                                formulation  This option modifies the
%                                sub-observer point obtained with the
%                                'XLT' option to account for the
%                                observer's velocity relative to the
%                                solar system barycenter.
%
%                     'XCN'      Converged Newtonian light time
%                                correction. This is the same as XLT
%                                correction but with further iterations
%                                to a converged Newtonian light time
%                                solution.
%
%                     'XCN+S'    "Transmission" case: converged
%                                Newtonian light time and stellar
%                                aberration corrections.
%
%      obsrvr   the scalar string name of the observing body.
%
%               [1,c5] = size(obsrvr); char = class(obsrvr)
%
%                  or
%
%               [1,1] = size(obsrvr); cell = class(obsrvr)
%
%               The observing body is an ephemeris object: it typically
%               is a spacecraft, the earth, or a surface point on the
%               earth. `obsrvr' is case-insensitive, and leading and
%               `obsrvr' are not significant. Optionally, you may
%               trailing blanks in supply a string containing the integer
%               ID code for the object. For example both 'MOON' and '301'
%               are legitimate strings that indicate the Moon is the
%               observer.
%
%   the call:
%
%      [subpnt] = mice_subpnt( method, target, et, fixref, abcorr, obsrvr )
%
%   returns:
%
%      subpnt   the structure(s) containing the results of the calculation.
%
%               [1,n] = size(subpnt); struct = class(subpnt)
%
%               Each structure consists of the fields:
%
%                  spoint   the array defining the sub-observer point on the
%                           target body.
%
%                           [3,1]  = size(subpnt(i).spoint);
%                           double = class(subpnt(i).spoint)
%
%                           For target shapes modeled by ellipsoids, the
%                           sub-observer point is defined either as the point
%                           on the target body that is closest to the
%                           observer, or the target surface intercept of the
%                           line from the observer to the target's center.
%
%                           For target shapes modeled by topographic data
%                           provided by DSK files, the sub-observer point is
%                           defined as the target surface intercept of the
%                           line from the observer to either the nearest
%                           point on the reference ellipsoid, or to the
%                           target's center. If multiple such intercepts
%                           exist, the one closest to the observer is
%                           selected.
%
%                           The input argument `method' selects the target
%                           shape model and sub-observer point definition to
%                           be used.
%
%                           `spoint' is expressed in Cartesian coordinates,
%                           relative to the body-fixed target frame designated
%                           by `fixref'. The body-fixed target frame is
%                           evaluated at the sub-observer epoch `trgepc'
%                           (see description below).
%
%                           When light time correction is used, the duration
%                           of light travel between `spoint' to the observer
%                           is considered to be the one way light time.
%
%                           When aberration corrections are used, `spoint'
%                           is computed using target body position and
%                           orientation that have been adjusted for the
%                           corrections applicable to `spoint' itself
%                           rather than to the target body's center. In
%                           particular, if the stellar aberration correction
%                           applicable to `spoint' is represented by a shift
%                           vector `s', then the light-time corrected
%                           position of the target is shifted by `s' before
%                           the sub-observer point is computed.
%
%                           The components of `spoint' have units of km.
%
%                  trgepc   the "sub-observer point epoch."
%
%                           [1,1]  = size(subpnt(i).trgepc);
%                           double = class(subpnt(i).trgepc)
%
%                           `trgepc' is defined as follows: letting `lt' be
%                           the one-way `trgepc' is the epoch et-lt, et+lt,
%                           or `et' depending on whether the requested
%                           aberration correction is, respectively, for
%                           received radiation, transmitted radiation, or
%                           omitted. `lt' is computed using the method
%                           indicated by `abcorr'.
%
%                           `trgepc' is expressed as seconds past J2000 TDB.
%
%                  srfvec   the array defining the position vector from
%                           the observer at `et' to `spoint'.
%
%                           [3,1]  = size(subpnt(i).srfvec);
%                           double = class(subpnt(i).srfvec)
%
%                           `srfvec' is expressed in the target body-fixed
%                           reference frame designated by `fixref', evaluated
%                           at `trgepc'.
%
%                           The components of `srfvec' are given in units of
%                           km.
%
%                           One can use the Matlab function norm to obtain the
%                           distance between the observer and `spoint':
%
%                              dist = norm( subpnt(i).srfvec )
%
%                           The observer's position `obspos', relative to the
%                           target body's center, where the center's position
%                           is corrected for aberration effects as indicated
%                           by `abcorr', can be computed with:
%
%                              obspos =  subpnt(i).spoint - subpnt(i).srfvec
%
%                           To transform the vector `srfvec' from a reference
%                           frame `fixref' at time `trgepc' to a
%                           time-dependent reference frame `ref' at time `et',
%                           the routine cspice_pxfrm2 should be called. Let
%                           `xform' be the 3x3 matrix representing the
%                           rotation from the reference frame `fixref' at time
%                           `trgepc' to the reference frame `ref' at time
%                           `et'. Then `srfvec' can be transformed to the
%                           result `refvec' as follows:
%
%                              xform  = cspice_pxfrm2( fixref, ref,        ...
%                                                      subpnt(i).trgepc, et );
%                              refvec = xform * srfvec;
%
%
%               `subpnt' return with the same vectorization measure, N, as
%               `et'.
%
%-Parameters
%
%   None.
%
%-Examples
%
%   Any numerical results shown for these examples may differ between
%   platforms as the results depend on the SPICE kernels used as input
%   and the machine specific arithmetic implementation.
%
%   1) Find the sub-Earth point on Mars for a specified time.
%
%      Compute the sub-Earth points using both triaxial ellipsoid
%      and topographic surface models. Topography data are provided by
%      a DSK file. For the ellipsoid model, use both the "intercept"
%      and "near point" sub-observer point definitions; for the DSK
%      case, use both the "intercept" and "nadir" definitions.
%
%      Display the locations of both the Earth and the sub-Earth
%      point relative to the center of Mars, in the IAU_MARS
%      body-fixed reference frame, using both planetocentric and
%      planetographic coordinates.
%
%      The topographic model is based on data from the MGS MOLA DEM
%      megr90n000cb, which has a resolution of 4 pixels/degree. A
%      triangular plate model was produced by computing a 720 x 1440
%      grid of interpolated heights from this DEM, then tessellating
%      the height grid. The plate model is stored in a type 2 segment
%      in the referenced DSK file.
%
%      Use the meta-kernel shown below to load the required SPICE
%      kernels.
%
%
%         KPL/MK
%
%         File: subpnt_ex1.tm
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
%            File name                        Contents
%            ---------                        --------
%            de430.bsp                        Planetary ephemeris
%            mar097.bsp                       Mars satellite ephemeris
%            pck00010.tpc                     Planet orientation and
%                                             radii
%            naif0011.tls                     Leapseconds
%            megr90n000cb_plate.bds           Plate model based on
%                                             MEGDR DEM, resolution
%                                             4 pixels/degree.
%
%         \begindata
%
%            KERNELS_TO_LOAD = ( 'de430.bsp',
%                                'mar097.bsp',
%                                'pck00010.tpc',
%                                'naif0011.tls',
%                                'megr90n000cb_plate.bds' )
%         \begintext
%
%         End of meta-kernel
%
%
%      Example code begins here.
%
%
%      function subpnt_ex1()
%
%         %
%         % Load kernel files via the meta-kernel.
%         %
%         cspice_furnsh( 'subpnt_ex1.tm' );
%
%         %
%         % Convert the UTC request time to ET (seconds past
%         % J2000, TDB).
%         %
%         et = cspice_str2et( '2008 aug 11 00:00:00' );
%
%         %
%         % Look up the target body's radii. We'll use these to
%         % convert Cartesian to planetodetic coordinates. Use
%         % the radii to compute the flattening coefficient of
%         % the reference ellipsoid.
%         %
%         radii  = cspice_bodvrd( 'MARS', 'RADII', 3 );
%
%         %
%         % Let `re' and `rp' be, respectively, the equatorial and
%         % polar radii of the target.
%         %
%         re = radii(1);
%         rp = radii(3);
%         f = ( re-rp)/re;
%
%         %
%         % Compute sub-observer point using light time and stellar
%         % aberration corrections. Use both ellipsoid and DSK
%         % shape models, and use all of the "near point,"
%         % "intercept," and "nadir" sub-observer point definitions.
%         %
%         method = { 'Intercept: ellipsoid',                               ...
%                    'Near point: ellipsoid',                              ...
%                    'Intercept/DSK/Unprioritized',                        ...
%                    'Nadir/DSK/Unprioritized'      };
%
%         for i=1:4
%
%            subpnt = mice_subpnt( method(i), 'MARS', et,                  ...
%                                 'IAU_MARS', 'LT+S', 'EARTH' );
%
%            %
%            % Expand the embedded data arrays to properly shaped
%            % generic arrays.
%            %
%            spoint   = reshape( [subpnt.spoint], 3, [] );
%            trgepc   = reshape( [subpnt.trgepc], 1, [] );
%            srfvec   = reshape( [subpnt.srfvec], 3, [] );
%
%            %
%            % Convert the sub-observer point's rectangular coordinates
%            % to planetographic longitude, latitude and altitude.
%            % Convert radians to degrees.
%            %
%            [spglon, spglat, spgalt] = cspice_recpgr( 'mars', spoint,     ...
%                                                       re,    f     );
%
%            spglon = spglon * cspice_dpr;
%            spglat = spglat * cspice_dpr;
%
%            %
%            % Convert sub-observer point's rectangular coordinates to
%            % planetocentric radius, longitude, and latitude. Convert
%            % radians to degrees.
%            %
%            [spcrad, spclon, spclat] =cspice_reclat( spoint ) ;
%
%            spclon = spclon * cspice_dpr;
%            spclat = spclat * cspice_dpr;
%
%            %
%            % Compute the observer's position relative to the center of the
%            % target, where the center's location has been adjusted using
%            % the aberration corrections applicable to the sub-point.
%            % Express the observer's location in geodetic coordinates.
%            %
%            obspos = spoint - srfvec;
%
%            [opglon, opglat, opgalt] = cspice_recpgr( 'mars', obspos,     ...
%                                                      re,     f      );
%
%            opglon = opglon * cspice_dpr;
%            opglat = opglat * cspice_dpr;
%
%            %
%            % Convert the observer's rectangular coordinates to planetodetic
%            % longitude, latitude and altitude. Convert radians to degrees.
%            %
%            [opcrad, opclon, opclat] = cspice_reclat( obspos ) ;
%
%            opclon = opclon * cspice_dpr;
%            opclat = opclat * cspice_dpr;
%
%            %
%            % Write the results.
%            %
%            fprintf( 'Computational Method = %s\n\n', char(method(i)) )
%
%            fprintf(                                                      ...
%               'Observer altitude                      (km) = %21.9f\n',  ...
%                                                                opgalt )
%
%            fprintf(                                                      ...
%               'Length of SRFVEC                       (km) = %21.9f\n',  ...
%                                                          norm(srfvec) )
%
%            fprintf(                                                      ...
%               'Sub-observer point altitude            (km) = %21.9f\n',  ...
%                                                                spgalt )
%
%            fprintf(                                                      ...
%               'Sub-observer planetographic longitude (deg) = %21.9f\n',  ...
%                                                                spglon )
%
%            fprintf(                                                      ...
%               'Observer planetographic longitude     (deg) = %21.9f\n',  ...
%                                                                opglon )
%
%            fprintf(                                                      ...
%               'Sub-observer planetographic latitude  (deg) = %21.9f\n',  ...
%                                                                spglat )
%
%            fprintf(                                                      ...
%               'Observer planetographic latitude      (deg) = %21.9f\n',  ...
%                                                                opglat )
%
%            fprintf(                                                      ...
%               'Sub-observer planetocentric longitude (deg) = %21.9f\n',  ...
%                                                                spclon )
%
%            fprintf(                                                      ...
%               'Observer planetocentric longitude     (deg) = %21.9f\n',  ...
%                                                                opclon )
%
%            fprintf(                                                      ...
%               'Sub-observer planetocentric latitude  (deg) = %21.9f\n',  ...
%                                                                spclat )
%
%            fprintf(                                                      ...
%               'Observer planetocentric latitude      (deg) = %21.9f\n',  ...
%                                                                opclat )
%
%            fprintf( '\n')
%
%         end
%
%         %
%         % It's always good form to unload kernels after use,
%         % particularly in MATLAB due to data persistence.
%         %
%         cspice_kclear
%
%
%      When this program was executed on a Mac/Intel/Octave6.x/64-bit
%      platform, the output was:
%
%
%      Computational Method = Intercept: ellipsoid
%
%      Observer altitude                      (km) =   349199089.540938914
%      Length of SRFVEC                       (km) =   349199089.577634573
%      Sub-observer point altitude            (km) =          -0.000000000
%      Sub-observer planetographic longitude (deg) =         199.302305032
%      Observer planetographic longitude     (deg) =         199.302305032
%      Sub-observer planetographic latitude  (deg) =          26.262401237
%      Observer planetographic latitude      (deg) =          25.994936751
%      Sub-observer planetocentric longitude (deg) =         160.697694968
%      Observer planetocentric longitude     (deg) =         160.697694968
%      Sub-observer planetocentric latitude  (deg) =          25.994934171
%      Observer planetocentric latitude      (deg) =          25.994934171
%
%      Computational Method = Near point: ellipsoid
%
%      Observer altitude                      (km) =   349199089.540930629
%      Length of SRFVEC                       (km) =   349199089.540930629
%      Sub-observer point altitude            (km) =          -0.000000000
%      Sub-observer planetographic longitude (deg) =         199.302305032
%      Observer planetographic longitude     (deg) =         199.302305032
%      Sub-observer planetographic latitude  (deg) =          25.994936751
%      Observer planetographic latitude      (deg) =          25.994936751
%      Sub-observer planetocentric longitude (deg) =         160.697694968
%      Observer planetocentric longitude     (deg) =         160.697694968
%      Sub-observer planetocentric latitude  (deg) =          25.729407227
%      Observer planetocentric latitude      (deg) =          25.994934171
%
%      Computational Method = Intercept/DSK/Unprioritized
%
%      Observer altitude                      (km) =   349199089.541009188
%      Length of SRFVEC                       (km) =   349199091.785398602
%      Sub-observer point altitude            (km) =          -2.207669751
%      Sub-observer planetographic longitude (deg) =         199.302305002
%      Observer planetographic longitude     (deg) =         199.302305002
%      Sub-observer planetographic latitude  (deg) =          26.262576677
%      Observer planetographic latitude      (deg) =          25.994936751
%      Sub-observer planetocentric longitude (deg) =         160.697694998
%      Observer planetocentric longitude     (deg) =         160.697694998
%      Sub-observer planetocentric latitude  (deg) =          25.994934171
%      Observer planetocentric latitude      (deg) =          25.994934171
%
%      Computational Method = Nadir/DSK/Unprioritized
%
%      Observer altitude                      (km) =   349199089.540999591
%      Length of SRFVEC                       (km) =   349199091.707164168
%      Sub-observer point altitude            (km) =          -2.166164622
%      Sub-observer planetographic longitude (deg) =         199.302305004
%      Observer planetographic longitude     (deg) =         199.302305003
%      Sub-observer planetographic latitude  (deg) =          25.994936751
%      Observer planetographic latitude      (deg) =          25.994936751
%      Sub-observer planetocentric longitude (deg) =         160.697694996
%      Observer planetocentric longitude     (deg) =         160.697694997
%      Sub-observer planetocentric latitude  (deg) =          25.729237570
%      Observer planetocentric latitude      (deg) =          25.994934171
%
%
%   2) Use mice_subpnt to find the sub-spacecraft point on Mars for the
%      Mars Reconnaissance Orbiter spacecraft (MRO) at a specified time,
%      using both the 'Ellipsoid/Near point' computation method and an
%      ellipsoidal target shape, and the 'DSK/Unprioritized/Nadir'
%      method and a DSK-based shape model.
%
%      Use both LT+S and CN+S aberration corrections to illustrate
%      the differences.
%
%      Convert the spacecraft to sub-observer point vector obtained from
%      mice_subpnt into the MRO_HIRISE_LOOK_DIRECTION reference frame at
%      the observation time. Perform a consistency check with this
%      vector: compare the Mars surface intercept of the ray emanating
%      from the spacecraft and pointed along this vector with the
%      sub-observer point.
%
%      Perform the sub-observer point and surface intercept computations
%      using both triaxial ellipsoid and topographic surface models.
%
%      For this example, the topographic model is based on the MGS MOLA
%      DEM megr90n000eb, which has a resolution of 16 pixels/degree.
%      Eight DSKs, each covering longitude and latitude ranges of 90
%      degrees, were made from this data set. For the region covered by
%      a given DSK, a grid of approximately 1500 x 1500 interpolated
%      heights was produced, and this grid was tessellated using
%      approximately 4.5 million triangular plates, giving a total plate
%      count of about 36 million for the entire DSK set.
%
%      All DSKs in the set use the surface ID code 499001, so there is
%      no need to specify the surface ID in the `method' strings passed
%      to cspice_sincpt and mice_subpnt.
%
%      Use the meta-kernel shown below to load the required SPICE
%      kernels.
%
%
%         KPL/MK
%
%         File name: subpnt_ex2.tm
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
%            File name                        Contents
%            ---------                        --------
%            de430.bsp                        Planetary ephemeris
%            mar097.bsp                       Mars satellite ephemeris
%            pck00010.tpc                     Planet orientation and
%                                             radii
%            naif0011.tls                     Leapseconds
%            mro_psp4_ssd_mro95a.bsp          MRO ephemeris
%            mro_v11.tf                       MRO frame specifications
%            mro_sclkscet_00022_65536.tsc     MRO SCLK coefficients
%                                             parameters
%            mro_sc_psp_070925_071001.bc      MRO attitude
%            megr90n000eb_*_plate.bds         Plate model DSKs based
%                                             on MEGDR DEM, resolution
%                                             16 pixels/degree.
%
%         \begindata
%
%            KERNELS_TO_LOAD = (
%
%               'de430.bsp',
%               'mar097.bsp',
%               'pck00010.tpc',
%               'naif0011.tls',
%               'mro_psp4_ssd_mro95a.bsp',
%               'mro_v11.tf',
%               'mro_sclkscet_00022_65536.tsc',
%               'mro_sc_psp_070925_071001.bc',
%               'megr90n000eb_LL000E00N_UR090E90N_plate.bds'
%               'megr90n000eb_LL000E90S_UR090E00S_plate.bds'
%               'megr90n000eb_LL090E00N_UR180E90N_plate.bds'
%               'megr90n000eb_LL090E90S_UR180E00S_plate.bds'
%               'megr90n000eb_LL180E00N_UR270E90N_plate.bds'
%               'megr90n000eb_LL180E90S_UR270E00S_plate.bds'
%               'megr90n000eb_LL270E00N_UR360E90N_plate.bds'
%               'megr90n000eb_LL270E90S_UR360E00S_plate.bds'  )
%
%         \begintext
%
%         End of meta-kernel
%
%
%      Example code begins here.
%
%
%      function subpnt_ex2()
%
%         %
%         % Local constants
%         %
%         META  = 'subpnt_ex2.tm';
%         NCORR = 2;
%         NMETH = 2;
%
%         %
%         % Local variables
%         %
%         abcorr = { 'LT+S', 'CN+S' };
%         fixref = 'IAU_MARS';
%         sinmth = { 'Ellipsoid', 'DSK/Unprioritized' };
%         submth = { 'Ellipsoid/Near point', 'DSK/Unprioritized/Nadir' };
%
%         %
%         % Load kernel files via the meta-kernel.
%         %
%         cspice_furnsh( META );
%
%         %
%         % Convert the TDB request time string to seconds past
%         % J2000, TDB.
%         %
%         [et] = cspice_str2et( '2007 SEP 30 00:00:00 TDB' );
%
%         %
%         % Compute the sub-spacecraft point using each method.
%         % Compute the results using both LT+S and CN+S aberration
%         % corrections.
%         %
%         for i=1:NMETH
%
%            fprintf( '\n' )
%            fprintf( 'Sub-observer point computation method = %s\n',      ...
%                                                          char(submth(i)) )
%
%            for j=1:NCORR
%               [subpnt] = mice_subpnt( submth(i), 'mars',    et,          ...
%                                       fixref,    abcorr(j), 'mro' );
%
%               %
%               % Compute the observer's altitude above `spoint'.
%               %
%               alt = cspice_vnorm( subpnt.srfvec );
%
%               %
%               % Express `srfvec' in the MRO_HIRISE_LOOK_DIRECTION
%               % reference frame at epoch `et'. Since `srfvec' is expressed
%               % relative to the IAU_MARS frame at `trgepc', we must call
%               % cspice_pxfrm2 to compute the position transformation matrix
%               % from IAU_MARS at `trgepc' to the MRO_HIRISE_LOOK_DIRECTION
%               % frame at time `et'.
%               %
%               % To make code formatting a little easier, we'll store
%               % the long MRO reference frame name in a variable:
%               %
%               hiref   = 'MRO_HIRISE_LOOK_DIRECTION';
%
%               [xform] = cspice_pxfrm2( 'iau_mars',    hiref,             ...
%                                        subpnt.trgepc, et    );
%               mrovec  = xform * subpnt.srfvec;
%
%               %
%               % Convert sub-observer point rectangular coordinates to
%               % planetocentric latitude and longitude. Convert radians to
%               % degrees.
%               %
%               [radius, lon, lat] = cspice_reclat( subpnt.spoint );
%
%               lon *= cspice_dpr;
%               lat *= cspice_dpr;
%
%               %
%               % Write the results.
%               %
%               fprintf( '\n' )
%               fprintf( '   Aberration correction = %s\n', char(abcorr(j)) )
%               fprintf( '\n' )
%               fprintf( '      MRO-to-sub-observer vector in\n' )
%               fprintf( '      MRO HIRISE look direction frame\n' )
%               fprintf( [ '         X-component             (km)',        ...
%                          ' = %21.9f\n' ], mrovec(1)              )
%               fprintf( [ '         Y-component             (km)',        ...
%                          ' = %21.9f\n' ], mrovec(2)              )
%               fprintf( [ '         Z-component             (km)',        ...
%                          ' = %21.9f\n' ], mrovec(3)              )
%               fprintf( [ '      Sub-observer point radius  (km)',        ...
%                          ' = %21.9f\n' ], radius                 )
%               fprintf( [ '      Planetocentric latitude   (deg)',        ...
%                          ' = %21.9f\n' ], lat                    )
%               fprintf( [ '      Planetocentric longitude  (deg)',        ...
%                          ' = %21.9f\n' ], lon                    )
%               fprintf( [ '      Observer altitude          (km)',        ...
%                          ' = %21.9f\n' ], alt                    )
%
%               %
%               % Consistency check: find the surface intercept on
%               % Mars of the ray emanating from the spacecraft and having
%               % direction vector `mrovec' in the MRO HIRISE look direction
%               % reference frame at `et'. Call the intercept point
%               % `xpoint'. `xpoint' should coincide with `spoint', up to a
%               % small round-off error.
%               %
%               [xpoint, xepoch,                                           ...
%                xvec,   found]  = cspice_sincpt( sinmth(i), 'mars',       ...
%                                                 et,        'iau_mars',   ...
%                                                 abcorr(j), 'mro',        ...
%                                                 hiref,     mrovec      );
%
%               if (  ~ found )
%                  fprintf( 'Bug: no intercept\n' )
%               else
%
%                  %
%                  % Report the distance between `xpoint' and `spoint'.
%                  %
%                  fprintf( [ '      Intercept comparison error (km) =',   ...
%                             ' %21.9f\n' ],                               ...
%                              cspice_vdist( xpoint, subpnt.spoint )    )
%                  fprintf( '\n' )
%               end
%            end
%         end
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
%      Sub-observer point computation method = Ellipsoid/Near point
%
%         Aberration correction = LT+S
%
%            MRO-to-sub-observer vector in
%            MRO HIRISE look direction frame
%               X-component             (km) =           0.286933229
%               Y-component             (km) =          -0.260425939
%               Z-component             (km) =         253.816326385
%            Sub-observer point radius  (km) =        3388.299078378
%            Planetocentric latitude   (deg) =         -38.799836378
%            Planetocentric longitude  (deg) =        -114.995297227
%            Observer altitude          (km) =         253.816622175
%            Intercept comparison error (km) =           0.000002144
%
%
%         Aberration correction = CN+S
%
%            MRO-to-sub-observer vector in
%            MRO HIRISE look direction frame
%               X-component             (km) =           0.286933107
%               Y-component             (km) =          -0.260426683
%               Z-component             (km) =         253.816315915
%            Sub-observer point radius  (km) =        3388.299078376
%            Planetocentric latitude   (deg) =         -38.799836382
%            Planetocentric longitude  (deg) =        -114.995297449
%            Observer altitude          (km) =         253.816611705
%            Intercept comparison error (km) =           0.000000001
%
%
%      Sub-observer point computation method = DSK/Unprioritized/Nadir
%
%         Aberration correction = LT+S
%
%            MRO-to-sub-observer vector in
%            MRO HIRISE look direction frame
%               X-component             (km) =           0.282372596
%               Y-component             (km) =          -0.256289313
%               Z-component             (km) =         249.784871247
%            Sub-observer point radius  (km) =        3392.330239436
%            Planetocentric latitude   (deg) =         -38.800230156
%            Planetocentric longitude  (deg) =        -114.995297338
%            Observer altitude          (km) =         249.785162334
%            Intercept comparison error (km) =           0.000002412
%
%
%         Aberration correction = CN+S
%
%            MRO-to-sub-observer vector in
%            MRO HIRISE look direction frame
%               X-component             (km) =           0.282372464
%               Y-component             (km) =          -0.256290075
%               Z-component             (km) =         249.784860121
%            Sub-observer point radius  (km) =        3392.330239564
%            Planetocentric latitude   (deg) =         -38.800230162
%            Planetocentric longitude  (deg) =        -114.995297569
%            Observer altitude          (km) =         249.785151209
%            Intercept comparison error (km) =           0.000000001
%
%
%-Particulars
%
%   A sister version of this routine exists named cspice_subpnt that returns
%   the structure field data as separate arguments.
%
%   Alternatively, if needed, the user can extract the field data from
%   vectorized `spoint' structures into separate arrays:
%
%      Extract the `spoint' field data to a 3X1 array `spoint':
%
%         spoint = reshape( [subpnt(:).spoint], 3, [] )
%
%      Extract the `trgepc' field data to a scalar `trgepc':
%
%         trgepc = reshape( [subpnt(:).trgepc], 1, [] )
%
%      Extract the `spoint' field data to a 3X1 array `spoint':
%
%         spoint = reshape( [subpnt(:).spoint], 3, [] )
%
%
%   For ellipsoidal target bodies, there are two different popular
%   ways to define the sub-observer point: "nearest point on the
%   target to the observer" or "target surface intercept of the line
%   containing observer and target." These coincide when the target
%   is spherical and generally are distinct otherwise.
%
%   For target body shapes modeled using topographic data provided by
%   DSK files, the "surface intercept" notion is valid, but the
%   "nearest point on the surface" computation is both inefficient to
%   execute and may fail to yield a result that is "under" the
%   observer in an intuitively clear way. The NADIR option for DSK
%   shapes instead finds the surface intercept of a ray that passes
%   through the nearest point on the target reference ellipsoid. For
%   shapes modeled using topography, there may be multiple
%   ray-surface intercepts; the closest one to the observer is
%   selected.
%
%   The NADIR definition makes sense only if the target shape is
%   reasonably close to the target's reference ellipsoid. If the
%   target is very different---the nucleus of comet
%   Churyumov-Gerasimenko is an example---the intercept definition
%   should be used.
%
%   This routine computes light time corrections using light time
%   between the observer and the sub-observer point, as opposed to
%   the center of the target. Similarly, stellar aberration
%   corrections done by this routine are based on the direction of
%   the vector from the observer to the light-time corrected
%   sub-observer point, not to the target center. This technique
%   avoids errors due to the differential between aberration
%   corrections across the target body. Therefore it's valid to use
%   aberration corrections with this routine even when the observer
%   is very close to the sub-observer point, in particular when the
%   observer to sub-observer point distance is much less than the
%   observer to target center distance.
%
%   When comparing sub-observer point computations with results from
%   sources other than SPICE, it's essential to make sure the same
%   geometric definitions are used.
%
%
%   Using DSK data
%   ==============
%
%      DSK loading and unloading
%      -------------------------
%
%      DSK files providing data used by this routine are loaded by
%      calling cspice_furnsh and can be unloaded by calling cspice_unload or
%      cspice_kclear. See the documentation of cspice_furnsh for limits on
%      numbers of loaded DSK files.
%
%      For run-time efficiency, it's desirable to avoid frequent
%      loading and unloading of DSK files. When there is a reason to
%      use multiple versions of data for a given target body---for
%      example, if topographic data at varying resolutions are to be
%      used---the surface list can be used to select DSK data to be
%      used for a given computation. It is not necessary to unload
%      the data that are not to be used. This recommendation presumes
%      that DSKs containing different versions of surface data for a
%      given body have different surface ID codes.
%
%
%      DSK data priority
%      -----------------
%
%      A DSK coverage overlap occurs when two segments in loaded DSK
%      files cover part or all of the same domain---for example, a
%      given longitude-latitude rectangle---and when the time
%      intervals of the segments overlap as well.
%
%      When DSK data selection is prioritized, in case of a coverage
%      overlap, if the two competing segments are in different DSK
%      files, the segment in the DSK file loaded last takes
%      precedence. If the two segments are in the same file, the
%      segment located closer to the end of the file takes
%      precedence.
%
%      When DSK data selection is unprioritized, data from competing
%      segments are combined. For example, if two competing segments
%      both represent a surface as sets of triangular plates, the
%      union of those sets of plates is considered to represent the
%      surface.
%
%      Currently only unprioritized data selection is supported.
%      Because prioritized data selection may be the default behavior
%      in a later version of the routine, the UNPRIORITIZED keyword is
%      required in the `method' argument.
%
%
%      Syntax of the `method' input argument
%      -------------------------------------
%
%      The keywords and surface list in the `method' argument
%      are called "clauses." The clauses may appear in any
%      order, for example
%
%         'NADIR/DSK/UNPRIORITIZED/<surface list>'
%         'DSK/NADIR/<surface list>/UNPRIORITIZED'
%         'UNPRIORITIZED/<surface list>/DSK/NADIR'
%
%      The simplest form of the `method' argument specifying use of
%      DSK data is one that lacks a surface list, for example:
%
%         'NADIR/DSK/UNPRIORITIZED'
%         'INTERCEPT/DSK/UNPRIORITIZED'
%
%      For applications in which all loaded DSK data for the target
%      body are for a single surface, and there are no competing
%      segments, the above strings suffice. This is expected to be
%      the usual case.
%
%      When, for the specified target body, there are loaded DSK
%      files providing data for multiple surfaces for that body, the
%      surfaces to be used by this routine for a given call must be
%      specified in a surface list, unless data from all of the
%      surfaces are to be used together.
%
%      The surface list consists of the string
%
%         'SURFACES = '
%
%      followed by a comma-separated list of one or more surface
%      identifiers. The identifiers may be names or integer codes in
%      string format. For example, suppose we have the surface
%      names and corresponding ID codes shown below:
%
%         Surface Name                              ID code
%         ------------                              -------
%         "Mars MEGDR 128 PIXEL/DEG"                1
%         "Mars MEGDR 64 PIXEL/DEG"                 2
%         "Mars_MRO_HIRISE"                         3
%
%      If data for all of the above surfaces are loaded, then
%      data for surface 1 can be specified by either
%
%         'SURFACES = 1'
%
%      or
%
%         'SURFACES = "Mars MEGDR 128 PIXEL/DEG"'
%
%      Double quotes are used to delimit the surface name
%      because it contains blank characters.
%
%      To use data for surfaces 2 and 3 together, any
%      of the following surface lists could be used:
%
%         'SURFACES = 2, 3'
%
%         'SURFACES = "Mars MEGDR  64 PIXEL/DEG", 3'
%
%         'SURFACES = 2, Mars_MRO_HIRISE'
%
%         'SURFACES = "Mars MEGDR 64 PIXEL/DEG", Mars_MRO_HIRISE'
%
%      An example of a `method' argument that could be constructed
%      using one of the surface lists above is
%
%      'NADIR/DSK/UNPRIORITIZED/SURFACES= "Mars MEGDR 64 PIXEL/DEG",3'
%
%
%      Aberration corrections
%      ----------------------
%
%      For irregularly shaped target bodies, the distance between the
%      observer and the nearest surface intercept need not be a
%      continuous function of time; hence the one-way light time
%      between the intercept and the observer may be discontinuous as
%      well. In such cases, the computed light time, which is found
%      using iterative algorithm, may converge slowly or not at all.
%      In all cases, the light time computation will terminate, but
%      the result may be less accurate than expected.
%
%-Exceptions
%
%   1)  If the specified aberration correction is unrecognized, an
%       error is signaled by a routine in the call tree of this
%       routine.
%
%   2)  If either the target or observer input strings cannot be
%       converted to an integer ID code, the error
%       SPICE(IDCODENOTFOUND) is signaled by a routine in the call
%       tree of this routine.
%
%   3)  If `obsrvr' and `target' map to the same NAIF integer ID code, the
%       error SPICE(BODIESNOTDISTINCT) is signaled by a routine in the
%       call tree of this routine.
%
%   4)  If the input target body-fixed frame `fixref' is not recognized,
%       the error SPICE(NOFRAME) is signaled by a routine in the call
%       tree of this routine. A frame name may fail to be recognized
%       because a required frame specification kernel has not been
%       loaded; another cause is a misspelling of the frame name.
%
%   5)  If the input frame `fixref' is not centered at the target body,
%       the error SPICE(INVALIDFRAME) is signaled by a routine in the
%       call tree of this routine.
%
%   6)  If the input argument `method' is not recognized, the error
%       SPICE(INVALIDMETHOD) is signaled by this routine, or, the
%       error is signaled by a routine in the call tree of this
%       routine.
%
%   7)  If the sub-observer point type is not specified or is not
%       recognized, the error SPICE(INVALIDSUBTYPE) is signaled by a
%       routine in the call tree of this routine.
%
%   8)  If the target and observer have distinct identities but are at
%       the same location (for example, the target is Mars and the
%       observer is the Mars barycenter), the error
%       SPICE(NOSEPARATION) is signaled by a routine in the call tree
%       of this routine.
%
%   9)  If insufficient ephemeris data have been loaded prior to
%       calling cspice_subpnt, an error is signaled by a
%       routine in the call tree of this routine. Note that when
%       light time correction is used, sufficient ephemeris data must
%       be available to propagate the states of both observer and
%       target to the solar system barycenter.
%
%   10) If the computation method specifies an ellipsoidal target
%       shape and triaxial radii of the target body have not been
%       loaded into the kernel pool prior to calling cspice_subpnt, an error
%       is signaled by a routine in the call tree of this routine.
%
%   11) The target must be an extended body, and must have a shape
%       for which a sub-observer point can be defined.
%
%       If the target body's shape is modeled as an ellipsoid, and if
%       any of the radii of the target body are non-positive, an error
%       is signaled by a routine in the call tree of this routine.
%
%       If the target body's shape is modeled by DSK data, the shape
%       must be such that the specified sub-observer point
%       definition is applicable. For example, if the target shape
%       is a torus, both the NADIR and INTERCEPT definitions might
%       be inapplicable, depending on the relative locations of the
%       observer and target.
%
%   12) If PCK data specifying the target body-fixed frame orientation
%       have not been loaded prior to calling cspice_subpnt, an error is
%       signaled by a routine in the call tree of this routine.
%
%   13) If `method' specifies that the target surface is represented by
%       DSK data, and no DSK files are loaded for the specified
%       target, an error is signaled by a routine in the call tree
%       of this routine.
%
%   14) If `method' specifies that the target surface is represented by
%       DSK data, and the ray from the observer to the sub-observer
%       point doesn't intersect the target body's surface, the error
%       SPICE(SUBPOINTNOTFOUND) is signaled by a routine in the call
%       tree of this routine.
%
%   15) If the surface intercept on the target body's reference
%       ellipsoid of the observer to target center vector cannot not
%       be computed, the error SPICE(DEGENERATECASE) is signaled by a
%       routine in the call tree of this routine. Note that this is a
%       very rare case.
%
%   16) If any of the input arguments, `method', `target', `et',
%       `fixref', `abcorr' or `obsrvr', is undefined, an error is
%       signaled by the Matlab error handling system.
%
%   17) If any of the input arguments, `method', `target', `et',
%       `fixref', `abcorr' or `obsrvr', is not of the expected type,
%       or it does not have the expected dimensions and size, an error
%       is signaled by the Mice interface.
%
%-Files
%
%   Appropriate kernels must be loaded by the calling program before
%   this routine is called.
%
%   The following data are required:
%
%   -  SPK data: ephemeris data for target and observer must be
%      loaded. If aberration corrections are used, the states of
%      target and observer relative to the solar system barycenter
%      must be calculable from the available ephemeris data.
%      Typically ephemeris data are made available by loading one
%      or more SPK files via cspice_furnsh.
%
%   -  PCK data: rotation data for the target body must be
%      loaded. These may be provided in a text or binary PCK file.
%
%   -  Shape data for the target body:
%
%         PCK data:
%
%            If the target body shape is modeled as an ellipsoid,
%            triaxial radii for the target body must be loaded into
%            the kernel pool. Typically this is done by loading a
%            text PCK file via cspice_furnsh.
%
%            Triaxial radii are also needed if the target shape is
%            modeled by DSK data, but the DSK NADIR method is
%            selected.
%
%         DSK data:
%
%            If the target shape is modeled by DSK data, DSK files
%            containing topographic data for the target body must be
%            loaded. If a surface list is specified, data for at
%            least one of the listed surfaces must be loaded.
%
%   The following data may be required:
%
%   -  Frame data: if a frame definition is required to convert the
%      observer and target states to the body-fixed frame of the
%      target, that definition must be available in the kernel
%      pool. Typically the definition is supplied by loading a
%      frame kernel via cspice_furnsh.
%
%   -  Surface name-ID associations: if surface names are specified
%      in `method', the association of these names with their
%      corresponding surface ID codes must be established by
%      assignments of the kernel variables
%
%         NAIF_SURFACE_NAME
%         NAIF_SURFACE_CODE
%         NAIF_SURFACE_BODY
%
%      Normally these associations are made by loading a text
%      kernel containing the necessary assignments. An example
%      of such an assignment is
%
%         NAIF_SURFACE_NAME += 'Mars MEGDR 128 PIXEL/DEG'
%         NAIF_SURFACE_CODE += 1
%         NAIF_SURFACE_BODY += 499
%
%   In all cases, kernel data are normally loaded once per program
%   run, NOT every time this routine is called.
%
%-Restrictions
%
%   None.
%
%-Required_Reading
%
%   MICE.REQ
%   DSK.REQ
%   FRAMES.REQ
%   PCK.REQ
%   SPK.REQ
%   TIME.REQ
%
%-Literature_References
%
%   None.
%
%-Author_and_Institution
%
%   J. Diaz del Rio     (ODC Space)
%   E.D. Wright         (JPL)
%
%-Version
%
%   -Mice Version 1.2.0, 10-AUG-2021 (EDW) (JDR)
%
%       Header update to reflect support for use of DSKs. Added example's
%       meta-kernel. Updated example #1 to use DSK data. Added second example.
%
%       Added -Parameters, -Exceptions, -Files, -Restrictions,
%       -Literature_References and -Author_and_Institution sections, and
%       extended -Particulars section.
%
%       Eliminated use of "lasterror" in rethrow.
%
%       Removed reference to the function's corresponding CSPICE header from
%       -Required_Reading section.
%
%   -Mice Version 1.1.0, 12-JAN-2015 (EDW)
%
%       Vectorized interface on input "et".
%
%       Edited -I/O section to conform to NAIF standard for Mice
%       documentation.
%
%   -Mice Version 1.0.1, 12-MAY-2009 (EDW)
%
%       Corrected type in -I/O call description. The call description
%       lacked the "fixref" argument.
%
%   -Mice Version 1.0.0, 30-JAN-2008 (EDW)
%
%-Index_Entries
%
%   find sub-observer point on target body
%   find nearest point to observer on target body
%
%-&

function [subpnt] = mice_subpnt( method, target, et, fixref, abcorr, obsrvr )

   switch nargin
      case 6

         method = zzmice_str(method);
         target = zzmice_str(target);
         et     = zzmice_dp(et);
         fixref = zzmice_str(fixref);
         abcorr = zzmice_str(abcorr);
         obsrvr = zzmice_str(obsrvr);

      otherwise
         error ( ['Usage: [_subnt_] = '                                    ...
                  'mice_subpnt( `method`, `target`, _et_,'                 ...
                  ' `fixref`, `abcorr`, `obsrvr`)'])
   end

   %
   % Call the MEX library. The "_s" suffix indicates a structure type
   % return argument.
   %
   try
      [subpnt] = mice('subpnt_s', method, target, et, fixref, abcorr, obsrvr);
   catch spiceerr
      rethrow(spiceerr)
   end


