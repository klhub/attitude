%-Abstract
%
%   CSPICE_ILLUMG finds the illumination angles (phase, incidence, and
%   emission) at a specified surface point of a target body.
%
%   The surface of the target body may be represented by a triaxial
%   ellipsoid or by topographic data provided by DSK files.
%
%   The illumination source is a specified ephemeris object.
%
%-Disclaimer
%
%   THIS SOFTWARE AND ANY RELATED MATERIALS WERE CREATED BY THE
%   CALIFORNIA  INSTITUTE OF TECHNOLOGY (CALTECH) UNDER A U.S.
%   GOVERNMENT CONTRACT WITH THE NATIONAL AERONAUTICS AND SPACE
%   ADMINISTRATION (NASA). THE SOFTWARE IS TECHNOLOGY AND SOFTWARE
%   PUBLICLY AVAILABLE UNDER U.S. EXPORT LAWS AND IS PROVIDED
%   'AS-IS' TO THE RECIPIENT WITHOUT WARRANTY OF ANY KIND, INCLUDING
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
%      method   a short string providing parameters defining the computation
%               method to be used.
%
%               [1,c1] = size(method); char = class(method)
%
%                  or
%
%               [1,1] = size(method); cell = class(method)
%
%               In the syntax descriptions below, items delimited by
%               brackets are optional.
%
%               `method' may be assigned the following values:
%
%                  'ELLIPSOID'
%
%                     The illumination angle computation uses a
%                     triaxial ellipsoid to model the surface of the
%                     target body. The ellipsoid's radii must be
%                     available in the kernel pool.
%
%
%                  'DSK/UNPRIORITIZED[/SURFACES = <surface list>]'
%
%                     The illumination angle computation uses
%                     topographic data to model the surface of the
%                     target body. These data must be provided by
%                     loaded DSK files.
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
%               Neither case nor white space are significant in `method',
%               except within double-quoted strings representing surface
%               names. For example, the string ' eLLipsoid ' is valid.
%
%               Within double-quoted strings representing surface names,
%               blank characters are significant, but multiple
%               consecutive blanks are considered equivalent to a single
%               blank. Case is not significant. So
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
%               `target' is case-insensitive, and leading and trailing
%               blanks in `target' are not significant. Optionally, you may
%               supply a string containing the integer ID code for the
%               object. For example both 'MOON' and '301' are legitimate
%               strings that indicate the Moon is the target body.
%
%      ilusrc   the name of the illumination source.
%
%               [1,c3] = size(ilusrc); char = class(ilusrc)
%
%                  or
%
%               [1,1] = size(ilusrc); cell = class(ilusrc)
%
%               This source may be any ephemeris object. Case, blanks, and
%               numeric values are treated in the same way as for the input
%               `target'.
%
%      et       the epoch, expressed as seconds past J2000 TDB, for which the
%               apparent illumination angles at the specified surface point
%               on the target body, as seen from the observing body, are to
%               be computed.
%
%               [1,1] = size(et); double = class(et)
%
%      fixref   the name of the body-fixed, body-centered reference frame
%               associated with the target body.
%
%               [1,c4] = size(fixref); char = class(fixref)
%
%                  or
%
%               [1,1] = size(fixref); cell = class(fixref)
%
%               The input surface point `spoint' and the output vector
%               `srfvec' are expressed relative to this reference frame. The
%               string `fixref' is case-insensitive, and leading and trailing
%               blanks in `fixref' are not significant.
%
%      abcorr   the aberration correction to be used in computing the
%               position and orientation of the target body and the location
%               of the illumination source.
%
%               [1,c5] = size(abcorr); char = class(abcorr)
%
%                  or
%
%               [1,1] = size(abcorr); cell = class(abcorr)
%
%               For remote sensing applications, where the apparent
%               illumination angles seen by the observer are desired,
%               normally either of the corrections
%
%                  'LT+S'
%                  'CN+S'
%
%               should be used. These and the other supported options
%               are described below. `abcorr' may be any of the
%               following:
%
%                  'NONE'     No aberration correction.
%
%               Let `lt' represent the one-way light time between the
%               observer and the input surface point `spoint' (note: NOT
%               between the observer and the target body's center). The
%               following values of `abcorr' apply to the "reception" case
%               in which photons depart from `spoint' at the light-time
%               corrected epoch et-lt and *arrive* at the observer's
%               location at `et':
%
%                  'LT'       Correct both the position of `spoint' as
%                             seen by the observer, and the position
%                             of the illumination source as seen by
%                             the target, for light time. Correct the
%                             orientation of the target for light
%                             time.
%
%                  'LT+S'     Correct both the position of `spoint' as
%                             seen by the observer, and the position
%                             of the illumination source as seen by
%                             the target, for light time and stellar
%                             aberration. Correct the orientation of
%                             the target for light time.
%
%                  'CN'       Converged Newtonian light time
%                             correction. In solving the light time
%                             equations for `spoint' and the
%                             illumination source, the 'CN'
%                             correction iterates until the solution
%                             converges.
%
%                  'CN+S'     Converged Newtonian light time and
%                             stellar aberration corrections. This
%                             option produces a solution that is at
%                             least as accurate at that obtainable
%                             with the 'LT+S' option. Whether the
%                             'CN+S' solution is substantially more
%                             accurate depends on the geometry of the
%                             participating objects and on the
%                             accuracy of the input data. In all
%                             cases this routine will execute more
%                             slowly when a converged solution is
%                             computed.
%
%               The following values of `abcorr' apply to the
%               "transmission" case in which photons *arrive* at
%               `spoint' at the light-time corrected epoch et+lt and
%               *depart* from the observer's location at `et':
%
%                  'XLT'      "Transmission" case: correct for
%                             one-way light time using a Newtonian
%                             formulation. This correction yields the
%                             illumination angles at the moment that
%                             `spoint' receives photons emitted from the
%                             observer's location at `et'.
%
%                             The light time correction uses an
%                             iterative solution of the light time
%                             equation. The solution invoked by the
%                             'XLT' option uses one iteration.
%
%                             Both the target position as seen by the
%                             observer, and rotation of the target
%                             body, are corrected for light time.
%
%                  'XLT+S'    "Transmission" case: correct for
%                             one-way light time and stellar
%                             aberration using a Newtonian
%                             formulation  This option modifies the
%                             angles obtained with the 'XLT' option
%                             to account for the observer's and
%                             target's velocities relative to the
%                             solar system barycenter (the latter
%                             velocity is used in computing the
%                             direction to the apparent illumination
%                             source).
%
%                  'XCN'      Converged Newtonian light time
%                             correction. This is the same as XLT
%                             correction but with further iterations
%                             to a converged Newtonian light time
%                             solution.
%
%                  'XCN+S'    "Transmission" case: converged
%                             Newtonian light time and stellar
%                             aberration corrections. This option
%                             produces a solution that is at least as
%                             accurate at that obtainable with the
%                             'XLT+S' option. Whether the 'XCN+S'
%                             solution is substantially more accurate
%                             depends on the geometry of the
%                             participating objects and on the
%                             accuracy of the input data. In all
%                             cases this routine will execute more
%                             slowly when a converged solution is
%                             computed.
%
%
%               Neither case nor white space are significant in
%               `abcorr'. For example, the string
%
%                 'Lt + s'
%
%               is valid.
%
%      obsrvr   the name of the observing body.
%
%               [1,c6] = size(obsrvr); char = class(obsrvr)
%
%                  or
%
%               [1,1] = size(obsrvr); cell = class(obsrvr)
%
%               The observing body is an ephemeris object: it typically
%               is a spacecraft, an extended body, or a surface point
%               for which ephemeris data are available. `obsrvr' is
%               case-insensitive, and leading and trailing blanks in
%               `obsrvr' are not significant. Optionally, you may supply
%               a string containing the integer ID code for the object.
%               For example both 'MOON' and '301' are legitimate strings
%               that indicate the Moon is the observer.
%
%               `obsrvr' may be not be identical to `target'.
%
%      spoint   a surface point on the target body, expressed in Cartesian
%               coordinates, relative to the body-fixed target frame
%               designated by `fixref'.
%
%               [3,1] = size(spoint); double = class(spoint)
%
%               `spoint' need not be visible from the observer's
%               location at the epoch `et'.
%
%               The components of `spoint' have units of km.
%
%   the call:
%
%      [trgepc, srfvec, phase,                                          ...
%       incdnc, emissn]        = cspice_illumg( method, target, ilusrc, ...
%                                               et,     fixref, abcorr, ...
%                                               obsrvr, spoint  )
%
%   returns:
%
%      trgepc   the "target surface point epoch."
%
%               [1,1] = size(trgepc); double = class(trgepc)
%
%               `trgepc' is defined as follows: letting `lt' be the one-way
%               light time between the observer and the input surface point
%               `spoint', `trgepc' is either the epoch et-lt, et+lt or `et'
%               depending on whether the requested aberration correction is,
%               respectively, for received radiation, transmitted radiation
%               or omitted. `lt' is computed using the method indicated by
%               `abcorr'.
%
%               `trgepc' is expressed as seconds past J2000 TDB.
%
%      srfvec   the vector from the observer's position at `et' to the
%               aberration-corrected (or optionally, geometric) position of
%               `spoint', where the aberration corrections are specified by
%               `abcorr'.
%
%               [3,1] = size(srfvec); double = class(srfvec)
%
%               `srfvec' is expressed in the target body-fixed reference
%               frame designated by `fixref', evaluated at `trgepc'.
%
%               The components of `srfvec' are given in units of km.
%
%               One can use the function norm to obtain the
%               distance between the observer and `spoint':
%
%                  dist = norm( srfvec );
%
%               The observer's position `obspos', relative to the
%               target body's center, where the center's position is
%               corrected for aberration effects as indicated by
%               `abcorr', can be computed with:
%
%                  obspos = spoint - srfvec;
%
%               To transform the vector `srfvec' from a reference frame
%               `fixref' at time `trgepc' to a time-dependent reference
%               frame `ref' at time `et', the routine cspice_pxfrm2 should be
%               called. Let `xform' be the 3x3 matrix representing the
%               rotation from the reference frame `fixref' at time
%               `trgepc' to the reference frame `ref' at time `et'. Then
%               `srfvec' can be transformed to the result `refvec' as
%               follows:
%
%                  [xform] = cspice_pxfrm2( fixref, ref, trgepc, et );
%                  refvec = xform * srfvec;
%
%
%      The following outputs depend on the existence of a well-defined
%      outward normal vector to the surface at `spoint'. See restriction 1.
%
%
%      phase    the phase angle at `spoint', as seen from `obsrvr' at time
%               `et'.
%
%               [1,1] = size(phase); double = class(phase)
%
%               This is the angle between the negative of the vector
%               `srfvec' and the spoint-illumination source vector at
%               `trgepc'. Units are radians. The range of `phase' is [0, pi].
%               See -Particulars below for a detailed discussion of the
%               definition.
%
%      incdnc   the illumination source incidence angle at `spoint', as seen
%               from `obsrvr' at time `et'.
%
%               [1,1] = size(incdnc); double = class(incdnc)
%
%               This is the angle between the surface normal vector at
%               `spoint' and the spoint-illumination source vector at
%               `trgepc'. Units are radians. The range of `incdnc' is [0, pi].
%               See -Particulars below for a detailed discussion of the
%               definition.
%
%      emissn   the emission angle at `spoint', as seen from `obsrvr' at time
%               `et'.
%
%               [1,1] = size(emissn); double = class(emissn)
%
%               This is the angle between the surface normal vector at
%               `spoint' and the negative of the vector `srfvec'. Units are
%               radians. The range of `emissn' is [0, pi]. See -Particulars
%               below for a detailed discussion of the definition.
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
%   1) Find the phase, solar incidence, and emission angles at the
%      sub-solar and sub-spacecraft points on Mars as seen from the Mars
%      Global Surveyor spacecraft at a specified UTC time.
%
%      Use both an ellipsoidal Mars shape model and topographic data
%      provided by a DSK file. For both surface points, use the 'near
%      point' and 'nadir' definitions for ellipsoidal and DSK shape
%      models, respectively.
%
%      Use converged Newtonian light time and stellar aberration
%      corrections.
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
%         File: illumg_ex1.tm
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
%            mgs_ext12_ipng_mgs95j.bsp        MGS ephemeris
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
%                                'mgs_ext12_ipng_mgs95j.bsp',
%                                'megr90n000cb_plate.bds'      )
%         \begintext
%
%         End of meta-kernel
%
%
%      Example code begins here.
%
%
%      function illumg_ex1()
%
%         %
%         % Load kernel files.
%         %
%         cspice_furnsh( 'illumg_ex1.tm' )
%
%
%         %
%         % Convert the UTC request time string to seconds past
%         % J2000 TDB.
%         %
%         utc = '2003 OCT 13 06:00:00 UTC';
%
%         et = cspice_str2et( utc );
%
%         %
%         % Assign observer and target names. The acronym MGS
%         % indicates Mars Global Surveyor. See NAIF_IDS for a
%         % list of names recognized by SPICE.
%         %
%         % Also set the target body-fixed frame and
%         % the aberration correction flag.
%         %
%
%         target = 'Mars';
%         obsrvr = 'MGS';
%         fixref = 'IAU_MARS';
%         abcorr = 'CN+S';
%
%         ilumth  = {'Ellipsoid', 'DSK/Unprioritized' };
%         submth =  {'Near Point/Ellipsoid', 'DSK/Nadir/Unprioritized' };
%
%         for i=1:numel(ilumth)
%
%            %
%            % Find the sub-solar point on Mars as
%            % seen from the MGS spacecraft at `et'. Use the
%            % "near point" style of sub-point definition
%            % when the shape model is an ellipsoid, and use
%            % the "nadir" style when the shape model is
%            % provided by DSK data. This makes it easy to
%            % verify the solar incidence angle when
%            % the target is modeled as an  ellipsoid.
%            %
%            [ssolpt, trgepc, srfvec] = ...
%                           cspice_subslr( submth(i), ...
%                                          target, et, fixref,  ...
%                                          abcorr, obsrvr );
%
%            %
%            % Now find the sub-spacecraft point.
%            %
%            [sscpt, trgepc, srfvec] = ...
%                            cspice_subpnt( submth(i), ...
%                                           target, et, fixref, ...
%                                           abcorr, obsrvr );
%
%            %
%            % Find the phase, solar incidence, and emission
%            % angles at the sub-solar point on Mars as seen
%            % from MGS at time `et'.
%            %
%            [ trgepc, srfvec, sslphs, sslsol, sslemi ] = ...
%                            cspice_illumg( ilumth(i),   ...
%                                           target, 'SUN',  et,  fixref, ...
%                                           abcorr,  obsrvr,  ssolpt );
%
%            %
%            % Do the same for the sub-spacecraft point.
%            %
%            [ trgepc, srfvec, sscphs, sscsol, sscemi ] = ...
%                             cspice_illumg( ilumth(i), ...
%                                            target, 'SUN', et, fixref, ...
%                                            abcorr, obsrvr, sscpt );
%
%            %
%            % Convert the angles to degrees and write them out.
%            %
%            sslphs = sslphs * cspice_dpr;
%            sslsol = sslsol * cspice_dpr;
%            sslemi = sslemi * cspice_dpr;
%            sscphs = sscphs * cspice_dpr;
%            sscsol = sscsol * cspice_dpr;
%            sscemi = sscemi * cspice_dpr;
%
%            fprintf( [ '\n'                                            ...
%                       '   cspice_illumg method: %s\n'                 ...
%                       '   cspice_subpnt method: %s\n'                 ...
%                       '   cspice_subslr method: %s\n'                 ...
%                       '\n'                                            ...
%                       '      Illumination angles at the '             ...
%                       'sub-solar point:\n'                            ...
%                       '\n'                                            ...
%                       '      Phase angle            (deg): %15.9f\n'  ...
%                       '      Solar incidence angle  (deg): %15.9f\n'  ...
%                       '      Emission angle         (deg): %15.9f\n'],...
%                              char(ilumth(i)),   ...
%                              char(submth(i)),   ...
%                              char(submth(i)),   ...
%                              sslphs,      ...
%                              sslsol,      ...
%                              sslemi                                    );
%
%            if ( i == 1 )
%
%               fprintf( [ '        The solar incidence angle ' ...
%                          'should be 0.\n'                     ...
%                          '        The emission and phase '    ...
%                          'angles should be equal.\n' ] );
%            end
%
%            fprintf( [ '\n'                                    ...
%                       '      Illumination angles at the '  ...
%                       'sub-s/c point:\n' ...
%                       '\n'...
%                       '      Phase angle            (deg): %15.9f\n'  ...
%                       '      Solar incidence angle  (deg): %15.9f\n'  ...
%                       '      Emission angle         (deg): %15.9f\n'],...
%                       sscphs, ...
%                       sscsol, ...
%                       sscemi                                            );
%
%
%            if ( i == 1 )
%
%              fprintf( [ '        The emission angle '  ...
%                         'should be 0.\n'               ...
%                         '        The solar incidence ' ...
%                         'and phase angles should be equal.\n' ] );
%              end
%
%              fprintf ( '\n' );
%
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
%         cspice_illumg method: Ellipsoid
%         cspice_subpnt method: Near Point/Ellipsoid
%         cspice_subslr method: Near Point/Ellipsoid
%
%            Illumination angles at the sub-solar point:
%
%            Phase angle            (deg):   138.370270685
%            Solar incidence angle  (deg):     0.000000000
%            Emission angle         (deg):   138.370270685
%              The solar incidence angle should be 0.
%              The emission and phase angles should be equal.
%
%            Illumination angles at the sub-s/c point:
%
%            Phase angle            (deg):   101.439331040
%            Solar incidence angle  (deg):   101.439331041
%            Emission angle         (deg):     0.000000002
%              The emission angle should be 0.
%              The solar incidence and phase angles should be equal.
%
%
%         cspice_illumg method: DSK/Unprioritized
%         cspice_subpnt method: DSK/Nadir/Unprioritized
%         cspice_subslr method: DSK/Nadir/Unprioritized
%
%            Illumination angles at the sub-solar point:
%
%            Phase angle            (deg):   138.387071678
%            Solar incidence angle  (deg):     0.967122745
%            Emission angle         (deg):   137.621480599
%
%            Illumination angles at the sub-s/c point:
%
%            Phase angle            (deg):   101.439331359
%            Solar incidence angle  (deg):   101.555993667
%            Emission angle         (deg):     0.117861156
%
%
%-Particulars
%
%   Mice contains four routines that compute illumination angles:
%
%      cspice_illumf (same as this routine, except that illumination
%                    and visibility flags are returned)
%
%      cspice_illumg (this routine)
%
%      cspice_ilumin (same as cspice_illumg, except that the sun is fixed
%                    as the illumination source)
%
%      cspice_illum  (deprecated)
%
%   cspice_illumf is the most capable of the set.
%
%
%   Illumination angles
%   ===================
%
%   The term "illumination angles" refers to the following set of
%   angles:
%
%
%      phase angle              Angle between the vectors from the
%                               surface point to the observer and
%                               from the surface point to the
%                               illumination source.
%
%      incidence angle          Angle between the surface normal at
%                               the specified surface point and the
%                               vector from the surface point to the
%                               illumination source.
%
%      emission angle           Angle between the surface normal at
%                               the specified surface point and the
%                               vector from the surface point to the
%                               observer.
%
%   The diagram below illustrates the geometric relationships
%   defining these angles. The labels for the incidence, emission,
%   and phase angles are "inc.", "e.", and "phase".
%
%
%                                                    *
%                                            illumination source
%
%                  surface normal vector
%                            ._                 _.
%                            |\                 /|  illumination
%                              \    phase      /    source vector
%                               \   .    .    /
%                               .            .
%                                 \   ___   /
%                            .     \/     \/
%                                  _\ inc./
%                           .    /   \   /
%                           .   |  e. \ /
%       *             <--------------- *  surface point on
%    viewing            vector            target body
%    location           to viewing
%    (observer)         location
%
%
%   Note that if the target-observer vector, the target normal vector
%   at the surface point, and the target-illumination source vector
%   are coplanar, then phase is the sum of the incidence and emission
%   angles. This rarely occurs; usually
%
%      phase angle  <  incidence angle + emission angle
%
%   All of the above angles can be computed using light time
%   corrections, light time and stellar aberration corrections, or no
%   aberration corrections. In order to describe apparent geometry as
%   observed by a remote sensing instrument, both light time and
%   stellar aberration corrections should be used.
%
%   The way aberration corrections are applied by this routine
%   is described below.
%
%      Light time corrections
%      ======================
%
%         Observer-target surface point vector
%         ------------------------------------
%
%         Let `et' be the epoch at which an observation or remote
%         sensing measurement is made, and let et-lt ("lt" stands
%         for "light time") be the epoch at which the photons
%         received at `et' were emitted from the surface point `spoint'.
%         Note that the light time between the surface point and
%         observer will generally differ from the light time between
%         the target body's center and the observer.
%
%
%         Target body's orientation
%         -------------------------
%
%         Using the definitions of `et' and `lt' above, the target body's
%         orientation at et-lt is used. The surface normal is
%         dependent on the target body's orientation, so the body's
%         orientation model must be evaluated for the correct epoch.
%
%
%         Target body -- illumination source vector
%         -----------------------------------------
%
%         The surface features on the target body near `spoint' will
%         appear in a measurement made at `et' as they were at et-lt.
%         In particular, lighting on the target body is dependent on
%         the apparent location of the illumination source as seen
%         from the target body at et-lt. So, a second light time
%         correction is used to compute the position of the
%         illumination source relative to the surface point.
%
%
%      Stellar aberration corrections
%      ==============================
%
%      Stellar aberration corrections are applied only if
%      light time corrections are applied as well.
%
%         Observer-target surface point body vector
%         -----------------------------------------
%
%         When stellar aberration correction is performed, the
%         direction vector `srfvec' is adjusted so as to point to the
%         apparent position of `spoint': considering `spoint' to be an
%         ephemeris object, `srfvec' points from the observer's
%         position at `et' to the light time and stellar aberration
%         corrected position of `spoint'.
%
%         Target body-illumination source vector
%         --------------------------------------
%
%         The target body-illumination source vector is the apparent
%         position of the illumination source, corrected for light
%         time and stellar aberration, as seen from the target body
%         at time et-lt.
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
%      both represent a surface as a set of triangular plates, the
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
%      -----------------------------------
%
%      The keywords and surface list in the `method' argument
%      are called "clauses." The clauses may appear in any
%      order, for example
%
%         'DSK/<surface list>/UNPRIORITIZED'
%         'DSK/UNPRIORITIZED/<surface list>'
%         'UNPRIORITIZED/<surface list>/DSK'
%
%      The simplest form of the `method' argument specifying use of
%      DSK data is one that lacks a surface list, for example:
%
%         'DSK/UNPRIORITIZED'
%
%      For applications in which all loaded DSK data for the target
%      body are for a single surface, and there are no competing
%      segments, the above string suffices. This is expected to be
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
%         'SURFACES ='
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
%         "SURFACES = 1"
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
%         'DSK/UNPRIORITIZED/SURFACES = "Mars MEGDR 64 PIXEL/DEG", 3'
%
%
%      Aberration corrections using DSK data
%      -------------------------------------
%
%      For irregularly shaped target bodies, the distance between the
%      observer and the nearest surface intercept need not be a
%      continuous function of time; hence the one-way light time
%      between the intercept and the observer may be discontinuous as
%      well. In such cases, the computed light time, which is found
%      using an iterative algorithm, may converge slowly or not at all.
%      In all cases, the light time computation will terminate, but
%      the result may be less accurate than expected.
%
%   Please refer to the Aberration Corrections Required Reading (abcorr.req)
%   for detailed information describing the nature and calculation of the
%   applied corrections.
%
%-Exceptions
%
%   1)  If the specified aberration correction is relativistic or
%       calls for stellar aberration but not light time correction,
%       the error SPICE(NOTSUPPORTED) is signaled by a routine in the
%       call tree of this routine.
%
%   2)  If the specified aberration correction is any other
%       unrecognized value, an error is signaled by a routine in the
%       call tree of this routine.
%
%   3)  If any of the target, observer, or illumination source input
%       strings cannot be converted to an integer ID code, the error
%       SPICE(IDCODENOTFOUND) is signaled by a routine in the call
%       tree of this routine.
%
%   4)  If `obsrvr' and `target' map to the same NAIF integer ID code, the
%       error SPICE(BODIESNOTDISTINCT) is signaled by a routine in the
%       call tree of this routine.
%
%   5)  If the input target body-fixed frame `fixref' is not recognized,
%       the error SPICE(NOFRAME) is signaled by a routine in the call
%       tree of this routine. A frame name may fail to be recognized
%       because a required frame specification kernel has not been
%       loaded; another cause is a misspelling of the frame name.
%
%   6)  If the input frame `fixref' is not centered at the target body,
%       the error SPICE(INVALIDFRAME) is signaled by a routine in the
%       call tree of this routine.
%
%   7)  If the input argument `method' is not recognized, the error
%       SPICE(INVALIDMETHOD) is signaled by a routine in the call tree
%       of this routine.
%
%   8)  If insufficient ephemeris data have been loaded prior to
%       calling cspice_illumg, an error is signaled by a
%       routine in the call tree of this routine. Note that when
%       light time correction is used, sufficient ephemeris data must
%       be available to propagate the states of observer, target, and
%       the illumination source to the solar system barycenter.
%
%   9)  If the computation method specifies an ellipsoidal target
%       shape and triaxial radii of the target body have not been
%       loaded into the kernel pool prior to calling cspice_illumg, an error
%       is signaled by a routine in the call tree of this routine.
%
%   10) If PCK data specifying the target body-fixed frame orientation
%       have not been loaded prior to calling cspice_illumg, an error is
%       signaled by a routine in the call tree of this routine.
%
%   11) If `method' specifies that the target surface is represented by
%       DSK data, and no DSK files are loaded for the specified
%       target, an error is signaled by a routine in the call tree
%       of this routine.
%
%   12) If `method' specifies that the target surface is represented by
%       DSK data, and data representing the portion of the surface on
%       which `spoint' is located are not available, an error is
%       signaled by a routine in the call tree of this routine.
%
%   13) If `method' specifies that the target surface is represented
%       by DSK data, `spoint' must lie on the target surface, not above
%       or below it. A small tolerance is used to allow for round-off
%       error in the calculation determining whether `spoint' is on the
%       surface.
%
%       If, in the DSK case, `spoint' is too far from the surface, an
%       error is signaled by a routine in the call tree of this
%       routine.
%
%       If the surface is represented by a triaxial ellipsoid, `spoint'
%       is not required to be close to the ellipsoid; however, the
%       results computed by this routine will be unreliable if `spoint'
%       is too far from the ellipsoid.
%
%   14) If radii for `target' are not found in the kernel pool, an error
%       is signaled by a routine in the call tree of this routine.
%
%   15) If the size of the `target' body radii kernel variable is not
%       three, an error is signaled by a routine in the call tree of
%       this routine.
%
%   16) If any of the three `target' body radii is less-than or equal to
%       zero, an error is signaled by a routine in the call tree of
%       this routine.
%
%   17) If any of the input arguments, `method', `target', `ilusrc',
%       `et', `fixref', `abcorr', `obsrvr' or `spoint', is undefined,
%       an error is signaled by the Matlab error handling system.
%
%   18) If any of the input arguments, `method', `target', `ilusrc',
%       `et', `fixref', `abcorr', `obsrvr' or `spoint', is not of the
%       expected type, or it does not have the expected dimensions and
%       size, an error is signaled by the Mice interface.
%
%-Files
%
%   Appropriate kernels must be loaded by the calling program before
%   this routine is called.
%
%   The following data are required:
%
%   -  SPK data: ephemeris data for target, observer, and the
%      illumination source must be loaded. If aberration
%      corrections are used, the states of target, observer, and
%      the illumination source relative to the solar system
%      barycenter must be calculable from the available ephemeris
%      data. Typically ephemeris data are made available by loading
%      one or more SPK files via cspice_furnsh.
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
%   1)  Results from this routine are not meaningful if the input
%       point lies on a ridge or vertex of a surface represented by
%       DSK data, or if for any other reason the direction of the
%       outward normal vector at the point is undefined.
%
%-Required_Reading
%
%   MICE.REQ
%   ABCORR.REQ
%   DSK.REQ
%   FRAMES.REQ
%   NAIF_IDS.REQ
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
%   -Mice Version 1.1.0, 20-NOV-2021 (EDW) (JDR)
%
%       Corrected comments and bug in code example.
%
%       Added -Parameters, -Exceptions, -Files, -Restrictions,
%       -Literature_References and -Author_and_Institution sections. Fixed
%       minor typos in header.
%
%       Edited the header to comply with NAIF standard.
%
%       Eliminated use of "lasterror" in rethrow.
%
%       Removed reference to the function's corresponding CSPICE header from
%       -Required_Reading section.
%
%   -Mice Version 1.0.0, 04-APR-2017 (EDW)
%
%-Index_Entries
%
%   illumination angles general source
%   lighting angles general source
%   phase angle general source
%   incidence angle general source
%   emission angle general source
%
%-&

function [trgepc, srfvec, phase, incdnc, emissn] = cspice_illumg( method, ...
                                              target, ilusrc, et, fixref, ...
                                              abcorr, obsrvr, spoint)

   switch nargin
      case 8

         method = zzmice_str(method);
         target = zzmice_str(target);
         ilusrc = zzmice_str(ilusrc);
         et     = zzmice_dp(et);
         fixref = zzmice_str(fixref);
         abcorr = zzmice_str(abcorr);
         obsrvr = zzmice_str(obsrvr);
         spoint = zzmice_dp(spoint);

      otherwise

         error ( [ 'Usage: [trgepc, srfvec(3), phase, incdnc, emissn] = ' ...
                     'cspice_ilumin( `method`, `target`, `ilusrc`, et, '  ...
                     '`fixref`, `abcorr`, `obsrvr`, spoint(3))' ] )

   end

   %
   % Call the MEX library. The "_s" suffix indicates a structure type
   % return argument.
   %
   try
      [ilumin] = mice('illumg_s', method, target, ilusrc, et, ...
                                  fixref, abcorr, obsrvr, spoint);
      trgepc   = reshape( [ilumin(:).trgepc], 1, [] );
      srfvec   = reshape( [ilumin(:).srfvec], 3, [] );
      phase    = reshape( [ilumin(:).phase ], 1, [] );
      incdnc   = reshape( [ilumin(:).incdnc], 1, [] );
      emissn   = reshape( [ilumin(:).emissn], 1, [] );
   catch spiceerr
      rethrow(spiceerr)
   end
