%-Abstract
%
%   CSPICE_QDQ2AV derives angular velocity from a unit quaternion and its
%   derivative with respect to time.
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
%      q        a unit length 4-vector representing a SPICE-style quaternion.
%
%               [4,1] = size(q); double = class(q)
%
%               See the discussion of quaternion styles in -Particulars
%               below.
%
%      dq       a 4-vector representing the derivative of `q' with respect to
%               time.
%
%               [4,1] = size(dq); double = class(dq)
%
%   the call:
%
%      [av] = cspice_qdq2av( q, dq )
%
%   returns:
%
%      av       3-vector representing the angular velocity defined by `q' and
%               `dq', that is, the angular velocity of the frame defined by
%               the rotation matrix associated with `q'.
%
%               [3,1] = size(av); double = class(av)
%
%               This rotation matrix can be obtained via the Mice routine
%               cspice_q2m; see the -Particulars section for the explicit
%               matrix entries.
%
%               `av' is the vector (imaginary) part of the
%               quaternion product
%
%                        *
%                  -2 * q  * dq
%
%               This angular velocity is the same vector that could
%               be obtained (much less efficiently ) by mapping `q'
%               and `dq' to the corresponding C-matrix `r' and its
%               derivative `dr', then calling the Mice routine
%               cspice_xf2rav.
%
%               `av' has units of
%
%                  radians / T
%
%               where
%
%                  1 / T
%
%               is the unit associated with `dq'.
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
%   1) The following test program creates a quaternion and quaternion
%      derivative from a known rotation matrix and angular velocity
%      vector. The angular velocity is recovered from the quaternion
%      and quaternion derivative by calling cspice_qdq2av and by an
%      alternate method; the results are displayed for comparison.
%
%      Example code begins here.
%
%
%      function qdq2av_ex1()
%
%         %
%         % Local variables
%         %
%         dm     = zeros(3,3);
%         qav    = zeros(4,1);
%         xtrans = zeros(6,6);
%
%         %
%         % Pick some Euler angles and form a rotation matrix.
%         %
%         angle = [ -20.0 * cspice_rpd, ...
%                   50.0  * cspice_rpd, ...
%                   -60.0 * cspice_rpd  ]';
%
%         [m]   = cspice_eul2m( angle(3), angle(2), angle(1), 3, 1, 3 );
%
%         [q]   = cspice_m2q( m );
%
%         %
%         % Choose an angular velocity vector.
%         %
%         expav = [ 1.0, 2.0, 3.0 ]';
%
%         %
%         % Form the quaternion derivative.
%         %
%         qav(1)   =  0.0;
%         qav(2:4) = expav;
%
%         [dq]     = cspice_qxq( q, qav );
%
%         dq       = -0.5 * dq;
%
%         %
%         % Recover angular velocity from `q' and `dq' using cspice_qdq2av.
%         %
%         [av] = cspice_qdq2av( q, dq );
%
%         %
%         % Now we'll obtain the angular velocity from `q' and
%         % `dq' by an alternate method.
%         %
%         % Convert `q' back to a rotation matrix.
%         %
%         [m] = cspice_q2m( q );
%
%         %
%         % Convert `q' and `dq' to a rotation derivative matrix.  This
%         % somewhat messy procedure is based on differentiating the
%         % formula for deriving a rotation from a quaternion, then
%         % substituting components of `q' and `dq' into the derivative
%         % formula.
%         %
%         dm(1,1) = -4.0  * (   q(3)*dq(3) + q(4)*dq(4) );
%
%         dm(1,2) =  2.0  * (   q(2)*dq(3) + q(3)*dq(2)    ...
%                             - q(1)*dq(4) - q(4)*dq(1) );
%
%         dm(1,3) =  2.0  * (   q(2)*dq(4) + q(4)*dq(2)    ...
%                             + q(1)*dq(3) + q(3)*dq(1) );
%
%         dm(2,1) =  2.0  * (   q(2)*dq(3) + q(3)*dq(2)    ...
%                             + q(1)*dq(4) + q(4)*dq(1) );
%
%         dm(2,2) = -4.0  * (   q(2)*dq(2) + q(4)*dq(4) );
%
%         dm(2,3) =  2.0  * (   q(3)*dq(4) + q(4)*dq(3)    ...
%                             - q(1)*dq(2) - q(2)*dq(1) );
%
%         dm(3,1) =  2.0  * (   q(4)*dq(2) + q(2)*dq(4)    ...
%                             - q(1)*dq(3) - q(3)*dq(1) );
%
%         dm(3,2) =  2.0  * (   q(3)*dq(4) + q(4)*dq(3)    ...
%                             + q(1)*dq(2) + q(2)*dq(1) );
%
%         dm(3,3) = -4.0  * (   q(2)*dq(2) + q(3)*dq(3) );
%
%         %
%         % Form the state transformation matrix corresponding to `m'
%         % and `dm'.
%         %
%         % Upper left block:
%         %
%         for i=1:3
%            xtrans(i,1:3) = m(i,:);
%         end
%
%         %
%         % Upper right block:
%         %
%         for i=1:3
%            xtrans(i,4:6) = [ 0.0, 0.0, 0.0 ]';
%         end
%
%         %
%         % Lower left block:
%         %
%         for i=1:3
%            xtrans(3+i,1:3) = dm(i,:);
%         end
%
%         %
%         % Lower right block:
%         %
%         for i=1:3
%            xtrans(3+i,4:6) = m(i,:);
%         end
%
%         %
%         % Now use cspice_xf2rav to produce the expected angular velocity.
%         %
%         [mout, avx] = cspice_xf2rav( xtrans );
%
%         %
%         % The results should match to nearly full double precision.
%         %
%         fprintf( 'Original angular velocity:\n' )
%         fprintf( '%20.14f %19.14f %19.14f\n', ...
%                  expav(1), expav(2), expav(3) )
%         fprintf( 'cspice_qdq2av''s angular velocity:\n' )
%         fprintf( '%20.14f %19.14f %19.14f\n', ...
%                  av   (1), av   (2), av   (3) )
%         fprintf( 'cspice_xf2rav''s angular velocity:\n' )
%         fprintf( '%20.14f %19.14f %19.14f\n', ...
%                  avx  (1), avx  (2), avx  (3) )
%
%
%      When this program was executed on a Mac/Intel/Octave6.x/64-bit
%      platform, the output was:
%
%
%      Original angular velocity:
%          1.00000000000000    2.00000000000000    3.00000000000000
%      cspice_qdq2av's angular velocity:
%          1.00000000000000    2.00000000000000    3.00000000000000
%      cspice_xf2rav's angular velocity:
%          1.00000000000000    2.00000000000000    3.00000000000000
%
%
%-Particulars
%
%   Quaternion Styles
%   -----------------
%
%   There are different "styles" of quaternions used in
%   science and engineering applications. Quaternion styles
%   are characterized by
%
%   -  The order of quaternion elements
%
%   -  The quaternion multiplication formula
%
%   -  The convention for associating quaternions
%      with rotation matrices
%
%   Two of the commonly used styles are
%
%      - "SPICE"
%
%         > Invented by Sir William Rowan Hamilton
%         > Frequently used in mathematics and physics textbooks
%
%      - "Engineering"
%
%         > Widely used in aerospace engineering applications
%
%
%   Mice function interfaces ALWAYS use SPICE quaternions.
%   Quaternions of any other style must be converted to SPICE
%   quaternions before they are passed to Mice functions.
%
%
%   Relationship between SPICE and Engineering Quaternions
%   ------------------------------------------------------
%
%   Let `m' be a rotation matrix such that for any vector `v',
%
%      m*v
%
%   is the result of rotating `v' by theta radians in the
%   counterclockwise direction about unit rotation axis vector `a'.
%   Then the SPICE quaternions representing `m' are
%
%      (+/-) (  cos(theta/2),
%               sin(theta/2) * a(1),
%               sin(theta/2) * a(2),
%               sin(theta/2) * a(3)  )
%
%   while the engineering quaternions representing `m' are
%
%      (+/-) ( -sin(theta/2) * a(1),
%              -sin(theta/2) * a(2),
%              -sin(theta/2) * a(3),
%               cos(theta/2)         )
%
%   For both styles of quaternions, if a quaternion `q' represents
%   a rotation matrix `m', then -q represents `m' as well.
%
%   Given an engineering quaternion
%
%      qeng   = ( q1,  q2,  q3,  q4 )
%
%   the equivalent SPICE quaternion is
%
%      qspice = ( q4, -q1, -q2, -q3 )
%
%
%   Associating SPICE Quaternions with Rotation Matrices
%   ----------------------------------------------------
%
%   Let `from' and `to' be two right-handed reference frames, for
%   example, an inertial frame and a spacecraft-fixed frame. Let the
%   symbols
%
%      v    ,   v
%       from     to
%
%   denote, respectively, an arbitrary vector expressed relative to
%   the `from' and `to' frames. Let `m' denote the transformation matrix
%   that transforms vectors from frame `from' to frame `to'; then
%
%      v   =  m * v
%       to         from
%
%   where the expression on the right hand side represents left
%   multiplication of the vector by the matrix.
%
%   Then if the unit-length SPICE quaternion `q' represents `m', where
%
%      q = (q1, q2, q3, q4)
%
%   the elements of `m' are derived from the elements of `q' as follows:
%
%        .-                                                           -.
%        |            2    2                                           |
%        |  1 - 2*( q3 + q4 )   2*(q2*q3 - q1*q4)   2*(q2*q4 + q1*q3)  |
%        |                                                             |
%        |                                                             |
%        |                                2    2                       |
%    m = |  2*(q2*q3 + q1*q4)   1 - 2*( q2 + q4 )   2*(q3*q4 - q1*q2)  |
%        |                                                             |
%        |                                                             |
%        |                                                    2    2   |
%        |  2*(q2*q4 - q1*q3)   2*(q3*q4 + q1*q2)   1 - 2*( q2 + q3 )  |
%        `-                                                           -'
%
%   Note that substituting the elements of -q for those of `q' in the
%   right hand side leaves each element of `m' unchanged; this shows
%   that if a quaternion `q' represents a matrix `m', then so does the
%   quaternion -q.
%
%   To map the rotation matrix `m' to a unit quaternion, we start by
%   decomposing the rotation matrix as a sum of symmetric
%   and skew-symmetric parts:
%
%                                        2
%      m = [ I  +  (1-cos(theta)) * omega  ] + [ sin(theta) * omega ]
%
%                       symmetric                 skew-symmetric
%
%
%   `omega' is a skew-symmetric matrix of the form
%
%                 .-               -.
%                 |   0   -n3   n2  |
%                 |                 |
%       omega  =  |   n3   0   -n1  |
%                 |                 |
%                 |  -n2   n1   0   |
%                 `-               -'
%
%   The vector `n' of matrix entries (n1, n2, n3) is the rotation axis
%   of `m' and `theta' is m's rotation angle. Note that `n' and `theta'
%   are not unique.
%
%   Let
%
%      cth = cos(theta/2)
%      sth = sin(theta/2)
%
%   Then the unit quaternions `q' corresponding to `m' are
%
%      q = +/- ( cth, sth*n1, sth*n2, sth*n3 )
%
%   The mappings between quaternions and the corresponding rotations
%   are carried out by the Mice routines
%
%      cspice_q2m {quaternion to matrix}
%      cspice_m2q {matrix to quaternion}
%
%   cspice_m2q always returns a quaternion with scalar part greater than
%   or equal to zero.
%
%
%   SPICE Quaternion Multiplication Formula
%   ---------------------------------------
%
%   Given a SPICE quaternion
%
%      q = ( q1, q2, q3, q4 )
%
%   corresponding to rotation axis `a' and angle `theta' as above, we can
%   represent `q' using "scalar + vector" notation as follows:
%
%      s =   q1           = cos(theta/2)
%
%      v = ( q2, q3, q4 ) = sin(theta/2) * a
%
%      q = s + v
%
%   Let `quat1' and `quat2' be SPICE quaternions with respective scalar
%   and vector parts `s1', `s2' and `v1', `v2':
%
%      quat1 = s1 + v1
%      quat2 = s2 + v2
%
%   We represent the dot product of `v1' and `v2' by
%
%      <v1, v2>
%
%   and the cross product of `v1' and `v2' by
%
%      v1 x v2
%
%   Then the SPICE quaternion product is
%
%      quat1*quat2 = s1*s2 - <v1,v2>  + s1*v2 + s2*v1 + (v1 x v2)
%
%   If `quat1' and `quat2' represent the rotation matrices `m1' and `m2'
%   respectively, then the quaternion product
%
%      quat1*quat1
%
%   represents the matrix product
%
%      m1*m2
%
%
%   About this routine
%   ==================
%
%   Given a time-dependent SPICE quaternion representing the
%   attitude of an object, we can obtain the object's angular
%   velocity `av' in terms of the quaternion `q' and its derivative
%   with respect to time `dq':
%
%                         *
%      av  =  I * ( -2 * q  * dq )                                 (1)
%
%   That is, `av' is the vector (imaginary) part of the product
%   on the right hand side (RHS) of equation (1). The scalar part
%   of the RHS is zero.
%
%   We'll now provide an explanation of formula (1). For any
%   time-dependent rotation, the associated angular velocity at a
%   given time is a function of the rotation and its derivative at
%   that time. This fact enables us to extend a proof for a limited
%   subset of rotations to *all* rotations: if we find a formula
%   that, for any rotation in our subset, gives us the angular
%   velocity as a function of the rotation and its derivative, then
%   that formula must be true for all rotations.
%
%   We start out by considering the set of rotation matrices
%
%      r(t) = m(t) * k                                             (2)
%
%   where `k' is a constant rotation matrix and m(t) represents a
%   matrix that 'rotates' with constant, unit magnitude angular
%   velocity and that is equal to the identity matrix at t = 0.
%
%   For future reference, we'll consider `k' to represent a coordinate
%   transformation from frame `f1' to frame `f2'. We'll call `f1' the
%   'base frame' of `k'. We'll let `avf2' be the angular velocity of
%   m(t) relative to `f2' and `avf1' be the same angular velocity
%   relative to `f1'.
%
%   Referring to the axis-and-angle decomposition of m(t)
%
%                                                2
%      m(t) = I + sin(t)*omega + (1-cos(t))*omega                  (3)
%
%   (see the Rotation Required Reading for a derivation) we
%   have
%
%      d(m(t))|
%      -------|     = omega                                        (4)
%        dt   |t=0
%
%   Then the derivative of r(t) at t = 0 is given by
%
%
%      d(r(t))|
%      -------|     = omega  * k                                   (5)
%        dt   |t=0
%
%
%   The rotation axis `a' associated with `omega' is defined by    (6)
%
%      a(1) =  - omega(2,3)
%      a(2) =    omega(1,3)
%      a(3) =  - omega(1,2)
%
%   Since the coordinate system rotation m(t) rotates vectors about `a'
%   through angle `t' radians at time `t', the angular velocity `avf2' of
%   m(t) is actually given by
%
%      avf2  =  - a                                                (7)
%
%   This angular velocity is represented relative to the image
%   frame `f2' associated with the coordinate transformation `k'.
%
%   Now, let's proceed to the angular velocity formula for
%   quaternions.
%
%   To avoid some verbiage, we'll freely use 3-vectors to represent
%   the corresponding pure imaginary quaternions.
%
%   Letting qr(t), qm(t), and `qk' be quaternions representing the
%   time-dependent matrices r(t), m(t) and `k' respectively, where
%   qm(t) is selected to be a differentiable function of `t' in a
%   neighborhood of t = 0, the quaternion representing r(t) is
%
%      qr(t) = qm(t) * qk                                          (8)
%
%   Differentiating with respect to `t', then evaluating derivatives
%   at t = 0, we have
%
%      d(qr(t))|         d(qm(t))|
%      --------|     =   --------|     * qk                        (9)
%         dt   |t=0         dt   |t=0
%
%
%   Since qm(t) represents a rotation having axis `a' and rotation
%   angle `t', then (according to the relationship between SPICE
%   quaternions and rotations set out in the Rotation Required
%   Reading), we see qm(t) must be the quaternion (represented as the
%   sum of scalar and vector parts):
%
%      cos(t/2)  +  sin(t/2) * a                                  (10)
%
%   where `a' is the rotation axis corresponding to the matrix
%   `omega' introduced in equation (3). By inspection
%
%      d(qm(t))|
%      --------|     =   1/2 * a                                  (11)
%         dt   |t=0
%
%   which is a quaternion with scalar part zero. This allows us to
%   rewrite the quaternion derivative
%
%      d(qr(t))|
%      --------|     =   1/2  *  a  *  qk                         (12)
%         dt   |t=0
%
%   or for short,
%
%      dq = 1/2 * a * qk                                          (13)
%
%   Since from (7) we know the angular velocity `avf2' of the frame
%   associated with qm(t) is the negative of the rotation axis
%   defined by (3), we have
%
%      dq = - 1/2 * avf2 * qk                                     (14)
%
%   Since
%
%      avf2 = k * avf1                                            (15)
%
%   we can apply the quaternion transformation formula
%   (from the Rotation Required Reading)
%
%                               *
%      avf2 =  qk  *  avf1  * qk                                  (16)
%
%   Now we re-write (15) as
%
%                                   *
%      dq = - 1/2 * ( qk * avf1 * qk ) * qk
%
%         = - 1/2 *   qk * avf1                                   (17)
%
%   Then the angular velocity vector `avf1' is given by
%
%                     *
%      avf`  = -2 * qk  * dq                                      (18)
%
%   The relation (18) has now been demonstrated for quaternions
%   having constant, unit magnitude angular velocity. But since
%   all time-dependent quaternions having value `qk' and derivative
%   `dq' at a given time `t' have the same angular velocity at time `t',
%   that angular velocity must be `avf1'.
%
%-Exceptions
%
%   1)  A unitized version of input quaternion is used in the
%       computation. No attempt is made to diagnose an invalid
%       input quaternion.
%
%   2)  If any of the input arguments, `q' or `dq', is undefined, an
%       error is signaled by the Matlab error handling system.
%
%   3)  If any of the input arguments, `q' or `dq', is not of the
%       expected type, or it does not have the expected dimensions and
%       size, an error is signaled by the Mice interface.
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
%   ROTATION.REQ
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
%   angular velocity from  quaternion and derivative
%
%-&
function [av] = cspice_qdq2av( q, dq )

   switch nargin
      case 2

         q = zzmice_dp(q);
         dq = zzmice_dp(dq);

      otherwise

         error ( 'Usage: [av(3)] = cspice_qdq2av( q(4), dq(4) )' )

   end

   %
   % Call the MEX library.
   %
   try
      [av] = mice('qdq2av_c', q, dq);
   catch spiceerr
      rethrow(spiceerr)
   end
