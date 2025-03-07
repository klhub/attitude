%-Abstract
%
%   MiceGF.m performs Mice GF-specific definitions.
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
%   None.
%
%-Parameters
%
%   None.
%
%-Examples
%
%   Include these definitions by using the call:
%
%      MiceUser;
%
%-Particulars
%
%   This include file defines macros that may be referenced in application
%   code that calls Mice GF functions.
%   
%
%   Macros
%   ======
%   
%      Workspace parameters
%      --------------------
% 
%      Mice applications normally don't declare workspace arguments
%      and therefore don't directly reference workspace size parameters.
%      However, Mice GF APIs dealing with numeric constraints
%      dynamically allocate workspace memory; the amount allocated
%      depends on the number of intervals the workspace windows can
%      hold. This amount is an input argument to the GF numeric quantity
%      APIs.
% 
%      The parameters below are used to calculate the amount of memory
%      required. Each workspace window contains 6 double precision
%      numbers in its control area and 2 double precision numbers for
%      each interval it can hold.
%
%      
%         Name                  Description
%         ----                  ----------
%         SPICE_GF_NWMAX        Maximum number of windows required for 
%                               a user-defined workspace array. 
%         
%         SPICE_GF_NWDIST       Number of workspace windows used by
%                               cspice_gfdist and the underlying SPICELIB
%                               routine GFDIST.
%
%         SPICE_GF_NWILUM       Number of workspace windows used by
%                               cspice_gfilum and the underlying SPICELIB
%                               routine GFILUM.
%
%         SPICE_GF_NWSEP        Number of workspace windows used by
%                               cspice_gfsep and the underlying SPICELIB
%                               routine GFSEP.
%
%         SPICE_GF_NWRR         Number of workspace windows used by
%                               cspice_gfrr and the underlying SPICELIB
%                               routine GFRR.
%                               
%         SPICE_GF_NWPA         Number of workspace windows used by
%                               cspice_gfpa and the underlying SPICELIB
%                               routine GFPA.                               
%
%
%      Field of view (FOV) parameters
%      ------------------------------
%
%         Name                  Description
%         ----                  ----------
%         SPICE_GF_MAXVRT       Maximum allowed number of boundary
%                               vectors for a polygonal FOV.
%         
%         SPICE_GF_CIRFOV       Parameter identifying a circular FOV.
%
%         SPICE_GF_ELLFOV       Parameter identifying a elliptical FOV.
%
%         SPICE_GF_POLFOV       Parameter identifying a polygonal FOV.
%
%         SPICE_GF_RECFOV       Parameter identifying a rectangular FOV.
%
%         SPICE_GF_SHPLEN       Parameter specifying maximum length of
%                               a FOV shape name.
%
%         SPICE_GF_MARGIN       is a small positive number used to
%                               constrain the orientation of the
%                               boundary vectors of polygonal FOVs. Such
%                               FOVs must satisfy the following
%                               constraints:
%
%                               1)  The boundary vectors must be
%                                   contained within a right circular
%                                   cone of angular radius less than
%                                   than (pi/2) - SPICE_GF_MARGIN radians; in
%                                   other words, there must be a vector
%                                   A such that all boundary vectors
%                                   have angular separation from A of
%                                   less than (pi/2)-SPICE_GF_MARGIN radians.
% 
%                               2)  There must be a pair of boundary
%                                   vectors U, V such that all other
%                                   boundary vectors lie in the same
%                                   half space bounded by the plane
%                                   containing U and V. Furthermore, all
%                                   other boundary vectors must have
%                                   orthogonal projections onto a plane
%                                   normal to this plane such that the
%                                   projections have angular separation
%                                   of at least 2*SPICE_GF_MARGIN radians
%                                   from the plane spanned by U and V.
%
%                               SPICE_GF_MARGIN is currently set to 1.D-12.
%         
%
%      Occultation parameters
%      ----------------------
%
%         SPICE_GF_ANNULR       Parameter identifying an "annular
%                               occultation." This geometric condition
%                               is more commonly known as a "transit."
%                               The limb of the background object must
%                               not be blocked by the foreground object
%                               in order for an occultation to be
%                               "annular."
%
%         SPICE_GF_ANY          Parameter identifying any type of
%                               occultation or transit.
%
%         SPICE_GF_FULL         Parameter identifying a full
%                               occultation: the foreground body
%                               entirely blocks the background body.
%
%         SPICE_GF_PARTL        Parameter identifying an "partial
%                               occultation." This is an occultation in
%                               which the foreground body blocks part,
%                               but not all, of the limb of the
%                               background body.
%
% 
%
%      Target shape parameters
%      -----------------------
%
%         SPICE_GF_EDSHAP       Parameter indicating a target object's
%                               shape is modeled as an ellipsoid.
%
%         SPICE_GF_PTSHAP       Parameter indicating a target object's
%                               shape is modeled as a point.
%
%         SPICE_GF_RYSHAP       Parameter indicating a target object's
%                               "shape" is modeled as a ray emanating
%                               from an observer's location. This model
%                               may be used in visibility computations
%                               for targets whose direction, but not
%                               position, relative to an observer is
%                               known.
% 
%         SPICE_GF_SPSHAP       Parameter indicating a target object's
%                               shape is modeled as a sphere.
%
%
%
%      Search parameters
%      -----------------
%
%      These parameters affect the manner in which GF searches are
%      performed. 
%
%         SPICE_GF_ADDWIN       is a parameter used in numeric quantity
%                               searches that use an equality
%                               constraint. This parameter is used to
%                               expand the confinement window (the
%                               window over which the search is
%                               performed) by a small amount at both
%                               ends. This expansion accommodates the
%                               case where a geometric quantity is equal
%                               to a reference value at a boundary point
%                               of the original confinement window.
% 
%         SPICE_GF_CNVTOL       is the default convergence tolerance
%                               used by GF routines that don't support a
%                               user-supplied tolerance value. GF
%                               searches for roots will terminate when a
%                               root is bracketed by times separated by
%                               no more than this tolerance. Units are
%                               seconds.
%
%-Exceptions
%
%   None.
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
%   None.
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
%   -Mice Version 1.0.0, 11-JUN-2020 (JDR)
%
%-Index_Entries
%
%   Include Mice GF-related parameters
%
%-&
   

%
% See the -Particulars section above for parameter descriptions.
%

%
% Workspace parameters
%      
SPICE_GF_NWMAX  =       15;
SPICE_GF_NWDIST =       5;
SPICE_GF_NWILUM =       5;
SPICE_GF_NWSEP  =       5;
SPICE_GF_NWRR   =       5;
SPICE_GF_NWPA   =       5;


%
% Field of view (FOV) parameters
%
SPICE_GF_MAXVRT =       10000;  
SPICE_GF_CIRFOV =       'CIRCLE';
SPICE_GF_ELLFOV =       'ELLIPSE';
SPICE_GF_POLFOV =       'POLYGON';
SPICE_GF_RECFOV =       'RECTANGLE';
SPICE_GF_SHPLEN =       10;
SPICE_GF_MARGIN =       1.e-12;
 

%
% Occultation parameters
%
SPICE_GF_ANNULR =       'ANNULAR';                               
SPICE_GF_ANY    =       'ANY';                           
SPICE_GF_FULL   =       'FULL';
SPICE_GF_PARTL  =       'PARTIAL';

 
%
% Target shape parameters
%
SPICE_GF_EDSHAP =       'ELLIPSOID';
SPICE_GF_PTSHAP =       'POINT';
SPICE_GF_RYSHAP =       'RAY';
SPICE_GF_SPSHAP =       'SPHERE';


%
% Search parameters
%
SPICE_GF_ADDWIN =       1.e0;
SPICE_GF_CNVTOL =       1.e-06;

%
% End of include file MiceGF.m
%
