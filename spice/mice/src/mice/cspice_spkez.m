%-Abstract
%
%   CSPICE_SPKEZ returns the state (position and velocity) of a target body
%   relative to an observing body, optionally corrected for light
%   time (planetary aberration) and stellar aberration.
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
%               The target and observer define a state vector whose
%               position component points from the observer to the target.
%
%      et       the ephemeris time, expressed as seconds past J2000 TDB, at
%               which the state of the target body relative to the observer
%               is to be computed.
%
%               [1,1] = size(et); double = class(et)
%
%               `et' refers to time at the observer's location.
%
%      ref      the name of the reference frame relative to which the output
%               state vector should be expressed.
%
%               [1,c1] = size(ref); char = class(ref)
%
%                  or
%
%               [1,1] = size(ref); cell = class(ref)
%
%               This may be any frame supported by the SPICE system,
%               including built-in frames (documented in the Frames Required
%               Reading) and frames defined by a loaded frame kernel (FK).
%
%               When `ref' designates a non-inertial frame, the
%               orientation of the frame is evaluated at an epoch
%               dependent on the selected aberration correction.
%               See the description of the output state vector `starg'
%               for details.
%
%      abcorr   indicates the aberration corrections to be applied to the
%               state of the target body to account for one-way light time
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
%                             geometric state of the target body
%                             relative to the observer.
%
%               The following values of `abcorr' apply to the
%               "reception" case in which photons depart from the
%               target's location at the light-time corrected epoch
%               et-lt and *arrive* at the observer's location at
%               `et':
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
%                             equation (see -Particulars for details).
%                             The solution invoked by the 'LT' option
%                             uses one iteration.
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
%                             until the solution converges (three
%                             iterations on all supported platforms).
%                             Whether the 'CN+S' solution is
%                             substantially more accurate than the
%                             'LT' solution depends on the geometry
%                             of the participating objects and on the
%                             accuracy of the input data. In all
%                             cases this routine will execute more
%                             slowly when a converged solution is
%                             computed. See the -Particulars section
%                             below for a discussion of precision of
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
%                  'XCN+S'    "Transmission" case: converged Newtonian
%                             light time correction and stellar
%                             aberration correction.
%
%
%               Neither special nor general relativistic effects are
%               accounted for in the aberration corrections applied
%               by this routine.
%
%               Case and blanks are not significant in the string
%               `abcorr'.
%
%      obs      the NAIF ID code for an observing body.
%
%               [1,1] = size(obs); int32 = class(obs)
%
%   the call:
%
%      [starg, lt] = cspice_spkez( targ, et, ref, abcorr, obs )
%
%   returns:
%
%      starg    a Cartesian state vector representing the position and
%               velocity of the target body relative to the specified
%               observer.
%
%               [6,1] = size(starg); double = class(starg)
%
%               `starg' is corrected for the specified aberrations, and is
%               expressed with respect to the reference frame specified by
%               `ref'. The first three components of `starg' represent the
%               x-, y- and z-components of the target's position; the last
%               three components form the corresponding velocity vector.
%
%               Units are always km and km/sec.
%
%               The position component of `starg' points from the
%               observer's location at `et' to the aberration-corrected
%               location of the target. Note that the sense of the
%               position vector is independent of the direction of
%               radiation travel implied by the aberration
%               correction.
%
%               The velocity component of `starg' is the derivative
%               with respect to time of the position component of
%               `starg.'
%
%               Non-inertial frames are treated as follows: letting
%               `ltcent' be the one-way light time between the observer
%               and the central body associated with the frame, the
%               orientation of the frame is evaluated at et-ltcent,
%               et+ltcent, or `et' depending on whether the requested
%               aberration correction is, respectively, for received
%               radiation, transmitted radiation, or is omitted. `ltcent'
%               is computed using the method indicated by `abcorr'.
%
%      lt       the one-way light time between the observer and target in
%               seconds.
%
%               [1,1] = size(lt); double = class(lt)
%
%               If the target state is corrected for aberrations, then 'lt'
%               is the one-way light time between the observer and the light
%               time corrected target location.
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
%   1) Load a planetary ephemeris SPK, then look up a series of
%      geometric states of the Moon relative to the Earth,
%      referenced to the J2000 frame.
%
%      Use the SPK kernel below to load the required Earth and
%      Moon ephemeris data.
%
%         de421.bsp
%
%
%      Example code begins here.
%
%
%      function spkez_ex1()
%
%         ABCORR = 'NONE';
%         FRAME  = 'J2000';
%
%         %
%         % The name of the SPK file shown here is fictitious;
%         % you must supply the name of an SPK file available
%         % on your own computer system.
%         %
%         SPK = 'de421.bsp';
%
%         %
%         % ET0 represents the date 2000 Jan 1 12:00:00 TDB.
%         %
%         ET0 = 0.0;
%
%         %
%         % Use a time step of 1 hour; look up 4 states.
%         %
%         STEP   = 3600.0;
%         MAXITR = 4;
%
%         %
%         % The NAIF IDs of the earth and moon are 399 and 301
%         % respectively.
%         %
%         OBSERVER = 399;
%         TARGET   = 301;
%
%         %
%         % Load the spk file.
%         %
%         cspice_furnsh( SPK );
%
%         %
%         % Step through a series of epochs, looking up a state vector
%         % at each one.
%         %
%         for i=0:MAXITR-1
%
%            et =  ET0 + i*STEP;
%
%            [state, lt] = cspice_spkez( TARGET,  et,     ...
%                                        FRAME,   ABCORR, ...
%                                        OBSERVER         );
%
%            fprintf( '\n' )
%            fprintf( 'et = %20.10f\n', et )
%            fprintf( '\n' )
%            fprintf( 'J2000 x-position (km):   %20.10f\n', state(1) )
%            fprintf( 'J2000 y-position (km):   %20.10f\n', state(2) )
%            fprintf( 'J2000 z-position (km):   %20.10f\n', state(3) )
%            fprintf( 'J2000 x-velocity (km/s): %20.10f\n', state(4) )
%            fprintf( 'J2000 y-velocity (km/s): %20.10f\n', state(5) )
%            fprintf( 'J2000 z-velocity (km/s): %20.10f\n', state(6) )
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
%      et =         0.0000000000
%
%      J2000 x-position (km):     -291608.3853096409
%      J2000 y-position (km):     -266716.8329467875
%      J2000 z-position (km):      -76102.4871467836
%      J2000 x-velocity (km/s):         0.6435313868
%      J2000 y-velocity (km/s):        -0.6660876862
%      J2000 z-velocity (km/s):        -0.3013257043
%
%      et =      3600.0000000000
%
%      J2000 x-position (km):     -289279.8983133120
%      J2000 y-position (km):     -269104.1084289378
%      J2000 z-position (km):      -77184.2420729120
%      J2000 x-velocity (km/s):         0.6500629244
%      J2000 y-velocity (km/s):        -0.6601685834
%      J2000 z-velocity (km/s):        -0.2996455351
%
%      et =      7200.0000000000
%
%      J2000 x-position (km):     -286928.0014055001
%      J2000 y-position (km):     -271469.9902460162
%      J2000 z-position (km):      -78259.9083077002
%      J2000 x-velocity (km/s):         0.6565368360
%      J2000 y-velocity (km/s):        -0.6542023962
%      J2000 z-velocity (km/s):        -0.2979431229
%
%      et =     10800.0000000000
%
%      J2000 x-position (km):     -284552.9026554719
%      J2000 y-position (km):     -273814.3097527430
%      J2000 z-position (km):      -79329.4060465982
%      J2000 x-velocity (km/s):         0.6629527800
%      J2000 y-velocity (km/s):        -0.6481896017
%      J2000 z-velocity (km/s):        -0.2962186180
%
%
%-Particulars
%
%   This routine is part of the user interface to the SPICE ephemeris
%   system. It allows you to retrieve state information for any
%   ephemeris object relative to any other in a reference frame that
%   is convenient for further computations.
%
%
%   Aberration corrections
%   ======================
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
%   time and stellar aberration corrected." The SPICE Toolkit can
%   correct for two phenomena affecting the apparent location of an
%   object: one-way light time (also called "planetary aberration") and
%   stellar aberration.
%
%   One-way light time
%   ------------------
%
%   Correcting for one-way light time is done by computing, given an
%   observer and observation epoch, where a target was when the observed
%   photons departed the target's location. The vector from the
%   observer to this computed target location is called a "light time
%   corrected" vector. The light time correction depends on the motion
%   of the target relative to the solar system barycenter, but it is
%   independent of the velocity of the observer relative to the solar
%   system barycenter. Relativistic effects such as light bending and
%   gravitational delay are not accounted for in the light time
%   correction performed by this routine.
%
%   Stellar aberration
%   ------------------
%
%   The velocity of the observer also affects the apparent location
%   of a target: photons arriving at the observer are subject to a
%   "raindrop effect" whereby their velocity relative to the observer
%   is, using a Newtonian approximation, the photons' velocity
%   relative to the solar system barycenter minus the velocity of the
%   observer relative to the solar system barycenter. This effect is
%   called "stellar aberration." Stellar aberration is independent
%   of the velocity of the target. The stellar aberration formula
%   used by this routine does not include (the much smaller)
%   relativistic effects.
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
%   transmission of photons to the target. This also requires correction
%   of the geometric target position for the effects of light time
%   and stellar aberration, but in this case the corrections are
%   computed for radiation traveling *from* the observer to the target.
%   We will refer to this situation as the "transmission" case.
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
%   One may object to using the term "observer" in the transmission
%   case, in which radiation is emitted from the observer's location.
%   The terminology was retained for consistency with earlier
%   documentation.
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
%      Geometric case
%      ==============
%
%      cspice_spkez begins by computing the geometric position T(et) of the
%      target body relative to the solar system barycenter (SSB).
%      Subtracting the geometric position of the observer O(et) gives
%      the geometric position of the target body relative to the
%      observer. The one-way light time, `lt', is given by
%
%               | T(et) - O(et) |
%         lt = -------------------
%                       c
%
%      The geometric relationship between the observer, target, and
%      solar system barycenter is as shown:
%
%
%         SSB ---> O(et)
%          |      /
%          |     /
%          |    /
%          |   /  T(et) - O(et)
%          V  V
%         T(et)
%
%
%      The returned state consists of the position vector
%
%         T(et) - O(et)
%
%      and a velocity obtained by taking the difference of the
%      corresponding velocities. In the geometric case, the
%      returned velocity is actually the time derivative of the
%      position.
%
%
%      Reception case
%      ==============
%
%      When any of the options 'LT', 'CN', 'LT+S', 'CN+S' is selected
%      for `abcorr', cspice_spkez computes the position of the target body at
%      epoch et-lt, where `lt' is the one-way light time. Let T(t) and
%      O(t) represent the positions of the target and observer
%      relative to the solar system barycenter at time t; then `lt' is
%      the solution of the light-time equation
%
%                | T(et-lt) - O(et) |
%         lt = ------------------------                            (1)
%                         c
%
%      The ratio
%
%         | T(et) - O(et) |
%        -------------------                                       (2)
%                 c
%
%      is used as a first approximation to `lt'; inserting (2) into the
%      right hand side of the light-time equation (1) yields the
%      "one-iteration" estimate of the one-way light time ('LT').
%      Repeating the process until the estimates of `lt' converge yields
%      the "Converged Newtonian" light time estimate ('CN').
%
%      Subtracting the geometric position of the observer O(et) gives
%      the position of the target body relative to the observer:
%      T(et-lt) - O(et).
%
%         SSB ---> O(et)
%          | \     |
%          |  \    |
%          |   \   | T(et-lt) - O(et)
%          |    \  |
%          V     V V
%         T(et)  T(et-lt)
%
%      The position component of the light time corrected state
%      is the vector
%
%         T(et-lt) - O(et)
%
%      The velocity component of the light time corrected state
%      is the difference
%
%         T_vel(et-lt)*(1-d(lt)/d(et)) - O_vel(et)
%
%      where T_vel and O_vel are, respectively, the velocities of the
%      target and observer relative to the solar system barycenter at
%      the epochs et-lt and `et'.
%
%      If correction for stellar aberration is requested, the target
%      position is rotated toward the solar system barycenter-relative
%      velocity vector of the observer. The rotation is computed as
%      follows:
%
%         Let `r' be the light time corrected vector from the observer
%         to the object, and `v' be the velocity of the observer with
%         respect to the solar system barycenter. Let `w' be the angle
%         between them. The aberration angle `phi' is given by
%
%            sin(phi) = v sin(w) / C
%
%         Let `h' be the vector given by the cross product
%
%            h = r X v
%
%         Rotate `r' by `phi' radians about `h' to obtain the apparent
%         position of the object.
%
%      When stellar aberration corrections are used, the rate of change
%      of the stellar aberration correction is accounted for in the
%      computation of the output velocity.
%
%
%      Transmission case
%      ==================
%
%      When any of the options 'XLT', 'XCN', 'XLT+S', 'XCN+S' is
%      selected, cspice_spkez computes the position of the target body T at
%      epoch et+lt, where `lt' is the one-way light time. `lt' is the
%      solution of the light-time equation
%
%               | T(et+lt) - O(et) |
%         lt = ----------------------                              (3)
%                        c
%
%      Subtracting the geometric position of the observer, O(et),
%      gives the position of the target body relative to the
%      observer: T(et-lt) - O(et).
%
%                 SSB --> O(et)
%                / |    *
%               /  |  *  T(et+lt) - O(et)
%              /   |*
%             /   *|
%            V  V  V
%        T(et+lt)  T(et)
%
%      The position component of the light-time corrected state
%      is the vector
%
%         T(et+lt) - O(et)
%
%      The velocity component of the light-time corrected state
%      consists of the difference
%
%         T_vel(et+lt)*(1+d(lt)/d(et)) - O_vel(et)
%
%      where T_vel and O_vel are, respectively, the velocities of the
%      target and observer relative to the solar system barycenter at
%      the epochs et+lt and `et'.
%
%      If correction for stellar aberration is requested, the target
%      position is rotated away from the solar system barycenter-
%      relative velocity vector of the observer. The rotation is
%      computed as in the reception case, but the sign of the
%      rotation angle is negated.
%
%
%   Precision of light time corrections
%   ===================================
%
%      Corrections using one iteration of the light time solution
%      ----------------------------------------------------------
%
%      When the requested aberration correction is 'LT', 'LT+S',
%      'XLT', or 'XLT+S', only one iteration is performed in the
%      algorithm used to compute `lt'.
%
%      The relative error in this computation
%
%         | LT_ACTUAL - LT_COMPUTED |  /  LT_ACTUAL
%
%      is at most
%
%          (v/C)**2
%         ---------
%          1 - (v/C)
%
%      which is well approximated by (v/C)**2, where `v' is the
%      velocity of the target relative to an inertial frame and C is
%      the speed of light.
%
%      For nearly all objects in the solar system `v' is less than 60
%      km/sec. The value of C is ~300000 km/sec. Thus the
%      one-iteration solution for `lt' has a potential relative error
%      of not more than 4e-8. This is a potential light time error of
%      approximately 2e-5 seconds per astronomical unit of distance
%      separating the observer and target. Given the bound on `v' cited
%      above:
%
%         As long as the observer and target are separated by less
%         than 50 astronomical units, the error in the light time
%         returned using the one-iteration light time corrections is
%         less than 1 millisecond.
%
%         The magnitude of the corresponding position error, given
%         the above assumptions, may be as large as (v/C)**2 * the
%         distance between the observer and the uncorrected target
%         position: 300 km or equivalently 6 km/AU.
%
%      In practice, the difference between positions obtained using
%      one-iteration and converged light time is usually much smaller
%      than the value computed above and can be insignificant. For
%      example, for the spacecraft Mars Reconnaissance Orbiter and
%      Mars Express, the position error for the one-iteration light
%      time correction, applied to the spacecraft-to-Mars center
%      vector, is at the 1 cm level.
%
%      Comparison of results obtained using the one-iteration and
%      converged light time solutions is recommended when adequacy of
%      the one-iteration solution is in doubt.
%
%
%      Converged corrections
%      ---------------------
%
%      When the requested aberration correction is 'CN', 'CN+S',
%      'XCN', or 'XCN+S', as many iterations as are required for
%      convergence are performed in the computation of `lt'. Usually
%      the solution is found after three iterations. The relative
%      error present in this case is at most
%
%          (v/C)**4
%         ---------
%          1 - (v/C)
%
%      which is well approximated by (v/C)**4.
%
%         The precision of this computation (ignoring round-off
%         error) is better than 4e-11 seconds for any pair of objects
%         less than 50 AU apart, and having speed relative to the
%         solar system barycenter less than 60 km/s.
%
%         The magnitude of the corresponding position error, given
%         the above assumptions, may be as large as (v/C)**4 * the
%         distance between the observer and the uncorrected target
%         position: 1.2 cm at 50 AU or equivalently 0.24 mm/AU.
%
%      However, to very accurately model the light time between
%      target and observer one must take into account effects due to
%      general relativity. These may be as high as a few hundredths
%      of a millisecond for some objects.
%
%
%   Relativistic Corrections
%   =========================
%
%   This routine does not attempt to perform either general or
%   special relativistic corrections in computing the various
%   aberration corrections. For many applications relativistic
%   corrections are not worth the expense of added computation
%   cycles. If however, your application requires these additional
%   corrections we suggest you consult the astronomical almanac (page
%   B36) for a discussion of how to carry out these corrections.
%
%-Exceptions
%
%   1)  If the reference frame `ref' is not a recognized reference
%       frame, the error SPICE(UNKNOWNFRAME) is signaled by a routine
%       in the call tree of this routine.
%
%   2)  If the loaded kernels provide insufficient data to compute the
%       requested state vector, an error is signaled by a routine in
%       the call tree of this routine.
%
%   3)  If an error occurs while reading an SPK or other kernel file,
%       the error  is signaled by a routine in the call tree
%       of this routine.
%
%   4)  If any of the required attributes of the reference frame `ref'
%       cannot be determined, the error SPICE(UNKNOWNFRAME2) is
%       signaled by a routine in the call tree of this routine.
%
%   5)  If any of the input arguments, `targ', `et', `ref', `abcorr'
%       or `obs', is undefined, an error is signaled by the Matlab
%       error handling system.
%
%   6)  If any of the input arguments, `targ', `et', `ref', `abcorr'
%       or `obs', is not of the expected type, or it does not have the
%       expected dimensions and size, an error is signaled by the Mice
%       interface.
%
%-Files
%
%   This routine computes states using SPK files that have been loaded into
%   the SPICE system, normally via the kernel loading interface routine
%   cspice_furnsh. See the routine cspice_furnsh and the SPK and KERNEL
%   Required Reading for further information on loading (and unloading)
%   kernels.
%
%   If the output state `starg' is to be expressed relative to a
%   non-inertial frame, or if any of the ephemeris data used to
%   compute `starg' are expressed relative to a non-inertial frame in
%   the SPK files providing those data, additional kernels may be
%   needed to enable the reference frame transformations required to
%   compute the state. Normally these additional kernels are PCK
%   files or frame kernels. Any such kernels must already be loaded
%   at the time this routine is called.
%
%-Restrictions
%
%   None.
%
%-Required_Reading
%
%   FRAMES.REQ
%   MICE.REQ
%   NAIF_IDS.REQ
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
%
%-Version
%
%   -Mice Version 1.0.0, 10-AUG-2021 (JDR)
%
%-Index_Entries
%
%   using body codes get target state relative to an observer
%   get state relative to observer corrected for aberrations
%   read ephemeris data
%   read trajectory data
%
%-&
function [starg, lt] = cspice_spkez( targ, et, ref, abcorr, obs )

   switch nargin
      case 5

         targ   = zzmice_int(targ);
         et     = zzmice_dp(et);
         ref    = zzmice_str(ref);
         abcorr = zzmice_str(abcorr);
         obs    = zzmice_int(obs);

      otherwise

         error ( ['Usage: [starg(6), lt] = cspice_spkez( targ, et,' ...
                  ' `ref`, `abcorr`, obs )'] )

   end

   %
   % Call the MEX library. The "_s" suffix indicates a structure type
   % return argument.
   %
   try
      [starg_s] = mice('spkez_s', targ, et, ref, abcorr, obs);
      starg  = reshape( [starg_s.state ], 6, [] );
      lt     = reshape( [starg_s.lt    ], 1, [] );
   catch spiceerr
      rethrow(spiceerr)
   end
