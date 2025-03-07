%-Abstract
%
%   CSPICE_SPKCVO returns the state of a specified target relative to an
%   "observer," where the observer has constant velocity in a specified
%   reference frame. The observer's state is provided by the calling
%   program rather than by loaded SPK files.
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
%      target   name of a target body. Optionally, you may supply
%               the ID code of the object as an integer string. For
%               example, both 'EARTH' and '399' are legitimate strings
%               to supply to indicate the target is earth.
%
%               Case and leading and trailing blanks are not significant
%               in the string `target'.
%
%               [1,c1] = size(target), char = class(target)
%
%                  or
%
%               [1,1] = size(target); cell = class(target)
%
%      et       ephemeris time at which the state of the
%               target relative to the observer is to be computed. `et' is
%               expressed as seconds past J2000 TDB. `et' refers to time
%               at the observer's location.
%
%               `et' is independent of the observer epoch `obsepc'.
%
%               [1,1] = size(et), double = class(et)
%
%      outref   name of the reference frame with respect to which
%               the output state is expressed.
%
%               When `outref' is time-dependent (non-inertial), its
%               orientation relative to the J2000 frame is evaluated in
%               the manner commanded by the input argument `refloc' (see
%               description below).
%
%               Case and leading and trailing blanks are not significant
%               in the string `outref'.
%
%               [1,c2] = size(outref), char = class(outref)
%
%                  or
%
%               [1,1] = size(outref); cell = class(outref)
%
%     refloc    name indicating the output reference frame
%               evaluation locus: this is the location associated
%               with the epoch at which this routine is to evaluate
%               the orientation, relative to the J2000 frame, of the
%               output frame `outref'. The values and meanings of
%               `refloc' are:
%
%                  'OBSERVER'  Evaluate `outref' at the observer's
%                              epoch `et'.
%
%                              Normally the locus 'OBSERVER' should
%                              be selected when `outref' is centered
%                              at the observer.
%
%
%                  'TARGET'    Evaluate `outref' at the target epoch;
%                              letting `lt' be the one-way light time
%                              between the target and observer, the
%                              target epoch is
%
%                                 et-lt  if reception aberration
%                                        corrections are used
%
%                                 et+lt  if transmission aberration
%                                        corrections are used
%
%                                 et     if no aberration corrections
%                                        are used
%
%                              Normally the locus 'TARGET' should
%                              be selected when `outref' is centered
%                              at the target object.
%
%
%                  'CENTER'    Evaluate the frame `outref' at the epoch
%                              associated its center. This epoch,
%                              which we'll call `etctr', is determined
%                              as follows:
%
%                                 Let `ltctr' be the one-way light time
%                                 between the observer and the center
%                                 of `outref'. Then `etctr' is
%
%                                    et-ltctr  if reception
%                                              aberration corrections
%                                              are used
%
%                                    et+ltctr  if transmission
%                                              aberration corrections
%                                              are used
%
%                                    et        if no aberration
%                                              corrections are used
%
%
%                              The locus 'CENTER' should be selected
%                              when the user intends to obtain
%                              results compatible with those produced
%                              by cspice_spkezr.
%
%               When `outref' is inertial, all choices of `refloc'
%               yield the same results.
%
%               Case and leading and trailing blanks are not
%               significant in the string `refloc'.
%
%               [1,c3] = size(refloc), char = class(refloc)
%
%                  or
%
%               [1,1] = size(refloc); cell = class(refloc)
%
%      abcorr   name indicating the aberration corrections to be
%               applied to the observer-target state to account for one-way
%               light time and stellar aberration.
%
%               `abcorr' may be any of the following:
%
%                  'NONE'     Apply no correction. Return the
%                             geometric state of the target
%                             relative to the observer.
%
%               The following values of `abcorr' apply to the
%               "reception" case in which photons depart from the
%               target's location at the light-time corrected epoch
%               et-lt and *arrive* at the observer's location at `et':
%
%                  'LT'       Correct for one-way light time (also
%                             called "planetary aberration") using a
%                             Newtonian formulation. This correction
%                             yields the state of the target at the
%                             moment it emitted photons arriving at
%                             the observer at `et'.
%
%                             The light time correction uses an
%                             iterative solution of the light time
%                             equation. The solution invoked by the
%                             'LT' option uses one iteration.
%
%                  'LT+S'     Correct for one-way light time and
%                             stellar aberration using a Newtonian
%                             formulation. This option modifies the
%                             state obtained with the 'LT' option to
%                             account for the observer's velocity
%                             relative to the solar system
%                             barycenter. The result is the apparent
%                             state of the target---the position and
%                             velocity of the target as seen by the
%                             observer.
%
%                  'CN'       Converged Newtonian light time
%                             correction. In solving the light time
%                             equation, the 'CN' correction iterates
%                             until the solution converges.
%
%                  'CN+S'     Converged Newtonian light time
%                             and stellar aberration corrections.
%
%
%               The following values of `abcorr' apply to the
%               "transmission" case in which photons *depart* from
%               the observer's location at `et' and arrive at the
%               target's location at the light-time corrected epoch
%               et+lt:
%
%                  'XLT'      "Transmission" case: correct for
%                             one-way light time using a Newtonian
%                             formulation. This correction yields the
%                             state of the target at the moment it
%                             receives photons emitted from the
%                             observer's location at `et'.
%
%                  'XLT+S'    "Transmission" case: correct for
%                             one-way light time and stellar
%                             aberration using a Newtonian
%                             formulation  This option modifies the
%                             state obtained with the 'XLT' option to
%                             account for the observer's velocity
%                             relative to the solar system
%                             barycenter. The position component of
%                             the computed target state indicates the
%                             direction that photons emitted from the
%                             observer's location must be "aimed" to
%                             hit the target.
%
%                  'XCN'      "Transmission" case: converged
%                             Newtonian light time correction.
%
%                  'XCN+S'    "Transmission" case: converged
%                             Newtonian light time and stellar
%                             aberration corrections.
%
%
%               Neither special nor general relativistic effects are
%               accounted for in the aberration corrections applied
%               by this routine.
%
%               Case and leading and trailing blanks are not
%               significant in the string `abcorr'.
%
%               [1,c4] = size(abcorr), char = class(abcorr)
%
%                  or
%
%               [1,1] = size(abcorr); cell = class(abcorr)
%
%      obssta   geometric state of an observer moving at constant velocity
%               relative to its center of motion `obsctr', expressed in the
%               reference frame `obsref', at the epoch `obsepc'.
%
%               `obssta' is a six-dimensional vector representing
%               position and velocity in Cartesian coordinates: the
%               first three components represent the position of an
%               observer relative to its center of motion; the last
%               three components represent the velocity of the
%               observer.
%
%               Units are always km and km/sec.
%
%               [6,1] = size(obssta), double = class(obssta)
%
%      obsepc   epoch expressed as seconds past J2000 TDB, at which the
%               observer state `obssta' is applicable. For other epochs,
%               the position of the observer relative
%               to its center of motion is linearly extrapolated
%               using the velocity component of `obssta'.
%
%               `obsepc' is independent of the epoch `et' at which the
%               state of the target relative to the observer is to be
%               computed.
%
%               [1,1] = size(obsepc), double = class(obsepc)
%
%      obsctr   name of the center of motion of `obssta'. The
%               ephemeris of `obsctr' is provided by loaded SPK files.
%
%               Optionally, you may supply the integer ID code for
%               the object as an integer string. For example both
%               'MOON' and '301' are legitimate strings that indicate
%               the moon is the center of motion.
%
%               Case and leading and trailing blanks are not
%               significant in the string `obsctr'.
%
%               [1,c5] = size(obsctr), char = class(obsctr)
%
%                  or
%
%               [1,1] = size(obsref); cell = class(obsctr)
%
%      obsref   name of the reference frame relative to which
%               the input state `obssta' is expressed. The observer has
%               constant velocity relative to its center of motion
%               in this reference frame.
%
%               Case and leading and trailing blanks are not
%               significant in the string `obsref'.
%
%               [1,c6] = size(obsref), char = class(obsref)
%
%                  or
%
%               [1,1] = size(obsref); cell = class(obsref)
%
%   the call:
%
%      [state, lt] = cspice_spkcvo( target, et,     outref, ...
%                                   refloc, abcorr, obssta, ...
%                                   obsepc, obsctr, obsref )
%
%   returns:
%
%      state    state of the target relative to the specified
%               observer. `state' is corrected for the specified
%               aberrations and is expressed with respect to the
%               reference frame specified by `outref'. The first three
%               components of `state' represent the x-, y- and
%               z-components of the target's position; the last three
%               components form the corresponding velocity vector.
%
%               The position component of `state' points from the
%               observer's location at `et' to the aberration-corrected
%               location of the target. Note that the sense of the
%               position vector is independent of the direction of
%               radiation travel implied by the aberration
%               correction.
%
%               The velocity component of `state' is the derivative
%               with respect to time of the position component of
%               `state'.
%
%               Units are always km and km/sec.
%
%               When `state' is expressed in a time-dependent
%               (non-inertial) output frame, the orientation of that
%               frame relative to the J2000 frame is evaluated in the
%               manner indicated by the input argument `refloc' (see
%               description above).
%
%               [6,1] = size(state), double = class(state)
%
%      lt       one-way light time between the observer
%               and target in seconds. If the target state is corrected
%               for aberrations, then `lt' is the one-way light time
%               between the observer and the light time corrected
%               target location.
%
%               [1,1] = size(lt), double = class(lt)
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
%   1) Compute apparent solar azimuth and elevation as seen from a
%      specified surface point on the earth.
%
%      Task Description
%      ================
%
%      In this example we'll use the location of the DSN station
%      DSS-14 as our surface point.
%
%      We'll perform the solar azimuth and elevation computation two
%      ways:
%
%         - Using a station frame kernel to provide the
%           specification of a topocentric reference frame
%           centered at DSS-14.
%
%         - Computing inline the transformation from the earth-fixed,
%           earth-centered frame ITRF93 to a topocentric frame
%           centered at DSS-14.
%
%      Note that results of the two computations will differ
%      slightly. This is due to differences in the orientations
%      of the topocentric frames. There are two sources of the
%      differences:
%
%         1) The station position is time-dependent due to tectonic
%            plate motion, and epochs of the station positions used
%            to specify the axes of the topocentric frame are
%            different in the two cases. This gives rise to different
%            orientations of the frame's axes relative to the frame
%            ITRF93.
%
%         2) The two computations use different earth radii; this
%            results in computation of different geodetic latitudes
%            of the station. This difference also affects the
%            topocentric frame orientation relative to ITRF93.
%
%
%      Kernels
%      =======
%
%      Use the meta-kernel shown below to load the required SPICE
%      kernels.
%
%
%         KPL/MK
%
%         File name: spkcvo_ex1.tm
%
%         This is the meta-kernel file for the header code example for
%         the subroutine cspice_spkcvo. These kernel files can be found on
%         the NAIF website.
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
%            de421.bsp                        Planetary ephemeris
%            pck00010.tpc                     Planet orientation and
%                                             radii
%            naif0010.tls                     Leapseconds
%            earth_720101_070426.bpc          Earth historical
%                                             binary PCK
%            earthstns_itrf93_050714.bsp      DSN station SPK
%            earth_topo_050714.tf             DSN station FK
%            mgs_moc_v20.ti                   MGS MOC instrument
%                                             parameters
%            mgs_sclkscet_00061.tsc           MGS SCLK coefficients
%            mgs_sc_ext12.bc                  MGS s/c bus attitude
%            mgs_ext12_ipng_mgs95j.bsp        MGS ephemeris
%
%         \begindata
%
%         KERNELS_TO_LOAD = ( 'de421.bsp',
%                             'pck00010.tpc',
%                             'naif0010.tls',
%                             'earth_720101_070426.bpc',
%                             'earthstns_itrf93_050714.bsp',
%                             'earth_topo_050714.tf',
%                             'mgs_moc_v20.ti',
%                             'mgs_sclkscet_00061.tsc',
%                             'mgs_sc_ext12.bc',
%                             'mgs_ext12_ipng_mgs95j.bsp'  )
%
%         \begintext
%
%         End of meta-kernel.
%
%
%      Example code begins here.
%
%
%      %
%      %  Program spkcvo_ex1
%      %
%      %  This program uses cspice_spkcvo to compute solar azimuth
%      %  and elevation at a given surface point on the earth.
%      %
%      function spkcvo_ex1()
%
%         %
%         % Local constants
%         %
%         META   =  'spkcvo_ex1.tm';
%         TIMFMT =  'YYYY MON DD HR:MN:SC.###### UTC';
%         TIMFM2 =  'YYYY MON DD HR:MN:SC.###### TDB ::TDB';
%
%         %
%         % Local variables
%         %
%         z = [0., 0., 1. ]';
%
%         %
%         % Load SPICE kernels.
%         %
%         cspice_furnsh( META )
%
%         %
%         % Convert the observation time to seconds past J2000 TDB.
%         %
%         obstim = '2003 OCT 13 06:00:00.000000 UTC';
%
%         et = cspice_str2et( obstim );
%
%         %
%         % Set the target, observer center, and observer frame.
%         %
%         target = 'SUN';
%         obsctr = 'EARTH';
%         obsref = 'ITRF93';
%
%         %
%         % Set the state of DSS-14 relative to the earth's
%         % center at the J2000 epoch, expressed in the
%         % ITRF93 reference frame. Values come from the
%         % earth station SPK specified in the meta-kernel.
%
%         %
%         % The velocity is non-zero due to tectonic
%         % plate motion.
%         %
%         obsepc    =  0.0;
%
%         obssta =  [ -2353.6213656676991, -4641.3414911499403,  ...
%                      3677.0523293197439, -0.00000000000057086, ...
%                      0.00000000000020549, -0.00000000000012171 ]';
%
%         %
%         % Find the apparent state of the sun relative
%         % to the station in the DSS-14_TOPO reference frame.
%         % Evaluate the output frame's orientation, that is the
%         % orientation of the DSS-14_TOPO frame relative to the
%         % J2000 frame, at the observation epoch. This
%         % correction is obtained by setting `refloc' to
%         % 'OBSERVER'.
%         %
%         outref = 'DSS-14_TOPO';
%         abcorr = 'CN+S';
%
%         refloc = 'OBSERVER';
%
%         %
%         % Compute the observer-target state.
%         %
%         [state0, lt0] = cspice_spkcvo( target, et,     outref, ...
%                                        refloc, abcorr, obssta, ...
%                                        obsepc, obsctr, obsref );
%
%         %
%         % Compute planetocentric coordinates of the
%         % observer-target position in the local
%         % topocentric reference frame DSS-14_TOPO.
%         %
%         [r, lon, lat] = cspice_reclat( state0(1:3) );
%
%         %
%         % Compute solar azimuth. The latitude we've
%         % already computed is the elevation. Express
%         % both angles in degrees.
%         %
%         el =   lat * cspice_dpr;
%         az = - lon * cspice_dpr;
%
%         if ( az < 0. )
%            az = az + 360.;
%         end
%
%         %
%         % Display the computed state, light time. and angles.
%         %
%         emitim = cspice_timout( et-lt0, TIMFMT );
%         epcstr = cspice_timout( obsepc, TIMFM2 );
%
%         fprintf( ' Frame evaluation locus:     %s\n\n', refloc )
%
%         fprintf( ' Target:                     %s\n', target )
%         fprintf( ' Observation time:           %s\n', obstim )
%         fprintf( ' Observer center:            %s\n', obsctr )
%         fprintf( ' Observer-center state time: %s\n', epcstr )
%         fprintf( ' Observer frame:             %s\n', obsref )
%         fprintf( ' Emission time:              %s\n', emitim )
%         fprintf( ' Output reference frame:     %s\n', outref )
%         fprintf( ' Aberration correction:      %s\n\n', abcorr )
%
%         fprintf( ' Observer-target position (km):\n' )
%         fprintf( '%20.8f %20.8f %20.8f\n', state0(1:3) )
%         fprintf( ' Observer-target velocity (km/s):\n' )
%         fprintf( '%20.8f %20.8f %20.8f\n', state0(4:6) )
%         fprintf( ' Light time (s):        %20.8f\n\n', lt0 )
%
%         fprintf( ' Solar azimuth (deg):     %20.8f\n', az )
%         fprintf( ' Solar elevation (deg):   %20.8f\n\n', el )
%
%         %
%         % For an arbitrary surface point, we might not
%         % have a frame kernel available. In this case
%         % we can look up the state in the observer frame
%         % using cspice_spkcvo and then convert the state to
%         % the local topocentric frame. We'll first
%         % create the transformation matrix for converting
%         % vectors in the observer frame to the topocentric
%         % frame.
%         %
%         % First step: find the geodetic (planetodetic)
%         % coordinates of the observer. We need the
%         % equatorial radius and flattening coefficient
%         % of the reference ellipsoid.
%         %
%         radii = cspice_bodvrd( 'EARTH', 'RADII', 3 );
%
%         re = radii(1);
%         rp = radii(3);
%
%         f  = ( re - rp ) / re;
%
%         [obslon, obslat, obsalt] = cspice_recgeo( obssta(1:3), re, f );
%
%         %
%         % Find the outward surface normal on the reference
%         % ellipsoid at the observer's longitude and latitude.
%         %
%         normal = cspice_latrec( 1., obslon, obslat );
%
%         %
%         % The topocentric frame has its +Z axis aligned
%         % with `normal' and its +X axis pointed north.
%         % The north direction is aligned with the component
%         % of the ITRF93 +Z axis orthogonal to the topocentric
%         % +Z axis.
%         %
%         xform = cspice_twovec( normal, 3, z, 1 );
%
%         outref = 'ITRF93';
%         abcorr = 'CN+S';
%
%         refloc = 'OBSERVER';
%
%         %
%         % Compute the observer-target state.
%         %
%         [state1, lt1] = cspice_spkcvo( target, et,     outref, ...
%                                        refloc, abcorr, obssta, ...
%                                        obsepc, obsctr, obsref );
%
%         %
%         % Convert the position to the topocentric frame.
%         %
%         topvec = xform * state1(1:3);
%
%         %
%         % Compute azimuth and elevation.
%         %
%         [r, lon, lat] = cspice_reclat( topvec );
%
%         el =   lat * cspice_dpr;
%         az = - lon * cspice_dpr;
%
%         if ( az < 0. )
%            az = az + 360.;
%         end
%
%         fprintf( ' AZ/EL computed without frame kernel:' )
%         fprintf( ' Distance between last two\n'          )
%         fprintf( ' positions (km):   %20.8f\n\n',        ...
%                    cspice_vdist( state0(1:3), topvec )   )
%
%         fprintf( ' Solar azimuth (deg):     %20.8f\n', az )
%         fprintf( ' Solar elevation (deg):   %20.8f\n\n', el )
%
%
%         %
%         % It's always good form to unload kernels after use,
%         % particularly in Matlab due to data persistence.
%         %
%         cspice_kclear
%
%
%      When this program was executed on a Mac/Intel/Octave5.x/64-bit
%      platform, the output was:
%
%
%       Frame evaluation locus:     OBSERVER
%
%       Target:                     SUN
%       Observation time:           2003 OCT 13 06:00:00.000000 UTC
%       Observer center:            EARTH
%       Observer-center state time: 2000 JAN 01 12:00:00.000000 TDB
%       Observer frame:             ITRF93
%       Emission time:              2003 OCT 13 05:51:42.068322 UTC
%       Output reference frame:     DSS-14_TOPO
%       Aberration correction:      CN+S
%
%       Observer-target position (km):
%         62512272.82076502    58967494.42506485  -122059095.46751761
%       Observer-target velocity (km/s):
%             2475.97326517       -9870.26706232       -3499.90809969
%       Light time (s):                497.93167797
%
%       Solar azimuth (deg):             316.67141599
%       Solar elevation (deg):           -54.85253168
%
%       AZ/EL computed without frame kernel: Distance between last two
%       positions (km):             3.07056969
%
%       Solar azimuth (deg):             316.67141786
%       Solar elevation (deg):           -54.85253216
%
%
%-Particulars
%
%   This routine computes observer-target states for observers whose
%   trajectories are not provided by SPK files.
%
%   Observers supported by this routine must have constant velocity
%   with respect to a specified center of motion, expressed in a
%   caller-specified reference frame. The state of the center of
%   motion relative to the target must be computable using
%   loaded SPK data.
%
%   For applications in which the observer has zero velocity
%   relative to its center of motion, the Mice routine
%
%      cspice_spkcpo     { SPK, constant position observer }
%
%   can be used. cspice_spkcpo has a simpler interface than that
%   of cspice_spkcvo.
%
%   This routine is suitable for computing states of target ephemeris
%   objects, as seen from landmarks on the surface of an extended
%   object, in cases where no SPK data are available for those
%   landmarks.
%
%   This routine's treatment of the output reference frame differs
%   from that of the principal SPK API routines
%
%      cspice_spkezr
%      cspice_spkpos
%
%   which require both observer and target ephemerides to be provided
%   by loaded SPK files:
%
%      The SPK API routines listed above evaluate the orientation of the
%      output reference frame (with respect to the J2000 frame) at an
%      epoch corrected for one-way light time between the observer and
%      the center of the output frame. When the center of the output
%      frame is not the target (for example, when the target is on the
%      surface of Mars and the output frame is centered at Mars'
%      center), the epoch of evaluation may not closely match the
%      light-time corrected epoch associated with the target itself. A
%      similar problem may occur when the observer is a surface point on
%      an extended body and the output frame is centered at the body
%      center: the listed routines will correct the orientation of the
%      output frame for one-way light time between the frame center and
%      the observer.
%
%      This routine allows the caller to dictate how the orientation
%      of the output reference frame is to be evaluated. The caller
%      passes to this routine an input string called the output
%      frame's evaluation "locus." This string specifies the location
%      associated with the output frame's evaluation epoch. The three
%      possible values of the locus are
%
%         'TARGET'
%         'OBSERVER'
%         'CENTER'
%
%      The choice of locus has an effect when aberration corrections
%      are used and the output frame is non-inertial.
%
%      When the locus is 'TARGET' and light time corrections are
%      used, the orientation of the output frame is evaluated at the
%      epoch obtained by correcting the observation epoch `et' for
%      one-way light time `lt'. The evaluation epoch will be either
%      et-lt or et+lt for reception or transmission corrections
%      respectively.
%
%      For remote sensing applications where the target is a surface
%      point on an extended object, and the orientation of that
%      object should be evaluated at the emission time, the locus
%      'TARGET' should be used.
%
%      When the output frame's orientation should be evaluated at
%      the observation epoch `et', which is the case when the
%      output frame is centered at the observer, the locus
%      'OBSERVER' should be used.
%
%      The locus option 'CENTER' is provided for compatibility
%      with existing SPK state computation APIs such as cspice_spkezr.
%
%      Note that the output frame evaluation locus does not affect
%      the computation of light time between the target and
%      observer.
%
%
%   The SPK routines that compute observer-target states for
%   combinations of objects having ephemerides provided by the SPK
%   system and objects having constant position or constant velocity
%   are
%
%      cspice_spkcpo {SPK, Constant position observer}
%      cspice_spkcpt {SPK, Constant position target}
%      cspice_spkcvo {SPK, Constant velocity observer}
%      cspice_spkcvt {SPK, Constant velocity target}
%
%-Exceptions
%
%   1)  If either the name of the center of motion or the target
%       cannot be translated to its NAIF ID code, the error
%       SPICE(IDCODENOTFOUND) is signaled by a routine in the call
%       tree of this routine.
%
%   2)  If the reference frame `outref' is unrecognized, the error
%       SPICE(UNKNOWNFRAME) is signaled by a routine in the call tree
%       of this routine.
%
%   3)  If the reference frame `obsref' is unrecognized, an error is
%       signaled by a routine in the call tree of this routine.
%
%   4)  If the frame evaluation locus `refloc' is not recognized, the
%       error SPICE(NOTSUPPORTED) is signaled by a routine in the call
%       tree of this routine.
%
%   5)  If the loaded kernels provide insufficient data to compute
%       the requested state vector, an error is signaled
%       by a routine in the call tree of this routine.
%
%   6)  If an error occurs while reading an SPK or other kernel file,
%       the error  is signaled by a routine in the call tree of
%       this routine.
%
%   7)  If the aberration correction `abcorr' is not recognized, an
%       error is signaled by a routine in the call tree of this
%       routine.
%
%   8)  If any of the input arguments, `target', `et', `outref',
%       `refloc', `abcorr', `obssta', `obsepc', `obsctr' or `obsref',
%       is undefined, an error is signaled by the Matlab error
%       handling system.
%
%   9)  If any of the input arguments, `target', `et', `outref',
%       `refloc', `abcorr', `obssta', `obsepc', `obsctr' or `obsref',
%       is not of the expected type, or it does not have the expected
%       dimensions and size, an error is signaled by the Mice
%       interface.
%
%-Files
%
%   Appropriate kernels must be loaded by the calling program before
%   this routine is called.
%
%   The following data are required:
%
%   -  SPK data: ephemeris data for the observer center and target
%      must be loaded. If aberration corrections are used, the
%      states of observer center and target relative to the solar
%      system barycenter must be calculable from the available
%      ephemeris data. Typically ephemeris data are made available
%      by loading one or more SPK files using cspice_furnsh.
%
%   The following data may be required:
%
%   -  PCK data: if the target frame is a PCK frame, rotation data
%      for the target frame must be loaded. These may be provided
%      in a text or binary PCK file.
%
%   -  Frame data: if a frame definition not built into SPICE is
%      required, for example to convert the observer-target state
%      to the output frame, that definition must be available in
%      the kernel pool. Typically frame definitions are supplied
%      by loading a frame kernel using cspice_furnsh.
%
%   -  Additional kernels: if any frame used in this routine's
%      state computation is a CK frame, then at least one CK and
%      corresponding SCLK kernel is required. If dynamic frames
%      are used, additional SPK, PCK, CK, or SCLK kernels may be
%      required.
%
%   In all cases, kernel data are normally loaded once per program
%   run, NOT every time this routine is called.
%
%-Restrictions
%
%   1)  This routine may not be suitable for work with stars or other
%       objects having large distances from the observer, due to loss
%       of precision in position vectors.
%
%-Required_Reading
%
%   FRAMES.REQ
%   MICE.REQ
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
%   -Mice Version 1.1.0, 07-AUG-2020 (EDW) (JDR)
%
%       Changed input argument name "evlref" to "refloc".
%
%       Edited the header to comply with NAIF standard. Added example's task
%       description.
%
%       Added -Parameters, -Exceptions, -Files, -Restrictions,
%       -Literature_References and -Author_and_Institution sections.
%
%       Eliminated use of "lasterror" in rethrow.
%
%       Removed reference to the function's corresponding CSPICE header from
%       -Required_Reading section.
%
%   -Mice Version 1.0.0, 11-JUN-2013 (EDW)
%
%-Index_Entries
%
%   state relative to constant_velocity_observer
%   state relative to constant_velocity surface_point
%   state relative to surface_point on extended_object
%   state relative to landmark on extended_object
%
%-&

function [state, lt] = cspice_spkcvo(target, et,     outref, ...
                                     refloc, abcorr, obssta, ...
                                     obsepc, obsctr, obsref )

   switch nargin
      case 9

         target = zzmice_str(target);
         et     = zzmice_dp(et);
         outref = zzmice_str(outref);
         refloc = zzmice_str(refloc);
         abcorr = zzmice_str(abcorr);
         obssta = zzmice_dp(obssta);
         obsepc = zzmice_dp(obsepc);
         obsctr = zzmice_str(obsctr);
         obsref = zzmice_str(obsref);

      otherwise

         error ( ['Usage: [ state(6), lt] = cspice_spkcvo( ' ...
                          '`target`, et, `outref`, '         ...
                          '`refloc`, `abcorr`, obssta(6), '  ...
                          'obsepc, `obsctr`, `obsref` )'] )

   end

   %
   % Call the MEX library. The "_s" suffix indicates a structure type
   % return argument.
   %
   try
      [starg] = mice('spkcvo_s',target, et,     outref, ...
                                refloc, abcorr, obssta, ...
                                obsepc, obsctr, obsref );
      state   = reshape( [starg.state], 6, [] );
      lt      = reshape( [starg.lt   ], 1, [] );
   catch spiceerr
      rethrow(spiceerr)
   end
