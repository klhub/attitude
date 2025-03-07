%-Abstract
%
%   CSPICE_DSKN02 computes the unit normal vector for a specified plate from
%   a type 2 DSK segment.
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
%      handle   the handle of a DSK file containing a type 2 segment
%               from which data are to be fetched.
%
%               [1,1] = size(handle); int32 = class(handle)
%
%      dladsc   the DLA descriptor associated with the segment from
%               which data are to be fetched.
%
%               [SPICE_DLA_DSCSIZ,1]  = size(dladsc)
%                               int32 = class(dladsc)
%
%      plid     the plate ID.
%
%               [1,1] = size(plid); int32 = class(plid)
%
%               Plate IDs range from 1 to NP (the number of plates in the
%               segment identified by `dladsc').
%
%   the call:
%
%      [normal] = cspice_dskn02( handle, dladsc, plid )
%
%   returns:
%
%      normal   the normal vector associated with the plate designated
%               by `plid'.
%
%               [3,1] = size(normal); double = class(normal)
%
%               The direction of `normal' is determined by the order of the
%               plate's vertices; the vertices are presumed to be ordered in
%               the right-handed (counterclockwise) sense about the normal
%               direction. If the plate's vertices are `v1', `v2', `v3', then
%               `normal' points in the direction
%
%                  (v2 - v1) x ( v3 - v2 )
%
%               where 'x' represents the cross product operator.
%
%               The vector `normal' is expressed in the body-fixed
%               reference frame of the segment designated by `dladsc'.
%               The center of this frame is the origin of the cartesian
%               coordinate system in which the vertices are expressed.
%               Note that the frame center need not coincide with the
%               central body of the segment. Units are km.
%
%               The vector has magnitude 1.
%
%               If an error occurs on the call, `normal' is undefined.
%
%-Parameters
%
%   See the parameter definitions file
%
%      MiceDLA.m
%
%   for declarations of DLA descriptor sizes and documentation of the
%   contents of DLA descriptors.
%
%   See the parameter definitions file
%
%      MiceDSK.m
%
%   for declarations of DSK descriptor sizes and documentation of the
%   contents of DSK descriptors.
%
%   See the parameter definitions file
%
%      MiceDSK.m
%
%   for declarations of DSK data type 2 (plate model) parameters.
%
%-Examples
%
%   Any numerical results shown for this example may differ between
%   platforms as the results depend on the SPICE kernels used as input
%   and the machine specific arithmetic implementation.
%
%   1) Look up all the vertices associated with each plate
%      of the model contained in a specified type 2 segment. For each
%      of the first 5 plates, display the plate's vertices and normal
%      vector.
%
%      For this example, we'll show the context of this look-up:
%      opening the DSK file for read access, traversing a trivial,
%      one-segment list to obtain the segment of interest.
%
%      Example code begins here.
%
%
%      function dskn02_ex1
%
%         %
%         % Constants
%         %
%         PBUFSIZ = 10000;
%
%         %
%         % Initial values
%         %
%         verts = zeros(3,3);
%
%         %
%         % Prompt for the name of the file to search.
%         %
%         dsk = input( 'Name of DSK file > ', 's' );
%
%         %
%         % Open the DSK file for read access.
%         % We use the DAS-level interface for
%         % this function.
%         %
%         handle  = cspice_dasopr( dsk );
%
%         %
%         % Begin a forward search through the
%         % kernel, treating the file as a DLA.
%         % In this example, it's a very short
%         % search.
%         %
%         [dladsc, found] = cspice_dlabfs( handle );
%
%         if ~found
%
%            %
%            % We arrive here only if the kernel
%            % contains no segments. This is
%            % unexpected, but we're prepared for it.
%            %
%            fprintf( 'No segments found in DSK file %s\n', dsk )
%            return
%
%         end
%
%         %
%         % If we made it this far, `dladsc' is the
%         % DLA descriptor of the first segment.
%         %
%         % Get segment vertex and plate counts.
%         %
%         [nv, np] = cspice_dskz02( handle, dladsc );
%
%         fprintf( '\n' )
%         fprintf( 'Number of vertices:  %d\n', nv )
%         fprintf( 'Number of plates:    %d\n', np )
%
%         %
%         %  Display the vertices of each of the first 5 plates.
%         %
%         remain = min(np, 5);
%         start  = 1;
%
%         while (remain > 0 )
%
%            %
%            % `nread' is the number of plates we"ll read on this
%            % loop pass. Set `nread' to the minimum of PBUFSIZ
%            % and `remain'.
%            %
%            nread = min(PBUFSIZ, remain);
%
%            plates = cspice_dskp02( handle, dladsc, start, nread );
%
%            for  i = 1:(nread)
%
%               plix = start + i - 1;
%
%               %
%               %  Read the vertices of the current plate.
%               %
%               for  j = 1:3
%
%                  verts(j,:) = cspice_dskv02( handle,                     ...
%                                              dladsc, plates(j,i), 1 );
%
%               end
%
%
%               %
%               % Display the vertices of the ith plate:
%               %
%               fprintf( '\n' )
%               fprintf( 'Plate number: %d\n', plix )
%
%               for  j = 1:3
%                  fprintf( '   Vertex %d: ( %16.8e %16.8e %16.8e )\n',    ...
%                                                         j, verts(j,:) )
%               end
%
%               %
%               % Display the normal vector of the current plate:
%               %
%               normal = cspice_dskn02( handle, dladsc, plix );
%               fprintf( '   Normal:   ( %16.8e %16.8e %16.8e )\n', normal )
%
%            end
%
%            start  = start  + nread;
%            remain = remain - nread;
%
%         end
%
%         %
%         % Close file.
%         %
%         cspice_dascls( handle )
%
%
%      When this program was executed on a Mac/Intel/Octave5.x/64-bit
%      platform, using the DSK file named phobos512.bds, the output
%      was:
%
%
%      Name of DSK file > phobos512.bds
%
%      Number of vertices:  1579014
%      Number of plates:    3145728
%
%      Plate number: 1
%         Vertex 1: (  -6.77444000e+00   6.26815000e+00   6.01149000e+00 )
%         Vertex 2: (  -6.76238000e+00   6.25728000e+00   6.02556000e+00 )
%         Vertex 3: (  -6.75710000e+00   6.27754000e+00   6.02096000e+00 )
%         Normal:   (  -5.81973770e-01   3.21285613e-01   7.47048918e-01 )
%
%      Plate number: 2
%         Vertex 1: (  -6.77444000e+00   6.26815000e+00   6.01149000e+00 )
%         Vertex 2: (  -6.77973000e+00   6.24790000e+00   6.01610000e+00 )
%         Vertex 3: (  -6.76238000e+00   6.25728000e+00   6.02556000e+00 )
%         Normal:   (  -5.81456950e-01   3.21988310e-01   7.47148809e-01 )
%
%      Plate number: 3
%         Vertex 1: (  -6.77973000e+00   6.24790000e+00   6.01610000e+00 )
%         Vertex 2: (  -6.76768000e+00   6.23701000e+00   6.03019000e+00 )
%         Vertex 3: (  -6.76238000e+00   6.25728000e+00   6.02556000e+00 )
%         Normal:   (  -5.81597068e-01   3.22641957e-01   7.46757671e-01 )
%
%      Plate number: 4
%         Vertex 1: (  -6.77973000e+00   6.24790000e+00   6.01610000e+00 )
%         Vertex 2: (  -6.78499000e+00   6.22762000e+00   6.02070000e+00 )
%         Vertex 3: (  -6.76768000e+00   6.23701000e+00   6.03019000e+00 )
%         Normal:   (  -5.83129010e-01   3.20560704e-01   7.46459237e-01 )
%
%      Plate number: 5
%         Vertex 1: (  -6.78499000e+00   6.22762000e+00   6.02070000e+00 )
%         Vertex 2: (  -6.77299000e+00   6.21674000e+00   6.03482000e+00 )
%         Vertex 3: (  -6.76768000e+00   6.23701000e+00   6.03019000e+00 )
%         Normal:   (  -5.83664048e-01   3.23060196e-01   7.44962005e-01 )
%
%
%-Particulars
%
%   None.
%
%-Exceptions
%
%   1)  If the input handle is invalid, an error is signaled by a
%       routine in the call tree of this routine.
%
%   2)  If a file read error occurs, the error is signaled by a
%       routine in the call tree of this routine.
%
%   3)  If the input DLA descriptor is invalid, the effect of this
%       routine is undefined. The error *may* be diagnosed by
%       routines in the call tree of this routine, but there are no
%       guarantees.
%
%   4)  If `plid' is less than 1 or greater than the number of plates in
%       the segment, the error SPICE(INDEXOUTOFRANGE) is signaled by a
%       routine in the call tree of this routine.
%
%   5)  This routine does not check for linear independence of the
%       plate's edges. The plate model is assumed to be geometrically
%       valid.
%
%   6)  If any of the input arguments, `handle', `dladsc' or `plid',
%       is undefined, an error is signaled by the Matlab error
%       handling system.
%
%   7)  If any of the input arguments, `handle', `dladsc' or `plid',
%       is not of the expected type, or it does not have the expected
%       dimensions and size, an error is signaled by the Mice
%       interface.
%
%-Files
%
%   See input argument `handle'.
%
%-Restrictions
%
%   See -Exceptions section.
%
%-Required_Reading
%
%   DAS.REQ
%   DSK.REQ
%   MICE.REQ
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
%   -Mice Version 1.1.0, 21-JUL-2020 (EDW) (JDR)
%
%       Fixed typos in code example.
%
%       Edited the header to comply with NAIF standard. Updated
%       code example to prompt for the input DSK file and reduce the
%       number of plates whose vertices are shown on output.
%
%       Added -Parameters, -Exceptions, -Files, -Restrictions,
%       -Literature_References and -Author_and_Institution sections.
%
%       Eliminated use of "lasterror" in rethrow.
%
%       Removed reference to the function's corresponding CSPICE header from
%       -Required_Reading section.
%
%   -Mice Version 1.0.0, 06-MAY-2014 (NJB) (EDW)
%
%-Index_Entries
%
%   compute normal vector for a type 2 DSK plate
%   compute normal vector from DSK type 2 plate id
%
%-&

function [normal] = cspice_dskn02( handle, dladsc, plid )

   switch nargin
      case 3

         handle = zzmice_int( handle );
         dladsc = zzmice_int( dladsc );
         plid   = zzmice_int( plid   );

      otherwise

         error ( [ 'Usage: [normal(3)] = cspice_dskn02( ' ...
                                     'handle, dladsc, plid )' ]);

   end

   %
   % Call the MEX library.
   %
   try
      [normal] = mice('dskn02_c', handle, dladsc, plid );
   catch spiceerr
      rethrow(spiceerr)
   end


