%-Abstract
%
%   CSPICE_REPMC replaces a marker with a character string.
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
%      value    the replacement character string.
%
%               [1,c3] = size(value); char = class(value)
%
%                  or
%
%               [1,1] = size(value); cell = class(value)
%
%               Leading and trailing blanks in `value' are NOT significant:
%               the portion of `value' that is substituted for `marker'
%               extends from its first non-blank character to its last
%               non-blank character.
%
%               However, if `value' is blank or empty, a single blank is
%               substituted for the first occurrence of `marker'.
%
%   the call:
%
%      [out] = cspice_repmc( in, marker, value )
%
%   returns:
%
%      out      the string obtained by substituting `value' (leading and
%               trailing blanks excepted) for the first occurrence of
%               `marker' in the input string.
%
%               [1,c4] = size(out); char = class(out)
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
%   1) The following example illustrate the use of cspice_repmc to
%      replace a marker within a string with a character string
%      value.
%
%
%      Example code begins here.
%
%
%      function repmc_ex1()
%
%         %
%         % 1. Single marker
%         %
%         marker   = '#';
%         instr    = 'Invalid value. The value was:  #';
%
%         [outstr] = cspice_repmc( instr, marker, 'append' );
%
%         fprintf( 'Case 1: Single marker.\n' )
%         fprintf( '   Input : %s\n', instr )
%         fprintf( '   Output: %s\n', outstr )
%         fprintf( '\n' )
%
%         %
%         % 2. Multiple markers
%         %
%         marker   = ' XX ';
%         instr    = 'The token XX was not recognized. Was it XX?';
%
%         [outstr] = cspice_repmc( instr, marker, '  FND  ' );
%
%         fprintf( 'Case 2: Multiple markers.\n' )
%         fprintf( '   Input : %s\n', instr )
%         fprintf( '   Output: %s\n', outstr )
%         fprintf( '\n' )
%
%
%      When this program was executed on a Mac/Intel/Octave6.x/64-bit
%      platform, the output was:
%
%
%      Case 1: Single marker.
%         Input : Invalid value. The value was:  #
%         Output: Invalid value. The value was:  append
%
%      Case 2: Multiple markers.
%         Input : The token XX was not recognized. Was it XX?
%         Output: The token FND was not recognized. Was it XX?
%
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
%      [string] = cspice_repmct( string, '#1', n_pics, 'C' );
%      [string] = cspice_repmc( string, '#2', DIR_NAME );
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
%   2)  If `value' is blank or empty, a single blank is substituted for the
%       first occurrence of `marker'.
%
%   3)  If any of the input arguments, `in', `marker' or `value', is
%       undefined, an error is signaled by the Matlab error handling
%       system.
%
%   4)  If any of the input arguments, `in', `marker' or `value', is
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
%   -Mice Version 1.0.0, 22-JAN-2021 (JDR)
%
%-Index_Entries
%
%   replace marker with character_string
%
%-&
function [out] = cspice_repmc( in, marker, value )

   switch nargin
      case 3

         in     = zzmice_str(in, true);
         marker = zzmice_str(marker, true);
         value  = zzmice_str(value, true);

      otherwise

         error ( 'Usage: [`out`] = cspice_repmc( `in`, `marker`, `value` )' )

   end

   %
   % Call the MEX library.
   %
   try
      [out] = mice('repmc_c', in, marker, value);
   catch spiceerr
      rethrow(spiceerr)
   end
