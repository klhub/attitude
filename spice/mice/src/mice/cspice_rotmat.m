%-Abstract
%
%   CSPICE_ROTMAT calculates the rotation matrix generated by
%   a rotation of a specified angle about a specified axis applied
%   to a matrix. This rotation is thought of as rotating the
%   coordinate system.
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
%      m1       a 3x3 matrix to which a rotation is to be applied.
%
%               [3,3] = size(m1); double = class(m1)
%
%               In matrix algebra, the components of the matrix are
%               relevant in one particular coordinate system. Applying
%               cspice_rotmat changes the components of `m1' so that they are
%               relevant to a rotated coordinate system.
%
%      angle    the angle in radians through which the original coordinate
%               system is to be rotated.
%
%               [1,1] = size(angle); double = class(angle)
%
%      iaxis    the index for the axis of the original coordinate system
%               about which the rotation by `angle' is to be performed.
%
%               [1,1] = size(iaxis); int32 = class(iaxis)
%
%               iaxis = 1,2 or 3 designates the X-, Y- or Z-axis,
%               respectively.
%
%   the call:
%
%      [mout] = cspice_rotmat( m1, angle, iaxis )
%
%   returns:
%
%      mout     the matrix resulting from the application of the specified
%               rotation to the input matrix `m1'.
%
%               [3,3] = size(mout); double = class(mout)
%
%               If
%
%                  [angle]
%                         iaxis
%
%               denotes the rotation matrix by `angle' radians about `iaxis',
%               (refer to the routine cspice_rotate) then `mout' is given by
%               the following matrix equation:
%
%                  mout = [angle]      * m1
%                                iaxis
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
%   1) Rotate the 3x3 identity matrix by 90 degrees about
%      the y axis.
%
%      Example code begins here.
%
%
%      function rotmat_ex1()
%
%         %
%         % Create the 3x3 identity matrix.
%         %
%         ident = eye(3);
%
%         %
%         % Rotate 'ident' by Pi/2 about the Y axis.
%         %
%         r = cspice_rotmat( ident, cspice_halfpi, 2 );
%
%         %
%         %  Output the resulting matrix.
%         %
%         fprintf('%18.12f %18.12f %18.12f\n', r(1,:));
%         fprintf('%18.12f %18.12f %18.12f\n', r(2,:));
%         fprintf('%18.12f %18.12f %18.12f\n', r(3,:));
%
%
%      When this program was executed on a Mac/Intel/Octave6.x/64-bit
%      platform, the output was:
%
%
%          0.000000000000     0.000000000000    -1.000000000000
%          0.000000000000     1.000000000000     0.000000000000
%          1.000000000000     0.000000000000     0.000000000000
%
%
%-Particulars
%
%   None.
%
%-Exceptions
%
%   1)  If the axis index is not in the range 1 to 3, it will be
%       treated the same as that integer 1, 2, or 3 that is congruent
%       to it mod 3.
%
%   2)  If any of the input arguments, `m1', `angle' or `iaxis', is
%       undefined, an error is signaled by the Matlab error handling
%       system.
%
%   3)  If any of the input arguments, `m1', `angle' or `iaxis', is
%       not of the expected type, or it does not have the expected
%       dimensions and size, an error is signaled by the Mice
%       interface.
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
%   E.D. Wright         (JPL)
%
%-Version
%
%   -Mice Version 1.2.0, 10-AUG-2021 (EDW) (JDR)
%
%       Edited the header to comply with NAIF standard.
%       Reformatted example's output and added problem statement.
%
%       Added -Parameters, -Exceptions, -Files, -Restrictions,
%       -Literature_References and -Author_and_Institution sections.
%
%       Eliminated use of "lasterror" in rethrow.
%
%       Removed reference to the function's corresponding CSPICE header from
%       -Required_Reading section.
%
%   -Mice Version 1.1.1, 10-MAR-2015 (EDW)
%
%       Edited -I/O section to conform to NAIF standard for Mice
%       documentation.
%
%   -Mice Version 1.1.0, 24-JAN-2009 (EDW)
%
%       Corrected the function definition name. This wrapper had a
%       the function name "cspice_rotate" instead of "cspice_rotmat."
%
%   -Mice Version 1.0.0, 17-JAN-2006 (EDW)
%
%-Index_Entries
%
%   rotate a matrix
%
%-&

function [mout] = cspice_rotmat( m1, angle, iaxis )

   switch nargin
      case 3

         m1    = zzmice_dp(m1);
         angle = zzmice_dp(angle);
         iaxis = zzmice_int(iaxis);

      otherwise

         error ( [ 'Usage: [mout(3,3)] = ' ...
                   'cspice_rotmat( m1(3,3), angle, iaxis )' ] )

   end

   %
   % Call the MEX library.
   %
   try
      [mout] = mice('rotmat_c', m1, angle, iaxis );
   catch spiceerr
      rethrow(spiceerr)
   end


