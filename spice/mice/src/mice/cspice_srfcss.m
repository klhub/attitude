%-Abstract
%
%   CSPICE_SRFCSS translates a surface ID code, together with a body
%   string, to the corresponding surface name. If no such surface name exists,
%   return a string representation of the surface ID code.
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
%      code     an integer ID code for a surface associated with a
%               specified body.
%
%               [1,1] = size(code); int32 = class(code)
%
%      bodstr   a string designating the body associated with the
%               input surface ID code.
%
%               [1,c1] = size(bodstr), char = class(bodstr)
%
%                  or
%
%               [1,1] = size(bodstr), cell = class(bodstr)
%
%               `bodstr' may contain a body name or a string representation
%               of the body's integer ID code.
%
%               For example, `bodstr' may contain
%
%                  '1000012'
%
%               instead of
%
%                  '67P/CHURYUMOV-GERASIMENKO (1969 R1)'
%
%               Case and leading and trailing blanks in a name are not
%               significant. Sequences of consecutive embedded blanks
%               are considered equivalent to a single blank. That is,
%               all of the following strings are equivalent names:
%
%                  '67P/CHURYUMOV-GERASIMENKO (1969 R1)'
%                  '67P/Churyumov-Gerasimenko (1969 R1)'
%                  '67P/CHURYUMOV-GERASIMENKO (1969 R1)   '
%                  '67P/CHURYUMOV-GERASIMENKO    (1969 R1)'
%                  '   67P/CHURYUMOV-GERASIMENKO (1969 R1)'
%
%               However, '67P/CHURYUMOV-GERASIMENKO(1969R1)'
%               is not equivalent to the names above.
%
%   the call:
%
%      [srfstr, isname] = cspice_srfcss( code, bodstr )
%
%   returns:
%
%      srfstr   the name of the surface identified by `code', for the body
%               designated by `bodstr', if for this body an association
%               exists between the input surface ID and a surface name.
%
%               [1,c1] = size(srfstr); char = class(srfstr)
%
%               If `code' has more than one translation, then the most
%               recently defined surface name corresponding to `code' is
%               returned. `srfstr' will have the exact format (case and
%               embedded blanks) used in the definition of the
%               name/code association.
%
%               If the input surface ID code and body name do not map
%               to a surface name, `srfstr' is set to the string
%               representation of `code'.
%
%     isname    a logical flag that is true if a surface name
%               corresponding to the input ID codes was found and
%               false otherwise.
%
%               [1,1] = size(isname); logical = class(isname)
%
%               When `isname' is false, the output string `srfstr' contains
%               a string representing the integer `code'.
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
%   1) Supposed a text kernel has been loaded that contains
%      the following assignments:
%
%         NAIF_SURFACE_NAME += ( 'MGS MOLA  64 pixel/deg',
%                                'MGS MOLA 128 pixel/deg',
%                                'PHOBOS GASKELL Q512'     )
%         NAIF_SURFACE_CODE += (   1,   2,    1 )
%         NAIF_SURFACE_BODY += ( 499, 499,  401 )
%
%      Translate each surface and body ID code pair to the
%      associated surface name. Also perform a translation
%      for a surface ID having no matching name.
%
%      Use the meta-kernel shown below to define the required SPICE
%      kernel variables.
%
%
%         KPL/MK
%
%         File: srfcss_ex1.tm
%
%         This meta-kernel is intended to support operation of SPICE
%         example programs. The file contents shown here should not be
%         assumed to contain adequate or correct versions of data
%         required by SPICE-based user applications.
%
%
%         \begindata
%
%         NAIF_SURFACE_NAME += ( 'MGS MOLA  64 pixel/deg',
%                                'MGS MOLA 128 pixel/deg',
%                                'PHOBOS GASKELL Q512'     )
%         NAIF_SURFACE_CODE += (   1,   2,    1 )
%         NAIF_SURFACE_BODY += ( 499, 499,  401 )
%
%         \begintext
%
%         End of meta-kernel
%
%
%      Example code begins here.
%
%
%      function srfcss_ex1()
%
%         bodstr = { 'MARS', 'PHOBOS', '499', 'MARS', 'ZZZ' };
%         surfid = [  1,   1,   2,   3,  1 ];
%         tf     = { 'false', 'true' };
%         meta   = 'srfcss_ex1.tm';
%
%         cspice_furnsh( meta );
%
%         for i= 1:numel( bodstr )
%
%            [srfnam, isname] = cspice_srfcss( surfid(i), bodstr(i) );
%
%            fprintf(['surface ID       = %d\n'                            ...
%                     'body string      = %s\n'                            ...
%                     'name found       = %s\n'                            ...
%                     'surface string   = %s\n\n'],                        ...
%                      surfid(i),                                          ...
%                      char( bodstr(i) ),                                  ...
%                      char( tf(int32(isname)+1) ),                        ...
%                      srfnam )
%         end
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
%      surface ID       = 1
%      body string      = MARS
%      name found       = true
%      surface string   = MGS MOLA  64 pixel/deg
%
%      surface ID       = 1
%      body string      = PHOBOS
%      name found       = true
%      surface string   = PHOBOS GASKELL Q512
%
%      surface ID       = 2
%      body string      = 499
%      name found       = true
%      surface string   = MGS MOLA 128 pixel/deg
%
%      surface ID       = 3
%      body string      = MARS
%      name found       = false
%      surface string   = 3
%
%      surface ID       = 1
%      body string      = ZZZ
%      name found       = false
%      surface string   = 1
%
%
%-Particulars
%
%   Surfaces are always associated with bodies (which usually are
%   ephemeris objects). For any given body, a mapping between surface
%   names and surface ID codes can be established.
%
%   Bodies serve to disambiguate surface names and ID codes: the set
%   of surface names and surface ID codes for a given body can be
%   thought of as belonging to a name space. A given surface ID code
%   or surface name may be used for surfaces of multiple bodies,
%   without conflict.
%
%   Associations between surface names and ID codes are always made
%   via kernel pool assignments; there are no built-in associations.
%
%   cspice_srfcss is one of four related subroutines:
%
%      cspice_srfs2c    Surface string and body string to surface ID code
%      cspice_srfscc    Surface string and body ID code to surface ID code
%      cspice_srfc2s    Surface ID code and body ID code to surface string
%      cspice_srfcss    Surface ID code and body string to surface string
%
%   cspice_srfs2c, cspice_srfc2s, cspice_srfscc, and cspice_srfcss perform
%   translations between surface strings and their corresponding integer
%   ID codes.
%
%   Refer to naif_ids.req for details concerning adding new surface
%   name/code associations at run time by loading text kernels.
%
%-Exceptions
%
%   1)  If the input body string cannot be mapped to a body name, the
%       output `srfstr' is set to a string representation of the
%       surface ID code. The output `isname' is set to false.
%
%       This case is not treated as an error.
%
%   2)  If the input surface code cannot be mapped to a surface name,
%       the output `srfstr' is set to a string representation of the
%       surface ID code. The input body string is ignored. The output
%       `isname' is set to false.
%
%       This case is not treated as an error.
%
%   3)  If any of the input arguments, `code' or `bodstr', is
%       undefined, an error is signaled by the Matlab error handling
%       system.
%
%   4)  If any of the input arguments, `code' or `bodstr', is not of
%       the expected type, or it does not have the expected dimensions
%       and size, an error is signaled by the Mice interface.
%
%-Files
%
%   Surface name-to-ID mappings may be defined at run time by loading
%   text kernels containing kernel variable assignments of the form
%
%      NAIF_SURFACE_NAME += ( <surface name 1>, ... )
%      NAIF_SURFACE_CODE += ( <surface code 1>, ... )
%      NAIF_SURFACE_BODY += ( <body code 1>,    ... )
%
%   Above, the ith elements of the lists on the assignments' right
%   hand sides together define the ith surface name/ID mapping.
%
%   The same effect can be achieved using assignments formatted as
%   follows:
%
%      NAIF_SURFACE_NAME += <surface name 1>
%      NAIF_SURFACE_CODE += <surface code 1>
%      NAIF_SURFACE_BODY += <body code 1>
%
%      NAIF_SURFACE_NAME += <surface name 2>
%      NAIF_SURFACE_CODE += <surface code 2>
%      NAIF_SURFACE_BODY += <body code 2>
%
%         ...
%
%   Note the use of the
%
%      +=
%
%   operator; this operator appends to rather than overwrites the
%   kernel variable named on the left hand side of the assignment.
%
%-Restrictions
%
%   None.
%
%-Required_Reading
%
%   DSK.REQ
%   MICE.REQ
%   NAIF_IDS.REQ
%
%-Literature_References
%
%   None.
%
%-Author_and_Institution
%
%   N.J. Bachman        (JPL)
%   J. Diaz del Rio     (ODC Space)
%   E.D. Wright         (JPL)
%
%-Version
%
%   -Mice Version 1.1.0, 07-AUG-2020 (EDW) (JDR)
%
%       Added -Parameters, -Exceptions, -Files, -Restrictions,
%       -Literature_References and -Author_and_Institution sections. Edited
%       the header to comply with NAIF standard.
%
%       Added call to cspice_kclear in code example.
%
%       Eliminated use of "lasterror" in rethrow.
%
%       Removed reference to the function's corresponding CSPICE header from
%       -Required_Reading section.
%
%   -Mice Version 1.0.0, 28-FEB-2016 (EDW) (NJB)
%
%-Index_Entries
%
%   surface ID code and body string to surface string
%
%-&

function [srfstr, isname] = cspice_srfcss(code, bodstr)

   switch nargin
      case 2

         code   = zzmice_int(code);
         bodstr = zzmice_str(bodstr);

      otherwise

         error ( 'Usage: [`srfstr`, isname] = cspice_srfcss(code, `bodstr`)' )

   end

   %
   % Call the MEX library. The "_s" suffix indicates a structure type
   % return argument.
   %
   try
      [srfcss] = mice('srfcss_s', code, bodstr);
      srfstr   = char( srfcss.name );
      isname   = reshape( [srfcss.found], 1, [] );
   catch spiceerr
      rethrow(spiceerr)
   end

