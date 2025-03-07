%-Abstract
%
%   CSPICE_REPMD replaces a marker with a double precision number.
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
%      in       an arbitrary character string.
%
%               [1,c1] = size(in); char = class(in)
%
%                  or
%
%               [1,1] = size(in); cell = class(in)
%
%      marker   an arbitrary character string.
%
%               [1,c2] = size(marker); char = class(marker)
%
%                  or
%
%               [1,1] = size(marker); cell = class(marker)
%
%               The first occurrence of `marker' in the input string is to
%               be replaced by `value'.
%
%               Leading and trailing blanks in `marker' are NOT
%               significant. In particular, no substitution is performed
%               if `marker' is blank or empty.
%
%      value    an arbitrary double precision number.
%
%               [1,1] = size(value); double = class(value)
%
%      sigdig   the number of significant digits with which `value' is to be
%               represented.
%
%               [1,1] = size(sigdig); int32 = class(sigdig)
%
%               `sigdig' must be greater than zero and less than 15.
%
%   the call:
%
%      [out] = cspice_repmd( in, marker, value, sigdig )
%
%   returns:
%
%      out      the string obtained by substituting the text representation
%               of `value' for the first occurrence of `marker' in the input
%               string.
%
%               [1,c3] = size(out); char = class(out)
%
%               The text representation of `value' is in scientific
%               notation, having the number of significant digits
%               specified by `sigdig'. The representation of `value' is
%               produced by the SPICELIB routine DPSTR; see that routine
%               for details concerning the representation of double
%               precision numbers.
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
%   1) The following example illustrate the use of cspice_repmd to
%      replace a marker within a string with the text representation
%      of a double precision value.
%
%
%      Example code begins here.
%
%
%      function repmd_ex1()
%
%         %
%         % 1. Single marker, two significant digits.
%         %
%         marker   = '#';
%         instr    = 'Invalid value. The value was:  #';
%
%         [outstr] = cspice_repmd( instr, marker, 5.0e1, 2 );
%
%         fprintf( 'Case 1: Single marker, two significant digits.\n' )
%         fprintf( '   Input : %s\n', instr )
%         fprintf( '   Output: %s\n', outstr )
%         fprintf( '\n' )
%
%         %
%         % 2. Multiple markers, three significant digits.
%         %
%         marker   = ' XX ';
%         instr    = 'Left > Right endpoint. Left: XX; Right: XX';
%
%         [outstr] = cspice_repmd( instr, marker, -5.2e-9, 3 );
%
%         fprintf( [ 'Case 2: Multiple markers, three significant',      ...
%                    ' digits.\n' ]                                   )
%         fprintf( '   Input : %s\n', instr )
%         fprintf( '   Output: %s\n', outstr )
%         fprintf( '\n' )
%
%         %
%         % 3. Excessive significant digits.
%         %
%         marker   = '#';
%         instr    = 'Invalid value. The value was:  #';
%
%         [outstr] = cspice_repmd( instr, marker, 5.0e1, 100 );
%
%         fprintf( 'Case 3: Excessive significant digits.\n' )
%         fprintf( '   Input : %s\n', instr )
%         fprintf( '   Output: %s\n', outstr )
%         fprintf( '\n' )
%
%
%      When this program was executed on a Mac/Intel/Octave6.x/64-bit
%      platform, the output was:
%
%
%      Case 1: Single marker, two significant digits.
%         Input : Invalid value. The value was:  #
%         Output: Invalid value. The value was:  5.0E+01
%
%      Case 2: Multiple markers, three significant digits.
%         Input : Left > Right endpoint. Left: XX; Right: XX
%         Output: Left > Right endpoint. Left: -5.20E-09; Right: XX
%
%      Case 3: Excessive significant digits.
%         Input : Invalid value. The value was:  #
%         Output: Invalid value. The value was:  5.0000000000000E+01
%
%
%      Note that, in Case #3 even though 100 digits of precision were
%      requested, only 14 were returned.
%
%-Particulars
%
%   This is one of a family of related routines for inserting values
%   into strings. They are typically to construct messages that
%   are partly fixed, and partly determined at run time. For example,
%   a message like
%
%      'Fifty-one pictures were found in directory [USER.DATA].'
%
%   might be constructed from the fixed string
%
%      '#1 pictures were found in directory #2.'
%
%   by the calls
%
%      [string] = cspice_repmct( string, '#1', 51, 'C' );
%      [string] = cspice_repmc( string, '#2', '[USER.DATA]' );
%
%   which substitute the cardinal text 'Fifty-one' and the character
%   string '[USER.DATA]' for the markers '#1' and '#2' respectively.
%
%   The complete list of routines is shown below.
%
%      cspice_repmc    ( Replace marker with character string value )
%      cspice_repmd    ( Replace marker with double precision value )
%      cspice_repmf    ( Replace marker with formatted d.p. value   )
%      cspice_repmi    ( Replace marker with integer value          )
%      cspice_repml    ( Replace marker with logical value          )
%      cspice_repmct   ( Replace marker with cardinal text          )
%      cspice_repmot   ( Replace marker with ordinal text           )
%
%-Exceptions
%
%   1)  If `marker' is blank or empty, or if `marker' is not a substring of
%       `in', no substitution is performed. (`out' and `in' are identical.)
%
%   2)  If any of the input arguments, `in', `marker', `value' or
%       `sigdig', is undefined, an error is signaled by the Matlab
%       error handling system.
%
%   3)  If any of the input arguments, `in', `marker', `value' or
%       `sigdig', is not of the expected type, or it does not have the
%       expected dimensions and size, an error is signaled by the Mice
%       interface.
%
%-Files
%
%   None.
%
%-Restrictions
%
%   1)  The maximum number of significant digits returned is 14.
%
%   2)  This routine makes explicit use of the format of the string
%       returned by the SPICELIB routine DPSTR; should that routine
%       change, substantial work may be required to bring this routine
%       back up to snuff.
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
%
%-Version
%
%   -Mice Version 1.0.0, 01-NOV-2021 (JDR)
%
%-Index_Entries
%
%   replace marker with d.p. number
%
%-&
function [out] = cspice_repmd( in, marker, value, sigdig )

   switch nargin
      case 4

         in     = zzmice_str(in, true);
         marker = zzmice_str(marker, true);
         value  = zzmice_dp(value);
         sigdig = zzmice_int(sigdig);

      otherwise

         error ( [ 'Usage: [`out`] = '                                      ...
                   'cspice_repmd( `in`, `marker`, value, sigdig )' ] )

   end

   %
   % Call the MEX library.
   %
   try
      [out] = mice('repmd_c', in, marker, value, sigdig);
   catch spiceerr
      rethrow(spiceerr)
   end
