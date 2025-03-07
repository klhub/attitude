%-Abstract
%
%   CSPICE_LGRESP evaluates a Lagrange interpolating polynomial for a
%   specified set of coordinate pairs whose first components are equally
%   spaced, at a specified abscissa value.
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
%      n        the number of points defining the polynomial.
%
%               [1,1] = size(n); int32 = class(n)
%
%               The array `yvals' contains `n' elements.
%
%      first,
%      step     respectively, a starting abscissa value and a step
%               size that define the set of abscissa values at which a
%               Lagrange interpolating polynomial is to be defined.
%
%               [1,1] = size(first); double = class(first)
%               [1,1] = size(step); double = class(step)
%
%               The set of abscissa values is
%
%                  first   +   i * step,     i = 0, ..., n-1
%
%               `step' must be non-zero.
%
%      yvals    an array of ordinate values that, together with the abscissa
%               values defined by `first' and `step', define `n' ordered
%               pairs belonging to the graph of a function.
%
%               [n,1] = size(yvals); double = class(yvals)
%
%               The set of points
%
%                  (  first  +  (i-1)*STEP,   yvals(i)  )
%
%               where `i' ranges from 1 to `n', define the Lagrange
%               polynomial used for interpolation.
%
%      x        the abscissa value at which the interpolating polynomial is
%               to be evaluated.
%
%               [1,1] = size(x); double = class(x)
%
%   the call:
%
%      [lgresp] = cspice_lgresp( n, first, step, yvals, x )
%
%   returns:
%
%      lgresp   the value at `x' of the unique polynomial of degree n-1 that
%               fits the points in the plane defined by `first', `step', and
%               `yvals'.
%
%               [1,1] = size(lgresp); double = class(lgresp)
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
%   1) Fit a cubic polynomial through the points
%
%          ( -1,  -2 )
%          (  1,  -8 )
%          (  3,  26 )
%          (  5, 148 )
%
%      and evaluate this polynomial at x = 2.
%
%      The returned value of cspice_lgresp should be 1.0, since the
%      unique cubic polynomial that fits these points is
%
%                   3      2
%         f(x)  =  x  + 2*x  - 4*x - 7
%
%
%      Example code begins here.
%
%
%      function lgresp_ex1()
%
%         n      =   4;
%         first  =  -1.0;
%         step   =   2.0;
%
%         yvals  = [ -2.0, -8.0, 26.0, 148.0 ]';
%
%         answer =   cspice_lgresp( n, first, step, yvals, 2.0 );
%
%         fprintf( 'ANSWER = %f\n', answer )
%
%
%      When this program was executed on a Mac/Intel/Octave6.x/64-bit
%      platform, the output was:
%
%
%      ANSWER = 1.000000
%
%
%   2) Solve the same problem using a negative step. In order to
%      find the solution, set the elements of `yvals' in reverse order.
%
%      The returned value of cspice_lgresp would still be 1.0.
%
%
%      Example code begins here.
%
%
%      function lgresp_ex2()
%
%         n      =   4;
%         first  =   5.0;
%         step   =  -2.0;
%
%         yvals  = [ 148.0, 26.0, -8.0, -2.0 ]';
%
%         answer =   cspice_lgresp( n, first, step, yvals, 2.0 );
%
%         fprintf( 'ANSWER = %f\n', answer )
%
%
%      When this program was executed on a Mac/Intel/Octave6.x/64-bit
%      platform, the output was:
%
%
%      ANSWER = 1.000000
%
%
%-Particulars
%
%   Given a set of `n' distinct abscissa values and corresponding
%   ordinate values, there is a unique polynomial of degree n-1,
%   often called the "Lagrange polynomial", that fits the graph
%   defined by these values. The Lagrange polynomial can be used to
%   interpolate the value of a function at a specified point, given a
%   discrete set of values of the function.
%
%   Users of this routine must choose the number of points to use
%   in their interpolation method. The authors of Reference [1] have
%   this to say on the topic:
%
%      Unless there is solid evidence that the interpolating function
%      is close in form to the true function `f', it is a good idea to
%      be cautious about high-order interpolation. We
%      enthusiastically endorse interpolations with 3 or 4 points, we
%      are perhaps tolerant of 5 or 6; but we rarely go higher than
%      that unless there is quite rigorous monitoring of estimated
%      errors.
%
%   The same authors offer this warning on the use of the
%   interpolating function for extrapolation:
%
%      ...the dangers of extrapolation cannot be overemphasized:
%      An interpolating function, which is perforce an extrapolating
%      function, will typically go berserk when the argument `x' is
%      outside the range of tabulated values by more than the typical
%      spacing of tabulated points.
%
%   For Lagrange interpolation on unequally spaced abscissa values,
%   see the Mice routine cspice_lgrint.
%
%-Exceptions
%
%   1)  If `step' is zero, the error SPICE(INVALIDSTEPSIZE) is signaled
%       by a routine in the call tree of this routine.
%
%   2)  If `n' is less than 1, the error SPICE(INVALIDSIZE) is signaled
%       by a routine in the call tree of this routine.
%
%   3)  This routine does not attempt to ward off or diagnose
%       arithmetic overflows.
%
%   4)  If any of the input arguments, `n', `first', `step', `yvals'
%       or `x', is undefined, an error is signaled by the Matlab error
%       handling system.
%
%   5)  If any of the input arguments, `n', `first', `step', `yvals'
%       or `x', is not of the expected type, or it does not have the
%       expected dimensions and size, an error is signaled by the Mice
%       interface.
%
%   6)  If the number of elements in `yvals' is less than `n', an error
%       is signaled by the Mice interface.
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
%   [1]  W. Press, B. Flannery, S. Teukolsky and W. Vetterling,
%        "Numerical Recipes -- The Art of Scientific Computing,"
%        chapters 3.0 and 3.1, Cambridge University Press, 1986.
%
%-Author_and_Institution
%
%   J. Diaz del Rio     (ODC Space)
%
%-Version
%
%   -Mice Version 1.0.0, 01-JUL-2021 (JDR)
%
%-Index_Entries
%
%   interpolate function using Lagrange polynomial
%   Lagrange interpolation
%
%-&
function [lgresp] = cspice_lgresp( n, first, step, yvals, x )

   switch nargin
      case 5

         n     = zzmice_int(n);
         first = zzmice_dp(first);
         step  = zzmice_dp(step);
         yvals = zzmice_dp(yvals);
         x     = zzmice_dp(x);

      otherwise

         error ( [ 'Usage: [lgresp] = '                                     ...
                   'cspice_lgresp( n, first, step, yvals(n), x )' ] )

   end

   %
   % Call the MEX library.
   %
   try
      [lgresp] = mice('lgresp_c', n, first, step, yvals, x);
   catch spiceerr
      rethrow(spiceerr)
   end
