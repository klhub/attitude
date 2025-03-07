%-Abstract
%
%   CSPICE_TPARSE parses a time string and returns seconds past the J2000
%   epoch on a formal calendar.
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
%      string   an input time string, containing a Calendar or Julian Date.
%
%               [1,c1] = size(string); char = class(string)
%
%                  or
%
%               [1,1] = size(string); cell = class(string)
%
%               It may be in several different formats and can make use of
%               abbreviations. Several example strings and the times that
%               they translate to are listed below in the -Examples section.
%
%   the call:
%
%      [sp2000, errmsg] = cspice_tparse( string )
%
%   returns:
%
%      sp2000   the equivalent of UTC, expressed in UTC seconds past J2000.
%
%               [1,1] = size(sp2000); double = class(sp2000)
%
%               If an error occurs, or if the input time string is
%               ambiguous, `sp2000' is not changed.
%
%      errmsg   a descriptive error message, which is blank when no error
%               occurs.
%
%               [1,c2] = size(errmsg); char = class(errmsg)
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
%   1) Parse a series of time strings representing calendar dates and
%      output number of seconds past J2000 epoch that corresponds to
%      each of them. Some of the input strings have an invalid format
%      which is reflected in their output.
%
%
%      Example code begins here.
%
%
%      function tparse_ex1()
%
%         %
%         % Assign an array of calendar dates. Not all of them are
%         % valid.
%         %
%         date = { '1986-01-18T12:19:52.18',  '17JUN1982 18:28:28',         ...
%                  '182-''92/ 12:28:29.182',  '''67-271/ 12:28:30.291',     ...
%                  '-467-14-25 26:00:75',     '1993 FEB 35',                ...
%                  '1993 MAR 7' };
%
%         %
%         % Loop over the `date' array, call cspice_tparse for each element.
%         %
%         fprintf( '    Input string        UTC sec past J2000\n' )
%         fprintf( '----------------------  ------------------\n' )
%
%         for i=1:7
%
%            [sp2000, errmsg] = cspice_tparse( date(i) );
%
%            if ( strcmp( errmsg, '' ) )
%
%               fprintf( '%-22s   %17.6f\n', char(date(i)), sp2000 )
%
%            else
%
%               fprintf( '%-22s  %s\n', char(date(i)), errmsg )
%
%            end
%
%         end
%
%
%      When this program was executed on a PC/Linux/Matlab9.x/32-bit
%      platform, the output was:
%
%
%          Input string        UTC sec past J2000
%      ----------------------  ------------------
%      1986-01-18T12:19:52.18   -440293207.820000
%      17JUN1982 18:28:28       -553541492.000000
%      182-'92/ 12:28:29.182    -236820690.818000
%      '67-271/ 12:28:30.291    2137710510.291000
%      -467-14-25 26:00:75     An unexpected delimiter ('-') was encountered***
%      1993 FEB 35              -215265600.000000
%      1993 MAR 7               -215265600.000000
%
%
%      Warning: incomplete output. 1 line extended past the right
%      margin of the header and has been truncated. This line is
%      marked by "***" at the end of the line.
%
%
%      Note that the "1993 FEB 35" string in converted to UTC seconds
%      past J2000, interpreted as "1993 MAR 7".
%
%
%   2) Below is a sampling of some of the time formats that are
%      acceptable as inputs to cspice_tparse. A complete discussion of
%      permissible formats is given in the reference document
%      time.req.
%
%      ISO (T) Formats.
%
%      String                        Year Mon  DOY DOM  HR Min Sec
%      ----------------------------  ---- ---  --- ---  -- --- -----
%      1996-12-18T12:28:28           1996 Dec   na  18  12  28 28
%      1986-01-18T12                 1986 Jan   na  18  12  00 00
%      1986-01-18T12:19              1986 Jan   na  18  12  19 00
%      1986-01-18T12:19:52.18        1986 Jan   na  18  12  19 52.18
%      1986-01-18T12:19:52.18Z       1986 Jan   na  18  12  19 52.18
%      1995-08t18:28:12              1995  na  008  na  18  28 12
%      1995-08T18:28:12Z             1995  na  008  na  18  28 12
%      1995-18T                      1995  na  018  na  00  00 00
%      0000-01-01T                   1 BC Jan   na  01  00  00 00
%
%
%      Calendar Formats.
%
%      String                        Year   Mon DOM  HR Min  Sec
%      ----------------------------  ----   --- ---  -- ---  ------
%      Tue Aug  6 11:10:57  1996     1996   Aug  06  11  10  57
%      1 DEC 1997 12:28:29.192       1997   Dec  01  12  28  29.192
%      2/3/1996 17:18:12.002         1996   Feb  03  17  18  12.002
%      Mar 2 12:18:17.287 1993       1993   Mar  02  12  18  17.287
%      1992 11:18:28  3 Jul          1992   Jul  03  11  18  28
%      June 12, 1989 01:21           1989   Jun  12  01  21  00
%      1978/3/12 23:28:59.29         1978   Mar  12  23  28  59.29
%      17JUN1982 18:28:28            1982   Jun  17  18  28  28
%      13:28:28.128 1992 27 Jun      1992   Jun  27  13  28  28.128
%      1972 27 jun 12:29             1972   Jun  27  12  29  00
%      '93 Jan 23 12:29:47.289       1993*  Jan  23  12  29  47.289
%      27 Jan 3, 19:12:28.182        2027*  Jan  03  19  12  28.182
%      23 A.D. APR 4, 18:28:29.29    0023** Apr  04  18  28  29.29
%      18 B.C. Jun 3, 12:29:28.291   -017** Jun  03  12  29  28.291
%      29 Jun  30 12:29:29.298       2029+  Jun  30  12  29  29.298
%      29 Jun '30 12:29:29.298       2030*  Jun  29  12  29  29.298
%
%
%      Day of Year Formats.
%
%      String                        Year  DOY HR Min Sec
%      ----------------------------  ----  --- -- --- ------
%      1997-162::12:18:28.827        1997  162 12  18 28.827
%      162-1996/12:28:28.287         1996  162 12  28 28.287
%      1993-321/12:28:28.287         1993  231 12  28 28.287
%      1992 183// 12 18 19           1992  183 12  18 19
%      17:28:01.287 1992-272//       1992  272 17  28 01.287
%      17:28:01.282 272-1994//       1994  272 17  28 01.282
%      '92-271/ 12:28:30.291         1992* 271 12  28 30.291
%      92-182/ 18:28:28.281          1992* 182 18  28 28.281
%      182-92/ 12:29:29.192          0182+ 092 12  29 29.192
%      182-'92/ 12:28:29.182         1992  182 12  28 29.182
%
%
%      Julian Date Strings.
%
%      jd 28272.291                  Julian Date   28272.291
%      2451515.2981 (JD)             Julian Date 2451515.2981
%      2451515.2981 JD               Julian Date 2451515.2981
%
%                                   Abbreviations Used in Tables
%
%                                      na    --- Not Applicable
%                                      Mon   --- Month
%                                      DOY   --- Day of Year
%                                      DOM   --- Day of Month
%                                      Wkday --- Weekday
%                                      Hr    --- Hour
%                                      Min   --- Minutes
%                                      Sec   --- Sec
%
%      *  The default interpretation of a year that has been
%         abbreviated to two digits with or without a leading quote
%         as in 'xy or xy (such as '92 or 92) is to treat the year as
%         19xy if xy > 68 and to treat it as 20xy otherwise. Thus '70
%         is interpreted as 1970 and '67 is treated as 2067. However,
%         you may change the "split point" and centuries through use
%         of the Mice routine cspice_tsetyr. See that routine for a
%         discussion of how you may reset the split point.
%
%      ** All epochs are regarded as belonging to the Gregorian
%         calendar. We formally extend the Gregorian calendar backward
%         and forward in time for all epochs. If you have epochs
%         belonging to the Julian Calendar, consult the SPICELIB
%         routines TPARTV and JUL2GR for a discussion concerning
%         conversions to the Gregorian calendar and ET. The routines
%         cspice_timdef and cspice_str2et, used together, also support
%         conversions from Julian Calendar epochs to ET.
%
%      +  When a day of year format or calendar format string is
%         input and neither of the integer components of the date is
%         greater than 1000, the first integer is regarded as being
%         the year.
%
%      Any integer greater than 1000 is regarded as a year
%      specification. Thus 1001-1821//12:28:28 is interpreted as
%      specifying two years and will be rejected as ambiguous.
%
%-Particulars
%
%   The input string is examined and the various components of a date
%   are identified: julian date, year, month, day of year, day of
%   month, hour, minutes, seconds. These items are assumed to be
%   components on a calendar that contains no leapseconds (i.e. every
%   day is assumed to have exactly 86400 seconds).
%
%   cspice_tparse recognizes a wide range of standard time formats. The
%   -Examples section contains a list of several common strings that
%   are recognized and their interpretation. cspice_tparse relies on the
%   lower level SPICELIB routine TPARTV to interpret the input string.
%
%   Here is a brief summary of some of the basic rules used in the
%   interpretation of strings.
%
%   1)  Unless the substring 'JD' or 'jd' is present, the string is
%       assumed to be a calendar format (day-month-year or year and
%       day of year). If the substring JD or jd is present, the
%       string is assumed to represent a Julian date.
%
%   2)  If the Julian date specifier is not present, any integer
%       greater than 999 is regarded as being a year specification.
%
%   3)  A dash '-' can represent a minus sign only if it precedes
%       the first digit in the string and the string contains
%       the Julian date specifier (JD). (No negative years,
%       months, days, etc. are allowed).
%
%   4)  Numeric components of a time string must be separated
%       by a character that is not a digit or decimal point.
%       Only one decimal component is allowed. For example
%       1994219.12819 is sometimes interpreted as the
%       219th day of 1994 + 0.12819 days. cspice_tparse does not
%       support such strings.
%
%   5)  No exponential components are allowed. For example you
%       can't specify the Julian date of J2000 as 2.451545E6.
%       You also can't input 1993 Jun 23 23:00:01.202E-4 and have
%       to explicitly list all zeros that follow the decimal
%       point: i.e. 1993 Jun 23 23:00:00.0001202.
%
%   6)  The single colon (:) when used to separate numeric
%       components of a string is interpreted as separating
%       Hours, Minutes, and Seconds of time.
%
%   7)  If a double slash (//) or double colon (::) follows
%       a pair of integers, those integers are assumed  to
%       represent the year and day of year.
%
%   8)  A quote followed by an integer less than 100 is regarded
%       as an abbreviated year. For example: '93 would be regarded
%       as the 93rd year of the reference century. See the SPICELIB
%       routine TEXPYR for further discussion of abbreviated years.
%
%   9)  An integer followed by 'B.C.' or 'A.D.' is regarded as
%       a year in the era associated with that abbreviation.
%
%   10) All dates are regarded as belonging to the extended
%       Gregorian Calendar (the Gregorian calendar is the calendar
%       currently used by western society). See the SPICELIB routine
%       JUL2GR for converting from Julian Calendar to the Gregorian
%       Calendar.
%
%   11) If the ISO date-time separator (T) is present in the string
%       ISO allowed token patterns are examined for a match
%       with the current token list. If no match is found the
%       search is abandoned and appropriate diagnostic messages
%       are generated. Historically the interpretation of ISO 
%       formatted time strings deviates from the ISO standard in 
%       allowing two digit years and expanding years in the 0 to 99 
%       range the same way as is done for non ISO formatted strings. 
%       Due to this interpretation it is impossible to specify 
%       times in years in the 0 A.D. to 99 A.D. range using ISO 
%       formatted strings on the input.
%
%   12) If two delimiters are found in succession in the time
%       string, the time string is diagnosed as an erroneous string.
%       (Delimiters are comma, white space, dash, slash, period, or
%       day of year mark. The day of year mark is a pair of forward
%       slashes or a pair of colons.)
%
%       Note the delimiters do not have to be the same. The pair
%       of characters ',-' counts as two successive delimiters.
%
%   13) White space and commas serve only to delimit tokens in the
%       input string. They do not affect the meaning of any
%       of the tokens.
%
%   14) If an integer is greater than 1000 (and the 'JD' label
%       is not present, the integer is regarded as a year.
%
%   15) When the size of the integer components does not clearly
%       specify a year the following patterns are assumed
%
%       Calendar Format
%
%          Year Month Day
%          Month Day Year
%          Year Day Month
%
%          where Month is the name of a month, not its numeric
%          value.
%
%          When integer components are separated by slashes (/)
%          as in 3/4/5. Month, Day, Year is assumed (2005 March 4)
%
%       Day of Year Format.
%
%          If a day of year marker is present (// or ::) the
%          pattern
%
%            I-I// or I-I:: (where I stands for an integer)
%
%          is interpreted as Year Day-of-Year. However, I-I/ is
%          regarded as ambiguous.
%
%   To understand the complete list of strings that can be understood
%   by cspice_tparse you need to examine the SPICELIB routine TPARTV and read
%   the appendix to the TIME required reading entitled "Parsing Time
%   Strings."
%
%   cspice_tparse does not support the specification of time system
%   such as TDT or TDB; AM/PM specifications of time; or time
%   zones (such as PDT, UTC+7:20, etc.).
%
%   If some part of the time string is not recognized or if
%   the meaning of the components are not clear, an error string
%   is constructed that explains the problem with the string.
%
%   Since the routine works by breaking the input string into
%   a sequence of tokens whose meanings are determined by position
%   and magnitude, you can supply strings such as 1993 FEB 35 and
%   have this correctly interpreted as March 7, 1993. However,
%   this default action can be modified so that only "proper"
%   calendar dates and times are recognized. To do this call
%   the routine cspice_tparch as shown below:
%
%      cspice_tparch( 'YES' );
%
%   This will cause the routine to treat dates and times with
%   components outside the normal range as errors.
%
%   To return to the default behavior
%
%      cspice_tparch( 'NO' );
%
%   This routine returns information about parse errors in the output
%   string `errmsg'.
%
%-Exceptions
%
%   1)  If the input argument `string' is undefined, an error is
%       signaled by the Matlab error handling system.
%
%   2)  If the input argument `string' is not of the expected type, or
%       it does not have the expected dimensions and size, an error is
%       signaled by the Mice interface.
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
%   TIME.REQ
%
%-Literature_References
%
%   None.
%
%-Author_and_Institution
%
%   M. Costa Sitja      (JPL)
%   J. Diaz del Rio     (ODC Space)
%
%-Version
%
%   -Mice Version 1.0.0, 23-DEC-2021 (JDR) (MCS)
%
%-Index_Entries
%
%   parse a utc time string
%
%-&
function [sp2000, errmsg] = cspice_tparse( string )

   switch nargin
      case 1

         string = zzmice_str(string);

      otherwise

         error ( 'Usage: [sp2000, `errmsg`] = cspice_tparse( `string` )' )

   end

   %
   % Call the MEX library.
   %
   try
      [sp2000, errmsg] = mice('tparse_c', string);
   catch spiceerr
      rethrow(spiceerr)
   end
