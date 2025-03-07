%-Abstract
%
%   CSPICE_SPKAPO returns the position of a target body relative to an
%   observer, optionally corrected for light time and stellar aberration.
%
%-Disclaimer
%
%   THIS SOFTWARE AND ANY RELATED MATERIALS WERE CREATED BY THE
%   CALIFORNIA INSTITUTE OF TECHNOLOGY (CALTECH) UNDER A U.S.
%   GOVERNMENT CONTRACT WITH THE NATIONAL AERONAUTICS AND SPACE
%   ADMINISTRATION (NASA). THE SOFTWARE IS TECHNOLOGY AND SOFTWARE
%   PUBLICLY AVAILABLE UNDER U.S. EXPORT LAWS AND IS PROVIDED "AS-IS"
%   TO THE RECIPIENT WITHOUT WARRANTY OF ANY KIND, INCLUDING ANY
%   WARRANTIES OF PERFORMANCE OR MERCHANTABILITY OR FITNESS FOR A
%   PARTICULAR USE OR PURPOSE (AS SET FORTH IN UNITED STATES UCC
%   SECTIONS 2312-2313) OR FOR ANY PURPOSE WHATSOEVER, FOR THE
%   SOFTWARE AND RELATED MATERIALS, HOWEVER USED.
%
%   IN NO EVENT SHALL CALTECH, ITS JET PROPULSION LABORATORY, OR NASA
%   BE LIABLE FOR ANY DAMAGES AND/OR COSTS, INCLUDING, BUT NOT
%   LIMITED TO, INCIDENTAL OR CONSEQUENTIAL DAMAGES OF ANY KIND,
%   INCLUDING ECONOMIC DAMAGE OR INJURY TO PROPERTY AND LOST PROFITS,
%   REGARDLESS OF WHETHER CALTECH, JPL, OR NASA BE ADVISED, HAVE
%   REASON TO KNOW, OR, IN FACT, SHALL KNOW OF THE POSSIBILITY.
%
%   RECIPIENT BEARS ALL RISK RELATING TO QUALITY AND PERFORMANCE OF
%   THE SOFTWARE AND ANY RELATED MATERIALS, AND AGREES TO INDEMNIFY
%   CALTECH AND NASA FOR ALL THIRD-PARTY CLAIMS RESULTING FROM THE
%   ACTIONS OF RECIPIENT IN THE USE OF THE SOFTWARE.
%
%-I/O
%
%   Given:
%
%      targ     the NAIF ID code for a target body.
%
%               [1,1] = size(targ); int32 = class(targ)
%
%               The target and observer define a position vector which
%               points from the observer to the target.
%
%      et       the ephemeris time, expressed as seconds past J2000 TDB, at
%               which the position of the target body relative to the
%               observer is to be computed.
%
%               [1,1] = size(et); double = class(et)
%
%               `et' refers to time at the observer's location.
%
%      ref      the inertial reference frame with respect to which the
%               observer's state `sobs' is expressed.
%
%               [1,c1] = size(ref); char = class(ref)
%
%                  or
%
%               [1,1] = size(ref); cell = class(ref)
%
%               `ref' must be recognized by the SPICE Toolkit. The
%               acceptable frames are listed in the Frames Required Reading.
%
%               Case and blanks are not significant in the string
%               `ref'.
%
%      sobs     the geometric (uncorrected) state of the observer relative to
%               the solar system barycenter at epoch et.
%
%               [6,1] = size(sobs); double = class(sobs)
%
%               `sobs' is a 6-vector: the first three components of `sobs'
%               represent a Cartesian position vector; the last three
%               components represent the corresponding velocity vector.
%               `sobs' is expressed relative to the inertial reference frame
%               designated by `ref'.
%
%               Units are always km and km/sec.
%
%
%      abcorr   indicates the aberration corrections to be applied to the
%               position of the target body to account for one-way light time
%               and stellar aberration.
%
%               [1,c2] = size(abcorr); char = class(abcorr)
%
%                  or
%
%               [1,1] = size(abcorr); cell = class(abcorr)
%
%               See the discussion in the -Particulars section for
%               recommendations on how to choose aberration corrections.
%
%               `abcorr' may be any of the following:
%
%                  'NONE'     Apply no correction. Return the
%                             geometric position of the target body
%                             relative to the observer.
%
%               The following values of `abcorr' apply to the
%               "reception" case in which photons depart from the
%               target's location at the light-time corrected epoch
%               et-lt and *arrive* at the observer's location at et:
%
%                  'LT'       Correct for one-way light time (also
%                             called "planetary aberration") using a
%                             Newtonian formulation. This correction
%                             yields the position of the target at the
%                             moment it emitted photons arriving at
%                             the observer at et.
%
%                             The light time correction involves
%                             iterative solution of the light time
%                             equation (see -Particulars for details).
%                             The solution invoked by the 'LT' option
%                             uses one iteration.
%
%                  'LT+S'     Correct for one-way light time and
%                             stellar aberration using a Newtonian
%                             formulation. This option modifies the
%                             position obtained with the 'LT' option
%                             to account for the observer's velocity
%                             relative to the solar system
%                             barycenter. The result is the apparent
%                             position of the target---the position
%                             of the target as seen by the observer.
%
%                  'CN'       Converged Newtonian light time
%                             correction. In solving the light time
%                             equation, the 'CN' correction iterates
%                             until the solution converges (three
%                             iterations on all supported platforms).
%                             Whether the 'CN+S' solution is
%                             substantially more accurate than the
%                             'LT' solution depends on the geometry
%                             of the participating objects and on the
%                             accuracy of the input data. In all
%                             cases this routine will execute more
%                             slowly when a converged solution is
%                             computed. See the -Particulars section of
%                             cspice_spkezr for a discussion of precision of
%                             light time corrections.
%
%                  'CN+S'     Converged Newtonian light time
%                             correction and stellar aberration
%                             correction.
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
%                             position of the target at the moment it
%                             receives photons emitted from the
%                             observer's location at `et'.
%
%                  'XLT+S'    "Transmission" case: correct for
%                             one-way light time and stellar
%                             aberration using a Newtonian
%                             formulation  This option modifies the
%                             position obtained with the 'XLT' option
%                             to account for the observer's velocity
%                             relative to the solar system
%                             barycenter. The target position
%                             indicates the direction that photons
%                             emitted from the observer's location
%                             must be "aimed" to hit the target.
%
%                  'XCN'      "Transmission" case: converged
%                             Newtonian light time correction.
%
%                  'XCN+S'    "Transmission" case: converged Newtonian
%                             light time correction and stellar
%                             aberration correction.
%
%               Neither special nor general relativistic effects are
%               accounted for in the aberration corrections applied
%               by this routine.
%
%               Case and blanks are not significant in the string
%               `abcorr'.
%
%   the call:
%
%      [ptarg, lt] = cspice_spkapo( targ, et, ref, sobs, abcorr )
%
%   returns:
%
%      ptarg    a Cartesian 3-vector representing the position of the target
%               body relative to the specified observer.
%
%               [3,1] = size(ptarg); double = class(ptarg)
%
%               `ptarg' is corrected for the specified aberrations, and is
%               expressed with respect to the specified inertial reference
%               frame. The components of `ptarg' represent the x-, y- and
%               z-components of the target's position.
%
%               Units are always km.
%
%               The vector `ptarg' points from the observer's position
%               at `et' to the aberration-corrected location of the
%               target. Note that the sense of the position vector is
%               independent of the direction of radiation travel
%               implied by the aberration correction.
%
%      lt       the one-way light time between the observer and target in
%               seconds.
%
%               [1,1] = size(lt); double = class(lt)
%
%               If the target position is corrected for aberrations, then
%               `lt' is the one-way light time between the observer and the
%               light time corrected target location.
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
%   1) Compute the apparent position of the Moon relative to the
%      Earth, corrected for one light-time and stellar aberration,
%      given the geometric state of the Earth relative to the Solar
%      System Barycenter, and the difference between the stellar
%      aberration corrected and uncorrected position vectors, taking
%      several steps.
%
%      First, compute the light-time corrected state of the Moon body
%      as seen by the Earth, using its geometric state. Then apply
%      the correction for stellar aberration to the light-time
%      corrected state of the target body.
%
%      The code in this example could be replaced by a single call
%      to cspice_spkpos:
%
%         [pos, lt] = cspice_spkpos( 'MOON',  et,     ...
%                                    'J2000', 'LT+S', ...
%                                    'EARTH'          );
%
%
%      Use the meta-kernel shown below to load the required SPICE
%      kernels.
%
%
%         KPL/MK
%
%         File name: spkapo_ex1.tm
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
%            de418.bsp                     Planetary ephemeris
%            naif0009.tls                  Leapseconds
%
%         \begindata
%
%            KERNELS_TO_LOAD = ( 'de418.bsp',
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
%      function spkapo_ex1()
%
%         %
%         % Assign an observer, Earth, target, Moon, time of interest and
%         % reference frame for returned vectors.
%         %
%         idobs  = 399;
%         idtarg = 301;
%         utcstr = 'July 4 2004';
%         reffrm = 'J2000';
%
%         %
%         % Load the needed kernels.
%         %
%         cspice_furnsh( 'spkapo_ex1.tm' );
%
%         %
%         % Convert the time string to ephemeris time, J2000.
%         %
%         [et] = cspice_str2et( utcstr );
%
%         %
%         % Get the state of the observer with respect to the solar
%         % system barycenter.
%         %
%         [sobs] = cspice_spkssb( idobs, et, reffrm );
%
%         %
%         % Get the light-time corrected position `pos' of the target
%         % body `idtarg' as seen by the observer.
%         %
%         [pos, lt] = cspice_spkapo( idtarg, et, reffrm, sobs, 'LT' );
%
%         %
%         % Output the uncorrected vector.
%         %
%         fprintf( 'Uncorrected position vector\n' )
%         fprintf( '   %18.6f %18.6f %18.6f\n', pos(1), pos(2), pos(3) )
%
%         %
%         % Apply the correction for stellar aberration to the
%         % light-time corrected position of the target body.
%         %
%         [pcorr] = cspice_stelab( pos, sobs(4:6) );
%
%         %
%         % Output the corrected position vector and the apparent
%         % difference from the uncorrected vector.
%         %
%         fprintf( '\n' )
%         fprintf( 'Corrected position vector\n' )
%         fprintf( '   %18.6f %18.6f %18.6f\n', ...
%                  pcorr(1), pcorr(2), pcorr(3) )
%
%         %
%         % Apparent difference.
%         %
%         appdif = pos - pcorr;
%         fprintf( '\n' )
%         fprintf( 'Apparent difference\n' )
%         fprintf( '   %18.6f %18.6f %18.6f\n',    ...
%                  appdif(1), appdif(2), appdif(3) )
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
%      Uncorrected position vector
%              201738.725087     -260893.141602     -147722.589056
%
%      Corrected position vector
%              201765.929516     -260876.818077     -147714.262441
%
%      Apparent difference
%                 -27.204429         -16.323525          -8.326615
%
%
%-Particulars
%
%   In space science or engineering applications one frequently
%   wishes to know where to point a remote sensing instrument, such
%   as an optical camera or radio antenna, in order to observe or
%   otherwise receive radiation from a target. This pointing problem
%   is complicated by the finite speed of light: one needs to point
%   to where the target appears to be as opposed to where it actually
%   is at the epoch of observation. We use the adjectives
%   "geometric," "uncorrected," or "true" to refer to an actual
%   position or state of a target at a specified epoch. When a
%   geometric position or state vector is modified to reflect how it
%   appears to an observer, we describe that vector by any of the
%   terms "apparent," "corrected," "aberration corrected," or "light
%   time and stellar aberration corrected."
%
%   The SPICE Toolkit can correct for two phenomena affecting the
%   apparent location of an object: one-way light time (also called
%   "planetary aberration") and stellar aberration. Correcting for
%   one-way light time is done by computing, given an observer and
%   observation epoch, where a target was when the observed photons
%   departed the target's location. The vector from the observer to
%   this computed target location is called a "light time corrected"
%   vector. The light time correction depends on the motion of the
%   target, but it is independent of the velocity of the observer
%   relative to the solar system barycenter. Relativistic effects
%   such as light bending and gravitational delay are not accounted
%   for in the light time correction performed by this routine.
%
%   The velocity of the observer also affects the apparent location
%   of a target: photons arriving at the observer are subject to a
%   "raindrop effect" whereby their velocity relative to the observer
%   is, using a Newtonian approximation, the photons' velocity
%   relative to the solar system barycenter minus the velocity of the
%   observer relative to the solar system barycenter. This effect is
%   called "stellar aberration." Stellar aberration is independent
%   of the motion of the target. The stellar aberration formula used
%   by this routine is non- relativistic.
%
%   Stellar aberration corrections are applied after light time
%   corrections: the light time corrected target position vector is
%   used as an input to the stellar aberration correction.
%
%   When light time and stellar aberration corrections are both
%   applied to a geometric position vector, the resulting position
%   vector indicates where the target "appears to be" from the
%   observer's location.
%
%   As opposed to computing the apparent position of a target, one
%   may wish to compute the pointing direction required for
%   transmission of photons to the target. This requires correction
%   of the geometric target position for the effects of light time and
%   stellar aberration, but in this case the corrections are computed
%   for radiation traveling from the observer to the target.
%
%   The "transmission" light time correction yields the target's
%   location as it will be when photons emitted from the observer's
%   location at `et' arrive at the target. The transmission stellar
%   aberration correction is the inverse of the traditional stellar
%   aberration correction: it indicates the direction in which
%   radiation should be emitted so that, using a Newtonian
%   approximation, the sum of the velocity of the radiation relative
%   to the observer and of the observer's velocity, relative to the
%   solar system barycenter, yields a velocity vector that points in
%   the direction of the light time corrected position of the target.
%
%   The traditional aberration corrections applicable to observation
%   and those applicable to transmission are related in a simple way:
%   one may picture the geometry of the "transmission" case by
%   imagining the "observation" case running in reverse time order,
%   and vice versa.
%
%   One may reasonably object to using the term "observer" in the
%   transmission case, in which radiation is emitted from the
%   observer's location. The terminology was retained for
%   consistency with earlier documentation.
%
%   Below, we indicate the aberration corrections to use for some
%   common applications:
%
%      1) Find the apparent direction of a target. This is
%         the most common case for a remote-sensing observation.
%
%            Use 'LT+S' or 'CN+S': apply both light time and stellar
%            aberration corrections.
%
%         Note that using light time corrections alone ('LT') is
%         generally not a good way to obtain an approximation to an
%         apparent target vector: since light time and stellar
%         aberration corrections often partially cancel each other,
%         it may be more accurate to use no correction at all than to
%         use light time alone.
%
%
%      2) Find the corrected pointing direction to radiate a signal
%         to a target. This computation is often applicable for
%         implementing communications sessions.
%
%            Use 'XLT+S' or 'XCN+S': apply both light time and stellar
%            aberration corrections for transmission.
%
%
%      3) Compute the apparent position of a target body relative
%         to a star or other distant object.
%
%            Use one of 'LT', 'CN', 'LT+S', or 'CN+S' as needed to match
%            the correction applied to the position of the distant
%            object. For example, if a star position is obtained from a
%            catalog, the position vector may not be corrected for
%            stellar aberration. In this case, to find the angular
%            separation of the star and the limb of a planet, the vector
%            from the observer to the planet should be corrected for
%            light time but not stellar aberration.
%
%
%      4) Obtain an uncorrected state vector derived directly from
%         data in an SPK file.
%
%            Use 'NONE'.
%
%
%      5) Use a geometric state vector as a low-accuracy estimate
%         of the apparent state for an application where execution
%         speed is critical.
%
%            Use 'NONE'.
%
%
%      6) While this routine cannot perform the relativistic
%         aberration corrections required to compute states
%         with the highest possible accuracy, it can supply the
%         geometric states required as inputs to these computations.
%
%            Use 'NONE', then apply relativistic aberration
%            corrections (not available in the SPICE Toolkit).
%
%
%   Below, we discuss in more detail how the aberration corrections
%   applied by this routine are computed.
%
%
%   Geometric case
%   ==============
%
%      cspice_spkapo begins by computing the geometric position targ(et) of
%      the target body relative to the solar system barycenter (SSB).
%      Subtracting the geometric position of the observer obs(et) gives
%      the geometric position of the target body relative to the
%      observer. The one-way light time, `lt', is given by
%
%               | targ(et) - obs(et) |
%         lt = ------------------------
%                         C
%
%      The geometric relationship between the observer, target, and
%      solar system barycenter is as shown:
%
%
%          SSB ---> obs(et)
%           |      /
%           |     /
%           |    /
%           |   /  targ(et) - obs(et)
%           V  V
%         targ(et)
%
%
%      The returned position vector is
%
%         targ(et) - obs(et)
%
%
%   Reception case
%   ==============
%
%      When any of the options 'LT', 'CN', 'LT+S', 'CN+S' are
%      selected, cspice_spkapo computes the position of the target body at
%      epoch et-lt, where `lt' is the one-way light time. Let targ(t)
%      and obs(t) represent the positions of the target and observer
%      relative to the solar system barycenter at time `t'; then `lt'
%      is the solution of the
%      light-time equation
%
%               | targ(et-lt) - obs(et) |
%         lt = ---------------------------                         (1)
%                           C
%
%      The ratio
%
%          | targ(et) - obs(et) |
%         ------------------------                                 (2)
%                    C
%
%      is used as a first approximation to `lt'; inserting (2) into the
%      RHS of the light-time equation (1) yields the 'one-iteration'
%      estimate of the one-way light time. Repeating the process
%      until the estimates of lt converge yields the "converged
%      Newtonian" light time estimate.
%
%      Subtracting the geometric position of the observer obs(et) gives
%      the position of the target body relative to the observer:
%      targ(et-lt) - obs(et).
%
%           SSB ---> obs(et)
%            | \       |
%            |  \      |
%            |   \     | targ(et-lt) - obs(et)
%            |    \    |
%            |     \   |
%            |      \  |
%            V       V V
%         targ(et)   targ(et-lt)
%
%
%      The light-time corrected position is the vector
%
%         targ(et-lt) - obs(et)
%
%      If correction for stellar aberration is requested, the target
%      position is rotated toward the solar system barycenter-relative
%      velocity vector of the observer. The magnitude of the rotation
%      depends on the magnitude of the observer's velocity relative
%      to the solar system barycenter and the angle between
%      this velocity and the observer-target vector. The rotation
%      is computed as follows:
%
%         Let `r' be the light time corrected vector from the observer
%         to the object, and `v' be the velocity of the observer with
%         respect to the solar system barycenter. Let `w' be the angle
%         between them. The aberration angle phi is given by
%
%            sin(phi) = v * sin(w) / c
%
%         Let `h' be the vector given by the cross product
%
%            h = r X v
%
%         Rotate `r' by `phi' radians about `h' to obtain the apparent
%         position of the object.
%
%
%
%   Transmission case
%   ==================
%
%      When any of the options 'XLT', 'XCN', 'XLT+S', 'XCN+S' are
%      selected, cspice_spkapo computes the position of the target body at
%      epoch et+lt, where `lt' is the one-way light time.  `lt' is the
%      solution of the light-time equation
%
%               | targ(et+lt) - obs(et) |
%         lt = ---------------------------                         (3)
%                           C
%
%      Subtracting the geometric position of the observer, obs(et),
%      gives the position of the target body relative to the
%      observer: targ(et-lt) - obs(et).
%
%                     SSB --> obs(et)
%                    / |    *
%                   /  |  *  targ(et+lt) - obs(et)
%                  /   |*
%                 /   *|
%                V  V  V
%         targ(et+lt)  targ(et)
%
%
%      The light-time corrected position is
%
%         targ(et+lt) - obs(et)
%
%      If correction for stellar aberration is requested, the target
%      position is rotated away from the solar system barycenter-
%      relative velocity vector of the observer. The magnitude of the
%      rotation depends on the magnitude of the velocity and the
%      angle between the velocity and the observer-target vector.
%      The rotation is computed as in the reception case, but the
%      sign of the rotation angle is negated.
%
%   Neither special nor general relativistic effects are accounted
%   for in the aberration corrections performed by this routine.
%
%-Exceptions
%
%   1)  If the value of `abcorr' is not recognized, the error
%       SPICE(SPKINVALIDOPTION) is signaled by a routine in the call
%       tree of this routine.
%
%   2)  If the reference frame requested is not a recognized
%       inertial reference frame, the error SPICE(BADFRAME) is
%       signaled by a routine in the call tree of this routine.
%
%   3)  If the position of the target relative to the solar system
%       barycenter cannot be computed, an error is signaled by a
%       routine in the call tree of this routine.
%
%   4)  If any of the input arguments, `targ', `et', `ref', `sobs' or
%       `abcorr', is undefined, an error is signaled by the Matlab
%       error handling system.
%
%   5)  If any of the input arguments, `targ', `et', `ref', `sobs' or
%       `abcorr', is not of the expected type, or it does not have the
%       expected dimensions and size, an error is signaled by the Mice
%       interface.
%
%-Files
%
%   This routine computes positions using SPK files that have been
%   loaded into the SPICE system, normally via the kernel loading
%   interface routine cspice_furnsh. Application programs typically load
%   kernels once before this routine is called, for example during
%   program initialization; kernels need not be loaded repeatedly.
%   See the routine cspice_furnsh and the SPK and KERNEL Required Reading
%   for further information on loading (and unloading) kernels.
%
%   If any of the ephemeris data used to compute `ptarg' are expressed
%   relative to a non-inertial frame in the SPK files providing those
%   data, additional kernels may be needed to enable the reference
%   frame transformations required to compute `ptarg'. Normally
%   these additional kernels are PCK files or frame kernels. Any
%   such kernels must already be loaded at the time this routine is
%   called.
%
%-Restrictions
%
%   1)  The ephemeris files to be used by cspice_spkapo must be loaded
%       (normally by the Mice kernel loader cspice_furnsh) before
%       this routine is called.
%
%   2)  Unlike most other SPK position computation routines, this
%       routine requires that the input state be relative to an
%       inertial reference frame. Non-inertial frames are not
%       supported by this routine.
%
%   3)  In a future version of this routine, the implementation
%       of the aberration corrections may be enhanced to improve
%       accuracy.
%
%-Required_Reading
%
%   MICE.REQ
%   SPK.REQ
%
%-Literature_References
%
%   None.
%
%-Author_and_Institution
%
%   J. Diaz del Rio     (ODC Space)
%
%-Version
%
%   -Mice Version 1.0.0, 10-AUG-2021 (JDR)
%
%-Index_Entries
%
%   apparent position from SPK file
%   get apparent position
%
%-&
function [ptarg, lt] = cspice_spkapo( targ, et, ref, sobs, abcorr )

   switch nargin
      case 5

         targ = zzmice_int(targ);
         et = zzmice_dp(et);
         ref = zzmice_str(ref);
         sobs = zzmice_dp(sobs);
         abcorr = zzmice_str(abcorr);

      otherwise

         error ( ['Usage: [ptarg(3), lt] = ',                             ...
                  'cspice_spkapo( targ, et, `ref`, sobs(6), `abcorr` )'] )

   end

   %
   % Call the MEX library. The "_s" suffix indicates a structure type
   % return argument.
   %
   try
      [ptarg_s] = mice('spkapo_s', targ, et, ref, sobs, abcorr);
      ptarg  = reshape( [ptarg_s.pos   ], 3, [] );
      lt     = reshape( [ptarg_s.lt    ], 1, [] );
   catch spiceerr
      rethrow(spiceerr)
   end
