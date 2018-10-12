unit LTVT_Unit;
{
 v0.1:
  1. The button on the About.. form has been changed from "OK" to "Close".
  2. Add MARK option to Go To form.
 v0.2:
  1. Caption on Current UT Time button changed to Current UT.
  2. Add "Context" help for errors loading JPL and texture files.
 v0.3:
  1. Correct error in previous change -- context for Clementine was accidentally
     based on presence of USGS hi-res file.
  2. Load low resolution texture only if requested.
  3. Add "Save As Default"/ "Restore Defaults" buttons to Set Location Form -- these
     save/restore both location and geocentric/topocentric choice.
  4. LTVT starts in Geocentric mode.
  5. Initial Sub-solar point is +90 (East).
  5. Detect when changes have been made in filenames or JPL path and
     (if so) prompt to Save new names (but not location) on exit.
  6. On Right-Click Go To, pre-fill form with Lon & Lat of mouse point -- this
     allows switching to Aerial View of current area.
 v0.4:
  1. Delete (hidden) Aerial view button and right-click menu item.
  2. Add "Label" button to "Moon Display" panel and "Modify labels.."
     option under File... menu to change font and/or location.
  3. Add an "Add label..." option to the right-click mouse menu for annotating images.
  4. Changed NumericEdit unit to automatically substitute periods for commas in
     extended value entry boxes.
  5. Repaired JPL file boundary-crossing problem in MEP and PSS (they should
     both be able to silently cross making calculations using multiple JPL files
     as long as they are all in the a single directory.
  6. Corrected error in listing of librations in MEP and PSS -- longitude and
     latitude were formerly reversed.  Also corrected error in visibility code.
     It was indicating if Sun (not feature) was on visible disk.
  7. Suppressed MoonUp/SunDown symbol in both MEP and PSS when in geocentric mode
     and graying of lines for MoonDown in MEP.
  8. Completely re-wrote SunAngle search in MEP - it now does a brute force search
     using a user-specified interval defaulting to 60 minutes.
  9. Added option to filter output in MEP (suppressing lines that are not within
     the requested tolerance).

 v0.5:
  1. Cross-hair cursor selection moved to top of right-click menu.  It is the only
     one that can have a check mark. Moved Add label... option up as well.
  2. Deleted "Clear Reference Point" as a separate option.  It now *replaces*
     "Set Reference Point" when the later is active and vice-versa.
  3. "Overlay Dots" and "Identify nearest feature" now check whether a newly-plotted
     dot is already in the CraterInfo array.  If so, a duplicate name is not
     added.  The penalty in time turned out to be minimal.
  4. Correct label for "Include feature size" checkbox on Modify Labels form --
     it was formerly chopped off.
  5. Back to Textures by default on startup.

v0.5:
  1. Delete unused "Measure Distances" option from right-click menu.

v0.6:
  1. Slight re-arrangement of order in right-click menu.
  2. MoonPosition unit has option to output Sub-observer and Sub-earth points in
     Mean Earth/Rotation axis system (formerly it was in the native Principal Axis
     System of the JPL ephemeris).  This system is offset from the PA system by
     three rotation angles, p1, p2 and tau.  Default values are provided but can
     be over-ridden by explicitly specifying these in the *.ini file.
  3. Add progress bar and "Drawing dots..." label while reading the Named Features File.
     Formerly program gave impression of freezing.

v0.7:
  1. Change name of principal axis to selenographic rotation angles in LTVT.ini
     file from MeanEarthAxis_p1Angle_arcsec to SelenographicAxes_p1Angle_arcsec etc.
  2. Use floating point (instead of integer) division to determine the pixel
     position in the reference map corresponding to 0 longitude and latitude.
     If the reference map contains an even number of pixels (0,0) will fall at
     a pixel boundary.  PDS Map-a-Planet, when it supplies grid lines, rounds down.
     LTVT shows (0,0) at the pixel boundary, which, at very high zoom will be
     at the lower right corner of the intersection of the PDS grid lines. If the
     reference map has a odd number of pixels, LTVT will show (0,0) in the center
     of the PDS lines.
  3. If an external file is in the LTVT.exe folder, strip the path from the file name
     before saving to the LTVT.ini file.
  4. Modify ExtendedValue routine in Win_Ops to replace commas with periods before
     trying to evaluate as a decimal number.

v0.8:
  1. Add file selection box for changing associations with external files.
  2. Correct error in Goto form where list in combo box was added to but not cleared on each showing.
  3. Move Save Image from File menu to button at lower right.
  4. Change Key names in LTVT.ini from  Low_Resolution_USGS_Relief_Map, Low_Resolution_USGS_Relief_Map,
     and Clementine_Texture_Map to Texture1_File, Texture2_File, and Texture3_File and
     at keys for radio button captions.

v0.9:
  1. FormClose dialog now has Yes-No-Cancel if file names were changed.
  2. File Associations form now has full path for all files.
  3. Change File... menu to Files...
  4. Move Moon Event Predictor from Tools... menu to button at lower right.
  5. Clean up file saving options in Save Image to make BMP the default (color
     is renedered more accurately) and eliminate .ico, .emf and .wmf options).
  6. Move Invert-LR, Invert-UD and BlackSky options to a new Display Options form
     under tools.
  7. PhotoSessionsSearch & MEP: add geocentric selection by checkbox.  Add more
     detail to printout.
  8. PSS file is now selectable through Change File Associations menu.
  9. PSS replaces semicolons with commas in .csv photo dates/times file.
 10. Move texture radio buttons to allow longer user-set captions.

v0.10:
  1. Remove compiler directives (of unknown origin) that appeared at top of
     this unit in Version 0.08.
  2. Modify Set Reference Point so that you don't need to Clear Reference Point
     before setting a new one -- when a reference point display is active,
     two options now appear:  Set New Reference Point and Clear Reference Point.

v0.11:
  1. Correct error:  SunRad was initially set to 1920 arc-sec instead of 1920/2,
     making terminator zone twice as wide as it should be unless updated by calculation.
  2. Introduce vector method of drawing terminator small circles, allowing rotation
     of line of cusps.
  3. Add optional overall rotation angle of image x-y axes (about z= towards observer),
     and optional cartographic mode in which central meridian of complete Moon image
     is vertical with north at top.
  4. Add checkbox to label options form to permit labeling satellite features by
     letter only.
  5. Add pop-up memo with calculation details; display controlled by checkbox on
     DisplayOptions form.
  6. Correct use of global variables in H_JPL_Ephemeris, so that when the JPL
     file is changed data from the former file will not be misinterpreted as
     currently valid data.

v0.12
  1. Change project and main unit names from LTVT_vn_nn to LTVT.  This allows
     the sub-forms to contain a reference to the main unit that does not
     need to be updated with each revision (e.g., for making declaration of
     FontLabel filename in main unit accessible to LabelFontSelector form).
     However, the .exe file now has to be manually tagged with the version number.
  2. Improve tool tips to explain more clearly that numeric longtiudes are
     with E=+ and W=-; while latitudes are N=+ and S=-.
  3. Add ability to save font used for labeling maps (typeface, color, style,
     size and position) so it can be restored the next time the program is started.
  4. Add MouseOptions form. It gives control over cursor and three modes of
     readout with respect to reference point:
       a. Distance and bearing.
       b. Shadow length mode.
       c. Ray height mode.
  5. Change "Defaults" label on main screen to "Reset" to avoid confusion with
     other Save/Restore defaults buttons.
  6. Remove "crosshair cursor" and "clear reference point" options from right-click
     menu.
  7. "Display options" renamed "Cartographic Options".
  8. Add ability to display feature file containing Clementine altimeter data
     (code "AT") with point reading displayed as LIDAR elevation + revolution number.
  9. Add optional libration circle drawn when DOTS or TEXTURE is clicked.

v0.13
  1. Change cursor to hour-glass during lengthy operations.
  2. Add a trial version of options to calibrate and load user photos.
  3. Calibration data is stored in a sub-observer sub-solar + two user-defined points fomat.
  4. Add an adjustable gamma function that can be used for altering the contrast/brightness of rendered textures.
  5. Note: this is a test version and was never publicly released.

v0.14
  1. Move original (X-Y center) boxes off main form to GoTo box. Completely rewrite
     all routines related to X-Y centering.  The screen X-Y system is identical to the
     selenographic Xi-Eta system if and *only* if one selects the Cartographic orientation
     mode with the Sub-observer point set to (0,0) and the rotation angle to 0.
     Under those circumstances, the Invert Up-Down, and Invert Left-Right options
     can be used without disturbing the X-Y (Xi-Eta) readout.  At all times and in all
     modes X-Y refer to the left-right up-down screen-oriented cartesian coordinates
     of an image point the center of the system at the center of the lunar disk
     and the scale set so the lunar radius = 1 unit.
  2. The GoTo form now has radio buttons permitting it to operate either in the
     original longitude-latitude mode, or, now, in an X-Y mode.  The two modes
     operate in the same way, and offer the same options, with the exception that
     the X-Y mode can be used to specify a point off the lunar disk.  As before,
     the GoTo form can be accessed either from the Tools... menu or by right-clicking
     on the image.  When accessed by the right-click method, the form is pre-filled with
     the longitude, latitude and X-Y coordinates of the position at which the mouse was
     clicked.  Otherwise, it retains the last values entered.  Note: if the right click
     mouse position is off the lunar disk the longitude and latitude are undefined,
     so only the X-Y boxes are updated.
  3. Change "Personal Photo Calibrator" form to request photo date/time and observer
     location, rather than computed sub-observer and sub-solar coordinates;  the latter
     are automatically computed at Step 4 in the calibration procedure.  As a result
     the main LTVT form does not need to be set the the photo date-time in order to
     determine the photo geometry.
  4. On the "Personal Photo Calibrator" form, the Save button is now visible *only*
     if the Step 4 radio button is clicked. Also, whenever the Save button is visible
     the current calibration can be previewed in the sense that the lunar longitude
     and latitude will be display below the image as the mouse is moved over it.
  5. Change format of saved calibration data to include not only the coordinates of
     the two calibration points and the sub-observer and sub-solar positions on which the
     calibration was based, but also the photo date, UT, observer location and image
     size in pixels.  At the moment the rendering of a calibrated photo is based entirely
     on the the two calibration points and the sub-observer and sub-solar positions recorded
     in the calibration file, so this new information is used for display purposes only.
  6. Change name of user-supplied photo calibration data file.  The internal
     format is a North American-style .csv file (with periods for decimal points and
     commas for item separators) but the default file name will be PhotoCalibrationData.txt
     to prevent Windows from automatically opening it with a spreadsheet program.
     In many countries, the default .csv style is to use commas for decimal points
     and semi-colons for item separators.  In such countries, PhotoCalibrationData.txt can
     be successfully opened with the Microsoft Excel spreadsheet *only* if the user
     changes the Regional Settings preferences in the Control Panel to English(United States),
     but this is not recommended.  If changes must be made to  PhotoCalibrationData.txt,
     please do so with a simple text editor (such as Notepad or WordPad) retaining the simple
     text format.  LTVT will attempt to recognize files in the European-style, but this
     process can never be entirely reliable. LTVT records dates in the calibration
     file in the format YYYY/MM/DD.  LTVT *should* be able to read dates in the local
     national format, but placing dates in the calibration file in that format is
     **NOT** recommended, since such information is not exchangeable with users in other
     countries.
  7. Add a warning if the PhotoCalibrationData.txt file cannot be found and a new
     one is about to be created.
  8. For user-supplied photos, make the No_Data color user-selectable with a
     default of clAqua (cyan).  Selection is done in the Cartographic Options
     window.  Also add an option for drawing/not drawing the red and blue
     terminator lines.
  9. Update label information in saved LTVT images.  The default is now to specify
     the center of the image by longitude and latitude.  The center is given in
     terms of X-Y coordinates only if the center point is off the lunar disk
     (where longitude and latitude are undefined). Two additional lines have been
     added, one at the top and one at the bottom so that the labels once again
     include all information needed to recreate the image:  i.e., texture file
     name, inversion, rotation and orientation options.
     NOTE: .bmp (bitmap) format continues to be recommended for saved images.
     They can be easily converted to .jpg at a later time if desired.  LTVT does
     not do a good job of saving images directly to .jpg format (it can do it,
     if requested, but the quality is not as good as can be obtained by later
     conversion with a dedicated photo-processing program).
 10. The colors of the lines appearing at the top and bottom of the saved LTVT
     images may be selected in the Change Dot/Label Preferences... menu.
     NOTE: the last line, giving a date/time and observer location does not appear
     if the sub-observer location was changed since the last time the
     Compute Geometry button was clicked.  In such cases the main screen will
     say "Manually Set Geometry".  This applies, for example to *all* Aerial Views.
     In the saved images, a manually-set geometry is assumed unless otherwise
     indicated.
 11. Add capability for copying observer locations from a list on disk.  The name
     and location of the file are specified in the Change external file associations...
     menu (default = "Observatory_List.txt"). If a file of the specified name exists,
     the drop-down list is display, otherwise it is not.  The format of the file
     is a comma-delimited list consisting of East_longitude, North_latitude, Elevation (meters)
     and Name.  The Name is placed last so that it can contain any characters, including commas.
 12. In the Calibrated Photo Selector window, add readouts of all information found in the
     calibration disk file.  The locations and coordinates of the two calibration points are
     displayed in boxes allowing user modification.  If changes are made to the numbers in the boxes
     before clicking Select, those changes will affect *only* the current loading.  They do
     not in any way alter the calibration stored on disk.  Note that the Mirror code
     is a multiplication factor along the lunar X-axis.  The only two meaningful values are +1 and -1.
 13. In the Calibrated Photo Selector window, add two new checkboxes at the bottom
     of the form which allow one to "Overwrite geometry" and/or "Overwrite date/time/location"
     when a calibrated photo is selected.  The "Overwrite geometry" mode is the
     same as what was used in v0.13: that is, when the photo is loaded, the
     sub-observer and sub-solar points in the main LTVT window are set to those
     of the calibrated photo, the use "User texture" radio button is selected, and
     then the Texture button is clicked.  When "Overwrite date/time/location" is
     selected, those values will all be replaced in the main window, then the
     Compute Geometry and Texture buttons are clicked.  Assuming the calibration data
     have not been manually altered, the computation of geometry should yield the same
     sub-observer and sub-solar points as those stored in the file.  Hence both
     these options should photo as it was originally taken.  For example, if the
     original frame was entirely on the lunar disk, it should appear in as an
     undistorted rectangle (but probably rotated relative to the Moon's pole).
     If neither box is checked, then the photo is used as a texture, but drawn onto
     a globe with whatever geometry is currently set in the main window.  For example,
     if the Sub-observer point in the main window is set to (0,0), then the user-supplied
     photo will be drawn onto an unlibrated Moon.  This mode is useful, for example,
     for correcting photos from different days to a uniform geometry so they can be
     pasted together into a mosaic.
 14. Remove statement changing Set Ref Pt to Set New Ref Pt after first click.
 15. In Go To menu, "Mark" now re-sets the Ref Pt to specified value.  In Photo
     Calibrator form Ref Pt coordinates are copied.
 16. Improve dialog when new photo calibration file needs to be created, and add
     automatically generated header lines explaining the format.
 17. Better error messages and invalidate old user photo if an error is encountered
     reading the new calibration data.
 18. In cartographic options, add checkbox requesting LTVT to Compute Geometry with
     the current system UT at startup.

  v0.14.1 (mostly bug fixes)
    1. In Photo Calibrator, change notation for calibrated mouse readout from
       the "NP up" to the more informative "North pole up".
    2. Add Moon's angular diameter to information displayed in box in upper right
       corner of screen.  The value shown is two times the Arcsin of the Moon's
       radius, taken as 1737.4 km, divided by the distance from the observer's
       location to the Moon's center. At present it appears only in the topocentric
       mode.
    3. In Photo Calibrator: add warning message if one clicks on the image without
       having the Step 2 or Step 3 radio button clicked.
    4. In Main Program: ensure that if a brief file name (no path information)
       is found in the LTVT.ini file, the application directory, rather than the
       current working directory is assumed.
    5. Correct error : dot color of non-crater features was inadvertently
       hardwired to "Yellow" and ignored selection in Dot/Label Preferences window.
       It now honors the selection.
    6. Correct error : in saved images with manually-set geometry (e.g., aerial
       views) the line specifying the texture file name was overwriting the
       bottom part of the image.  It now prints in the proper location below
       the image.

  v0.14.2
    1. In Change Dot/Label Options provide a checkbox to include or not include
       annotation lines at the top and bottom of the saved images.  With the
       un-annotated images, it is easy to save a series that can be assembled,
       using a program like iMerge, into an arbitarily large basemap for
       registering the frames of a mosaic.
    2. In Photo Calibrator, at Step 4, make visible a readout of the rotation
       angle of the raw image with respect to a standard north-up Moon, and
       also the Zoom needed in the LTVT main window to match the scale of the
       raw image.  These can be used to generate a mosaic basemap that matches
       the scale and orientation of the raw images.
    3. In the Calibrated Photo Selector form change the check boxes below the
       Select/Cancel buttons to radio buttons (only one can be selected at a time)
       and add two additional options:
         a. Load without changing main window geometry.
         b. Load at original scale and orientation.  This automatically sets the
         zoom and rotation angle of the LTVT main window to match the scale and
         orientation of the raw image.  To generate overlays corresponding to the
         raw images it is necessary then, only to select the desired reference
         map and click Texture (or Dots).
    4. Also in the Calibrated Photo Selector, add a line at the top that gives
       the full path to the currently selected image.  In the previous versions
       only the file name in the list box was visible, and there was no way to
       tell where it was located on the hard drive.
    5. Correct error: when a Dots Mode image was saved to disk, the name of the
       texture file was undefined. It is now set to "none (Dots Mode)".
    6. Add an "Inverse Shadow Length" elevation measuring mouse mode.  In this
       mode when a reference point is set at the tip of shadow a line is drawn
       back towards the Sun.  The mouse is moved back along the line until the
       shadow-casting bright pixel is encountered, at which point the readout
       indicates the elevation difference.  In the "normal" mode, the reference
       point is set at the shadow casting point and the mouse moved to the shadow
       tip.  The two modes should give identical results for any given pair of
       points.  Which mode is most useful depends on whether the thing one is
       most interested in is a feature in the ridge line or in the shadow line.
    7. Fix readout of Moon's apparent angular diameter so it can be displayed in
       Geocentric as well as Topocentric mode.  Notice that results are
       systematically smaller than JPL Horizons by about 0.1 arc second, and
       differ by a few minutes as to the time of apogee and perigee.
    8. In Dots Mode, make the colors of the Moon's sunlit and shadowed sides
       user selectable.  This is useful for creating transparent GIF mouse-over
       overlays for web presentations.  If the two colors are set to the same
       value then the background color can be chosen as the transparent color in
       a photo processing software, and the only the dots and label text will
       show in the overlay.

  v0.14.3
    1. Correct error:  "Marking" a point with the GoTo menu was corrupting the
       reference point.
    2. Correct error: in Mouse Options menu, last part of explanation of inverse
       shadow mode radio button was not visible.
    3. Clean up tab-order so that pressing TAB key moves through the buttons and
       input boxes in sequence.
    4. Add help on F1 feature:  when a button or input box is highlighted, pressing
       F1 will open and jump to the relevant section in the LTVT_UserGuide.chm
       file.
    5. In Photo Calibrator, add buttons to optionally change zoom of image being
       calibrated by steps of factors of 2.  The mouse location readout at the
       bottom of the screen continues to refer to pixel positions in the original
       image. If both the old and the new image, after changing the zoom, exceed
       the size of the viewing window, then the scroll bars are automatically
       adjusted to maintain the current centering.
    6. In Photo Calibrator, add additional safety checks to prevent completion
       of calibration with invalid data.  Specifically, do not attempt to
       complete calculation if the reference points are at the same location or
       at a longitude and latitude that cannot be seen in the current viewing
       geometry.
    7. In main program, add similar checks to avoid loading a user-calibrated
       image with invalid data.
    8. Add a work-around so that date/times prior to 1900 will print correctly
       despite faulty system date to string function.
    9. The GoTo...Mark... procedure formerly rejected points whose longitude and
       latitude placed them on the Moon's farside (in the current viewing geometry).
       It continues to issue a warning, but plots a red Mark showing the projected
       position (as if the Moon were transparent).
   10. Add a checkbox in the Files...Change External File Associations... menu
       for using an alternative method of copying internal texture bitmaps to the
       viewable window.  Tests by Paolo Amoroso found that the default method
       was incompatible with the Wine for Linux Windows emulator, but that this
       alternative method worked.  Also, removed range limits on the observation
       date input controls, which also caused problems with Wine.
   11. In Dot/Label Preferences, add a choice as to whether discontinued names
       (the ones in square brackets in the IAU list) should be included among
       those plotted.
   12. Add a right-click option to automatically label just the nearest dot.
       The dot is labeled exactly as if the Label button were clicked, but only
       a single dot is affected.
   13. Correct error:  In Change Dots/Label Preferences, when the default font
       was restored, the font sample was not being refreshed.  It is again.
   14. Correct error:  the "feature diameter" part of the Clementine Altimeter
       data listing is actually the satellite revolution number.  This was
       displaying properly in the mouse information area, but when labels
       "including feature diameter" were placed on the map, this value was
       erroneously listed as a size in "km".  The format of the map labels for
       both Clementine Altimeter and ULCN data points now match the form shown
       in the mouse information area.
   15. Change name of initial button on Photo Calibration page from "Load" to
       "Open".
   16. In Photo Calibrator add hour-glass cursor while large photos are being
       loaded.
   17. Correct error:  in Tools...Change Dot/Label preferences a positive Y-offset
       now moves the label up.  This was formerly reversed.

v0.15
  1. Change the way shadow lengths are interpretted when the User Texture
     button is selected. Formerly Earth-based photos were regarded as images
     of flattened spheres on which accurate selenographic longitudes could be
     inferred from the X-Y position.  Now they are regarded as projected images
     of features seen in relief.  The position (x1, y1) of point P1 at one end of
     a shadow segment is turned into a vector V1 representing its position
     in three dimensions relative to the center of a selenographic sphere of
     radius R0.  A line is then followed in the projected direction of the
     solar rays to find the (x2, y2) projected position of the other end.
     Starting at point P1, a vector, S, in the direction of the solar rays is
     traced until its projected tip is at (x2, y2).  The sum of V1 + S is a
     vector with its origin at the center of the sphere representing the
     3-dimensional position of point P2 at the far end of the shadow segement.
     The difference in length of of V1 vs. V2 is taken as the difference in
     elevation. This method should give accurate elevation differences, although
     when analyzing Earth-based photos, there will continue to be small errors
     in longitude and latitude because the actual topographic features are
     seen somewhat displaced (radially) by projection from the positions they
     would have on a constant radius sphere.
  2. The method of calculating the heights of the minimum and maximum rays above
     or below the lunar surface in the region beyond a shadow casting peak has
     not yet been adapted to the user-supplied photo mode.  A warning is issued
     if one closes the Mouse Options form with this option selected while a
     user-supplied (Earth-based) photo is being displayed.
  3. Add capability to display dot file with Kurt Fisher's list of crater
     depths.  Code "CD" is used to designate items of this type.

v0.16
  1. Rework the convention for Feature Size Threshold to allow plotting data from
     lists where some entries contain Size entries that cannot be interpretted as
     numbers (e.g., blank or non-numerical codes).  The meaning of the Feature
     Size Threshold is now as follows:
       a. Feature Size Threshold = -1 : display all features flagged by
         a non-blank entry in the first column.
       b. Feature Size Threshold =  0 : display all features in the list.
       c. All other values:  display an entry if and only if the "Feature Size"
          field can be successfully decoded as a number and that number equals
          or exceeds the specified threshold.
  2. Modify the CalibratedPhotoSelection form so that pressing the ENTER key
     is equivalent to clicking on the Select button (i.e., it loads the currently
     highlighted photo with the current radio-button selection).  This makes
     it possible to select a previously calibrated photo entirely with the keyboard
     (up-down arrows to highlight; ENTER to select).
  3. Add display to GoTo longitude/latitude window so it indicates the Rukl and
     LTO map numbers in which that point lies.
  4. Change Earth-based elevation difference readout to be consistent with
     older method: difference is now always mouse point elevation with respect
     to reference point elevation.
  5. In Dot/Label Options form, move and rename checkbox regarding inclusion/exclusion
     of IAU discontinued names from the Label Options group to the Dot Options group,
     since it determines whether dots will be plotted.
  6. Also in the Label Options group of the Dot/Label Options form add checkboxes
     to include/not include the feature name and the units of the feature
     dimension.  One can now independently pick and choose which elements one
     wants in the label:  name and/or size.  For satellite features, the name
     can include or not include the name of the parent feature (in addition to
     the satellite letter). For sizes, the label can include or not include the
     units.  If you lists both a name and size, the size is shown in parenthesis.
     If on the size is given, then no parenthesis are used.
  7. Change logic of labeling to label feature sizes using the literal entry in
     listed in the disk file (formerly the size entry was converted to a number
     and then formatted back to text with a fixed precision).  This permits
     non-numeric size entries:  for example, "3x10" or "approx. 5" for the
     diameter of an irregular crater.
  8. Under Files... menu on main page, add an option for viewing and loading into
     the main window Lunar Topographic Orthophotomap (LTO) and Topophotomap image
     files from the Lunar and Planetary Institute website.

  v0.16.1
    1. Modify key trapping so that when either the PhotoCalibrator,
       MoonEventPredictor, PhotoSessionsSearch, or LTO_Viewer sub=programs are
       running, the keystroke combination CTRL-TAB will switch between those windows
       and the main LTVT window.
    2. Modify User Photo Calibrator to save Sub-solar longitude as a value between
       -180 and +180 degrees.
    3. Modify texture radio button labels so they appear black if and only if
       the texture has been loaded. If the texture has not yet been loaded, the
       label appears gray.
    4. Correct errors involving left-right and up-down inversions when user-calibrated
       photos are loaded in original geometry.  Formerly, these were not properly
       initialized, and mirror-reversed images might appear in a non-reversed
       window.
    5. Add a checkbox to the GoTo window which (if checked) restricts the items
       listed in the drop-down box to the specially flagged features in the
       current dot file that display when the Feature Size Threshold is set to -1
       (flagged features have a non-null character in the first field).  The
       status of this box is *not* saved or restored with the other program options,
       but it *is* automatically checked when one first loads either
       "ClementineAltimeterData.csv" or "2005_ULCN.csv".  In the former case,
       no items are flagged, so the drop-down box is blank.  In the latter case,
       control points carried over from the 1994 ULCN are flagged, and so they
       appear in the drop-down box.  To see all the points in the dot file, one
       has to manually uncheck this box, close the form, and then re-open it.
    6. Add hour-glass cursor while GoTo window drop-down list is being prepared.
    7. In the dot files, add feature type category "GD" for GLR dome catalog features.
       These are treated the same as satellite craters (code "SF"). The only difference
       is the mouse display identifies them as "Dome" rather than "Crater".
    8. Modify implementation of Kurt Fisher's "CD" code for crater depth. It now
       works like "SF" and "GD" and the unit is correctly shown as "km" (it was
       formerly given incorrectly as "m").
    9. Modify the dot/label preferences form so that the dividing points between
       craters of various sizes can be set to non-integer values.  This permits,
       for example, Kurt's crater depths to be color=coded by fraction of a kilometer.
   10. Update default time span in MoonEventPredictor from 2006-2007 to 2007-2008.

  v0.16.2  (not publicly released)
    1. Correct error: since adding the Linux Compatibility mode it has not been
       possible to set the year to dates before 1758, because (for Linux
       compatibility) no minimum date was assigned to the date controls.  The
       minimum date is now set at runtime to 1/1/1600 if Linux Compatibility
       has not been requested, and the Set Year window works again.
    2. Correct error:  starting in v0.16, the option to exclude discontinued
       features was being ignored when the feature size threshold was set to zero.

v0.17
  1. Correct error: when a dot was added by the Right-click Identify Nearest Feature
     option, the feature size did not display.
  2. Correct "Flagged Features Only" checkbox in GoTo form so that the list in
     the drop-down box is updated immediately upon changing the check mark.
     Previously one had to close and reopen the window to see the updated list.
  3. Move Additional Rotation Angle box from Cartographic Options to Moon Display
     section of Main Window, and add an input box to request a latitude/longitude
     grid.  The grid is drawn if and only if the box is set to a non-zero value.
  4. Also in the Moon Display section of Main Window, add a check box to request
     that circles corresponding to the feature size be drawn around each dot.
  5. In Dot/Label Options, add user-selectable color fields for plus mark used
     to Mark and show Reference Points, and for the option feature size circles.
  6. Check if Texture File buttons in Moon Display window need to be grayed out
     when Restore Defaults is selected in External File Associations window.
     Formerly a change was detected only when a file name was manually changed.
  7. Improve handling of ULCN dots:
     a. For 1994 ULCN (feature type code 'CN'), show control point code number
        if a common name is not available.  Formerly these names appeared blank
        in the labels and GoTo box.
     b. For 2005 ULCN (feature type code 'CN5'), show expected error ("EVP") of
        height estimates in the mouse readout.
     c. For both files, display the numeric set number (1-5) of the dot in the
        mouse readout area.
  8. Add feature type codes CN and CN5 to the list of types to which the three-level
     coloring scheme in Dot/Label Preferences applies.  This feature can now be
     used for coloring the control network dots according to elevation zone (e.g.,
     <1735, 1735-1737, and >1737 km).  The complete set of codes to which the
     scheme is applied is now: AA, SF, CN, CN5, GD, and CD.  Clementine altimeter
     data cannot be sorted in this way because the elevation data is in the name
     field rather than in the dimension field of the dot file.
  9. Begin to add ability to load LAC charts (not yet fully implemented).

  v0.17.1
    1. For images saved in JPEG format, change compression setting from 100 (max)
       to 90.  This produces files are indistinguishable, but half the size
       (approx. 180 vs. 360 kb).  It is still recommended that files be saved
       in the BMP format, and that a third party image viewer (such as Photoshop)
       be used to convert them to JPEG. The results are sharper and the colors
       cleaner than a JPEG saved directly from LTVT.
    2. Complete implementation of mechanism for loading LAC maps (from Lunar
       and Planetary Institute website) in Mercator and Lambert Conformal Conic
       projections.

  v0.17.2
    1. When a dot is added by right-clicking and requesting "Indentify nearest
       named feature", the dot is plotted using the current reference point color.
       Formerly the dot was always plotted in aqua (cyan) with no choice. It is
       also drawn as a circle with the diameter specified in the Dot/Label
       Preferences window.  Formerly it was drawn as a 2-pixel square.

v0.18
  1. Remove "Select" button from GoTo box.  It served no purpose and was
     confusing.
  2. Move controls in Photo Calibrator from left side to right, and make form
     resizeable.  As the window is resized, the image expands to the lower
     right.
  3. Introduce convention in Photo Calibrator form that an observer elevation
     of -999 is taken to mean that the preceding longitude-latitude are the
     sub-observer point on the Moon rather than the observer's location on
     Earth.  This permits the loading of orthographic map imagery (where the
     sub-observer point is effectively lon=0/lat=0).
  4. Make a near-clone of the (user) Photo Calibrator for calibrating narrow
     field, near-normal satellite photos.  It is accessed through a "Calibrate
     a satellite photo..." option under Files... in the main window.  Satellite
     photos will initially be treated on the assumption that they are identical
     to the orthographic view that would be obtained from over an effective
     sub-observer point obtained by drawing a line from the Moon's center parallel
     to the line of sight, i.e., that they are equivalent to the view obtained
     from the same direction but at a great distance. In addition to the two
     reference points, the data required are the longitude, latitude ("nadir")
     and elevation of the satellite, and the longitude and latitude of the
     principal ground point (intersection of line of sight with lunar surface).
     Satellite photo calibration data are intermingled with the user photo
     calibrations, but identified by a new code "U1" indicating the special
     meaning of the long/lat/elev as a satellite position rather than an observer
     location on earth.
  5. Add right-click mouse option to set reference point on nearest dot.  This
     permits precise copying of dot coordinates without having to zoom in on dot.
     It can be used, for example, to set the reference point to the exact
     position of a ULCN control point.
  5. Add right-click mouse Help option to bring up page in Help File explaining
     each right-click option.

v0.19
  1. In Calibrated Photo selection form, add option to filter list based on
     a specified longitude and latitude.  When that option is checked, the
     program checks each calibrated photo and displays only those for which
     the specified longitude and latitude falls within the calibrated pixel
     range.  In addition each listing is preceded by the Sun's altitude and
     azimuth at that position based on the date/time associated with the photo.
  2. Also in the Calibrated Photo selection form, add a SORT checkbox.  If
     this is checked, then when one clicks "List Photos" the available items are
     listed alphabetically (in the feature search mode, in order of descending
     sun angle).  If the box is not checked, the items are listed in the order
     in which they are encountered in the CalibratedPhotos data file. When one
     changes from one display mode to another, LTVT attempts to highlight the
     last selected photo based on the file name.
  3. Also in the Calibrated Photo selection form, add a CHANGE button to permit
     changing the file of calibration data that is searched without having to
     go to the "Files...Change external file associations..." menu.
  4. In the Photo Session Search form, add similar button to permit changing
     the file (of photo date/times) being searched without having to go to the
     "Files...Change external file associations..." menu.
  5. In the Tools... and right-click menus, add a circle drawing tool.  It draws
     a circle (ellipse as seen in projection) of the specified diameter at
     the specified location.  Its intended purpose is to permit more accurate
     estimates of the size and location of lunar features.  Like the GoTo
     window, if invoked by a right-click, the longitude/latitude boxes are
     pre-set to the current mouse position.  If invoked through the Tools...
     menu, the control reappears with the longitude/latitude boxes unchanged.
     The numeric values in the input boxes can be incremented with the UP-DOWN
     arrows on the keyboard.  In that mode, the step is approximately 1 pixel
     per keystroke.  Holding down the SHIFT key increases the step by 5X.
     The center of the circle is indicated by a plus mark.
  6. Make size of plus marks (used for representing reference points, center of
     circles drawn with Circle Tool, etc.) adjustable by via Dot Size input
     box in Dot/Label Options window.  The plus mark generated by the circle
     drawing tool is drawn at the current Dot Size.  All other plus marks are
     drawn at the (DotSize + 1).  Setting Dot Size to -1 or less will suppress
     the drawing of the plus mark at the center of a circle generated by the
     Circle Tool. Reference Marks will not be visible if the Dot Size is -2 or
     less. The center mark generated by the Circle Tool can also be suppressed
     by unchecking the "Show Center" checkbox on that form.
  7. In the X-Y section of the GoTo form, add a Redraw button.  This refreshes
     the main image (re-centers on specified X-Y) without having to close the
     window.  The X-Y values can be incremented or decremented using the
     UP-DOWN arrows on the keyboard.  In that mode, the step is approximately 1 pixel
     per clikeystroke ck.  Holding down the SHIFT key increases the step by 5X.
     This allows the images in two copies of LTVT (running simultaneously) to
     be accurately aligned.  This is most easily accomplished by the following
     procedure: (a) left-click on the feature on wants to be the center in one
     image; (b) right-click on the same feature in the second image and select
     GoTo... from the pop-up menu; (c) select the X-Y mode and click REDRAW --
     this will center the image on the desired feature; (d) click on the X-value
     data entry box and use the UP-DOWN arrow keys to optimize the value; (e)
     repeat with the Y-value data entry box.
  8. Change default date in LTVT main window from Dec. 31 2006 to Dec. 31 2007.
  9. Correct error in drawing of plus marks.  Formerly they were unsymmetric about
     the central point, with the arms at the top and left missing one pixel at the
     end.
 10. Modify the Change Location window so that if a drop-down list of Observatory
     Locations is being used, and the current location matches one, the name of
     that listing will appear as the current selection in the combo box.
 11. Improve algorithm for checking calibration in Step 4 of the Satellite Photo
     Calibration form.  As the mouse is moved over the image, LTVT solves for
     the projection of the current pixel onto the lunar sphere and correctly
     displays the longitude and latitude at which that pixel will appear in the
     LTVT main window.
 12. Modify the scheme for shadow measurements on user-calibrated photos in the
     following ways:
       (1) In Cartographic Options window, add data entry box for specifying
         length of red line drawn during making shadow length measurements.
       (2) In effect, draw red lines based on the expected pixel positions of
         a straight line in the direction of the projected sunlight in the
         original image.  This may or may not appear as a straight line in the
         LTVT main window, depending on the geometry to which the image is mapped.
       (3) As the mouse is moved along the red line in LTVT main window, the
         shadow calculation is based on the corresponding position along the
         straight line in the original image.
     As a result of these changes, consistent and accurate elevation differences
     can be determined on the basis of shadow lengths independent of the projection
     in which the image is displayed.  This means the sunlight direction in
     LTVT-projected satellite images is now correct (it was formerly only approximately
     right) and the elevation differences are rigorously correct even with the
     close range perspective of the original.

  v0.19.1
    1. In Calibrated Photo Selection form, add option to overwrite sub-solar
       position only.
    2. In Calibrated Photo Selection form, change filename sorting to a case-
       insensitive mode.
    3. Modify Circle Drawing Tool: (1) "Draw" button is highlighted each time
       form opens; (2) can use ESC key to close form.
    4. In Moon Event Predictor, reset date/time format each time form is opened.
       For unknown reasons, UT time listings would switch to am/pm format.
    5. Move what was formerly "PhotoSessionsSearch" to Files... menu as
       "Search a photo times list...".  This can still be used for searching
       a list of the dates/times of uncalibrated photos.
    6. Rename button in lower right to "Find Photos": clicking it is now the same
       as the "Files...Load a calibrated photo..." function in the main menu,
       except that in the Calibrated Photo Selection form the "Sort" and "Filter"
       boxes are automatically checked, so one sees a list of *only* those
       calibrated photos containing the center point of the present LTVT image.
    7. Add a "Save Image" choice to the options available under "Files..." in
       the main window.  It is identical to clicking the "Save Image" button
       in the lower right of the screen.  The menu option allows the current
       LTVT screenshot to be saved to disk by the keystroke combination:
       ALT-F-I.
    8. In "Change Cartographic Options" form, change default orientation to
       "Lunar Atlas".  With the new photo-searching capability, this works
       better than the alternative ("Line of Cusps") mode when a new view of
       a given scene is loaded, especially with the "Overwrite sun angle" option.
       In the "Lunar Atlas" (central meridian vertical) mode, the existing scene
       is repainted with the new photo and only the sun angle readout is affected.
       In the "Line of Cusps" vertical mode, the new image has to be rotated
       compared to the old one, which can cause the object of interest to shift
       out of the viewing window.
    9. Correct Calibrated Photo Selection form so it won't attempt to sort a
       list containing less than two entries.
   10. Improve error trapping if calibrated photo list contains invalid/non-
       numerical data.

  v0.19.2
    1. Slightly increase blank space on left and bottom to try to avoid program
       window being placed in scroll bars on Windows desktops with newer "themes".
       Note: LTVT was designed on a Windows XP system with the "desktop theme"
       set to "Windows Classic" (simple square windows without fancy 3D effects).
       It will look best on a system set the same way.
    2. Add checkbox to automatically mark center pixel of image.  This is useful
       for making small changes to the centering. The mark is a plus mark drawn
       with the current Reference Mark options.
    3. In the GoTo menu, using the Up-Down arrows to modify the X-Y values shifted
       the image by 1 pixel or 5 pixels (with SHIFT key held down).  Change this
       to 3 pixels with SHIFT, 9 pixels with CTRL, and 27 pixels with both.
    4. When a calibrated photo is loaded, indicate in the main window that the
       geometry has been manually set (based on the values in the calibrated
       photo database listing) unless it has actually been re-computed based on
       the displayed date/time and observer location.
    5. Add "Libration Tabulator" to the Tools menu.
    6. In "Change External Files" permit Texture 3 to be a cylindrical projection
       texture file covering less than the whole sphere.
    7. Increase Percent Illumination display in upper right of main window from
       2 to 3 decimal points.  This is only a theoretical value, but the extra
       precision helps to distinguish small differences near New and Full phases.
    8. Remove the "Tools...Set year..." function.  That dialog box is now accessed
       by pressing the ESC key while a date setting date-time box has focus.
       It can now be invoked in this way for ALL date-setting boxes on all forms.
       Also change the functionality so that it overwrites the year but preserves
       the month and day (previously these were reset to "1").
    9. In external files selection dialog, change filter for Lunar Features
       (dot) file and Photo Sessions Search file to include *.txt as well as
       *.csv.
   10. Add "RECORD" button to the Circle Drawing Tool that automatically writes
       the current diameter and position to a dot file called "CircleList.txt"
       in the application directory.  If a file of that name already exists, the
       new data is appended to it.  Otherwise the file is created.
   11. Add button to Satellite Photo Calibrator form to automatically copy
       Clementine support data from *.LBL file, if it can be found.
   12. On start-up, encode date box on main page to Dec. 31 of current year.
       In earlier releases it was permanently set to 2006 or 2007.
   13. Correct error causing red shadow-measuring line to be drawn in wrong
       direction on user photos displayed with left-right inverted.
   14. Remove inadvertent "2020" Max Date restriction on date input boxes in
       Moon Event Predictor.
   15. Correct error in column headers newly created photo calibration files.
       The labels for the columns containing X-Y pixel positions and lunar
       lon-lat were inverted.  Calibration data is listed in the order: "X-pixel,
       Y-pixel, Longitude, Latitude".  The header comments are for reference
       only and do not affect the operation of the program.

  v0.19.3
    1. In PhotoSelector, artificially set Alt/Ax of Sun to 90/0 for images with
       observer elevation of "-999".  This puts all maps in a separate category
       at the top.  Also add option to show librations in longitude and latitude
       in the selection list (these do not affect the sequence in which the
       photos will be sorted).
    2. Slightly reformat the Calibrated Photo Selection menu to give more space
       for wider borders.  Slightly reduce the height of the list box to permit
       inserting a header line at the top identifying the column contents. Also,
       when the "Filter" option is selected, add text after the header line that
       gives the sun angle at the selected feature using the Subsolar Point in
       the main window; and the X-Y position of the feature in the currently
       selected photo.  X is the position expressed as a fraction of the photo
       width starting from the left.  Y is fraction of the photo height measuring
       down from the top. The location of the feature is also indicated by a
       plus mark drawn over the thumbnail image.  The plus mark is drawn with
       the same style and color as the current reference mark.
    3. To Tools... add temporary function to superimpose rectangles representing
       the Rukl map zones using the Grid color. Since the lines are drawn in
       apparent Xi-Eta, this is accurate only in zero libration views.  Dashed
       centerlines are added (dividing the zones into subquadrants) depending on
       the status of the Rukl panel in the GoTo menu.  Dashed lines are added
       if a quadrant is selected.  They are omitted if "Center" is chosen.  This
       determines the grid style whether or not a GoTo action has actually been
       performed.
    4. In Right Click menu add option to record shadow length measurement.  This
       option appears only when the Mouse Option is set to Direct or Inverse
       Shadow Length Measurement. The result is written to a disk file if and
       only if such a file exists and has been initialized with the Circle Drawing
       Tool.
    5. In the Dot/Label Preferences menu add a checkbox requesting that when a
       shadow measurement is recorded the plotted position will be projected to
       its position on a constant radius sphere.  This shows the relation between
       the reference point and the measurement point in a plan view.
    6. In the Circle Drawing Tool add a button to initialize a file for holding
       the shadow measurements.  If the file exists and has been initialized
       since LTVT was started, selecting the Right Click option to record a
       shadow measurement will both write it on the image and record the result
       to the disk file.  This includes the distance of the shadow point from
       the center of the circle at the time the file was initialized. Only one
       copy of LTVT can use the file properly at a time.
    7. In the Dot/Label Preferences menu add a checkbox requesting that for
       satellite feature letters, the value in the horizontal box be used as
       a radial offset towards the parent feature. The letter is printed in the
       direction towards the parent feature by the amount in the horizontal
       offset box plus one-half the font size.  This has no effect except in
       connection with satellite feature letters where the parent name is omitted.
    8. In the GoTo menu, add a panel that can Go To the longitude and latitude of
       the center of a Rukl map zone (or a subquadrant of one).  In a few cases
       at the limb the latitude and longitude are not defined.  In that case the
       image is centered on the nominal X-Y position of that zone, which gives
       a valid result only for zero-libration views in atlas orientation with
       zero rotation (it /does/ handle left-right and up-down inversions correctly
       in all cases).  The Rukl zone GoTo has an auto-plot option which (if checked)
       goes through the steps needed for generating WikiSpaces Rukl maps -- that
       is, adding the Rukl grid, overlaying and labeling the dots with the
       current dot and label preferences.
    9. In the About form, add link to LTVT Wiki web address and automatically
       update the copyright end date to the current year.

  v0.19.4
    1. Change Location Selector box to Auto-Dropdown mode to give it same look
       and feel as the Feature Name Selector box in the GoTo menu.
    2. Add warning box if one attempts to superimpose Rukl grid with Sub-Observer
       point set to anything other than (0,0).
    3. Internally change vector format in all units from MVectors to MPVectors.
    4. In PhotoSelector, add button to copy image info to clipboard for purpose
       of building image credits for map pages on the-Moon Wiki (this control is
       not normally visible at run time).  Also correct coding so that geometry
       readout on main form is not set to "Manual" if the "overwrite none" option
       is selected for loading a photo.
    5. Add a function to extract a feature's parent name based on USGS feature
       type code, and to Right-Click menu add an option to identify and label
       nearest feature plus all features sharing same parent.
    6. To Cartographic Options form, add options to display Moon simulations in
       equatorial and alt-az orientations. A warning is issued if the information
       needed to do this does not seem to be current.

  v0.19.5
    1. Read Feature List from disk to memory and update only as needed.
    2. Update GoTo list only as needed.
    3. Change caption of "Change Location" button in main window to
       "Location".
    4. Add status info to Mouse Display box caption that identifies orientation
       mode of current map.
    5. Add warning if shadow measurements are attempted using a user photo
       drawn with a subsolar point differing from the one encoded in the
       calibration data by more than 0.01 deg, and if so, offer to transfer
       the subsolar point data from current photo calibration info to the
       boxes in the Main Screen and redraw the texture.

  v0.19.6
    1. To Tools, add "Show Earth viewed from Moon".  This shows, in the main
       window, a north-up image of the Earth centered on the point from which
       the Moon is at the zenith.  The gamma can be adjusted, but not the zoom,
       rotation, centering or orientation.  Most of the Right-click Menu items
       are hidden, as are the "Center On" and "Aerial Image" buttons in the GoTo
       box.
    2. Add Earth texture to External File Associations menu.
    3. Revise labeling of Saved Images to be sure to give date and/or location
       on which Equatorial and Alt-Az orientations are based.
    4. Change default sky color to "Navy" (dark blue).

  v0.19.7
    1. Move routines for determining map zone from GoTo form to a separate unit.
    2. Correct error in assignment of Rukl zone for features in the small limb
       areas that fall outside the normal Rukl rectangles.
    3. Add continuous readout of map location to caption of Mouse Position
       readout box in main screen.  If the current mouse location can be
       converted to a valid selenographic longitude and latitude, this will
       include the IAU format LAC/LTO zone and if the feature is on the
       Earth-facing hemisphere it will be followed by the Rukl zone denoted
       R1..R76.
    4. Add libration readout to information in Mouse Position box when in Earth
       Viewer mode.
    5. Correct hints for information lines in Mouse Position box so they change
       depending on the display mode (Earth vs. Moon images).
    6. Add to Tools menu an option to draw circle representing limb as seen by
       currently specified observer at currently specified time.  This is
       accomplished by setting the appropriate values in the Circle Drawing Tool
       and clicking the "Draw" button, so the color will be whatever is specified
       there. This option has to be used with caution because there is no
       guarantee the specified time and location correspond to the desired
       observer.
    7. Corrected variable MoonRadius, used in some distance calculations, from
       1738 to 1737.4 (formerly used only in angular diameter calculations).
    8. In Cartographic Options form, change caption of check box from "Show
       libration circle" to "Show mean limb".
    9. Modify GoTo form hints and visibility of controls to change between
       Earth and Moon viewing modes. Delete obsolete/erroneous hint saying Mark
       button set reference point.

  v0.19.7.1
    1. 11/28/08: Correct duplicate variable introduced in v0.19.6 which produced
       erroneous interactive mouseover sun angle readout based on last
       mouseover computed subsolar point in Earth Viewer.  Corrected lines in
       both v0.19.6 and v0.19.7 files on LTVT website.

  v0.19.8
    1. Suppress drawing of circles for dot features whose numeric data is an
       elevation, specifically USGS Codes AT, CN, CN5 and CD.
    2. Add start/end option to libration tabulator. When checked, the listing
       gives the start and end times of the intervals meeting the criteria.
    3. Fix cycling between forms with CTRL-TAB. In old scheme, forms were
       prioritized and, due to a typo, cycling from the Libration Tabulator to
       the Main Window returned to the Moon Event Predictor.  Under new scheme,
       CTRL-TAB in Main Window will always cycle to the last form, if any, from
       which the Main Window was accessed with CTRL-TAB. If the Main Window has
       not previously been accessed by CTRL-TAB, it will cycle to the first open
       form, if any, using the old prioritized list.
    4. Add checkbox to PhotoSelector form permitting calibrated photos to be
       listed in order of ascending colongitude instead of descending solar
       altitude.
    5. Delete display of word "Clementine" in mouseover display of altimeter
       data with feature type code "AT", since altimeter results from other
       missions, such as Kaguya, are becoming available.
    6. Add an Abort button to the PhotoSesssions and Moon Event Predictor
       search forms.
    7. In Libration Tabulator, hide MinMoon and MaxSun elevation input boxes
       when geocentric mode is selected; and correct operation so that the
       calculated geocentric "elevations" of the Moon and Sun are ignored.
       In previous version, some valid date/times may have been rejected based
       on meaningless calculations of geocentric elevations.
    8. Add printout of current constraints in header at top of Libration
       Tabulator listings.

  v0.19.9
    1. Enlarge Calibrated Photo Selection form horizontally, and rearrange
       buttons at top of memo area for improved functionality with respect to
       colongitude, which can now be displayed independent of whether list is
       filtered or not.  Sort by: (1) colongitude if that checkbox is checked;
       (2) solar altitude if list is filtered AND colongitude not checked;
       (3) otherwise, by filename.

  v0.19.10
    1. In Moon Event Predictor, correct inadvertent error introduced when Abort
       button was added.  This forced user to exit and restart program to
       erase the Abort request.
    2. Also in Moon Event Predictor, when Geocentric Observer box is checked,
       replace display of Moon and Sun altitude and azimuth (meaningless for
       such an observer) with traditional estimates of Moon's phase at time of
       event: elongation, percent illumination and "age" (days since last New
       Moon).
    3. Finally, when the Moon Event Predictor button was clicked, the Sun angle
       and azimuth at the image center point were recalculated based on the date
       and time displayed in the main window .  They are now determined based on
       the sub-solar point displayed in the input boxes in the upper right of
       the main window. These may differ from those corresponding to the currently
       displayed date and time since they can be altered by manual entry or by
       loading a calibrated photo.  As before, the current date and time is
       copied from the main window, which makes it possible (if desired) to
       update the search data by clicking the "Calculate" button in the Moon Event
       Predictor form.
    4. In the Moon Event Predictor, Libration Tabulator and PhotoSessions Search
       forms, upgrade the user location selection box to include the drop-down list
       of observatory locations
    5. Add an "Add" button to each user location selection box.  This will append
       the current location to the current list on disk (if one exists) or create
       one with that location (if it does not) using the current text in the drop-
       down box as the site name. The drop-down box is now present at all times,
       whether or not a list currently exists on disk.
    6. Correct longstanding potential error in Moon Event Predictor : when
       filtering on sun azimuths, similar values near due north, such as 1 deg
       and 359 deg were being suppressed because of the large absolute difference.
       Before testing, the difference between the actual and target values is now
       reduced to an angle in the range +/-180, with a maximum possible absolute
       error of 180 deg. With the new logic, filtering on "-90 deg" is the same
       as filtering on "+270 deg", which it was not, formerly.  Also, make sure 
       print color is returned to black after using the gray font.

  v0.19.10.1
    1. Modify action of "Add" button in Observer Location boxes. Version 0.19.10
       attempted to copy the name from the drop-down box, but entering text similar
       to existing text changed the data in the longitude/latitude boxes.  Now
       clicking "Add" brings up a separate form for entering the new name.
    2. Modify comparison with existing data of text entered in Observer Location
       boxes to ignore leading and trailing blanks.
    3. Internal change consolidating calls for F1 help as listed at end of unit.

                                                                    25 Mar 2009}


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, LabeledNumericEdit, ExtCtrls, StdCtrls, Math, MPVectors, Win_Ops,
  ComCtrls, DateUtils, JPEG, H_JPL_Ephemeris, MoonPosition, H_ClockError,
  MP_Defs, Constnts, ExtDlgs, JimsGraph, RGB_Library, IniFiles, Menus,
  H_HTMLHelpViewer, Buttons, PopupMemo;

type
  TCrater = record
    UserFlag,
    Name,
    LatStr,
    LonStr : string;
    Lon,  {in radians}
    Lat  : extended; {in radians}
    NumericData : string;  {in km}
    USGS_Code : string; {'AL' = albedo feature, 'AA' = crater, 'SF' = satellite feature (lettered crater), 'LF' = landing site, all other types recognizable from name}
    AdditionalInfo1, AdditionalInfo2 : string;
    end;

  TCraterInfo = record  {holds info on all features currently indicated by dots}
    CraterData : TCrater;
    Dot_X, Dot_Y : integer;  {pixel at which feature is plotted}
    end;

type
  TTerminator_Form = class(TForm)
    SubObs_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    Label1: TLabel;
    SubObs_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    SubSol_Lon_LabeledNumericEdit: TLabeledNumericEdit;
    Label2: TLabel;
    SubSol_Lat_LabeledNumericEdit: TLabeledNumericEdit;
    DrawDots_Button: TButton;
    OpenDialog1: TOpenDialog;
    Date_DateTimePicker: TDateTimePicker;
    Time_DateTimePicker: TDateTimePicker;
    CraterThreshold_LabeledNumericEdit: TLabeledNumericEdit;
    DrawTexture_Button: TButton;
    EstimateData_Button: TButton;
    MoonElev_Label: TLabel;
    SavePictureDialog1: TSavePictureDialog;
    Colongitude_Label: TLabel;
    JimsGraph1: TJimsGraph;
    PercentIlluminated_Label: TLabel;
    EstimatedData_Label: TLabel;
    MouseLonLat_Label: TLabel;
    SunAngle_Label: TLabel;
    Zoom_LabeledNumericEdit: TLabeledNumericEdit;
    ResetZoom_Button: TButton;
    ProgressBar1: TProgressBar;
    Label6: TLabel;
    StatusLine_Label: TLabel;
    DrawingMap_Label: TLabel;
    ET_Label: TLabel;
    MT_Label: TLabel;
    CraterName_Label: TLabel;
    OverlayDots_Button: TButton;
    LoResUSGS_RadioButton: TRadioButton;
    HiResUSGS_RadioButton: TRadioButton;
    Clementine_RadioButton: TRadioButton;
    Now_Button: TButton;
    GeometryType_Label: TLabel;
    MainMenu1: TMainMenu;
    Help1: TMenuItem;
    About_MainMenuItem: TMenuItem;
    ools1: TMenuItem;
    GoTo_MainMenuItem: TMenuItem;
    Image_PopupMenu: TPopupMenu;
    DrawLinesToPoleAndSun_RightClickMenuItem: TMenuItem;
    IdentifyNearestFeature_RightClickMenuItem: TMenuItem;
    RefPtDistance_Label: TLabel;
    SetRefPt_RightClickMenuItem: TMenuItem;
    Goto_RightClickMenuItem: TMenuItem;
    File1: TMenuItem;
    Exit_MainMenuItem: TMenuItem;
    Saveoptions_MainMenuItem: TMenuItem;
    Geometry_GroupBox: TGroupBox;
    MoonDisplay_GroupBox: TGroupBox;
    MousePosition_GroupBox: TGroupBox;
    Label4: TLabel;
    SearchPhotoSessions_Button: TButton;
    SetLocation_Button: TButton;
    HelpContents_MenuItem: TMenuItem;
    FindJPLfile_MenuItem: TMenuItem;
    Changetexturefile_MenuItem: TMenuItem;
    LabelDots_Button: TButton;
    AddLabel_RightClickMenuItem: TMenuItem;
    ChangeExternalFiles_MainMenuItem: TMenuItem;
    SaveImage_Button: TButton;
    Predict_Button: TButton;
    Changelabelpreferences_MainMenuItem: TMenuItem;
    ChangeCartographicOptions_MainMenuItem: TMenuItem;
    ESCkeytocancel_RightClickMenuItem: TMenuItem;
    ChangeMouseOptions_MainMenuItem: TMenuItem;
    MouseOptions_RightClickMenuItem: TMenuItem;
    CalibratePhoto_MainMenuItem: TMenuItem;
    LoadCalibratedPhoto_MainMenuItem: TMenuItem;
    UserPhoto_RadioButton: TRadioButton;
    Gamma_LabeledNumericEdit: TLabeledNumericEdit;
    MoonDiameter_Label: TLabel;
    LabelNearestDot_RightClickMenuItem: TMenuItem;
    LTO_RadioButton: TRadioButton;
    GridSpacing_LabeledNumericEdit: TLabeledNumericEdit;
    DrawCircles_CheckBox: TCheckBox;
    RotationAngle_LabeledNumericEdit: TLabeledNumericEdit;
    Calibrateasatellitephoto1: TMenuItem;
    NearestDotToReferencePoint_RightClickMenuItem: TMenuItem;
    Help_RightClickMenuItem: TMenuItem;
    DrawCircle_RightClickMenuItem: TMenuItem;
    DrawCircle_MainMenuItem: TMenuItem;
    SaveImage_MainMenuItem: TMenuItem;
    SearchUncalibratedPhotos_MainMenuItem: TMenuItem;
    MarkCenter_CheckBox: TCheckBox;
    TabulateLibrations_MainMenuItem: TMenuItem;
    CountDots_RightClickMenuItem: TMenuItem;
    OpenAnLTOchart1: TMenuItem;
    DrawRuklGrid1: TMenuItem;
    Recordshadowmeasurement_RightClickMenuItem: TMenuItem;
    LabelFeatureAndSatellites_RightClickMenuItem: TMenuItem;
    ShowEarth_MainMenuItem: TMenuItem;
    DrawLimb_MainMenuItem: TMenuItem;
    procedure DrawDots_ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DrawTexture_ButtonClick(Sender: TObject);
    procedure EstimateData_ButtonClick(Sender: TObject);
    procedure ResetZoom_ButtonClick(Sender: TObject);
    procedure JimsGraph1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure JimsGraph1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OverlayDots_ButtonClick(Sender: TObject);
    procedure Now_ButtonClick(Sender: TObject);
    procedure Time_DateTimePickerEnter(Sender: TObject);
    procedure SubObs_Lon_LabeledNumericEditNumericEditKeyPress(
      Sender: TObject; var Key: Char);
    procedure SubSol_Lon_LabeledNumericEditNumericEditKeyPress(
      Sender: TObject; var Key: Char);
    procedure SubObs_Lat_LabeledNumericEditNumericEditKeyPress(
      Sender: TObject; var Key: Char);
    procedure SubSol_Lat_LabeledNumericEditNumericEditKeyPress(
      Sender: TObject; var Key: Char);
    procedure Date_DateTimePickerChange(Sender: TObject);
    procedure Time_DateTimePickerChange(Sender: TObject);
    procedure ObserverLongitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure ObserverLatitude_LabeledNumericEditNumericEditChange(
      Sender: TObject);
    procedure Exit_MainMenuItemClick(Sender: TObject);
    procedure About_MainMenuItemClick(Sender: TObject);
    procedure GoTo_MainMenuItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DrawLinesToPoleAndSun_RightClickMenuItemClick(Sender: TObject);
    procedure IdentifyNearestFeature_RightClickMenuItemClick(Sender: TObject);
    procedure SetRefPt_RightClickMenuItemClick(Sender: TObject);
    procedure ObserverElevation_LabeledNumericEditNumericEditChange(Sender: TObject);
    procedure Saveoptions_MainMenuItemClick(Sender: TObject);
    procedure SaveImage_MainMenuItemClick(Sender: TObject);
    procedure SearchPhotoSessions_ButtonClick(Sender: TObject);
    procedure SetLocation_ButtonClick(Sender: TObject);
    procedure HelpContents_MenuItemClick(Sender: TObject);
    procedure FindJPLfile_MenuItemClick(Sender: TObject);
    procedure Changetexturefile_MenuItemClick(Sender: TObject);
    procedure Goto_RightClickMenuItemClick(Sender: TObject);
    procedure LabelDots_ButtonClick(Sender: TObject);
    procedure AddLabel_RightClickMenuItemClick(Sender: TObject);
    procedure ChangeExternalFiles_MainMenuItemClick(Sender: TObject);
    procedure SaveImage_ButtonClick(Sender: TObject);
    procedure Predict_ButtonClick(Sender: TObject);
    procedure Changelabelpreferences_MainMenuItemClick(Sender: TObject);
    procedure ChangeCartographicOptions_MainMenuItemClick(Sender: TObject);
    procedure ChangeMouseOptions_MainMenuItemClick(Sender: TObject);
    procedure MouseOptions_RightClickMenuItemClick(Sender: TObject);
    procedure CalibratePhoto_MainMenuItemClick(Sender: TObject);
    procedure LoadCalibratedPhoto_MainMenuItemClick(Sender: TObject);
    procedure Now_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Date_DateTimePickerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Time_DateTimePickerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SetLocation_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EstimateData_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SubObs_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SubObs_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SubSol_Lon_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SubSol_Lat_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CraterThreshold_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DrawDots_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DrawTexture_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OverlayDots_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabelDots_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LoResUSGS_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HiResUSGS_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Clementine_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UserPhoto_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Gamma_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure Zoom_LabeledNumericEditNumericEditKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure ResetZoom_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SaveImage_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Predict_ButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchPhotoSessions_ButtonKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure LabelNearestDot_RightClickMenuItemClick(Sender: TObject);
    procedure OpenAnLTOchart1Click(Sender: TObject);
    procedure LTO_RadioButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RotationAngle_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure GridSpacing_LabeledNumericEditNumericEditKeyDown(
      Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DrawCircles_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Calibrateasatellitephoto1Click(Sender: TObject);
    procedure NearestDotToReferencePoint_RightClickMenuItemClick(Sender: TObject);
    procedure Help_RightClickMenuItemClick(Sender: TObject);
    procedure DrawCircle_RightClickMenuItemClick(Sender: TObject);
    procedure DrawCircle_MainMenuItemClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchUncalibratedPhotos_MainMenuItemClick(Sender: TObject);
    procedure MarkCenter_CheckBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TabulateLibrations_MainMenuItemClick(Sender: TObject);
    procedure CountDots_RightClickMenuItemClick(Sender: TObject);
    procedure DrawRuklGrid1Click(Sender: TObject);
    procedure Recordshadowmeasurement_RightClickMenuItemClick(
      Sender: TObject);
    procedure Image_PopupMenuPopup(Sender: TObject);
    procedure LabelFeatureAndSatellites_RightClickMenuItemClick(
      Sender: TObject);
    procedure ShowEarth_MainMenuItemClick(Sender: TObject);
    procedure DrawLimb_MainMenuItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    IniFileName : string; {file used for saving default parameters}

    BasePath : string;  // path to LTVT.exe

    ProposedFilename : String; // for saving file

    DefaultCursor : TCursor;

    EarthTextureFilename,
    CraterFilename, JPL_Filename, JPL_FilePath, LoResFilename,
    HiResFilename, ClementineFilename, NormalPhotoSessionsFilename,
    CalibratedPhotosFilename, ObservatoryListFilename,
    Tex3MinLonText, Tex3MaxLonText, Tex3MinLatText, Tex3MaxLatText,
    ObservatoryComboBoxDefaultText, ObservatoryNoFileText  : string;

    p1Text, p2Text, tauText : string; // arc-sec Mean Earth System offsets -- read from ini file
    ObserverLongitudeText, ObserverLatitudeText, ObserverElevationText : string; // altered via SelectObserverLocation_Form

    DrawingMode : (DotMode, TextureMode);
    ShowingEarth : Boolean;

    LastMouseClickPosition : TPoint;

    LinuxCompatibilityMode : Boolean;

    StartWithCurrentUT : Boolean;
    OrientationMode : (LineOfCusps, Cartographic, Equatorial, AltAz);
    IncludeLibrationCircle : boolean;
    IncludeTerminatorLines : boolean;
    LibrationCircleColor : TColor;
    NoDataColor : TColor;
    AnnotateSavedImages : Boolean;
    SavedImageUpperLabelsColor : TColor;
    SavedImageLowerLabelsColor : TColor;

    MoonRadius : extended;
    Point1Lon, Point1Lat, Point2Lon, Point2Lat : extended;  // set when measuring distance

// set during MouseMove -- used to Record Shadow Measuremt
    CurrentMouseX, CurrentMouseY, CurrentElevationDifference_m : Extended;
    ShadowTipVector : TVector;
// set in FormCreate
    ShadowProfileFilename : String;
// set on file initiation with Circle Drawing Tool
    ShadowProfileCenterVector : TVector; // center of crater being profiled, normalized to unit length
    SnapShadowPointsToPlanView : Boolean; // set from dot/label preferences form

    RefX, RefY, RefPtLon, RefPtLat, RefPtSunAngle, RefPtSunBearing : extended;

    CursorType : (UseDefaultCursor, UseCrosshairCursor);
    RefPtReadoutMode : (NoRefPtReadout, DistanceAndBearingRefPtMode,
      ShadowLengthRefPtMode, InverseShadowLengthRefPtMode, RayHeightsRefPtMode);

    LabelXPix_Offset, LabelYPix_Offset,
    Corrected_LabelXPix_Offset, Corrected_LabelYPix_Offset : Integer; // displacement from dot to label
    // first is as it appears on Label Options form; second is corrected for Font size
    IncludeFeatureName, FullCraterNames, IncludeFeatureSize, IncludeUnits,
    IncludeDiscontinuedNames, RadialDotOffset : Boolean;

    DotSize : integer;
    MediumCraterDiam, LargeCraterDiam : Extended;
    NonCraterColor, SmallCraterColor, MediumCraterColor, LargeCraterColor,
    CraterCircleColor, ReferencePointColor : TColor;

    JPL_Data : TextFile;  {optional source of ephermis info: set by SelectFile; used by RetrieveData}
    LoRes_TextureMap : TBitmap; {set to USGS map on form CREATE -- so always available}
    LoRes_Texture_Loaded : boolean;

    HiRes_TextureMap : TBitmap; {it takes several seconds for the initial load of the hi-res texture from disk,
      it also produces rather grainy full-moon images.  Therefore, although the on-screen images are drawn in
      about the same time, this file is loaded iff specifically requested}
    HiRes_Texture_Loaded : boolean;

    Clementine_TextureMap : TBitmap; {it takes several seconds for the initial load of the hi-res texture from disk,
      it also produces rather grainy full-moon images.  Therefore, although the on-screen images are drawn in
      about the same time, this file is loaded iff specifically requested}
    Clementine_Texture_Loaded : boolean;

    Earth_TextureMap : TBitmap;
    Earth_Texture_Loaded : boolean;

    TextureFilename : String; // identifies source of last background image used by Dots or Texture click

    LTO_Image : TBitmap;

    InvertLR, InvertUD : boolean;  // these are altered with the H_DisplayOptions form
    SkyColor, DotModeSunlitColor, DotModeShadowedColor : TColor;

    ShadowLineLength_pixels : Integer;

  {the following are set by CalculateGeometry}
    SubObsvrVector, SubSolarVector : TVector; {in Selenographic coordinates, based on NumericInput boxes}
//    CosTheta,                        {angle from projected center to sub-solar point}
    Solar_X_Projection : extended;   {projected x-coordinate of sub-solar point}
    XPrime_UnitVector, YPrime_UnitVector, ZPrime_UnitVector : TVector; {basis vectors for projected image
      where z' = towards observer;  y' = towards north terminator cusp;  x' = y' Cross z' = to right ("East")}
  {CalculateGeometry also sets range of JimsGraph1 per data specified in orthographic Center X, Center Y
    and Zoom numeric edits}

    ManualRotationDegrees : extended; {[deg]}
    SunRad : extended; {semi-diameter of Sun [radians] -- initialized to 1920/2 arc-sec, re-set by EstimateData_ButtonClick}

    SubSolarPoint : TPolarCoordinates;   {set by CalculateGeometry}
    SinSSLat, CosSSLat : extended;

    CraterList,  {current feature list}
    PrimaryCraterList : array of TCrater; {list of primary craters in list used for current overlay}
    CraterInfo : array of TCraterInfo; {list of craters represented by dots in current overlay}

    CraterListCurrent, GoToListCurrent : Boolean;
    LastCraterListFileRecord : TSearchRec;

    IdentifySatellites : Boolean;

 // following set when red line is drawn in shadow measuring mode on user photo
    RefPtVector,   // full vector at MoonRadius in Selenographic system
    ShadowDirectionVector : TVector;  // unit (1 km) vector parallel or anti-parallel to solar rays, depending on mode
    RefPtUserX, RefPtUserY,   // position of start of red line in X-Y system of original photo
    ShadowDirectionUserDistance : Extended; // amount of travel in photo X-Y system for 1 unit of ShadowDirectionVector

// The following are used for labeling saved images:
    ManualMode : boolean;  // current status of geometry labels

// Set by clicking EstimateData button
    ImageDate, ImageTime : TDateTime;
    ImageGeocentric : boolean;
    ImageObsLon, ImageObsLat, ImageObsElev : extended;

// Set by CalculateGeometry
    ImageManual : boolean;  // geometry was computed using manual settings
    ImageSubSolLon, ImageSubSolLat, ImageSubObsLon, ImageSubObsLat,
    ImageCenterX, ImageCenterY, ImageZoom : extended;

// Initially False, set to True if any file names have changed from their defaults.
    FileSettingsChanged : Boolean;
    OldFilename : string;  // not really global but used in many routines to check for change.

    ShowDetails : Boolean;
    PopupMemo : TPopupMemo_Form;

// Set by GoTo when a cross is drawn per data on GoTo form
//    MarkedPtLonText, MarkedPtLatText : string;

// Set by Transfer button in LTO_Viewer
    LTO_MapMode : (LTO_map, Mercator_map, Lambert_map);

    LTO_Filename : String;
    LTO_CenterLon, LTO_CenterLat, LTO_CenterXPix, LTO_CenterYPix,
    LTO_HorzPixPerDeg, LTO_VertPixPerDeg,
    LTO_SinTheta, LTO_CosTheta,  // rotation angle
    LTO_DegLonPerXPixel, LTO_DegLatPerYPixel : Extended;

    LTO_VertCorrection, LTO_MercatorScaleFactor,
    LTO_Lambert_ScaleFactor, LTO_Lambert_Lat1, LTO_Lambert_Lat2,
    LTO_Lambert_n, LTO_Lambert_F, LTO_Lambert_Rho_zero
     : Extended;


    function EphemerisDataAvailable(const MJD : Extended) : Boolean;

    function CorrectedDateTimeToStr(const DateTimeToPrint : TDateTime) : String;
    {corrects negative DateTimes (prior to 1/1/1900) so they will print properly
     with DateToStr}

    function BooleanToYesNo(const BooleanState: boolean): string;
    {returns 'yes' or 'no' for True and False}

    function YesNoToBoolean(const OptionString : string): boolean;
    {returns True if first letter of string is 'Y' or 'y'; otherwise False}

    function PosNegDegrees(const Angle : extended) : extended;
    {Adjusts Angle (in degrees) to range -180 .. +180}

    function LongitudeString(const LongitudeDegrees : extended; const DecimalPoints : integer): string;
    {returns value in range 180.nnn W to 180.nnn E}

    function LatitudeString(const LatitudeDegrees : extended; const DecimalPoints : integer): string;
    {returns value in range 90.nnn S to 90.nnn N}

    function VectorToPolar(const InputVector : TVector): TPolarCoordinates;
   {InputVector is in selenographic system with y = north pole}

    function RefreshCraterList : Boolean;
    {reads feature name list from disk}

    function PositionInCraterInfo(const ScreenX, ScreenY : integer) : boolean;
    {tests if there is already a known dot at the stated pixel position}

    function FullFilename(const ShortName : string): string;
    {adds BasePath to ShortName (filename) if ShortName has none}

    procedure SaveDefaultLabelOptions;
    {saves current map labeling font, position, & other choices to ini file}

    procedure RestoreDefaultLabelOptions;
    {retrieves current map labeling font, position, & other choices from ini file.}

    procedure WriteLabelOptionsToForm;

    procedure ReadLabelOptionsFromForm;

    procedure SaveCartographicOptions;
    {saves items items controlled by Cartographic Options form}

    procedure RestoreCartographicOptions;
    {saves items items controlled by Cartographic Options form}

    procedure WriteCartographicOptionsToForm;

    procedure ReadCartographicOptionsFromForm;

    procedure SaveMouseOptions;

    procedure RestoreMouseOptions;

    procedure WriteMouseOptionsToForm;

    procedure ReadMouseOptionsFromForm;

    procedure SaveFileOptions;

    procedure RestoreFileOptions;

    procedure WriteFileOptionsToForm;

    procedure ReadFileOptionsFromForm;

    procedure SaveLocationOptions;

    procedure RestoreLocationOptions;

    procedure WriteLocationOptionsToForm;

    procedure ReadLocationOptionsFromForm;

    procedure RefreshGoToList;

    procedure ClearImage;
    {clears Graph area and various labels}

    procedure PolarToVector(const Lat_radians, Lon_radians, Radius : extended;  var VectorResult : TVector);
    {returns vector in selenographic system with y-axis = north, z-axis = origin of latitude and longitude}

    function CalculateGeometry : Boolean;
    {uses Sub-observer and Sub-solar point input boxes to determine parameters cited above; also sets range of plot,
     returns True iff successfully completed}

    procedure DrawCircle(const CenterLonDeg, CenterLatDeg, RadiusDeg : Extended; CircleColor : TColor);
    {draws a pixel-wide circle in the requested color and of the requested radius about the center point}

    procedure DrawCross(const CenterXPixel, CenterYPixel, CrossSize : Integer; const CrossColor : TColor);
    {CrossSize determines extension of arms about central point. CrossSize=0 gives single pixel dot.
     Nothing is drawn if CrossSize<0.}

    procedure DrawTerminator;
    {draws segment of ellipse in current Pen color over current JimsGraph1}

    function ConvertXYtoVector(const XProj, YProj : extended;  Var PointVector : TVector) : Boolean;
    {converts from orthographic +/-1.0 system to (X,Y,Z) in selenographic system with radius = 1}

    function ConvertXYtoLonLat(const XProj, YProj : extended;  Var Point_Lon, Point_Lat : extended) : Boolean;
    {converts from orthographic +/-1.0 system to longitude and latitude [radians] in selenographic system}

    procedure ImageLoadProgress(Sender: TObject; Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean;
      const R: TRect; const Msg: String);

    procedure SetManualGeometryLabels;

    procedure SetEstimatedGeometryLabels;

    procedure GoToLonLat(const Long_Deg, Lat_Deg : extended);
     {attempts to set X-Y center to requested point, draw new texture map, and label point in aqua}

    procedure GoToXY(const X, Y : extended);
     {same except based on xi-eta style input}

    procedure RefreshImage;
     {redraws in Dots or Texture based on current setting}

    procedure HideMouseMoveLabels;

    procedure FindAndLoadJPL_File(const TrialFilename : string);

    function ConvertLonLatToUserPhotoXY(const Lon_radians, Lat_radians, Radius_km : extended; var UserX, UserY : extended) : Boolean;
    {given position on Moon, computes projected position in X-Y system of a calibrated image,
     where calibration is based on sphere of radius MoonRadius}

    function ConvertUserPhotoXYtoLonLat(const UserX, UserY, Radius_km : extended; var  Lon_radians, Lat_radians : extended) : Boolean;
    {inverse of preceding operation, determines longitude and latitude of point that would appear at specified
     position in image X-Y system if it originated on a sphere of radius MoonRadius}

    function ConvertLonLatToUserPhotoXPixYPix(const Lon_radians, Lat_radians, Radius_km : extended; var UserPhotoXPix, UserPhotoYPix : Integer) : Boolean;

//    procedure ConvertUserPhotoXPixYPixToXY(const UserPhotoXPix, UserPhotoYPix : integer; var UserX, UserY : extended);

    procedure LabelDot(const DotInfo : TCraterInfo);

    function FindClosestDot(var DotIndex : Integer) : Boolean;
    {returns index in CraterInfo[] of dot closest to last mouse click}

    procedure MarkXY(const X, Y : extended; const MarkColor : TColor);
    {draws cross at indicated point in "eta-xi" system}

    function  CalculateSubPoints(const MJD, ObsLon, ObsLat, ObsElev : extended; var SubObsPt, SubSunPt : TPolarCoordinates) : Boolean;
    {attempts to calculate sub-observer and sub-solar points on Moon, returns True iff successful}

    function BriefName(const FullName : string) : string;
    {strip off path if it is the same as LTVT.exe}

    function UpperCaseParentName(const FeatureName, FT_Code : String) : String;
    {attempts to extract parent part of FeatureName based on USGS Feature Type code; returns FeatureName if unsuccessful}

    function LabelString(const FeatureToLabel : TCraterInfo;
      const IncludeName, IncludeParent, IncludeSize, IncludeUnits, ShowMore : Boolean) : String;
    {returns string used for adding labels to map}

    function LTO_SagCorrectionDeg(const DelLonDeg, LatDeg : Extended) : Extended;
    {amount to be added to true Latitude to get Latitude as read on central meridian;
     DelLonDeg = displacement in longitude from center of map}

    function ConvertLTOLonLatToXY(const LTO_LonDeg, LTO_LatDeg : Extended; var LTO_XPix, LTO_YPix : Integer) : Boolean;

    procedure DisplayF1Help(const PressedKey : Word; const ShiftState : TShiftState; const HelpFileName : String);
    {launches .chm help on indicated page if PressedKey=F1}

  end;

var
  Terminator_Form: TTerminator_Form;

implementation

uses FileCtrl, H_Terminator_About_Unit, H_Terminator_Goto_Unit, H_Terminator_SetYear_Unit,
  H_Terminator_SelectObserverLocation_Unit, H_MoonEventPredictor_Unit,
  H_PhotosessionSearch_Unit, H_Terminator_LabelFontSelector_Unit,
  H_ExternalFileSelection_Unit, H_CartographicOptions_Unit, NumericEdit,
  H_MouseOptions_Unit, H_PhotoCalibrator_Unit, H_CalibratedPhotoSelector_Unit,
  LTO_Viewer_Unit, Satellite_PhotoCalibrator_Unit, CircleDrawing_Unit,
  LibrationTabulator_Unit, MapFns_Unit;

{$R *.dfm}

const
  ProgramVersion = '0.19.10.1';

// note: the following constants specify (in degrees) that texture files span
//   the full lunar globe.  They should not be changed.
  Tex3MinLon_DefaultText = '-180';
  Tex3MaxLon_DefaultText = '180';
  Tex3MinLat_DefaultText = '-90';
  Tex3MaxLat_DefaultText = '90';

var
  UserPhotoData : TPhotoCalData;
  UserPhotoLoaded : Boolean;
  UserPhoto : TBitmap;

  UserPhotoType : (EarthBased, Satellite);

  UserPhoto_SubObsVector,
  SatelliteVector, // for satellite photos this is the position of the camera relative to the Moon's center in selenodetic system
// for EarthBased photos, the following is a system pointing from the Sub-observer point to the Moon's center
// for Satellite photos the Z-axis points from the camera position (SatelliteVector) to the principal ground point
  UserPhoto_XPrime_Unit_Vector, UserPhoto_YPrime_Unit_Vector, UserPhoto_ZPrime_Unit_Vector : TVector;
  UserPhoto_StartXPix, UserPhoto_StartYPix, UserPhoto_InversionCode : Integer;
  UserPhoto_StartX, UserPhoto_StartY, UserPhoto_PixelsPerXYUnit,
  UserPhotoSinTheta, UserPhotoCosTheta : Extended;

function TTerminator_Form.VectorToPolar(const InputVector : TVector): TPolarCoordinates;
{InputVector is in selenographic system with y = north pole}
begin
  Result.Radius := VectorMagnitude(InputVector);
  Result.Latitude := ArcSin(InputVector[y]/Result.Radius);
  Result.Longitude := ArcTan2(InputVector[x],InputVector[z]);
end;

function TTerminator_Form.ConvertLonLatToUserPhotoXY(const Lon_radians, Lat_radians, Radius_km : extended; var UserX, UserY : extended) : Boolean;
var
  CosTheta : Extended;
  FeatureVector, LineOfSight : TVector;
begin {TTerminator_Form.ConvertLonLatToUserPhotoXY}
  if UserPhotoType=Satellite then
    begin
      Result := False;

      PolarToVector(Lat_radians, Lon_radians, Radius_km, FeatureVector);

      VectorDifference(FeatureVector,SatelliteVector,LineOfSight);

      if VectorMagnitude(LineOfSight)=0 then
        begin
//          ShowMessage('Feature of interest is in film plane!');
          Exit
        end;

      NormalizeVector(LineOfSight);

      CosTheta := DotProduct(LineOfSight,UserPhoto_ZPrime_Unit_Vector);
      if CosTheta<=0 then
        begin
//          ShowMessage('Feature of interest is behind film plane!');
          Exit
        end;

      if DotProduct(FeatureVector,LineOfSight)>0 then
        begin
//          ShowMessage('Feature of interest is beyond limb as seen by satellite!');
          Exit
        end;

      UserX := DotProduct(LineOfSight,UserPhoto_XPrime_Unit_Vector)/CosTheta;  // nominal Camera_Ux is to right, Uy down, like screen pixels
      UserY := -DotProduct(LineOfSight,UserPhoto_YPrime_Unit_Vector)/CosTheta; // reverse sign to make consistent with xi-eta (x= right; y= up) system

      Result := True;
    end
  else // Earthbased photo
    begin
      PolarToVector(Lat_radians,Lon_radians,Radius_km/MoonRadius,FeatureVector); // vector in selenographic system
      if DotProduct(FeatureVector,UserPhoto_SubObsVector)>0 then
        begin
          UserX := DotProduct(FeatureVector,UserPhoto_XPrime_Unit_Vector);
          UserY := DotProduct(FeatureVector,UserPhoto_YPrime_Unit_Vector);
          Result := True;
        end
      else
        begin
          Result := False;
        end;
    end;
end;  {TTerminator_Form.ConvertLonLatToUserPhotoXY}

function TTerminator_Form.ConvertUserPhotoXYtoLonLat(const UserX, UserY, Radius_km : extended; var  Lon_radians, Lat_radians : extended) : Boolean;
{inverse of preceding operation, determines longitude and latitude of point that would appear at specified
 position in image X-Y system if it originated on a sphere of radius MoonRadius}
var
  FeatureDirection, ScratchVector : TVector;
  MinusDotProd, Discrim, Distance : Extended;
  XYSqrd, RadiusFactorSqrd, XProj, YProj, ZProj, XX, YY, ZZ : Extended;

begin {TTerminator_Form.ConvertUserPhotoXYtoLonLat}
  Result := False;

  if UserPhotoType=Satellite then  // Satellite photos = sphere seen in finite perspective
    begin
      FeatureDirection := UserPhoto_ZPrime_Unit_Vector;

      ScratchVector := UserPhoto_XPrime_Unit_Vector;
      MultiplyVector(UserX,ScratchVector);
      VectorSum(FeatureDirection, ScratchVector, FeatureDirection);

      ScratchVector := UserPhoto_YPrime_Unit_Vector;
      MultiplyVector(UserY,ScratchVector);
      MultiplyVector(-1,ScratchVector);  // reverse direction to match screen system
      VectorSum(FeatureDirection, ScratchVector, FeatureDirection);

      NormalizeVector(FeatureDirection);  // unit vector from satellite in direction of object imaged

    // determine intercept (if any) of Feature Direction with lunar sphere of radius MoonRadius

      MinusDotProd := -DotProduct(SatelliteVector,FeatureDirection);  // this should be positive if camera is pointed towards Moon

      Discrim := Sqr(MinusDotProd) - (VectorModSqr(SatelliteVector) - Sqr(Radius_km));

      if Discrim<0 then Exit;   // error condition: no intercept of line and sphere

      Discrim := Sqrt(Discrim);

      Distance := MinusDotProd - Discrim;  // shortest solution of quadratic equation should be intercept with near side of Moon

      if Distance<0 then Distance := MinusDotProd + Discrim;  // error condition?: solution is to far side of Moon -- satellite is inside lunar radius?

      if Distance<0 then Exit;  // error condition: no way to get to lunar surface in camera direction.

      MultiplyVector(Distance,FeatureDirection);
      VectorSum(SatelliteVector,FeatureDirection,FeatureDirection);  // full vector from Moon's center to intercept point in selenographic system

      NormalizeVector(FeatureDirection);

      Lat_radians := ArcSin(FeatureDirection[Y]);
      Lon_radians := ArcTan2(FeatureDirection[X],FeatureDirection[Z]);

      Result := True;
    end
  else // Earthbased photo -- orthographic projection
    begin
      XProj := UserX;
      YProj := UserY;

      XYSqrd := Sqr(XProj) + Sqr(YProj);
      RadiusFactorSqrd := Sqr(Radius_km/MoonRadius);  // X-Y system is scaled to MoonRadius = 1
      if XYSqrd<RadiusFactorSqrd then
        begin
          ZProj := Sqrt(RadiusFactorSqrd - XYSqrd);  // this sets length to Radius_km/MoonRadius

          XX := XProj*UserPhoto_XPrime_Unit_Vector[x] + YProj*UserPhoto_YPrime_Unit_Vector[x] + ZProj*UserPhoto_ZPrime_Unit_Vector[x];
          YY := XProj*UserPhoto_XPrime_Unit_Vector[y] + YProj*UserPhoto_YPrime_Unit_Vector[y] + ZProj*UserPhoto_ZPrime_Unit_Vector[y];
          ZZ := XProj*UserPhoto_XPrime_Unit_Vector[z] + YProj*UserPhoto_YPrime_Unit_Vector[z] + ZProj*UserPhoto_ZPrime_Unit_Vector[z];

          Lat_radians := ArcSin(YY);
          Lon_radians := ArcTan2(XX,ZZ);
          Result := True;
        end;
    end;

end;  {TTerminator_Form.ConvertUserPhotoXYtoLonLat}

function TTerminator_Form.ConvertLonLatToUserPhotoXPixYPix(const Lon_radians, Lat_radians, Radius_km : extended; var UserPhotoXPix, UserPhotoYPix : Integer) : Boolean;
var
  FeatureX, FeatureY, TempXPix, TempYPix : Extended;
begin
  if ConvertLonLatToUserPhotoXY(Lon_radians, Lat_radians, Radius_km, FeatureX, FeatureY ) then
    begin
    // calculate distance from origin
      TempXPix := (FeatureX - UserPhoto_StartX)*UserPhoto_PixelsPerXYUnit;
      TempYPix := -(FeatureY - UserPhoto_StartY)*UserPhoto_PixelsPerXYUnit;  // Y Pixels run backwards to Y coordinate on Moon.
    // rotate and add to origin position
      UserPhotoXPix := UserPhoto_StartXPix + Round(TempXPix*UserPhotoCosTheta - TempYPix*UserPhotoSinTheta);
      UserPhotoYPix := UserPhoto_StartYPix + Round(TempXPix*UserPhotoSinTheta + TempYPix*UserPhotoCosTheta);
      Result := True;
    end
  else
    begin
      Result := False;
    end;
end;

{
procedure TTerminator_Form.ConvertUserPhotoXPixYPixToXY(const UserPhotoXPix, UserPhotoYPix : integer; var UserX, UserY : extended);
var
  TempX, TempY : Extended;
begin  //this routine is unproven
  TempX := (UserPhotoXPix - UserPhoto_StartXPix)/UserPhoto_PixelsPerXYUnit;
  TempY := (UserPhotoYPix - UserPhoto_StartYPix)/UserPhoto_PixelsPerXYUnit;
  UserX := UserPhoto_StartX + TempX*UserPhotoCosTheta + TempY*UserPhotoSinTheta;
  UserY := UserPhoto_StartY - TempX*UserPhotoSinTheta + TempY*UserPhotoCosTheta;
end;
}

function TTerminator_Form.CorrectedDateTimeToStr(const DateTimeToPrint : TDateTime) : String;
  begin
    if (DateTimeToPrint>=0) or (Frac(DateTimeToPrint)=0) then
      Result := DateTimeToStr(DateTimeToPrint)
    else
      Result := DateTimeToStr(Int(DateTimeToPrint) - 2 - Frac(DateTimeToPrint));
  end;

function TTerminator_Form.YesNoToBoolean(const OptionString : string): boolean;
  begin
    Result := UpperCaseString(Substring(OptionString,1,1))='Y';
  end;

procedure TTerminator_Form.FormCreate(Sender: TObject);
var
  IniFile : TIniFile;

begin {TTerminator_Form.FormCreate}
  CraterListCurrent := False;
  GoToListCurrent := False;
  IdentifySatellites := False;

  DefaultCursor := Screen.Cursor;

  Application.HelpFile := ExtractFilePath(Application.ExeName) + 'LTVT_USERGUIDE.chm';
//  Application.OnHelp := HH;

  BasePath := ExtractFilePath(Application.ExeName);

  ProposedFilename := 'LTVT_Image.bmp';
  ObservatoryComboBoxDefaultText := 'click ADD to assign a name to the current location';
  ObservatoryNoFileText := 'click ADD to start a list on disk';

  IniFileName := BasePath+'LTVT.ini'; //Note: if full path is not specified, file is assumed in C:\WINDOWS
  IniFile := TIniFile.Create(IniFileName);

  if YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Draw_Dots_on_Startup','no')) then
    DrawingMode := DotMode
  else
    DrawingMode := TextureMode;

  CraterThreshold_LabeledNumericEdit.NumericEdit.Text := IniFile.ReadString('LTVT Defaults','Feature_size_threshold','-1');
  IniFile.Free;

  StatusLine_Label.Caption := '';
  LoRes_Texture_Loaded := false;
  HiRes_Texture_Loaded := false;
  Clementine_Texture_Loaded := false;

//  ShortDateFormat := 'yyyy/mm/dd';
  LongTimeFormat := 'hh:nn:ss';
  ThousandSeparator := #0;
  DecimalSeparator := '.';

  try
    Date_DateTimePicker.Date := EncodeDateDay(CurrentYear,1);
  except
  end;


  Application.ShowHint := True;  // unable to get Menus to show hints!!

  HideMouseMoveLabels;   // items shown only if mouse is on lunar disk


  RefPtLon := 0;
  RefPtLat := 0;

  MoonRadius := 1737.4;  {JPL lunar radius [km] = consistent with IAU mapping diameter?}

  SunRad := 1920*OneArcSec/2;  // this is overridden by Estimate Geometry if a JPL file is available

  JimsGraph1.Initialize;
  JimsGraph1.Canvas.Brush.Style := bsClear;

  FileSettingsChanged := False;

  RestoreLocationOptions;
  RestoreFileOptions;
  RestoreDefaultLabelOptions;
  RestoreCartographicOptions;
  RestoreMouseOptions;

  if not LinuxCompatibilityMode then Date_DateTimePicker.MinDate := EncodeDateDay(1601,1);

  if StartWithCurrentUT then
    begin
      Now_Button.Click;
    end
  else
    begin
      SetManualGeometryLabels;
      RefreshImage;
    end;

  ShowDetails := False;
  PopupMemo := TPopupMemo_Form.Create(Application);
  PopupMemo.Caption := 'LTVT Calculation Details';

  ImageCenterX := 0;
  ImageCenterY := 0;

  UserPhoto_RadioButton.Hide;
  UserPhoto := TBitmap.Create;

  LTO_RadioButton.Hide;
  LTO_Image := TBitmap.Create;

  ShadowProfileFilename := BasePath+'ShadowProfile.txt';

end;  {TTerminator_Form.FormCreate}

procedure TTerminator_Form.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Answer : Word;
begin
  if (PhotosessionSearch_Form.PhotoSessionsFilename<>'') and (FullFilename(PhotosessionSearch_Form.PhotoSessionsFilename)<>FullFilename(NormalPhotoSessionsFilename)) then
    begin
      NormalPhotoSessionsFilename := PhotosessionSearch_Form.PhotoSessionsFilename;
      FileSettingsChanged := True;
    end;

  if FileSettingsChanged then
    begin
      Answer := MessageDlg('Some external file locations/names may have been changed from their defaults.'+CR
        +'Do you want to save the current ones as the new defaults?',mtConfirmation,[mbYes,mbNo,mbCancel],0);
      case Answer of
        mrCancel :
          begin
            Action := caNone;  // don't close Main Form after all!
            Exit;  // leave this routine
          end;
        mrYes : SaveFileOptions;
        end;
    end;

  LoRes_TextureMap.Free;
  HiRes_TextureMap.Free;
  Clementine_TextureMap.Free;
  UserPhoto.Free;
  LTO_Image.Free;

  PopupMemo.Free;

end;

function TTerminator_Form.LongitudeString(const LongitudeDegrees : extended; const DecimalPoints : integer): string;
{returns value in range 180.nnn W to 180.nnn E}
var
  DisplayLongitude : extended;
  LongitudeTag, FormatString : string;
begin
  DisplayLongitude := PosNegDegrees(LongitudeDegrees);  // put value in range -180 to +180
  FormatString := '%0.'+IntToStr(DecimalPoints)+'f';
  if DisplayLongitude>=0 then
    LongitudeTag := 'E'
  else
    LongitudeTag := 'W';
  Result := Format(FormatString+' %0s',[Abs(DisplayLongitude),LongitudeTag]);
end;

function TTerminator_Form.LatitudeString(const LatitudeDegrees : extended; const DecimalPoints : integer): string;
{returns value in range 180.nnn W to 180.nnn E}
var
  DisplayLatitude : extended;
  LatitudeTag, FormatString : string;
begin
  DisplayLatitude := PosNegDegrees(LatitudeDegrees);  // put value in range -180 to +180
  FormatString := '%0.'+IntToStr(DecimalPoints)+'f';
  if DisplayLatitude>=0 then
    LatitudeTag := 'N'
  else
    LatitudeTag := 'S';
  Result := Format(FormatString+' %0s',[Abs(DisplayLatitude),LatitudeTag]);
end;

procedure TTerminator_Form.PolarToVector(const Lat_radians, Lon_radians, Radius : extended;  var VectorResult : TVector);
{determines vector components of a point in polar form taking
  y-axis = polar direction
  z-axis = origin of Longitude (which is measured CCW about y-axis)
  x-axis = y cross z
 Lat, Lon are in radians }
  begin
    VectorResult[x] := Radius*Sin(Lon_radians)*Cos(Lat_radians);
    VectorResult[y] := Radius*Sin(Lat_radians);
    VectorResult[z] := Radius*Cos(Lon_radians)*Cos(Lat_radians);
  end;

function TTerminator_Form.CalculateGeometry : Boolean;
var
  LeftRight_Factor, UpDown_Factor : Integer;
  Lat1, Lon1, Lat2, Lon2, Colong, RotationAngle,
  CosTheta,  {angle from projected center to sub-solar point}
  CenterX, CenterY, ZoomFactor : Extended;
  InversionTag : String;

//  PolarAngle : Extended;

  ZenithVector, CelestialPoleVector : TVector;

begin {TTerminator_Form.CalculateGeometry}
  Result := False;

  ImageManual := ManualMode;  // current geometry was computed using manual settings

  Colong := 90 - SubSol_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue;
  while Colong>360 do Colong := Colong - 360;
  while Colong<0   do Colong := Colong + 360;
  Colongitude_Label.Caption := Format('%0.3f',[Colong]);
  MT_Label.Caption := Format('MT = %0s',[LongitudeString(-Colong,3)]);
  ET_Label.Caption := Format('ET = %0s',[LongitudeString(180-Colong,3)]);

  Lon1 := DegToRad(SubObs_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue);
  Lat1 := DegToRad(SubObs_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue);
  ImageSubObsLon := Lon1;
  ImageSubObsLat := Lat1;

// update with current values from form, since these may have been changed by user
  SubSolarPoint.Longitude := DegToRad(SubSol_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue);
  SubSolarPoint.Latitude := DegToRad(SubSol_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue);
  SubSolarPoint.Radius := 1;

  SinSSLat := Sin(SubSolarPoint.Latitude);
  CosSSLat := Cos(SubSolarPoint.Latitude);

  Lon2 := SubSolarPoint.Longitude;
  Lat2 := SubSolarPoint.Latitude;
  ImageSubSolLon := Lon2;
  ImageSubSolLat := Lat2;

  CosTheta := Sin(Lat1)*Sin(Lat2) + Cos(Lat1)*Cos(Lat2)*Cos(Lon2 - Lon1);
  PercentIlluminated_Label.Caption := Format('%% Illuminated = %0.3f',[50*(1 + CosTheta)]);

  PolarToVector(Lat1, Lon1, 1, SubObsvrVector); {sub-observer point}
  PolarToVector(Lat2, Lon2, 1, SubSolarVector); {sub-solar point}

  ZPrime_UnitVector := SubObsvrVector;
  NormalizeVector(ZPrime_UnitVector);

  InversionTag := '';
  if InvertLR then InversionTag := ' (Inverted L-R';
  if InvertUD then
    begin
      if InversionTag='' then
        InversionTag := ' (Inverted U-D'
      else
        InversionTag := InversionTag+' and U-D';
    end;
  if InversionTag<>'' then InversionTag := InversionTag+')';

  case OrientationMode of
    LineOfCusps :
      begin
        MoonDisplay_GroupBox.Caption := 'Moon Display:  Line of Cusps View'+InversionTag;

        CrossProduct(ZPrime_UnitVector,SubSolarVector,YPrime_UnitVector);

        {check if SubObsvrVector and SubSolarVector are parallel; if so, terminator is at limb so rotations relative
          to it are undefined;  arbitrarily use old x-axis to define new y'-axis}
        if VectorMagnitude(YPrime_UnitVector)=0 then
          begin
            CrossProduct(ZPrime_UnitVector,Ux,YPrime_UnitVector);
            if VectorMagnitude(YPrime_UnitVector)=0 then YPrime_UnitVector := Uy; //ZPrime_UnitVector parallel to Ux (looking from east or west)
          end;

        NormalizeVector(YPrime_UnitVector);

        if YPrime_UnitVector[y]<0 then MultiplyVector(-1,YPrime_UnitVector);

        CrossProduct(YPrime_UnitVector,ZPrime_UnitVector,XPrime_UnitVector);
        NormalizeVector(XPrime_UnitVector);
      end;

    Equatorial :
      begin
        if ManualMode then
          begin
            if MessageDlg('A map in Equatorial Orientation has been requested --'+CR+
              'the Earth north polar direction on which it is based may not be current',mtWarning,mbOKCancel,0)=mrCancel then
              Exit
            else
              begin
                with SelenographicCoordinateSystem do if VectorModSqr(UnitZ)=0 then
                  begin
                    UnitX := Ux;
                    UnitY := Uy;
                    UnitZ := Uz;
                  end;
                if VectorModSqr(EarthAxisVector)=0 then EarthAxisVector := Uz;
              end;
          end;

        MoonDisplay_GroupBox.Caption := 'Moon Display:  Equatorial View'+InversionTag;
        with SelenographicCoordinates(EarthAxisVector) do PolarToVector(Latitude,Longitude,1,CelestialPoleVector);
//        ShowMessage('Moon pole at : '+VectorString(SelenographicCoordinateSystem.UnitZ,3)+'  Earth pole in seleno system : '+VectorString(CelestialPoleVector,3)+'  ZPrime : '+VectorString(ZPrime_UnitVector,3));
        CrossProduct(CelestialPoleVector,ZPrime_UnitVector,XPrime_UnitVector);
        if VectorMagnitude(XPrime_UnitVector)=0 then XPrime_UnitVector := Ux;  //ZPrime_UnitVector parallel to zenith vector
        NormalizeVector(XPrime_UnitVector);
        CrossProduct(ZPrime_UnitVector,XPrime_UnitVector,YPrime_UnitVector);
      end;

    AltAz :
      begin
        if ManualMode then
          begin
            if MessageDlg('A map in Alt-Az Orientation has been requested --'+CR+
              'the observer zenith direction on which it is based may not be current',mtWarning,mbOKCancel,0)=mrCancel then
              Exit
            else
              begin
                with SelenographicCoordinateSystem do if VectorModSqr(UnitZ)=0 then
                  begin
                    UnitX := Ux;
                    UnitY := Uy;
                    UnitZ := Uz;
                  end;
                if VectorModSqr(ObserverZenithVector)=0 then ObserverZenithVector := Uz;
              end;
          end;

        MoonDisplay_GroupBox.Caption := 'Moon Display:  Alt-Az View'+InversionTag;
        with SelenographicCoordinates(ObserverZenithVector) do PolarToVector(Latitude,Longitude,1,ZenithVector);
//        ShowMessage('Moon pole at : '+VectorString(SelenographicCoordinateSystem.UnitZ,3)+'  Zenith direction in seleno system : '+VectorString(ObserverVertical,3)+'  ZPrime : '+VectorString(ZPrime_UnitVector,3));
        CrossProduct(ZenithVector,ZPrime_UnitVector,XPrime_UnitVector);
        if VectorMagnitude(XPrime_UnitVector)=0 then XPrime_UnitVector := Ux;  //ZPrime_UnitVector parallel to zenith vector
        NormalizeVector(XPrime_UnitVector);
        CrossProduct(ZPrime_UnitVector,XPrime_UnitVector,YPrime_UnitVector);
      end;

    else {Cartographic}
      begin
        MoonDisplay_GroupBox.Caption := 'Moon Display:  Cartographic View'+InversionTag;
        CrossProduct(Uy,ZPrime_UnitVector,XPrime_UnitVector);
        if VectorMagnitude(XPrime_UnitVector)=0 then XPrime_UnitVector := Ux;  //ZPrime_UnitVector parallel to Uy (looking from over north or south pole)
        NormalizeVector(XPrime_UnitVector);
        CrossProduct(ZPrime_UnitVector,XPrime_UnitVector,YPrime_UnitVector);
      end;

    end; {case}

  ManualRotationDegrees := RotationAngle_LabeledNumericEdit.NumericEdit.ExtendedValue;

  RotationAngle := DegToRad(ManualRotationDegrees);

  RotateVector(XPrime_UnitVector,RotationAngle,ZPrime_UnitVector);
  RotateVector(YPrime_UnitVector,RotationAngle,ZPrime_UnitVector);

{
if PolarAngle_CheckBox.Checked then
  begin
    PolarAngle := DotProduct(Uy,XPrime_UnitVector);
    if PolarAngle<>0 then PolarAngle := PiByTwo - ArcTan2(DotProduct(Uy,YPrime_UnitVector), PolarAngle);
    ShowMessage(Format('Polar angle = %0.3f',[RadToDeg(PolarAngle)]));
  end;
}

  Solar_X_Projection := DotProduct(SubSolarVector,XPrime_UnitVector);

  CenterX := ImageCenterX;
  CenterY := ImageCenterY;

  ZoomFactor := Zoom_LabeledNumericEdit.NumericEdit.ExtendedValue;
  ImageZoom := ZoomFactor;

  if ZoomFactor=0 then
    ZoomFactor := 1
  else
    ZoomFactor := 1/ZoomFactor;

  if InvertLR then
    begin
      LeftRight_Factor := -1;
      CenterX := -CenterX;
    end
  else
    LeftRight_Factor := +1;

  if InvertUD then
    begin
      UpDown_Factor := -1;
      CenterY := -CenterY;
    end
  else
    UpDown_Factor := +1;

  JimsGraph1.SetRange(LeftRight_Factor*(CenterX - 1*ZoomFactor),LeftRight_Factor*(CenterX + 1*ZoomFactor),
    UpDown_Factor*(CenterY - 1*ZoomFactor),UpDown_Factor*(CenterY + 1*ZoomFactor));

  ComputeDistanceAndBearing(RefPtLon,RefPtLat,SubSolarPoint.Longitude,SubSolarPoint.Latitude,RefPtSunAngle,RefPtSunBearing);
  RefPtSunAngle := Pi/2 - RefPtSunAngle;

  Result := True;
end;  {TTerminator_Form.CalculateGeometry}

procedure TTerminator_Form.ClearImage;
begin
  ProgressBar1.Hide;
  LabelDots_Button.Hide;
  DrawCircles_CheckBox.Show;
  MarkCenter_CheckBox.Show;
  StatusLine_Label.Caption := '';
  DrawingMap_Label.Caption := '';
  SetLength(CraterInfo,0);
  CraterName_Label.Caption := '';
end;

procedure TTerminator_Form.DrawCircle(const CenterLonDeg, CenterLatDeg, RadiusDeg : Extended; CircleColor : TColor);
var
  RotationAxis, PerpDirection, CirclePoint : TVector;
  OldMode : TPenMode;
  AngleStep, TotalAngle, TwoPi, X, Y, Z : extended;
begin {TTerminator_Form.DrawCircle}
  PolarToVector(DegToRad(CenterLatDeg),DegToRad(CenterLonDeg),1,RotationAxis);
  CrossProduct(Ux,RotationAxis,PerpDirection);
  if VectorMagnitude(PerpDirection)=0 then CrossProduct(Uy,RotationAxis,PerpDirection);
  CirclePoint := RotationAxis;
  RotateVector(CirclePoint,DegToRad(RadiusDeg),PerpDirection); // moves CirclePoint from RotationAxis (center) to point on cone of circle
  with JimsGraph1 do
    begin
      OldMode := Canvas.Pen.Mode;
      Canvas.Pen.Color := CircleColor;
      TwoPi :=  2*Pi;
      AngleStep := DegToRad(1);
      TotalAngle := 0;
      X := DotProduct(CirclePoint,XPrime_UnitVector);
      Y := DotProduct(CirclePoint,YPrime_UnitVector);
      MoveToDataPoint(X,Y);
      while TotalAngle<TwoPi do
        begin
          RotateVector(CirclePoint,AngleStep,RotationAxis);
          X := DotProduct(CirclePoint,XPrime_UnitVector);
          Y := DotProduct(CirclePoint,YPrime_UnitVector);
          Z := DotProduct(CirclePoint,ZPrime_UnitVector);
          if Z>0 then
            Canvas.Pen.Mode := pmCopy
          else
            Canvas.Pen.Mode := pmNop;  // Terminator point is not visible, use invisible ink mode
          LineToDataPoint(X,Y);
          TotalAngle := TotalAngle + AngleStep;
        end;
      Canvas.Pen.Mode := OldMode;
    end;
end;   {TTerminator_Form.DrawCircle}

procedure TTerminator_Form.DrawCross(const CenterXPixel, CenterYPixel, CrossSize : Integer; const CrossColor : TColor);
{CrossSize determines extension of arms about central point. CrossSize=0 gives single pixel dot.
 Nothing is drawn if CrossSize<0.}
begin
  with JimsGraph1 do
    begin
      if (CrossSize>=0) then with Canvas do
        begin
          Pen.Color := CrossColor;
          MoveTo(CenterXPixel,CenterYPixel-CrossSize);
          LineTo(CenterXPixel,CenterYPixel+CrossSize+1);    // note: LineTo stops short of destination by 1 pixel
          MoveTo(CenterXPixel-CrossSize,CenterYPixel);
          LineTo(CenterXPixel+CrossSize+1,CenterYPixel);
        end;
    end;
end;

procedure TTerminator_Form.DrawTerminator;
{this should be called only after a current CalculateGeometry}
var
  GridStepDeg, GridDeg, MaxLon, MinLon, MaxLat, MinLat : Extended;
  CornersGood : Boolean;

procedure TestCorner(const X, Y : Integer);
  var
    ProjectedX, ProjectedY, Lon, Lat : Extended;
  begin
    with JimsGraph1 do
      begin
        ProjectedX := XValue(X);
        ProjectedY := YValue(Y);
      end;

    if ConvertXYtoLonLat(ProjectedX,ProjectedY,Lon,Lat) then
      begin
        Lon := RadToDeg(Lon);
        Lat := RadToDeg(Lat);
        
        if Lon>MaxLon then MaxLon := Lon;
        if Lon<MinLon then MinLon := Lon;
        if Lat>MaxLat then MaxLat := Lat;
        if Lat<MinLat then MinLat := Lat;
      end
    else
      CornersGood := False;
  end;

begin {TTerminator_Form.DrawTerminator}
  if IncludeLibrationCircle then DrawCircle(0,0,90,LibrationCircleColor);

  if IncludeTerminatorLines then
    begin
      DrawCircle(RadToDeg(SubSolarPoint.Longitude),RadToDeg(SubSolarPoint.Latitude),RadToDeg(Pi/2-SunRad),clRed); // Evening terminator
      DrawCircle(RadToDeg(SubSolarPoint.Longitude),RadToDeg(SubSolarPoint.Latitude),RadToDeg(Pi/2+SunRad),clBlue); // Morning terminator
    end;

  MaxLat := -999;
  MinLat := 999;
  MaxLon := -999;
  MinLon := 999;
  CornersGood := True;

  TestCorner(0,0);
  TestCorner(JimsGraph1.Width-1,0);
  TestCorner(0,JimsGraph1.Height-1);
  TestCorner(JimsGraph1.Width-1,JimsGraph1.Height-1);

  while MaxLon<0 do MaxLon := MaxLon + 360;
  while MinLon<0 do MinLon := MinLon + 360;

  GridStepDeg := GridSpacing_LabeledNumericEdit.NumericEdit.ExtendedValue;

  if GridStepDeg<>0 then
    begin
      GridDeg := 0;
      while GridDeg<90 do
        begin
//          if (not CornersGood) or ((GridDeg<MaxLat) and (GridDeg>MinLat)) then
            DrawCircle(0,90,90-GridDeg,LibrationCircleColor); // draw little circle at Lat = +GridDeg
//          if (not CornersGood) or ((-GridDeg<MaxLat) and (-GridDeg>MinLat)) then
            DrawCircle(0,90,90+GridDeg,LibrationCircleColor); // draw little circle at Lat = -GridDeg
          GridDeg := GridDeg + GridStepDeg;
        end;
      GridDeg := 0;
      while GridDeg<180 do
        begin
//          if (not CornersGood) or ((GridDeg<MaxLon) and (GridDeg>MinLon))  or (((180+GridDeg)<MaxLon) and ((180+GridDeg)>MinLon))then
            DrawCircle(90+GridDeg,0,90,LibrationCircleColor); // draw great circles at Lon = GridDeg and 180+GridDeg
          GridDeg := GridDeg + GridStepDeg;
        end;
    end;

  if MarkCenter_CheckBox.Checked then
    begin
//      ShowMessage('Marking center');
      MarkXY(ImageCenterX,ImageCenterY,ReferencePointColor);
    end;

end;  {TTerminator_Form.DrawTerminator}

procedure TTerminator_Form.OverlayDots_ButtonClick(Sender: TObject);

  procedure DrawCraters;
    var
      MaxDiam,   // largest circle to plot
      Diam, MinKm : Extended;
      CurrentCrater : TCrater;
      CraterNum, DotRadius, DotRadiusSqrd, DiamErrorCode
        : Integer;

    procedure PlotCrater;
      var
        CraterVector : TVector;
        CraterColor : TColor;
        CraterCenterX, CraterCenterY, XOffset, YOffset, CraterIndex : Integer;

      begin {PlotCrater}
        with CurrentCrater do
          begin
            PolarToVector(Lat,Lon,1,CraterVector);
            if DotProduct(CraterVector,SubObsvrVector)>=0 then with JimsGraph1 do
              begin {crater is on visible hemisphere, so check its projection to see if it is in viewable area}
                CraterCenterX := XPix(DotProduct(CraterVector,XPrime_UnitVector));
                CraterCenterY := YPix(DotProduct(CraterVector,YPrime_UnitVector));
                {plot if projection falls within viewable area}
                if (CraterCenterX>=0) and (CraterCenterX<JimsGraph1.Width)
                  and (CraterCenterY>=0) and (CraterCenterY<JimsGraph1.Height) then
                  begin  // Plot this crater
                    if DotSize>0 then // Draw Dot
                      begin
                        if (USGS_Code='AA') or (USGS_Code='SF') or (USGS_Code='CN')
                         or (USGS_Code='CN5') or (USGS_Code='GD') or (USGS_Code='CD') then
                          begin
                            if DiamErrorCode=0 then
                              begin
                                if Diam>=LargeCraterDiam then
                                  CraterColor := LargeCraterColor
                                else if Diam>=MediumCraterDiam then
                                  CraterColor := MediumCraterColor
                                else
                                  CraterColor := SmallCraterColor;
                              end
                            else // unable to decode diameter
                              CraterColor := NonCraterColor;
                          end
                        else
                          CraterColor := NonCraterColor;

                        with Canvas do
                          begin
                            for XOffset := -DotRadius to DotRadius do
                              for YOffset := -DotRadius to DotRadius do
                                if (Sqr(XOffset)+Sqr(YOffset))<=DotRadiusSqrd then
                                  Pixels[CraterCenterX+XOffset, CraterCenterY+YOffset] := CraterColor;
                          end;
                      end;

                    if DrawCircles_CheckBox.Checked and (DiamErrorCode=0) and (Diam>0) and (Diam<MaxDiam)
                      and (USGS_Code<>'AT') and (USGS_Code<>'CN') and (USGS_Code<>'CN5') and (USGS_Code<>'CD') then
                      DrawCircle(RadToDeg(Lon),RadToDeg(Lat),RadToDeg(Diam/MoonRadius/2),CraterCircleColor);

                    if not PositionInCraterInfo(CraterCenterX, CraterCenterY) then
                      begin
                        CraterIndex := Length(CraterInfo);
                        SetLength(CraterInfo,CraterIndex+1);
                        CraterInfo[CraterIndex].CraterData := CurrentCrater;
                        CraterInfo[CraterIndex].Dot_X := CraterCenterX;
                        CraterInfo[CraterIndex].Dot_Y := CraterCenterY;
                      end;
                  end;
              end;


          end;
      end;  {PlotCrater}

    begin {DrawCraters}
      MaxDiam := MoonRadius*PiByTwo;

      RefreshCraterList;

      MinKm := CraterThreshold_LabeledNumericEdit.NumericEdit.ExtendedValue;

      DotRadius := Round(DotSize/2.0 + 0.5);
      if DotSize<=0 then
        DotRadiusSqrd := -1  // prevents drawing any dots
      else
        DotRadiusSqrd := Round(Sqr(DotSize/2.0));

      DrawingMap_Label.Caption := 'Plotting dots...';
      Application.ProcessMessages;
      ProgressBar1.Max := 9100;  // approx. num. lines in CraterFile
      ProgressBar1.Position := 0;
      ProgressBar1.Show;
      DrawCircles_CheckBox.Hide;
      MarkCenter_CheckBox.Hide;

      for CraterNum := 1 to Length(CraterList) do with CraterList[CraterNum-1] do
        begin
          if (CraterNum mod 1000)=0 then ProgressBar1.Position := CraterNum; // update periodically

          CurrentCrater := CraterList[CraterNum-1];

          val(NumericData,Diam,DiamErrorCode);
          if MinKm=0 then
            begin  // plot all features
              if IncludeDiscontinuedNames or (Substring(Name,1,1)<>'[') then PlotCrater;
            end
          else if MinKm=-1 then
            begin // plot flagged features
              if UserFlag<>'' then PlotCrater;
            end
          else
            begin // plot all features above threshold
              if (DiamErrorCode=0) and (Diam>=MinKm) and
                (IncludeDiscontinuedNames or (Substring(Name,1,1)<>'[')) then PlotCrater;
            end;

        end;

      ProgressBar1.Hide;
      DrawCircles_CheckBox.Show;
      MarkCenter_CheckBox.Show;
      DrawingMap_Label.Caption := '';

    end;  {DrawCraters}

begin {TTerminator_Form.Overlay_ButtonClick}
//  CalculateGeometry;  // do NOT do this -- overlay with geometry of last image drawn
//  SetLength(CraterInfo,0); // do NOT do this -- there may be previous points plotted -- duplicates won't hurt

  Screen.Cursor := crHourGlass;
  LabelDots_Button.Hide;
  DrawCraters;
  if Length(CraterInfo)>0 then LabelDots_Button.Show;
  Screen.Cursor := DefaultCursor;
end;  {TTerminator_Form.Overlay_ButtonClick}

procedure TTerminator_Form.DrawDots_ButtonClick(Sender: TObject);
var
  i, j : integer;
  BackgroundPattern : TBitMap;
  BkgRow  :  pRGBArray;
  SkyPixel, SunlightPixel, ShadowPixel : TRGBTriple;
  PointVector : TVector;
begin
  if not CalculateGeometry then Exit;

  TextureFilename := 'none (Dots Mode)';

  Screen.Cursor := crHourGlass;
  DrawingMode := DotMode;
  ShowingEarth := False;
  ClearImage;

//--- draw background pattern of light and shadow ---

  SkyPixel := ColorToRGBTriple(SkyColor);

  SunlightPixel := ColorToRGBTriple(DotModeSunlitColor);
  ShadowPixel := ColorToRGBTriple(DotModeShadowedColor);

  BackgroundPattern := TBitmap.Create;
  BackgroundPattern.PixelFormat := pf24bit;
  BackgroundPattern.Height := JimsGraph1.Height;
  BackgroundPattern.Width := JimsGraph1.Width;

  for j := 0 to (BackgroundPattern.Height - 1) do
    begin
      BkgRow := BackgroundPattern.ScanLine[j];
      for i := 0 to (BackgroundPattern.Width - 1) do  with JimsGraph1 do
        begin
           if not ConvertXYtoVector(XValue(i),YValue(j),PointVector) then
             BkgRow[i] := SkyPixel
           else if DotProduct(SubSolarVector,PointVector)>=0 then
             BkgRow[i] := SunlightPixel
           else
             BkgRow[i] := ShadowPixel;
        end;
    end;

  JimsGraph1.Canvas.Draw(0,0,BackgroundPattern);

  BackgroundPattern.Free;

//--- background pattern drawn ---

  with JimsGraph1 do with Canvas do
    begin
//--- draw limb ---
      Pen.Color := clBlack;
//      Arc(XPix(-1),YPix(+1),XPix(+1),YPix(-1),XPix(-1),YPix(+1),XPix(-1),YPix(+1));
    end;

  DrawTerminator;

  OverlayDots_ButtonClick(Sender);
  Screen.Cursor := DefaultCursor;
end;

function TTerminator_Form.ConvertXYtoVector(const XProj, YProj : extended;  Var PointVector : TVector) : Boolean;
{converts from orthographic +/-1.0 system to (X,Y,Z) in selenographic system with radius = 1}
var
  XYSqrd, ZProj, XX, YY, ZZ : extended;
begin
  XYSqrd := Sqr(XProj) + Sqr(YProj);
  if XYSqrd<1 then {point is inside circle, want to draw}
    begin
      ZProj := Sqrt(1 - XYSqrd);  // this sets length to 1

      XX := XProj*XPrime_UnitVector[x] + YProj*YPrime_UnitVector[x] + ZProj*ZPrime_UnitVector[x];
      YY := XProj*XPrime_UnitVector[y] + YProj*YPrime_UnitVector[y] + ZProj*ZPrime_UnitVector[y];
      ZZ := XProj*XPrime_UnitVector[z] + YProj*YPrime_UnitVector[z] + ZProj*ZPrime_UnitVector[z];

      AssignToVector(PointVector,XX,YY,ZZ);

      Result := True;
    end
  else
    begin
      Result := False;
    end;
end;


function TTerminator_Form.ConvertXYtoLonLat(const XProj, YProj : extended;  Var Point_Lon, Point_Lat : extended) : Boolean;
var
  Point_Vector : TVector;
begin
  if ConvertXYtoVector(XProj, YProj, Point_Vector) then
    begin
      Point_Lat := ArcSin(Point_Vector[Y]);
      Point_Lon := ArcTan2(Point_Vector[X],Point_Vector[Z]);
      Result := True;
    end
  else
    Result := False;
end;

procedure TTerminator_Form.DrawTexture_ButtonClick(Sender: TObject);
var
  TempPicture : TPicture;
  ScaledMap : TBitMap;

  MapPtr : ^TBitmap;

  i, j,                {screen coords}
  RawXPix, RawYPix,
  ErrorCode
  : Integer;

  Lat, Lon,            {selenographic latitude, longitude [radians]}
  MinLon, MaxLon, MinLat, MaxLat,  {of TextureMap}
  XPixPerRad, YPixPerRad,  {of TextureMap}
  Y, Gamma,
  TempVal
  : Extended;

  RawRow, ScaledRow  :  pRGBArray;

  SkyPixel, NoDataPixel : TRGBTriple;

begin {TTerminator_Form.DrawTexture_ButtonClick}
  if not CalculateGeometry then Exit;

  DrawingMode := TextureMode;
  ShowingEarth := False;

  Gamma := Gamma_LabeledNumericEdit.NumericEdit.ExtendedValue;
  if Gamma<>0 then
    Gamma := 1/Gamma
  else
    Gamma := 1000;

  ClearImage;

  SkyPixel := ColorToRGBTriple(SkyColor);
  NoDataPixel := ColorToRGBTriple(NoDataColor);

  if LoResUSGS_RadioButton.Checked and not LoRes_Texture_Loaded then
    begin
      OldFilename := LoResFilename;
      LoRes_TextureMap := TBitmap.Create;
//      HiRes_TextureMap.PixelFormat := pf24bit; // doesn't help

      if (not FileExists(LoResFilename)) and (MessageDlg('LTVT cannot find the low resolution USGS texture map'+CR
                        +'   Do you want help with this?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      if FileExists(LoResFilename) or PictureFileFound('USGS Low Resolution Texture File','lores.jpg',LoResFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
          TempPicture.OnProgress := ImageLoadProgress;
//          TempPicture.Bitmap.PixelFormat := pf24bit; // doesn't help
          TRY
            TRY
              TempPicture.LoadFromFile(LoResFilename);
              if LinuxCompatibilityMode then
                begin
                  LoRes_TextureMap.Width  := TempPicture.Graphic.Width;
                  LoRes_TextureMap.Height := TempPicture.Graphic.Height;
                  LoRes_TextureMap.PixelFormat := pf24bit;
                  LoRes_TextureMap.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  LoRes_TextureMap.Assign(TempPicture.Graphic);
                  LoRes_TextureMap.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                    // but it significantly slows down the loading of the image, particularly if it is already in BMP format.
                end;
              LoRes_Texture_Loaded := true;
              LoResUSGS_RadioButton.Font.Color := clBlack;
            EXCEPT
              ShowMessage('Unable to load "'+LoResFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end;

      if LoResFilename<>OldFilename then FileSettingsChanged := True;
    end;

  if HiResUSGS_RadioButton.Checked and not HiRes_Texture_Loaded then
    begin
      OldFilename := HiResFilename;
      HiRes_TextureMap := TBitmap.Create;
//      HiRes_TextureMap.PixelFormat := pf24bit; // doesn't help

      if (not FileExists(HiResFilename)) and (MessageDlg('LTVT needs to find a High Resolution USGS texture map'+CR
                        +'   Do you want help with this procedure?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      if FileExists(HiResFilename) or PictureFileFound('USGS High Resolution Texture File','hires.jpg',HiResFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
          TempPicture.OnProgress := ImageLoadProgress;
//          TempPicture.Bitmap.PixelFormat := pf24bit; // doesn't help
          TRY
            TRY
              TempPicture.LoadFromFile(HiResFilename);
              if LinuxCompatibilityMode then
                begin
// alternative way of copying to bitmap
                  HiRes_TextureMap.Width  := TempPicture.Graphic.Width;
                  HiRes_TextureMap.Height := TempPicture.Graphic.Height;
                  HiRes_TextureMap.PixelFormat := pf24bit;
                  HiRes_TextureMap.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  HiRes_TextureMap.Assign(TempPicture.Graphic);
                  HiRes_TextureMap.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                end;
              HiRes_Texture_Loaded := true;
              HiResUSGS_RadioButton.Font.Color := clBlack;
            EXCEPT
              ShowMessage('Unable to load "'+HiResFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end;

      if HiResFilename<>OldFilename then FileSettingsChanged := True;
    end;

  if Clementine_RadioButton.Checked and not Clementine_Texture_Loaded then
    begin
      OldFilename := ClementineFilename;
      Clementine_TextureMap := TBitmap.Create;
//      Clementine_TextureMap.PixelFormat := pf24bit; // doesn't help

      if (not FileExists(ClementineFilename)) and (MessageDlg('LTVT needs to find a Clementine texture map'+CR
                        +'   Do you want help with this procedure?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      if FileExists(ClementineFilename) or PictureFileFound('Clementine Texture File','hires_clem.jpg',ClementineFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
//          TempPicture.Bitmap.PixelFormat := pf24bit; // doesn't help
          TRY
            TRY
              TempPicture.LoadFromFile(ClementineFilename);
              if LinuxCompatibilityMode then
                begin
// alternative way of copying to bitmap
                  Clementine_TextureMap.Width  := TempPicture.Graphic.Width;
                  Clementine_TextureMap.Height := TempPicture.Graphic.Height;
                  Clementine_TextureMap.PixelFormat := pf24bit;
                  Clementine_TextureMap.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  Clementine_TextureMap.Assign(TempPicture.Graphic);
                  Clementine_TextureMap.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                    // but it significantly slows down the loading of the image, particularly if it is already in BMP format.
                end;
              Clementine_Texture_Loaded := true;
              Clementine_RadioButton.Font.Color := clBlack;
            EXCEPT
              ShowMessage('Unable to load "'+ClementineFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end;

      if ClementineFilename<>OldFilename then FileSettingsChanged := True;
    end;

  if UserPhoto_RadioButton.Checked and not UserPhotoLoaded then
    begin
      if FileExists(UserPhotoData.PhotoFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
          TRY
            TRY
              TempPicture.LoadFromFile(UserPhotoData.PhotoFilename);
              if LinuxCompatibilityMode then
                begin
                  UserPhoto.Width  := TempPicture.Graphic.Width;
                  UserPhoto.Height := TempPicture.Graphic.Height;
                  UserPhoto.PixelFormat := pf24bit;
                  UserPhoto.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  UserPhoto.Assign(TempPicture.Graphic);
                  UserPhoto.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                    // but it significantly slows down the loading of the image, particularly if it is already in BMP format.
                end;
              UserPhotoLoaded := True;
              UserPhoto_RadioButton.Font.Color := clBlack;
            EXCEPT
              ShowMessage('Unable to load "'+UserPhotoData.PhotoFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end
      else
        ShowMessage('Unable to find '+UserPhotoData.PhotoFilename);

    end;

  if LTO_RadioButton.Checked then
    begin
      MapPtr := @LTO_Image;
      TextureFilename := LTO_Filename;
    end
  else if Clementine_RadioButton.Checked and Clementine_Texture_Loaded then
    begin
      MapPtr := @Clementine_TextureMap;
      TextureFilename := ClementineFilename
    end
  else if HiResUSGS_RadioButton.Checked and HiRes_Texture_Loaded then
    begin
      MapPtr := @HiRes_TextureMap;
      TextureFilename := HiResFilename;
    end
  else if UserPhoto_RadioButton.Checked and UserPhotoLoaded then
    begin
      MapPtr := @UserPhoto;
      TextureFilename := UserPhotoData.PhotoFilename;
    end
  else if LoRes_Texture_Loaded then
    begin
      MapPtr := @LoRes_TextureMap;
      TextureFilename := LoResFilename;
    end
  else
    begin
      MapPtr := nil;
      TextureFilename := 'unknown';
    end;

  if MapPtr=nil then
    begin
      ShowMessage('No texture map loaded -- drawing map in Dots mode');
      DrawDots_Button.Click;
    end
  else
    begin
      if Clementine_RadioButton.Checked and not Clementine_Texture_Loaded then
        ShowMessage(Clementine_RadioButton.Caption+' not loaded -- using '+LoResUSGS_RadioButton.Caption);
      if HiResUSGS_RadioButton.Checked and not HiRes_Texture_Loaded then
        ShowMessage(HiResUSGS_RadioButton.Caption+' not loaded -- using '+LoResUSGS_RadioButton.Caption);

      DrawingMap_Label.Caption := 'Drawing texture map...';
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      ProgressBar1.Max := JimsGraph1.Height-1;
      ProgressBar1.Step := 1;
      ProgressBar1.Show;
      DrawCircles_CheckBox.Hide;
      MarkCenter_CheckBox.Hide;

// Note: Except for computing PixelsPerRadian of texture files, lon/lat limits are relevant
//  only to the Texture 3 ("Clementine") but are placed here so compiler can see they have
//  been initialized.

      Val(Tex3MinLon_DefaultText,MinLon,ErrorCode);
      Val(Tex3MaxLon_DefaultText,MaxLon,ErrorCode);
      Val(Tex3MinLat_DefaultText,MinLat,ErrorCode);
      Val(Tex3MaxLat_DefaultText,MaxLat,ErrorCode);

      if Clementine_RadioButton.Checked then
        begin
          Val(Tex3MinLonText,TempVal,ErrorCode);
          if ErrorCode=0 then
            MinLon := TempVal
          else
            ShowMessage('Unable to decode Texture 3 Minimum Longitude; substituting'+Tex3MinLon_DefaultText);

          Val(Tex3MaxLonText,TempVal,ErrorCode);
          if ErrorCode=0 then
            MaxLon := TempVal
          else
            ShowMessage('Unable to decode Texture 3 Maximum Longitude; substituting'+Tex3MaxLon_DefaultText);

          Val(Tex3MinLatText,TempVal,ErrorCode);
          if ErrorCode=0 then
            MinLat := TempVal
          else
            ShowMessage('Unable to decode Texture 3 Minimum Latitude; substituting'+Tex3MinLat_DefaultText);

          Val(Tex3MaxLatText,TempVal,ErrorCode);
          if ErrorCode=0 then
            MaxLat := TempVal
          else
            ShowMessage('Unable to decode Texture 3 Maximum Latitude; substituting'+Tex3MaxLat_DefaultText);

// Note danger of roundoff error in following, since most likely values are MinLon = -Pi and MaxLon = +Pi
          while MinLon<-180  do MinLon := MinLon + 360;
          while MinLon>180   do MinLon := MinLon - 360;
          while MaxLon<-180  do MaxLon := MaxLon + 360;
          while MaxLon>180   do MaxLon := MaxLon - 360;

          if MaxLon<MinLon then MaxLon := MaxLon + 360;

        end;

      MinLon := DegToRad(MinLon);
      MaxLon := DegToRad(MaxLon);
      MinLat := DegToRad(MinLat);
      MaxLat := DegToRad(MaxLat);

      XPixPerRad := MapPtr^.Width/(MaxLon - MinLon);
      YPixPerRad := MapPtr^.Height/(MaxLat - MinLat);

//      ShowMessage(Format('Min lon: %0.3f  Max Lon: %0.3f  ppd: %0.3f',[RadToDeg(MinLon),RadToDeg(MaxLon),XPixPerRad*DegToRad(1)]));

      ScaledMap := TBitmap.Create;
      ScaledMap.PixelFormat := pf24bit;
      ScaledMap.Height := JimsGraph1.Height;
      ScaledMap.Width := JimsGraph1.Width;

      for j := 0 to JimsGraph1.Height-1 do with JimsGraph1 do
        begin
    //      Application.ProcessMessages;
          ProgressBar1.StepIt;
          Y := YValue(j);
          ScaledRow := ScaledMap.ScanLine[j];

          for i := 0 to JimsGraph1.Width-1 do
            begin
              if ConvertXYtoLonLat(XValue(i),Y,Lon,Lat) then {point is inside circle, want to draw}
                begin
                  if UserPhoto_RadioButton.Checked then
                    begin
                      if ConvertLonLatToUserPhotoXPixYPix(Lon,Lat,MoonRadius,RawXPix,RawYPix)
                        and (RawXPix>=0) and (RawXPix<MapPtr^.Width) and (RawYPix>=0) and (RawYPix<MapPtr^.Height) then
                        begin
                          RawRow := MapPtr^.ScanLine[RawYPix];
                          ScaledRow[i] := RawRow[RawXPix];
                          GammaCorrectPixelValue(ScaledRow[i],Gamma);
                        end
                      else
                        ScaledRow[i] := NoDataPixel;
                    end
                  else if LTO_RadioButton.Checked then
                    begin
                      if ConvertLTOLonLatToXY(RadToDeg(Lon),RadToDeg(Lat),RawXPix,RawYPix) and
                       (RawXPix>=0) and (RawXPix<MapPtr^.Width) and (RawYPix>=0) and (RawYPix<MapPtr^.Height) then
                        begin
                          RawRow := MapPtr^.ScanLine[RawYPix];
                          ScaledRow[i] := RawRow[RawXPix];
                          GammaCorrectPixelValue(ScaledRow[i],Gamma);
                        end
                      else
                        ScaledRow[i] := NoDataPixel;
                    end
                  else if Clementine_RadioButton.Checked then // Texture Map 3
                    begin
                    // Note: MaxLon may exceed Pi if texture spans farside seam
                      if (Lat>=MinLat) and (Lat<=MaxLat) then
                        begin
                          RawYPix := Trunc((MaxLat - Lat)*YPixPerRad);
                          if (RawYPix>=0) and (RawYPix<MapPtr^.Height) then
                            begin
                              RawXPix := -999;  // invalid value by default
                              if (Lon>=MinLon) and (Lon<=MaxLon) then
                                RawXPix := Trunc((Lon - MinLon)*XPixPerRad)
                              else if ((Lon+TwoPi)>=MinLon) and ((Lon+TwoPi)<=MaxLon) then
                                RawXPix := Trunc((Lon + TwoPi - MinLon)*XPixPerRad);

                              if (RawXPix>=0) and (RawXPix<MapPtr^.Width) then
                                begin
                                  RawRow := MapPtr^.ScanLine[RawYPix];
                                  ScaledRow[i] := RawRow[RawXPix];
                                  GammaCorrectPixelValue(ScaledRow[i],Gamma);
                                end
                              else
                                ScaledRow[i] := NoDataPixel;;
                            end
                          else
                            ScaledRow[i] := NoDataPixel;;
                        end
                      else
                        ScaledRow[i] := NoDataPixel;;
                    end
                  else // other Texture Maps cover entire globe, so can dispense with limit checks
                    begin
                      RawXPix := Trunc((Lon - MinLon)*XPixPerRad);
                      RawYPix := Trunc((MaxLat - Lat)*YPixPerRad);

                   // wrap around if necessary
                      while RawXPix<0 do RawXPix := RawXPix + MapPtr^.Width;
                      while RawXPix>(MapPtr^.Width-1) do RawXPix := RawXPix - MapPtr^.Width;
                      while RawYPix<0 do RawYPix := RawYPix + MapPtr^.Height;
                      while RawYPix>(MapPtr^.Height-1) do RawYPix := RawYPix - MapPtr^.Height;

                      RawRow := MapPtr^.ScanLine[RawYPix];
                      ScaledRow[i] := RawRow[RawXPix];
                      GammaCorrectPixelValue(ScaledRow[i],Gamma);
                    end;
                end
              else if SkyColor<>clWhite then
                begin
                  ScaledRow[i] := SkyPixel;  // generates background of specified color outside image area
                end;
            end;

        end;

      JimsGraph1.Canvas.Draw(0,0,ScaledMap);

      ScaledMap.Free;

      DrawTerminator;
      ProgressBar1.Hide;
      DrawCircles_CheckBox.Show;
      MarkCenter_CheckBox.Show;
      DrawingMap_Label.Caption := '';
      Screen.Cursor := DefaultCursor;
    end;

end;  {TTerminator_Form.DrawTexture_ButtonClick}

function TTerminator_Form.PosNegDegrees(const Angle : extended) : extended;
{Adjusts Angle (in degrees) to range -180 .. +180}
  begin
    Result := Angle;
    while Result<-180 do Result := Result + 360;
    while Result>+180 do Result := Result - 360;
  end;

function  TTerminator_Form.CalculateSubPoints(const MJD, ObsLon, ObsLat, ObsElev : extended; var SubObsPt, SubSunPt : TPolarCoordinates) : Boolean;
var
  SavedObsLon, SavedObsLat, SavedObsElev : Extended;

  begin
    Result := False;

    if not EphemerisDataAvailable(MJD) then
      begin
        ShowMessage('Cannot estimate geometry -- ephemeris file not loaded');
        Exit;
      end;

    SavedObsLon := ObserverLongitude;
    SavedObsLat := ObserverLatitude;
    SavedObsElev := ObserverElevation;

    CurrentObserver := Special;
    ObserverLongitude := -ObsLon;
    ObserverLatitude := ObsLat;
    ObserverElevation := ObsElev;

    SubObsPt := SubEarthPointOnMoon(MJD);
    SubSunPt := SubSolarPointOnMoon(MJD);

    ObserverLongitude := SavedObsLon;
    ObserverLatitude := SavedObsLat;
    ObserverElevation := SavedObsElev;

    Result := True;  // calculation successfully completed
  end;

procedure TTerminator_Form.EstimateData_ButtonClick(Sender: TObject);
var
  UT_MJD : extended;
  SunPosition, MoonPosition : PositionResultRecord;
  SubEarthPoint : TPolarCoordinates;

begin {EstimateData_ButtonClick}
//  FocusControl(MousePosition_GroupBox); // need to remove focus or button will remain pictured in a depressed state

  Screen.Cursor := crHourGlass;

  ObserverLongitude := -ExtendedValue(ObserverLongitudeText); {Note: reversing positive West to negative West longitude}
  ObserverLatitude := ExtendedValue(ObserverLatitudeText);
  ObserverElevation := ExtendedValue(ObserverElevationText);
  ImageObsLon := -ObserverLongitude;
  ImageObsLat := ObserverLatitude;
  ImageObsElev := ObserverElevation;

  ImageDate := DateOf(Date_DateTimePicker.Date);
  ImageTime := TimeOf(Time_DateTimePicker.Time);
  ImageGeocentric := GeocentricSubEarthMode;

  UT_MJD := DateTimeToModifiedJulianDate(ImageDate + ImageTime);

  if not CalculateSubPoints(UT_MJD,ImageObsLon,ImageObsLat,ImageObsElev,SubEarthPoint,SubSolarPoint) then exit;

  CalculatePosition(UT_MJD,Moon,BlankStarDataRecord,MoonPosition);
  CalculatePosition(UT_MJD,Sun, BlankStarDataRecord,SunPosition);

//  with MoonPosition do ShowMessage(Format('MJD=%0.2f: DUT=%0.3f;  EUT=%0.3f',[UT_MJD,DUT,EUT]));

//  ShowMessage(Format('Lunar age = %0.3f days',[LunarAge(UT_MJD)]));

  if GeocentricSubEarthMode then
    begin
      EstimatedData_Label.Caption  := '          Imaginary observer is at center of Earth';
      MoonElev_Label.Caption       := '                 (geocentric computation)';
    end
  else
    begin
      EstimatedData_Label.Caption := 'For observer at '+LongitudeString(ImageObsLon,4)+' / '+LatitudeString(ImageObsLat,4);
      MoonElev_Label.Caption := Format('Moon: %0.1f deg at %0.1f az    Sun: %0.1f deg at %0.1f az',
        [MoonPosition.TopocentricAlt,MoonPosition.Azimuth,SunPosition.TopocentricAlt,SunPosition.Azimuth]);
    end;

  MoonDiameter_Label.Caption := Format('Moon''s angular diameter: %0.1f arc-seconds',[7200*RadToDeg(ArcSin(MoonRadius*OneKm/OneAU/ObserverToMoonAU))]);

  SetEstimatedGeometryLabels;

  SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[PosNegDegrees(RadToDeg(SubEarthPoint.Longitude))]);
  SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubEarthPoint.Latitude)]);

  SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[PosNegDegrees(RadToDeg(SubSolarPoint.Longitude))]);
  SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubSolarPoint.Latitude)]);

  SunRad := Rsun/(OneAU*MoonToSunAU);
//  ShowMessage(Format('Radius of Sun =%0.6f',[SunRad]));

  if ShowDetails then with PopupMemo do
    begin
      Show;
      Memo.Lines.Add('Requested date/time: '+DateToStr(ImageDate)+' at '+TimeToStr(ImageTime)+' UTC');
      Memo.Lines.Add(Format(' --> Julian date = %0.9f',[UT_MJD + MJDOffset]));
      with MoonPosition do
        begin
          Memo.Lines.Add(Format('For ephemeris lookup, add %0.3f seconds and read data in:',[EUT]));
          Memo.Lines.Add(' '+JPL_Filename);
          Memo.Lines.Add('giving following results: ');
          Memo.Lines.Add(Format('  Distance from observer to center of Moon: %0.0f m',[ObserverToMoonAU*OneAU]));
          Memo.Lines.Add(Format('  Distance from observer to center of Moon: %0.0f m',[Distance*OneAU]));
          Memo.Lines.Add(Format('  Angular diameter of Sun as seen from center of Moon: %0.6f degrees',[RadToDeg(2*SunRad)]));
        end;
      Memo.Lines.Add('');
    end;

  RefreshImage;
  Screen.Cursor := DefaultCursor;
end;  {EstimateData_ButtonClick}

function TTerminator_Form.RefreshCraterList : Boolean;
var
  CraterFile : TextFile;
  FileRecord : TSearchRec;
  CurrentCrater : TCrater;
  DataLine : String;
  LineNum, CraterCount, PrimaryCraterCount : Integer;

  function DecimalValue(StringToConvert: string): extended;
    var
      ErrorCode : integer;
    begin
      RemoveBlanks(StringToConvert);
      val(StringToConvert, Result, ErrorCode);
      if ErrorCode<>0 then
        begin
          ShowMessage('Unable to convert "'+StringToConvert
           +'" on line '+IntToStr(LineNum)+' to decimal number, error at position '+IntToStr(ErrorCode)+CR
           +'Substituting 0.00');
          Result := 0;
        end;
    end;

begin  {RefreshCraterList}
  Result := False;

  OldFilename := CraterFilename;

  if (not FileExists(OldFilename)) and (MessageDlg('LTVT is looking for the named features file'+CR
                    +'   Do you want help with this topic?',
      mtWarning,[mbYes,mbNo],0)=mrYes) then
        begin
          HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/LunarFeatureFile.htm'),HH_DISPLAY_TOPIC, 0);
        end;

  if not FileFound('Crater file',OldFilename,CraterFilename) then
    begin
//          ShowMessage('Cannot draw dots -- no feature file loaded');
      ShowMessage('Cannot draw dots -- '+CraterFilename+' not loaded');
      Exit;
    end;
  if CraterFilename<>OldFilename then FileSettingsChanged := True;

  if CraterListCurrent then
    begin
      FindFirst(CraterFilename,faAnyFile,FileRecord);
      if FileRecord.Time=LastCraterListFileRecord.Time then
        Exit
      else
        LastCraterListFileRecord := FileRecord;
    end;

  CraterListCurrent := False;
  GoToListCurrent := False;

  AssignFile(CraterFile,CraterFilename);
  Reset(CraterFile);

  if EOF(CraterFile) then
    begin
      ShowMessage('Lunar feature file ['+CraterFilename+'] is empty');
      Exit;
    end;

  Readln(CraterFile,DataLine);
  if Substring(DataLine,1,5)<>'USGS1' then
    begin
      ShowMessage('Lunar feature file ['+CraterFilename+'] is not in USGS1 format');
      Exit;
    end;

  LineNum := 1;

  Screen.Cursor := crHourGlass;
  DrawingMap_Label.Caption := 'Reading feature list...';
  Application.ProcessMessages;
  ProgressBar1.Max := 9100;  // approx. num. lines in CraterFile
  ProgressBar1.Position := 0;
  ProgressBar1.Show;
  DrawCircles_CheckBox.Hide;
  MarkCenter_CheckBox.Hide;

  SetLength(CraterList,300000); // max number to store in list
  CraterCount := 0;

  SetLength(PrimaryCraterList,10000); // max number to store in list
  PrimaryCraterCount := 0;

  while not EOF(CraterFile) do with CurrentCrater do
    begin
      Readln(CraterFile,DataLine);
      Inc(LineNum);
      if (LineNum mod 1000)=0 then ProgressBar1.Position := LineNum; // update periodically
      DataLine := Trim(DataLine);
      if (DataLine<>'') and (Substring(DataLine,1,1)<>'*') then
        begin
          UserFlag := LeadingElement(DataLine,',');
          Name := LeadingElement(DataLine,',');
//          if Name='' then ShowMessage('No name on line '+IntToStr(LineNum)); //Note: this is normal in latter part of 1994 ULCN
          LatStr := LeadingElement(DataLine,',');
          LonStr := LeadingElement(DataLine,',');
          Lat  := DegToRad(DecimalValue(LatStr));
          Lon  := DegToRad(DecimalValue(LonStr));
          NumericData := LeadingElement(DataLine,',');
          USGS_Code := LeadingElement(DataLine,',');  // read first element of remainder -- ignore possible comments at end of line
          if (USGS_Code='CN') or (USGS_Code='CN5')then
            begin
              AdditionalInfo1 := LeadingElement(DataLine,',');
              AdditionalInfo2 := LeadingElement(DataLine,',');
            end
          else
            begin
              AdditionalInfo1 := '';
              AdditionalInfo2 := '';
            end;

          if CraterCount<Length(CraterList) then
            begin
              CraterList[CraterCount] := CurrentCrater;
            end
          else
            begin
              SetLength(CraterList,Length(CraterList)+1);
              CraterList[Length(CraterList)-1] := CurrentCrater;
            end;

          Inc(CraterCount);

          if (UpperCaseString(USGS_Code)='AA') then
            begin
              if (PrimaryCraterCount<Length(PrimaryCraterList)) then
                PrimaryCraterList[PrimaryCraterCount] := CurrentCrater
              else
                begin
                  SetLength(PrimaryCraterList,Length(PrimaryCraterList)+1);
                  PrimaryCraterList[Length(PrimaryCraterList)-1] := CurrentCrater;
                end;

              Inc(PrimaryCraterCount);
            end;

        end;
    end;

  CloseFile(CraterFile);

  SetLength(CraterList,CraterCount);
  SetLength(PrimaryCraterList,PrimaryCraterCount);
  Screen.Cursor := DefaultCursor;

  ProgressBar1.Hide;
  DrawCircles_CheckBox.Show;
  MarkCenter_CheckBox.Show;
  DrawingMap_Label.Caption := '';

  CraterListCurrent := True;
  Result := True;
end;   {RefreshCraterList}

procedure TTerminator_Form.ResetZoom_ButtonClick(Sender: TObject);
begin
  ImageCenterX := 0;
  ImageCenterY := 0;
  Zoom_LabeledNumericEdit.NumericEdit.Text := '1.0';
  CraterThreshold_LabeledNumericEdit.NumericEdit.Text := '-1';
  Gamma_LabeledNumericEdit.NumericEdit.Text := '1.0';
  GridSpacing_LabeledNumericEdit.NumericEdit.Text := '0';
  RotationAngle_LabeledNumericEdit.NumericEdit.Text := '0';
  DrawCircles_CheckBox.Checked := False;
  MarkCenter_CheckBox.Checked := False;
  RefreshImage;
end;

procedure TTerminator_Form.JimsGraph1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
{Note: the X, Y returned to this routine are the positions within JimsGraph1 relative to upper left corner}
var
  ProjectedX, ProjectedY, Lon, Lat, UT_MJD,
  SunAngle, SunBearing, RefPtAngle, RefPtBearing,
  MagV2, ACosArg,
  Lon1, Lat1, Lon2, Lat2, CosTheta : extended;
  i, MinI, RSqrd, MinRsqrd : integer;
  FeatureDescription, RuklString : string;
  V1, V2, S : TVector;
  SavedGeocentricMode : Boolean;
  SunPosition, MoonPosition : PositionResultRecord;
  EarthViewerSubEarthPoint, EarthViewerSubSolarPoint : TPolarCoordinates;

  function RayHeight(const A, B :extended) : extended;
  {A = sun angle [rad] at source of light;  B = distance [rad] for source pt to target pt;
    Result = difference in elevation [m] from source pt to target pt}
    begin
      Result := 1000*MoonRadius*((Cos(A)/Cos(A-B)) - 1);
    end;

  procedure UserPhotoElevationReadout;
  {Interprets difference between reference and mouse points as an elevation difference
   for an Earth- or Satellite-based photo, as opposed to a flattened map.  The mouse must
   be pointed at the red line drawn on the mouse right-click.  The red line plots the
   possible endpoints in the original photo obtained by 3-dimensional extension from the
   starting point in the direction of the ShadowDirectionVector.  The distance from the
   reference point to the current mouse position in the original photo indicates the number
   of units of the ShadowDirectionVector that have to added to the original three dimensional
   position. The height difference is the difference in length of the vectors representing the
   start and endpoints.

   This routine assumes the following global variables were set when the red shadow line was drawn:

    RefPtVector,   // full vector at MoonRadius in Selenographic
    ShadowDirectionVector : TVector;  // unit (1 km) vector parallel or anti-parallel to solar rays, depending on mode
    RefPtUserX, RefPtUserY,   // position of start of red line in X-Y system of original photo
    ShadowDirectionUserDistance : Extended; // amount of travel in photo X-Y system for 1 unit of ShadowDirectionVector

    Note that the length of the RefPtVector is always set to MoonRadius.
}
    var
      MouseUserX, MouseUserY, MouseDistance : Extended;
    begin {UserPhotoElevationReadout}
      V1 := RefPtVector;
      S := ShadowDirectionVector;

      if not ConvertLonLatToUserPhotoXY(Lon,Lat,MoonRadius,MouseUserX, MouseUserY) then Exit;  // locate origin or current pixel in original photo

      MouseDistance := Sqrt(Sqr(MouseUserX - RefPtUserX) + Sqr(MouseUserY - RefPtUserY));

      if ShadowDirectionUserDistance<>0 then
        begin
          MultiplyVector(MouseDistance/ShadowDirectionUserDistance,S);
          VectorSum(V1,S,V2);  // move along Sun vector in three dimensions to point seen in projection at mouse point
          MagV2 := VectorMagnitude(V2);
          ShadowTipVector := V2;  // this is the opposite end from the Ref Pt -- it may be the shadow tip or the shadow-casting point

          ACosArg := DotProduct(V1,V2)/(VectorMagnitude(V1)*MagV2);
          if Abs(ACosArg)>1 then ACosArg := 1;  // avoid possible round off error

          CurrentElevationDifference_m := 1000*(MagV2 - MoonRadius);

          if MagV2<>0 then
            RefPtDistance_Label.Caption := Format('Shadow length = %0.2f deg; Height difference = %0.0f m',
              [RadToDeg(ArcCos(ACosArg)),CurrentElevationDifference_m])
          else
            RefPtDistance_Label.Caption := Format('Shadow length = %0.2f deg; Height difference = %0.0f m',
              [0,CurrentElevationDifference_m]);
        end
      else
        begin
          ShadowTipVector := RefPtVector;   //  dummy value -- three dimensional position cannot be evaluated
          RefPtDistance_Label.Caption := 'Sun direction parallel to line of sight';
        end;
    end;  {UserPhotoElevationReadout}

begin {Terminator_Form.JimsGraph1MouseMove}
  with JimsGraph1 do
    begin
      ProjectedX := XValue(X);
      ProjectedY := YValue(Y);
    end;

  CurrentMouseX := ProjectedX;
  CurrentMouseY := ProjectedY;


  if not ConvertXYtoLonLat(ProjectedX,ProjectedY,Lon,Lat) then
    begin
      MousePosition_GroupBox.Hint := 'X = horizontal, Y = vertical position on scale of -1 to +1; mouse is outside projected sphere';
      MousePosition_GroupBox.Caption := format('Mouse Position:  X = %0.4f  Y = %0.4f',[ProjectedX,ProjectedY]);
      HideMouseMoveLabels;
    end
  else
    begin
      if ShowingEarth then
        begin
          MousePosition_GroupBox.Hint := 'Box gives information related to observations of Sun and Moon from sea level at current mouse point on Earth';
          MousePosition_GroupBox.Caption := format('Mouse Position:  Longitude = %0s   Latitude = %0s',
            [LongitudeString(RadToDeg(Lon),2),LatitudeString(RadToDeg(Lat),2)]);

          MouseLonLat_Label.Hint := 'Altitude and azimuth of center of Sun as viewed from sea level at current mouse point';
          SunAngle_Label.Hint := 'Altitude and azimuth of center of Moon as viewed from sea level at current mouse point';
          RefPtDistance_Label.Hint := 'Librations in longitude and latitude and diameter of Moon as viewed from sea level at current mouse point';
          CraterName_Label.Hint := 'Angular separation of Sun and Moon and percent illumination of Moon as viewed from sea level at current mouse point';

          SavedGeocentricMode := GeocentricSubEarthMode;

          GeocentricSubEarthMode := False;

          ObserverLongitude := -RadToDeg(Lon); {Note: reversing positive West to negative West longitude}
          ObserverLatitude := RadToDeg(Lat);
          ObserverElevation := 0;

          UT_MJD := DateTimeToModifiedJulianDate(ImageDate + ImageTime);

          CalculatePosition(UT_MJD,Moon,BlankStarDataRecord,MoonPosition);
          CalculatePosition(UT_MJD,Sun, BlankStarDataRecord,SunPosition);

          MouseLonLat_Label.Caption := Format(' Sun is at :  %0.2f deg altitude and %0.2f deg azimuth',
            [SunPosition.TopocentricAlt,SunPosition.Azimuth]);
          SunAngle_Label.Caption := Format('Moon is at : %0.2f deg altitude and %0.2f deg azimuth',
            [MoonPosition.TopocentricAlt,MoonPosition.Azimuth]);

       {Note: need to correct reversal of positive West to negative West longitude}
          if not CalculateSubPoints(UT_MJD,-ObserverLongitude,ObserverLatitude,0,EarthViewerSubEarthPoint,EarthViewerSubSolarPoint) then
            CraterName_Label.Caption := ''
          else
            begin
              Lon1 := EarthViewerSubEarthPoint.Longitude;
              Lat1 := EarthViewerSubEarthPoint.Latitude;
              Lon2 := EarthViewerSubSolarPoint.Longitude;
              Lat2 := EarthViewerSubSolarPoint.Latitude;

              CosTheta := Sin(Lat1)*Sin(Lat2) + Cos(Lat1)*Cos(Lat2)*Cos(Lon2 - Lon1);

              ComputeDistanceAndBearing(MoonPosition.Azimuth*OneDegree,MoonPosition.TopocentricAlt*OneDegree,SunPosition.Azimuth*OneDegree,SunPosition.TopocentricAlt*OneDegree,SunAngle,SunBearing);

              RefPtDistance_Label.Caption := Format('Librations : %s / %s   Diam = %0.1f arc-sec'   ,
                [LongitudeString(RadToDeg(EarthViewerSubEarthPoint.Longitude),3),LatitudeString(RadToDeg(EarthViewerSubEarthPoint.Latitude),3),
                7200*RadToDeg(ArcSin(MoonRadius*OneKm/OneAU/ObserverToMoonAU))]);
              CraterName_Label.Caption := format(' Elongation = %0.2f deg;  Illumination = %0.3f%s',
                [SunAngle/OneDegree, 50*(1 + CosTheta), '%']);
            end;

          GeocentricSubEarthMode := SavedGeocentricMode;

        end
      else // showing Moon image
        begin
          MousePosition_GroupBox.Hint := 'Box gives information related to current mouse position on Moon; in top caption, "Map" is IAU format LTO zone number; "Rnn" is Rükl sheet number';
          RuklString := Rukl_String(Lon,Lat);
          if RuklString='' then
            MousePosition_GroupBox.Caption := format('Mouse Position:  X = %0.4f  Y = %0.4f  Map: %s',[ProjectedX,ProjectedY,LTO_String(Lon,Lat)])
          else
            MousePosition_GroupBox.Caption := format('Mouse Position:  X = %0.4f  Y = %0.4f  Map: %s / R%s',[ProjectedX,ProjectedY,LTO_String(Lon,Lat),RuklString]);

          MouseLonLat_Label.Hint := 'Selenographic longitude and latitude of current mouse point';
          SunAngle_Label.Hint := 'Altitude and azimuth of center of Sun as viewed from current mouse point on Moon';
          RefPtDistance_Label.Hint := 'Information related to mouse distance from current reference point';
          CraterName_Label.Hint := 'Information about dot closest to current mouse point';

          MouseLonLat_Label.Caption := format('Longitude = %0s   Latitude = %0s',
            [LongitudeString(RadToDeg(Lon),2),LatitudeString(RadToDeg(Lat),2)]);

          ComputeDistanceAndBearing(Lon,Lat,SubSolarPoint.Longitude,SubSolarPoint.Latitude,SunAngle,SunBearing);

          SunAngle := (Pi/2) - SunAngle;

          SunAngle_Label.Caption := format('Sun is at = %0.2f deg altitude and %0.2f deg azimuth',
            [SunAngle/OneDegree, SunBearing/OneDegree]);

          case RefPtReadoutMode of
            DistanceAndBearingRefPtMode :
              begin
                ComputeDistanceAndBearing(RefPtLon,RefPtLat,Lon,Lat,RefPtAngle,RefPtBearing);
                RefPtDistance_Label.Hint := 'Distance of current mouse point from reference point and azimuth CW from lunar north';
                RefPtDistance_Label.Caption := Format('From ref. pt. = %0.2f km  (%0.2f deg at %0.2f deg az)',
                  [MoonRadius*RefPtAngle,RadToDeg(RefPtAngle),RadToDeg(RefPtBearing)]);
              end;
            ShadowLengthRefPtMode :
              begin
                RefPtDistance_Label.Hint := 'Interpretation of current mouse position based on reference point at start of shadow';
                if UserPhoto_RadioButton.Checked then
                  UserPhotoElevationReadout
                else
                  begin
                    PolarToVector(Lat,Lon,MoonRadius,ShadowTipVector);
                    ComputeDistanceAndBearing(RefPtLon,RefPtLat,Lon,Lat,RefPtAngle,RefPtBearing);
                    CurrentElevationDifference_m := 1000*MoonRadius*(Cos(RefPtAngle-RefPtSunAngle)/Cos(RefPtSunAngle)-1);
                    RefPtDistance_Label.Caption := Format('Shadow length = %0.2f deg; Height difference = %0.0f m',
                      [RadToDeg(RefPtAngle),CurrentElevationDifference_m]);
                  end;
              end;
            InverseShadowLengthRefPtMode :
              begin
                RefPtDistance_Label.Hint := 'Interpretation of current mouse position based on reference point at tip of shadow';
                if UserPhoto_RadioButton.Checked then
                  UserPhotoElevationReadout
                else
                  begin
                    PolarToVector(Lat,Lon,MoonRadius,ShadowTipVector);
                    ComputeDistanceAndBearing(RefPtLon,RefPtLat,Lon,Lat,RefPtAngle,RefPtBearing);
                    CurrentElevationDifference_m := 1000*MoonRadius*(Cos(RefPtAngle-SunAngle)/Cos(SunAngle)-1);
                    RefPtDistance_Label.Caption := Format('Shadow length = %0.2f deg; Height difference = %0.0f m',
                      [RadToDeg(RefPtAngle),CurrentElevationDifference_m]);
                  end;
              end;
            RayHeightsRefPtMode :
              begin
                ComputeDistanceAndBearing(RefPtLon,RefPtLat,Lon,Lat,RefPtAngle,RefPtBearing);
                RefPtDistance_Label.Hint := 'Interpretation of current mouse position based on reference point at start of shadow';
                RefPtDistance_Label.Caption := Format('Distance = %0.2f deg; Min. ray = %0.0f m; Max. = %0.0f m',
                  [RadToDeg(RefPtAngle),RayHeight(RefPtSunAngle+SunRad,RefPtAngle),RayHeight(RefPtSunAngle-SunRad,RefPtAngle)]);
              end;
            else
              begin
                RefPtDistance_Label.Hint := '';
                RefPtDistance_Label.Caption := '';
              end;
            end;

          MinI := 0;
          MinRsqrd := MaxInt;

          for i := 0 to (Length(CraterInfo)-1) do with CraterInfo[i] do
            begin
              RSqrd := (X - Dot_X)*(X - Dot_X) + (Y - Dot_Y)*(Y - Dot_Y);
              if RSqrd<MinRsqrd then
                begin
                  MinRsqrd := RSqrd;
                  MinI := i;
                end;
            end;

      // display name iff mouse pointer is within 5 pixel radius of a dot
          if MinRsqrd<Sqr(5) then with CraterInfo[MinI].CraterData do
            begin
              if (USGS_Code='AA') or (USGS_Code='SF') then
                FeatureDescription := 'Crater:  '
              else if USGS_Code='GD' then
                FeatureDescription := 'GLR dome list:  '
              else if USGS_Code='CD' then
                FeatureDescription := 'Crater depth:  '
              else if USGS_Code='LF' then
                FeatureDescription := 'Landing site:  '
              else if (USGS_Code='CN') or (USGS_Code='CN5') then
                FeatureDescription := 'Control pt:  '
              else if USGS_Code='AT' then
                FeatureDescription := 'LIDAR elevation:  '
              else
                FeatureDescription := '';

              CraterName_Label.Caption  := FeatureDescription+LabelString(CraterInfo[MinI],True,True,True,True,True);
    {
              if (USGS_Code='CN') or (USGS_Code='CN5') then
                CraterName_Label.Caption  := Format('%s%s (%s km elev)',[FeatureDescription,Name,NumericData]) // "Diam" is actually Radial Distance
              else if USGS_Code='CD' then
                CraterName_Label.Caption  := Format('%s%s (%s km)',[FeatureDescription,Name,NumericData]) // "Diam" is actually Depth in kilometers
              else if USGS_Code='AT' then
                CraterName_Label.Caption  := Format('%s%s m (Rev. %s)',[FeatureDescription,Name,NumericData]) // "Diam" is actually Revolution Number
              else
                CraterName_Label.Caption  := Format('%s%s  (%s km)',[FeatureDescription,Name,NumericData]);
    }
            end
          else
            begin
              CraterName_Label.Hint  := '';
              CraterName_Label.Caption  := '';
            end;
        end;
    end;
end;  {Terminator_Form.JimsGraph1MouseMove}

procedure TTerminator_Form.JimsGraph1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LastMouseClickPosition.X := X;
  LastMouseClickPosition.Y := Y;
  if (Button=mbLeft) and (not ShowingEarth) then
    begin
      ImageCenterX := JimsGraph1.XValue(X);
      ImageCenterY := JimsGraph1.YValue(Y);
{change center, but do NOT alter the value on GoTo form}
//      H_Terminator_Goto_Form.CenterX_LabeledNumericEdit.NumericEdit.Text := format('%0.4f',[JimsGraph1.XValue(X)]);
//      H_Terminator_Goto_Form.CenterY_LabeledNumericEdit.NumericEdit.Text := format('%0.4f',[JimsGraph1.YValue(Y)]);
      RefreshImage;
    end;
end;

procedure TTerminator_Form.Now_ButtonClick(Sender: TObject);
var
  SystemTime: TSystemTime;  // this is supposed to be maintained in UTC
  SystemDateTime : TDateTime;
begin
//  FocusControl(MousePosition_GroupBox); // need to remove focus or button will remain pictured in a depressed state

  GetSystemTime(SystemTime);
  SystemDateTime := SystemTimeToDateTime(SystemTime);

//round to nearest whole minute
// -- convert from days to minutes, add 0.5, truncate and convert pack to days
//  SystemDateTime := OneMinute*Int(SystemDateTime*OneDay/OneMinute + 0.5)/OneDay;

  Date_DateTimePicker.Date := DateOf(SystemDateTime);
  Time_DateTimePicker.Time := TimeOf(SystemDateTime);
  EstimateData_Button.Click;
end;

procedure TTerminator_Form.Time_DateTimePickerEnter(Sender: TObject);
{Since only the HH:MM are displayed, make sure the seconds are set to zero
-- a Now_ButtonClick enters a complete TDateTime with seconds and milliseconds}
var
  CurrentSetting : TDateTime;
begin
  CurrentSetting := Time_DateTimePicker.Time;
  Time_DateTimePicker.Time := EncodeTime(HourOf(CurrentSetting),MinuteOf(CurrentSetting),0,0);
end;

procedure TTerminator_Form.ImageLoadProgress(Sender: TObject; Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean;
  const R: TRect; const Msg: String);
begin
  case Stage of
    psStarting:
      begin
        DrawingMap_Label.Caption := 'Progress reading image file...';
        ProgressBar1.Max := 100;
        ProgressBar1.Show;
        DrawCircles_CheckBox.Hide;
        MarkCenter_CheckBox.Hide;
        Application.ProcessMessages;
      end;
    psRunning:
      begin
        ProgressBar1.Position := PercentDone;
        ProgressBar1.Update;
        Application.ProcessMessages;
      end;
    psEnding:
      begin
        ProgressBar1.Hide;
        DrawCircles_CheckBox.Show;
        MarkCenter_CheckBox.Show;
        DrawingMap_Label.Caption := '';
        Application.ProcessMessages;
      end;
    end;
end;

procedure TTerminator_Form.SetManualGeometryLabels;
begin
  GeometryType_Label.Caption :=
    '---------------------------  Manually Set Geometry  ----------------------------';
  EstimatedData_Label.Hide;
  MoonElev_Label.Hide;
  MoonDiameter_Label.Hide;
  ManualMode := True;
end;

procedure TTerminator_Form.SetEstimatedGeometryLabels;
begin
  GeometryType_Label.Caption :=
    '---------------------------    Computed Geometry    ----------------------------';
  EstimatedData_Label.Show;
  MoonElev_Label.Show;
  MoonDiameter_Label.Show;
  ManualMode := False;
end;

procedure TTerminator_Form.SubObs_Lon_LabeledNumericEditNumericEditKeyPress(Sender: TObject; var Key: Char);
begin
  SetManualGeometryLabels;
end;

procedure TTerminator_Form.SubSol_Lon_LabeledNumericEditNumericEditKeyPress(Sender: TObject; var Key: Char);
begin
  SetManualGeometryLabels;
end;

procedure TTerminator_Form.SubObs_Lat_LabeledNumericEditNumericEditKeyPress(Sender: TObject; var Key: Char);
begin
  SetManualGeometryLabels;
end;

procedure TTerminator_Form.SubSol_Lat_LabeledNumericEditNumericEditKeyPress(Sender: TObject; var Key: Char);
begin
  SetManualGeometryLabels;
end;

procedure TTerminator_Form.Date_DateTimePickerChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TTerminator_Form.Time_DateTimePickerChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TTerminator_Form.ObserverLongitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TTerminator_Form.ObserverLatitude_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TTerminator_Form.ObserverElevation_LabeledNumericEditNumericEditChange(Sender: TObject);
begin
  SetManualGeometryLabels;
end;

procedure TTerminator_Form.Exit_MainMenuItemClick(Sender: TObject);
begin
  Close;
end;

procedure TTerminator_Form.About_MainMenuItemClick(Sender: TObject);
begin
  with TerminatorAbout_Form do
    begin
      Version_Label.Caption := 'Version: '+ProgramVersion;
      Copyright_Label.Caption := 'Copyright:  Jim Mosher and Henrik Bondo,  2006 - '+IntToStr(YearOf(Now));
      ShowModal;
    end;
end;

procedure TTerminator_Form.RefreshGoToList;
var
  CraterNum : Integer;
  FeatureName : String;

begin
  RefreshCraterList;
  if GoToListCurrent then Exit;

  with H_Terminator_Goto_Form do
    begin
      Screen.Cursor := crHourGlass;

      FeatureNameList.Clear;
      FeatureLatStringList.Clear;
      FeatureLonStringList.Clear;

      for CraterNum := 1 to Length(CraterList) do with CraterList[CraterNum-1] do
        begin
            begin
              if (not MinimizeGotoList_CheckBox.Checked) or (UserFlag<>'') then
                begin
                  FeatureName := Name;
                  FeatureLatStringList.Add(LatStr);  // read latitude string
                  FeatureLonStringList.Add(LonStr);  // read longitude string
                  if FeatureName='' then
                    begin
                      // in 1994 ULCN, if there is no common name, then AdditionalInfo1 contains a control point number such as P1021
                      if AdditionalInfo1<>'' then
                        FeatureName := AdditionalInfo1
                      else
                        FeatureName := 'no name available';
                    end;
                  FeatureNameList.Add(FeatureName);
                end;
            end;
        end;

      FeatureNames_ComboBox.Items.Clear;
      FeatureNames_ComboBox.Items.AddStrings(FeatureNameList);
      if LastItemSelected<FeatureNames_ComboBox.Items.Count then
        FeatureNames_ComboBox.ItemIndex := LastItemSelected
      else
        FeatureNames_ComboBox.ItemIndex := 0;
    //  ShowMessage('Restoring item '+IntToStr(LastItemSelected));


      Screen.Cursor := DefaultCursor;
      GoToListCurrent := True;

    end;
end;

procedure TTerminator_Form.GoTo_MainMenuItemClick(Sender: TObject);
var
  Rukl_Xi, Rukl_Eta, Rukl_LonDeg, Rukl_LatDeg : Extended;

  procedure ShowLunarControls(const DesiredState : Boolean);
    begin
      with H_Terminator_Goto_Form do
        begin
          RuklZone_RadioButton.Visible := DesiredState;
          GoTo_Button.Visible := DesiredState;
          AerialView_Button.Visible := DesiredState;
          LAC_Label.Visible := DesiredState;
          LTOZone_Label.Visible := DesiredState;
          RuklZone_Label.Visible := DesiredState;
          XY_Redraw_Button.Visible := DesiredState;
        end;
    end;

begin
  RefreshGoToList;
  with H_Terminator_Goto_Form do
    begin
      if ShowingEarth then
        begin
          SetToLon_LabeledNumericEdit.Hint := 'Geographic longitude in decimal degrees (E=+  W=-)';
          SetToLat_LabeledNumericEdit.Hint := 'Geographic Latitude in decimal degrees (N=+  S=-)';
          CenterX_LabeledNumericEdit.Hint := 'Enter desired horizontal screen position on scale where full Earth ranges from -1.0 (left) to +1.0 (right)';
          CenterY_LabeledNumericEdit.Hint := 'Enter desired vertical screen position on scale where full Earth ranges from +1.0 (top) to -1.0 (bottom)';
          if RuklZone_RadioButton.Checked then LonLat_RadioButton.Checked := True;
          ShowLunarControls(False);
        end
      else
        begin
          SetToLon_LabeledNumericEdit.Hint := 'Selenographic longitude in decimal degrees (E=+  W=-)';
          SetToLat_LabeledNumericEdit.Hint := 'Selenographic Latitude in decimal degrees (N=+  S=-)';
          CenterX_LabeledNumericEdit.Hint := 'Enter desired horizontal screen position on scale where full Moon ranges from -1.0 (left) to +1.0 (right)';
          CenterY_LabeledNumericEdit.Hint := 'Enter desired vertical screen position on scale where full Moon ranges from +1.0 (top) to -1.0 (bottom)';
          ShowLunarControls(True);
        end;

      ShowModal;
      if not (GoToState=Cancel) then
        begin
          if LonLat_RadioButton.Checked then
            GoToLonLat(SetToLon_LabeledNumericEdit.NumericEdit.ExtendedValue,SetToLat_LabeledNumericEdit.NumericEdit.ExtendedValue)
          else if XY_RadioButton.Checked then
            GoToXY(CenterX_LabeledNumericEdit.NumericEdit.ExtendedValue,CenterY_LabeledNumericEdit.NumericEdit.ExtendedValue)
          else //Rukl mode
            begin
              if Center_RadioButton.Checked then
                ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites.bmp'
              else
                begin
                  if NW_RadioButton.Checked then
                    ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites_NW.bmp'
                  else
                    if NE_RadioButton.Checked then
                      ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites_NE.bmp'
                  else
                    if SW_RadioButton.Checked then
                      ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites_SW.bmp'
                  else
                    if SE_RadioButton.Checked then
                      ProposedFilename := 'Rukl_'+RuklZone_LabeledNumericEdit.NumericEdit.Text+'_satellites_SE.bmp';
                end;

              GoToRuklZone_Center(Rukl_Xi, Rukl_Eta, Rukl_LonDeg, Rukl_LatDeg);
              if (Rukl_LonDeg=-999) or (Rukl_LatDeg=-999) then
                begin
                  ShowMessage('Using Xi-Eta : the requested Rukl zone does not have a well defined lunar lon-lat');
                  GoToXY(Rukl_Xi, Rukl_Eta);
                end
              else
                GoToLonLat(Rukl_LonDeg, Rukl_LatDeg);

              if AutoLabel_CheckBox.Checked then
                begin
                  DrawTexture_Button.Click; // erase reference mark at center
                  DrawRuklGrid1Click(Sender);
                  OverlayDots_Button.Click;
                  LabelDots_Button.Click;
                end;

            end;
        end;
    end;
end;

procedure TTerminator_Form.MarkXY(const X, Y : extended; const MarkColor : TColor);
var
  CraterCenterX, CraterCenterY : integer;
begin
  with JimsGraph1 do
    begin
      CraterCenterX := XPix(X);
      CraterCenterY := YPix(Y);
      if (CraterCenterX<0) or (CraterCenterX>JimsGraph1.Width) or
      (CraterCenterY<0) or (CraterCenterY>JimsGraph1.Height) then
        ShowMessage('Requested feature is not within the current viewing area')
      else
        DrawCross(CraterCenterX,CraterCenterY,DotSize+1,MarkColor);
    end;
end;

procedure TTerminator_Form.GoToXY(const X, Y : extended);
 {similar to GoToLonLat, but for xi-eta style input}
var
  DesiredLon, DesiredLat : Extended;
begin
  case H_Terminator_Goto_Form.GoToState of
    Mark : MarkXY(X,Y,ReferencePointColor);
    Center :
      begin
        ImageCenterX := X;
        ImageCenterY := Y;
        RefreshImage;
        MarkXY(X,Y,ReferencePointColor);
      end;
    AerialView :
      begin
        if not ConvertXYtoLonLat(X,Y,DesiredLon,DesiredLat) then
          begin
            ShowMessage('Unable to create aerial view: the requested X-Y position is not on the lunar disk');
            Exit;
          end
        else
          begin
            SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[PosNegDegrees(RadToDeg(DesiredLon))]);
            SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(DesiredLat)]);
            SetManualGeometryLabels;
            if not CalculateGeometry then Exit;
            ImageCenterX := 0;
            ImageCenterY := 0;
            RefreshImage;
            MarkXY(0,0,ReferencePointColor);
          end;
      end;
    end; // (case)
end;

procedure TTerminator_Form.GoToLonLat(const Long_Deg, Lat_Deg : extended);
 {attempts to set X-Y center to requested point, draw new texture map, and label point in aqua}
var
  CraterVector : TVector;
  X, Y : Extended;
  FarsideFeature : Boolean;
begin
  with H_Terminator_Goto_Form do if GoToState=AerialView then
    begin
        SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[PosNegDegrees(Long_Deg)]);
        SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[Lat_Deg]);
//      SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := SetToLon_LabeledNumericEdit.NumericEdit.Text;
//      SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := SetToLat_LabeledNumericEdit.NumericEdit.Text;
      SetManualGeometryLabels;
    end;
  if not ShowingEarth then if not CalculateGeometry then Exit;
  PolarToVector(DegToRad(Lat_Deg),DegToRad(Long_Deg),1,CraterVector);
  FarsideFeature := DotProduct(CraterVector,SubObsvrVector)<0;
  X := DotProduct(CraterVector,XPrime_UnitVector);
  Y := DotProduct(CraterVector,YPrime_UnitVector);
  if FarsideFeature then
    begin
      if ShowingEarth then
        ShowMessage('In the current viewing geometry, the requested feature is on the Earth''s farside')
      else
        ShowMessage('In the current viewing geometry, the requested feature is on the Moon''s farside');
      if H_Terminator_Goto_Form.GoToState=Mark then MarkXY(X,Y,clRed);
    end
  else
    begin {crater is on visible hemisphere, so check its projection to see if it is in viewable area}
      if not (H_Terminator_Goto_Form.GoToState=Mark) then
        begin
          ImageCenterX := X;
          ImageCenterY := Y;
          RefreshImage;
        end;
      MarkXY(X,Y,ReferencePointColor);
    end;
end;

procedure TTerminator_Form.RefreshImage;
begin
  if DrawingMode=DotMode then
    DrawDots_Button.Click
  else
    DrawTexture_Button.Click;

{Note: control does not seem to reach this point except on the very first call
  to "Refresh Image" after the program is started. Why is that???}
//   ShowMessage('Image refreshed');
end;

procedure TTerminator_Form.DrawLinesToPoleAndSun_RightClickMenuItemClick(Sender: TObject);
var
  MouseOrthoX, MouseOrthoY, MouseLat, MouseLon, PointLat, PointLon,
  PointX, PointY, PointZ, AngleStep, LineLengthSqrd : extended;
  PointVector, RotationAxis : TVector;
begin {TTerminator_Form.DrawlinestonorthandtowardsSun1Click}
  with JimsGraph1 do
    begin
      MouseOrthoX := XValue(LastMouseClickPosition.X);
      MouseOrthoY := YValue(LastMouseClickPosition.Y);

      if ConvertXYtoLonLat(MouseOrthoX,MouseOrthoY,MouseLon,MouseLat) then {mouse is pointed at a location with known longitude and latitude}
        begin
// Draw line to selenographic north by increasing latitude in small steps
          Canvas.Pen.Color := clBlue;
          MoveToDataPoint(MouseOrthoX,MouseOrthoY);
          PointLon := MouseLon;
          PointLat := MouseLat;
          AngleStep := 0.01; // radians

          LineLengthSqrd := 0;
          PointZ := 0;

          while (LineLengthSqrd<4000) and (PointZ>=0) do
            begin
              PointLat := PointLat + AngleStep;
              PolarToVector(PointLat,PointLon,1,PointVector);
              PointX := DotProduct(PointVector,XPrime_UnitVector);
              PointY := DotProduct(PointVector,YPrime_UnitVector);
              PointZ := DotProduct(PointVector,ZPrime_UnitVector); // >=0 iff point is on visible hemisphere
              if PointZ>=0 then LineToDataPoint(PointX,PointY);
              LineLengthSqrd := Sqr(XPix(PointX)-LastMouseClickPosition.X) + Sqr(YPix(PointY)-LastMouseClickPosition.Y);
            end;

// Draw line to SubSolar point by rotating PointVector CCW about (PointVector x SubSolarVector)
          Canvas.Pen.Color := clRed;
          MoveToDataPoint(MouseOrthoX,MouseOrthoY);
          PolarToVector(MouseLat,MouseLon,1,PointVector);
          CrossProduct(PointVector,SubSolarVector,RotationAxis);
          LineLengthSqrd := 0;
          PointZ := 0;

          while (LineLengthSqrd<4000) and (PointZ>=0) do
            begin
              RotateVector(PointVector,AngleStep,RotationAxis);
              PointX := DotProduct(PointVector,XPrime_UnitVector);
              PointY := DotProduct(PointVector,YPrime_UnitVector);
              PointZ := DotProduct(PointVector,ZPrime_UnitVector); // >=0 iff point is on visible hemisphere
              if PointZ>=0 then LineToDataPoint(PointX,PointY);
              LineLengthSqrd := Sqr(XPix(PointX)-LastMouseClickPosition.X) + Sqr(YPix(PointY)-LastMouseClickPosition.Y);
            end;

          PlotDataPoint(MouseOrthoX,MouseOrthoY,3,clGreen,clGreen);
        end;

    end;
end;  {TTerminator_Form.DrawlinestonorthandtowardsSun1Click}

procedure TTerminator_Form.IdentifyNearestFeature_RightClickMenuItemClick(Sender: TObject);
var
  ParentName : string;
  CraterX, CraterY, LastMouseX, LastMouseY, RSqrd, MinRsqrd, ClosestCraterX, ClosestCraterY,
  Diam : extended;
  ClosestCrater, CurrentCrater : TCrater;
  CraterVector : TVector;
  CraterNum, CraterIndex, DiamErrorCode : integer;
  DotRadius, DotRadiusSqrd, XOffset, YOffset  : integer;
  CraterColor : TColor;

begin {TTerminator_Form.IdentifyNearestFeature_RightClickMenuItemClick}
  ClosestCraterX := 0;  // compiler is complaining these may not be initialized
  ClosestCraterY := 0;

  LastMouseX := JimsGraph1.XValue(LastMouseClickPosition.X);
  LastMouseY := JimsGraph1.YValue(LastMouseClickPosition.Y);

  RefreshCraterList;
  MinRsqrd := MaxExtended;

  for CraterNum := 1 to Length(CraterList) do with CraterList[CraterNum-1] do
    begin
          if IncludeDiscontinuedNames or (Substring(Name,1,1)<>'[') then
          begin
            PolarToVector(Lat,Lon,1,CraterVector);
            if DotProduct(CraterVector,SubObsvrVector)>=0 then with JimsGraph1 do
              begin {crater is on visible hemisphere, so check its projection to see if it is in viewable area}
                CraterX := DotProduct(CraterVector,XPrime_UnitVector);
                CraterY := DotProduct(CraterVector,YPrime_UnitVector);
                RSqrd := Sqr(CraterX - LastMouseX) + Sqr(CraterY - LastMouseY);
                if RSqrd<MinRsqrd then
                  begin
                    ClosestCrater := CraterList[CraterNum-1];
                    ClosestCraterX := CraterX;
                    ClosestCraterY := CraterY;
                    MinRsqrd := RSqrd;
                  end;
              end;
          end;
    end;

  with JimsGraph1 do
    begin
      if DotSize>=0 then
        begin
          DotRadius := Round(DotSize/2.0 + 0.5);
          DotRadiusSqrd := Round(Sqr(DotSize/2.0));
          for XOffset := -DotRadius to DotRadius do
            for YOffset := -DotRadius to DotRadius do
              if (Sqr(XOffset)+Sqr(YOffset))<=DotRadiusSqrd then
                Canvas.Pixels[XPix(ClosestCraterX)+XOffset, YPix(ClosestCraterY)+YOffset] := ReferencePointColor;
        end;

      val(ClosestCrater.NumericData,Diam,DiamErrorCode);

//      ShowMessage(Format('Diam = %0.3f',[Diam]));
      if DrawCircles_CheckBox.Checked and (DiamErrorCode=0) and (Diam>0) and (Diam<(MoonRadius*PiByTwo)) then
        DrawCircle(RadToDeg(ClosestCrater.Lon),RadToDeg(ClosestCrater.Lat),
          RadToDeg(Diam/MoonRadius/2),CraterCircleColor);
    end;

  if IdentifySatellites then
    begin
      ParentName := UpperCaseParentName(ClosestCrater.Name,ClosestCrater.USGS_Code);
//      ShowMessage('Seeking satellites of '+ParentName);
    end
  else
    ShowMessage(ClosestCrater.Name+' has been plotted');

  if not PositionInCraterInfo(JimsGraph1.XPix(ClosestCraterX), JimsGraph1.YPix(ClosestCraterY)) then
    begin
      CraterIndex := Length(CraterInfo);
      SetLength(CraterInfo,CraterIndex+1);
      CraterInfo[CraterIndex].CraterData := ClosestCrater;
      CraterInfo[CraterIndex].Dot_X := JimsGraph1.XPix(ClosestCraterX);
      CraterInfo[CraterIndex].Dot_Y := JimsGraph1.YPix(ClosestCraterY);
    end;

  if IdentifySatellites then
    begin
      for CraterNum := 1 to Length(CraterList) do with CraterList[CraterNum-1] do
        begin
              if IncludeDiscontinuedNames or (Substring(Name,1,1)<>'[') then
              begin
                if UpperCaseParentName(Name,USGS_Code)=ParentName then
                  begin
                    PolarToVector(Lat,Lon,1,CraterVector);
                    if DotProduct(CraterVector,SubObsvrVector)>=0 then with JimsGraph1 do
                      begin {crater is on visible hemisphere, so check its projection to see if it is in viewable area}
                        CraterX := DotProduct(CraterVector,XPrime_UnitVector);
                        CraterY := DotProduct(CraterVector,YPrime_UnitVector);

                        with JimsGraph1 do
                          begin
                            val(NumericData,Diam,DiamErrorCode);

                            if (USGS_Code='AA') or (USGS_Code='SF') or (USGS_Code='CN')
                             or (USGS_Code='CN5') or (USGS_Code='GD') or (USGS_Code='CD') then
                              begin
                                if DiamErrorCode=0 then
                                  begin
                                    if Diam>=LargeCraterDiam then
                                      CraterColor := LargeCraterColor
                                    else if Diam>=MediumCraterDiam then
                                      CraterColor := MediumCraterColor
                                    else
                                      CraterColor := SmallCraterColor;
                                  end
                                else // unable to decode diameter
                                  CraterColor := NonCraterColor;
                              end
                            else
                              CraterColor := NonCraterColor;

                            if DotSize>=0 then
                              begin
                                DotRadius := Round(DotSize/2.0 + 0.5);
                                DotRadiusSqrd := Round(Sqr(DotSize/2.0));
                                for XOffset := -DotRadius to DotRadius do
                                  for YOffset := -DotRadius to DotRadius do
                                    if (Sqr(XOffset)+Sqr(YOffset))<=DotRadiusSqrd then
                                      Canvas.Pixels[XPix(CraterX)+XOffset, YPix(CraterY)+YOffset] := CraterColor;
                              end;

                            if DrawCircles_CheckBox.Checked and (DiamErrorCode=0) and (Diam>0) and (Diam<(MoonRadius*PiByTwo)) then
                              DrawCircle(RadToDeg(Lon),RadToDeg(Lat),
                                RadToDeg(Diam/MoonRadius/2),CraterCircleColor);
                          end;

                        if not PositionInCraterInfo(JimsGraph1.XPix(CraterX), JimsGraph1.YPix(CraterY)) then
                          begin
                            CurrentCrater := CraterList[CraterNum-1];
                            CraterIndex := Length(CraterInfo);
                            SetLength(CraterInfo,CraterIndex+1);
                            CraterInfo[CraterIndex].CraterData := CurrentCrater;
                            CraterInfo[CraterIndex].Dot_X := JimsGraph1.XPix(CraterX);
                            CraterInfo[CraterIndex].Dot_Y := JimsGraph1.YPix(CraterY);
                          end;
                      end;
                  end;
              end;
        end;
    end;

  if Length(CraterInfo)>0 then LabelDots_Button.Show;

end;  {TTerminator_Form.IdentifyNearestFeature_RightClickMenuItemClick}

procedure TTerminator_Form.LabelFeatureAndSatellites_RightClickMenuItemClick(Sender: TObject);
begin
  IdentifySatellites := True;
  IdentifyNearestFeature_RightClickMenuItemClick(Sender);
  LabelDots_Button.Click;
  IdentifySatellites := False;
end;

procedure TTerminator_Form.HideMouseMoveLabels;
begin
  MouseLonLat_Label.Caption := '';
  SunAngle_Label.Caption := '';
  CraterName_Label.Caption := '';
  RefPtDistance_Label.Caption := '';
end;

procedure TTerminator_Form.SetRefPt_RightClickMenuItemClick(Sender: TObject);
var
  UserPhotoSubSolarLon, UserPhotoSubSolarLat,
  SubSolarErrorDistance, SubSolarErrorBearing : Extended;

  procedure DrawLineInShadowDirection;
  var
    MouseLat, MouseLon,
    PixelsPerXY_unit,
    PointX, PointY, PointZ, AngleStep, LineLengthSqrd,
    NewUserX, NewUserY,
    NewLon, NewLat,
    StepMag : Extended;
    PointVector, RotationAxis, StepVector, NewVector : TVector;
    NewPosition : TPolarCoordinates;
    MaxPixelLengthSqrd, StepNum, MaxSteps : Integer;
  begin
    with JimsGraph1 do
      begin
        if ConvertXYtoLonLat(RefX,RefY,MouseLon,MouseLat) then {mouse is pointed at a location with known longitude and latitude}
          begin
  // Draw line away SubSolar point by rotating PointVector CW about (PointVector x SubSolarVector)
            Canvas.Pen.Color := clRed;
            MoveToDataPoint(RefX,RefY);

            if ShadowLineLength_pixels<=0 then
              MaxPixelLengthSqrd := 0
            else
              MaxPixelLengthSqrd := Sqr(ShadowLineLength_pixels);

            MaxSteps := 2*ShadowLineLength_pixels;  // set limit on loops if drawing is not accomplished in expected number of 1 pixel steps

            if UserPhoto_RadioButton.Checked then
              begin
{The following global variables need to be set when drawing the shadow line on a user-calibrated photo.
 They are used to generate the readout in the MouseMove routine.
    RefPtVector,   // full vector at MoonRadius in Selenographic
    ShadowDirectionVector : TVector;  // unit (1 km) vector parallel or anti-parallel to solar rays, depending on mode
    RefPtUserX, RefPtUserY,   // position of start of red line in X-Y system of original photo
    ShadowDirectionUserDistance : Extended; // amount of travel in photo X-Y system for 1 unit of ShadowDirectionVector
}
                PixelsPerXY_unit := Abs(JimsGraph1.Width/(XValue(JimsGraph1.Width) - XValue(0)));   // Abs() necessary because denominator <0 if image inverted left-right

                PolarToVector(MouseLat,MouseLon,MoonRadius,PointVector);  // starting point in selenographic system, corresponding to RefX, RefY
                RefPtVector := PointVector;

                ConvertLonLatToUserPhotoXY(MouseLon,MouseLat,MoonRadius,RefPtUserX, RefPtUserY); // starting point in photo

//                ShowMessage('Start vector = '+VectorString(PointVector,3));

                StepVector := SubSolarVector;  // unit vector corresponds to 1 km step in direction *opposite* to solar rays
                if RefPtReadoutMode<>InverseShadowLengthRefPtMode then MultiplyVector(-1,StepVector); // in same direction as solar rays
                ShadowDirectionVector := StepVector;

                VectorSum(PointVector,StepVector,NewVector);  // end point in selenographic system
//                ShowMessage('End vector = '+VectorString(NewVector,3));

                ShadowDirectionUserDistance := 0;   // default value if following fails
                NewPosition := VectorToPolar(NewVector); // determine selenographic lon/lat
                with NewPosition do
                  if not ConvertLonLatToUserPhotoXY(Longitude,Latitude,Radius,NewUserX,NewUserY) then  // end point in photo
                    begin
                      ShowMessage('Can''t draw line: Sun direction is parallel to line of sight');
                      Exit;
                    end;

                ShadowDirectionUserDistance := Sqrt(Sqr(NewUserX - RefPtUserX) + Sqr(NewUserY - RefPtUserY));

                ConvertUserPhotoXYtoLonLat(NewUserX,NewUserY,MoonRadius,NewLon,NewLat); // where endpoint is plotted on idealized Moon

{
                ShowMessage(Format(
                  'NewPos Lon/Lat = %0.3f,%0.3f; User X/Y = %0.3f,%0.3f; End Lon/Lat = %0.3f,%0.3f',
                  [RadToDeg(NewPosition.Longitude),RadToDeg(NewPosition.Latitude),NewUserX,NewUserY,
                   RadToDeg(NewLon),RadToDeg(NewLat)]));
}

                PolarToVector(NewLat,NewLon,1,NewVector);  // endpoint as plotted in idealized system
                PointX := DotProduct(NewVector,XPrime_UnitVector);
                PointY := DotProduct(NewVector,YPrime_UnitVector);

                StepMag := Sqrt(Sqr(PointX - RefX) + Sqr(PointY - RefY)); // magnitude in JimsGraph1 XY units

                if StepMag>0 then
                  begin
                    StepMag := 1/(StepMag*PixelsPerXY_unit);  // scale to 1 pixel
                    MultiplyVector(StepMag,StepVector);

                    LineLengthSqrd := 0;
                    PointZ := 0; // need to set for later conditional test
                    StepNum := 0;

                    while (LineLengthSqrd<MaxPixelLengthSqrd) and (PointZ>=0) and (StepNum<MaxSteps) do
                      begin
                        VectorSum(PointVector,StepVector,PointVector);  // current end point in full selenographic system (including radius)
                        NewPosition := VectorToPolar(PointVector); // determine selenographic lon/lat
                        with NewPosition do
                          if not ConvertLonLatToUserPhotoXY(Longitude,Latitude,Radius,NewUserX,NewUserY) then  // end point in photo
                            begin
//                              ShowMessage('Can''t draw line: unable to trace sunlight direction');  // conversion fails when off disk?
                              Exit;
                            end;

                        if not ConvertUserPhotoXYtoLonLat(NewUserX,NewUserY,MoonRadius,NewLon,NewLat) then Exit; // where endpoint is plotted on idealized Moon

                        PolarToVector(NewLat,NewLon,1,NewVector);  // point as plotted in idealized system
                        PointX := DotProduct(NewVector,XPrime_UnitVector);
                        PointY := DotProduct(NewVector,YPrime_UnitVector);
                        PointZ := DotProduct(NewVector,ZPrime_UnitVector); // >=0 iff point is on visible hemisphere

                        if PointZ>=0 then
                          begin
                            LineToDataPoint(PointX,PointY);
                            LineLengthSqrd := Sqr(XPix(PointX)-LastMouseClickPosition.X) + Sqr(YPix(PointY)-LastMouseClickPosition.Y);
                          end;

                        Inc(StepNum);
                      end;
                  end
                else
                  begin
                    ShowMessage('Can''t draw line: Sun direction is parallel to line of sight');
                    Exit;
                  end;
              end
            else // LTVT image is a flattened map, draw great circle towards (or away from) sub-solar point
              begin
                PolarToVector(MouseLat,MouseLon,MoonRadius,RefPtVector);
                PointVector := RefPtVector;
                NormalizeVector(PointVector);
                CrossProduct(PointVector,SubSolarVector,RotationAxis);
                if RefPtReadoutMode=InverseShadowLengthRefPtMode then
                  AngleStep := +0.01 // radians
                else
                  AngleStep := -0.01; // radians

                LineLengthSqrd := 0;
                PointZ := 0; // need to set for later conditional test

                while (LineLengthSqrd<MaxPixelLengthSqrd) and (PointZ>=0) do
                  begin
                    RotateVector(PointVector,AngleStep,RotationAxis);
                    PointX := DotProduct(PointVector,XPrime_UnitVector);
                    PointY := DotProduct(PointVector,YPrime_UnitVector);
                    PointZ := DotProduct(PointVector,ZPrime_UnitVector); // >=0 iff point is on visible hemisphere
                    if PointZ>=0 then LineToDataPoint(PointX,PointY);
                    LineLengthSqrd := Sqr(XPix(PointX)-LastMouseClickPosition.X) + Sqr(YPix(PointY)-LastMouseClickPosition.Y);
                  end;
              end;

            PlotDataPoint(RefX,RefY,3,clGreen,clGreen);
          end;

      end;
  end;

begin  {TTerminator_Form.SetRefPt_RightClickMenuItemClick}
  case RefPtReadoutMode of
  ShadowLengthRefPtMode, InverseShadowLengthRefPtMode, RayHeightsRefPtMode :
    begin
      if UserPhoto_RadioButton.Checked then
        begin
          UserPhotoSubSolarLon := DegToRad(ExtendedValue(UserPhotoData.SubSolLon));
          UserPhotoSubSolarLat := DegToRad(ExtendedValue(UserPhotoData.SubSolLat));
          ComputeDistanceAndBearing(SubSolarPoint.Longitude, SubSolarPoint.Latitude,
            UserPhotoSubSolarLon, UserPhotoSubSolarLat, SubSolarErrorDistance, SubSolarErrorBearing);
          if SubSolarErrorDistance>DegToRad(0.01) then
            case MessageDlg('Shadow measurements require an accurate SubSolar Point--'+CR+
                '    redraw with value in photo data?',mtConfirmation,[mbYes, mbNo, mbCancel],0) of
               mrYes :
                 begin
                   SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
                   SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
                   DrawTexture_Button.Click;
                 end;
               mrCancel : Exit;
               end;
        end;
    end;
  end;

  with JimsGraph1 do
    begin
      RefX := XValue(LastMouseClickPosition.X);
      RefY := YValue(LastMouseClickPosition.Y);
      if not ConvertXYtoLonLat(RefX,RefY,RefPtLon,RefPtLat) then
        begin
          ShowMessage('The mouse click is not on the visible lunar disk!');
          Exit;
        end;
      DrawCross(LastMouseClickPosition.X,LastMouseClickPosition.Y,DotSize+1,ReferencePointColor);
//      PlotDataPoint(RefX,RefY,3,clLime,clLime);
    end;

  ComputeDistanceAndBearing(RefPtLon,RefPtLat,SubSolarPoint.Longitude,SubSolarPoint.Latitude,RefPtSunAngle,RefPtSunBearing);
  RefPtSunAngle := Pi/2 - RefPtSunAngle;

  case RefPtReadoutMode of
    ShadowLengthRefPtMode, InverseShadowLengthRefPtMode, RayHeightsRefPtMode :
      DrawLineInShadowDirection
    else
      RefPtReadoutMode := DistanceAndBearingRefPtMode;
    end;

end;   {TTerminator_Form.SetRefPt_RightClickMenuItemClick}

procedure TTerminator_Form.NearestDotToReferencePoint_RightClickMenuItemClick(Sender: TObject);
var
  ClosestDot : Integer;
  CraterVector : TVector;
begin
  if FindClosestDot(ClosestDot) then with CraterInfo[ClosestDot].CraterData do
    begin
      RefPtLon := Lon;
      RefPtLat := Lat;
      PolarToVector(RefPtLat,RefPtLon,1,CraterVector);
      RefX := DotProduct(CraterVector,XPrime_UnitVector);
      RefY := DotProduct(CraterVector,YPrime_UnitVector);
      ComputeDistanceAndBearing(RefPtLon,RefPtLat,SubSolarPoint.Longitude,SubSolarPoint.Latitude,RefPtSunAngle,RefPtSunBearing);
      RefPtSunAngle := Pi/2 - RefPtSunAngle;

      MarkXY(RefX,RefY,ReferencePointColor);
    end
  else
    ShowMessage('Unable to find a dot');
end;

procedure TTerminator_Form.Recordshadowmeasurement_RightClickMenuItemClick(Sender: TObject);
var
  PlotVector : TVector;
  AngleFromCenter, PlotX, PlotY : Extended;
  PlotXPix, PlotYPix : Integer;
  ShadowFile : TextFile;
  ShadowStart, ShadowEnd : TPolarCoordinates;
begin
// put mark at shadow measurement point
  MarkXY(CurrentMouseX,CurrentMouseY,ReferencePointColor);

// also mark projection of measurement point onto constant radius sphere
  PlotVector := ShadowTipVector;
  if VectorModSqr(PlotVector)>0 then NormalizeVector(PlotVector);

  if SnapShadowPointsToPlanView and UserPhoto_RadioButton.Checked then with JimsGraph1 do
    begin
      PlotX := DotProduct(PlotVector,XPrime_UnitVector);
      PlotY := DotProduct(PlotVector,YPrime_UnitVector);
      MarkXY(PlotX,PlotY,ReferencePointColor);

      PlotXPix := XPix(PlotX);
      PlotYPix := YPix(PlotY);
    end
  else
    begin
      PlotXPix := LastMouseClickPosition.X;
      PlotYPix := LastMouseClickPosition.Y;
    end;

  with JimsGraph1 do with Canvas do
    begin
      TextOut(PlotXPix+Corrected_LabelXPix_Offset,
        PlotYPix-Corrected_LabelYPix_Offset,Format('%0.0f m',[CurrentElevationDifference_m]));
    end;

  if FileExists(ShadowProfileFilename) and (VectorMagnitude(ShadowProfileCenterVector)>0) then
    begin
      ShadowStart := VectorToPolar(RefPtVector);
      ShadowEnd   := VectorToPolar(ShadowTipVector);
      AngleFromCenter := ArcCos(DotProduct(PlotVector,ShadowProfileCenterVector));
      AssignFile(ShadowFile, ShadowProfileFilename);
      Append(ShadowFile);
      Writeln(ShadowFile,Format('%0.3f, %0.3f, %0.3f, %0.3f, %0.3f, %0.3f, %s',
        [AngleFromCenter*MoonRadius,      CurrentElevationDifference_m/1000,
         ShadowStart.Longitude/OneDegree, ShadowStart.Latitude/OneDegree,
         ShadowEnd.Longitude/OneDegree,   ShadowEnd.Latitude/OneDegree,
         ExtractFileName(TextureFilename)]));
      CloseFile(ShadowFile);
    end;

end;

function TTerminator_Form.BooleanToYesNo(const BooleanState: boolean): string;
  begin
    if BooleanState then
      Result := 'yes'
    else
      Result := 'no';
  end;

procedure TTerminator_Form.SaveImage_MainMenuItemClick(Sender: TObject);
begin  {TTerminator_Form.SaveImage_MainMenuItemClick}
  SaveImage_Button.Click;
end;   {TTerminator_Form.SaveImage_MainMenuItemClick}

procedure TTerminator_Form.SaveImage_ButtonClick(Sender: TObject);
var
  JPEG_Image : TJPEGImage;
  LabeledImage : TBitMap;
  ImageStartRow, TextStartRow : integer;
  CenterLon,CenterLat : Extended;
  DateTimeString, OutString, DesiredExtension : string;
//  Answer : Word;
begin
  SavePictureDialog1.FileName := ProposedFilename;

  if SavePictureDialog1.Execute then
    begin
      LabeledImage := TBitmap.Create;
      if AnnotateSavedImages then
        begin
          if ImageManual and not(ShowingEarth or (OrientationMode=Equatorial) or (OrientationMode=AltAz)) then
            ImageStartRow := 45
          else
            ImageStartRow := 60;
          LabeledImage.Height := JimsGraph1.Height + ImageStartRow;
          LabeledImage.Width := JimsGraph1.Width;
          with LabeledImage.Canvas do
            begin
              Draw(0,30,JimsGraph1.Picture.Graphic);
    //          ShowMessage('The text height is '+IntToStr(Font.Height));
              Font.Color := SavedImageUpperLabelsColor;
              if ShowingEarth then
                begin
                      TextOut(0,1,Format(' LTVT Image: Sub-solar Pt = %s/%s  Center = Sub-Lunar Pt = %s/%s  Zoom = %0.3f',
                        [LongitudeString(RadToDeg(ImageSubSolLon),3), LatitudeString(RadToDeg(ImageSubSolLat),3),
                         LongitudeString(RadToDeg(ImageSubObsLon),3), LatitudeString(RadToDeg(ImageSubObsLat),3),
                         1.0]));
                  OutString := 'Vertical axis : central meridian';
                end
              else
                begin
                  if not ConvertXYtoLonLat(ImageCenterX,ImageCenterY,CenterLon,CenterLat) then
                    TextOut(0,1,Format(' LTVT Image: Sub-solar Pt = %s/%s  Sub-Earth Pt = %s/%s  XY-Center = (%0.4f,%0.4f)  Zoom = %0.3f',
                      [LongitudeString(RadToDeg(ImageSubSolLon),3), LatitudeString(RadToDeg(ImageSubSolLat),3),
                       LongitudeString(RadToDeg(ImageSubObsLon),3), LatitudeString(RadToDeg(ImageSubObsLat),3),
                       ImageCenterX, ImageCenterY, ImageZoom]))
                  else
                    begin
                      TextOut(0,1,Format(' LTVT Image: Sub-solar Pt = %s/%s  Sub-Earth Pt = %s/%s  Center = %s/%s  Zoom = %0.3f',
                        [LongitudeString(RadToDeg(ImageSubSolLon),3), LatitudeString(RadToDeg(ImageSubSolLat),3),
                         LongitudeString(RadToDeg(ImageSubObsLon),3), LatitudeString(RadToDeg(ImageSubObsLat),3),
                         LongitudeString(RadToDeg(CenterLon),3), LatitudeString(RadToDeg(CenterLat),3), ImageZoom]));
                    end;

                  OutString := 'Vertical axis : ';
                  case OrientationMode of
                    Cartographic :
                      OutString := OutString + 'central meridian';
                    LineOfCusps :
                      OutString := OutString + 'line of cusps   ';
                    Equatorial :
                      OutString := OutString + 'celestial north ';
                    AltAz :
                      OutString := OutString + 'local zenith    ';
                    else
                      OutString := OutString + 'unknown         ';
                    end; {case}


                  if InvertLR and InvertUD then
                    OutString := OutString + '    Inverted left-right and up-down'
                  else if InvertLR then
                    OutString := OutString + '    Inverted left-right'
                  else if InvertUD then
                    OutString := OutString + '    Inverted up-down';

                  if ManualRotationDegrees<>0 then
                    OutString := OutString + Format('    Additional CW rotation: %0.3f deg',[ManualRotationDegrees]);
                end;

                TextOut(0,16,OutString);

                Font.Color := SavedImageLowerLabelsColor;

                if ImageManual and not(ShowingEarth or (OrientationMode=Equatorial) or (OrientationMode=AltAz)) then
                  begin
                    TextStartRow := LabeledImage.Height - 15;
                    TextOut(0,TextStartRow,'Texture file: '+ExtractFileName(TextureFilename));
                  end
                else
                  begin
                    TextStartRow := LabeledImage.Height - 30;
                    TextOut(0,TextStartRow,'Texture file: '+ExtractFileName(TextureFilename));
                    DateTimeString := DateToStr(ImageDate)+' at  '+TimeToStr(ImageTime)+' UT';
                    TextStartRow := LabeledImage.Height - 15;
                    if ShowingEarth then
                      TextOut(0,TextStartRow,Format('Earth viewed from center of Moon on %s',[DateTimeString]))
                    else
                      begin
                        if ImageGeocentric then
                          TextOut(0,TextStartRow,'Geocentric computation for: '+DateTimeString)
                        else
                          begin
                            if ImageManual then
                              begin
                                if OrientationMode=Equatorial then
                                  TextOut(0,TextStartRow,Format('Celestial north polar direction for %s',[DateTimeString]))
                                else
                                  TextOut(0,TextStartRow,Format('Zenith direction for an observer on Earth at %s/%s and %0.0f m elev on %s',
                                    [LongitudeString(ImageObsLon,3),LatitudeString(ImageObsLat,3),ImageObsElev,DateTimeString]));
                              end
                            else
                              TextOut(0,TextStartRow,Format('This view is predicted for an observer on Earth at %s/%s and %0.0f m elev on ',
                                [LongitudeString(ImageObsLon,3),LatitudeString(ImageObsLat,3),ImageObsElev])+DateTimeString);
                          end;
                      end;
                  end;
                end;
              end
            else  // no labels
              begin
                LabeledImage.Height := JimsGraph1.Height;
                LabeledImage.Width := JimsGraph1.Width;
                LabeledImage.Canvas.Draw(0,0,JimsGraph1.Picture.Graphic);
              end;

        DesiredExtension := UpperCase(ExtractFileExt(SavePictureDialog1.FileName));

        if (DesiredExtension='.JPG') or (DesiredExtension='.JPEG') then
          begin
            JPEG_Image := TJPEGImage.Create;
            try
    {          JPEG_Image.PixelFormat := jf24Bit; }    {this is supposed to be true by default}
    {          JPEG_Image.Performance := jpBestQuality; } {this is supposed to apply only to playback}
    {          JPEG_Image.ProgressiveEncoding := False; } {makes no difference}
              JPEG_Image.CompressionQuality := 90;  {highest possible is 100;  90 makes files half the size but indistinguishable}
              JPEG_Image.Assign(LabeledImage);
              JPEG_Image.SaveToFile(SavePictureDialog1.FileName);
            finally
              JPEG_Image.Free;
            end;
          end
        else {.bmp}
          begin
            SavePictureDialog1.FileName := ChangeFileExt(SavePictureDialog1.FileName,'.bmp');
            LabeledImage.SaveToFile(SavePictureDialog1.FileName);
          end;
        LabeledImage.Free;
    end;

end;

procedure TTerminator_Form.FindAndLoadJPL_File(const TrialFilename : string);
{attempts to find JPL file -- suggests help file if there is a problem}
  const
    LastDirectory : string = '';
  var
    JPL_OpenDialog : TOpenDialog;
    CorrectFilename, ExpectedFilename, ExpectedPath, ExpectedExtension : string;
  begin
    CorrectFilename := TrialFilename;
//    ShowMessage('Looking for "'+TrialFilename+'"');

    if FileExists(CorrectFilename) then
      begin {check if requested file exists}
        LoadJPL_File(CorrectFilename);
        Exit;
      end;

    ExpectedFilename := ExtractFileName(TrialFilename);
    ExpectedPath := ExtractFilePath(TrialFilename);
    if ExpectedPath='' then ExpectedPath := '.\';

    CorrectFilename := ExpectedPath+ExpectedFilename;

    if FileExists(CorrectFilename) then
      begin {check if requested file exists in current directory}
        LoadJPL_File(CorrectFilename);
//        ShowMessage(CorrectFilename+' found in current directory');
        Exit;
      end;

    if LastDirectory<>'' then
      begin
        CorrectFilename := LastDirectory+ExpectedFilename;

        if FileExists(CorrectFilename) then
          begin {check if requested file exists in directory from which last file was loaded}
            LoadJPL_File(CorrectFilename);
//            ShowMessage(ExpectedFilename+' found in last directory');
            Exit;
          end;

       end;

    if MessageDlg('You need to locate a JPL ephemeris file before LTVT can compute the geometry'+CR
                    +'   Do you want help with this procedure?',
      mtWarning,[mbYes,mbNo],0)=mrYes then
        begin
          HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/EphemerisFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
        end;

    OldFilename := JPL_FilePath;
    JPL_OpenDialog := TOpenDialog.Create(nil);
    try
      with JPL_OpenDialog do
        begin
          SetSubComponent(True);
          Title := 'JPL ephemeris file needed: '+ExpectedFilename;
          FileName := ExpectedFilename;
          InitialDir := ExpectedPath;
          ExpectedExtension := ExtractFileExt(TrialFilename);
          Filter := '*'+ExpectedExtension+'|*'+ExpectedExtension+'|All Files|*.*';
          Options := Options + [ofNoChangeDir];
          if Execute and FileExists(FileName) then
            begin
              CorrectFilename := FileName;
              LastDirectory := ExtractFilePath(Filename);
              LoadJPL_File(CorrectFilename);
              JPL_Filename := ExtractFileName(Filename);
              JPL_FilePath := ExtractFilePath(Filename);
            end
          else
            begin
              CorrectFilename := TrialFilename;
              ShowMessage('Unable to find JPL ephemeris file: "'+ExpectedFilename+'"');
            end;
        end;
    finally
      JPL_OpenDialog.Free;
    end;

//    ShowMessage(JPL_FilePath+' vs. '+OldFilename);

    if JPL_FilePath<>OldFilename then FileSettingsChanged := True;

  end;


procedure TTerminator_Form.HelpContents_MenuItemClick(Sender: TObject);
begin
  HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TitlePage.htm'),HH_DISPLAY_TOPIC, 0);
end;

procedure TTerminator_Form.FindJPLfile_MenuItemClick(Sender: TObject);
begin
  HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/EphemerisFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
end;

procedure TTerminator_Form.Changetexturefile_MenuItemClick(Sender: TObject);
begin
  HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
end;

procedure TTerminator_Form.Goto_RightClickMenuItemClick(Sender: TObject);
var
 MouseOrthoX, MouseOrthoY, MouseLat, MouseLon : extended;
begin
  with JimsGraph1 do
    begin
      MouseOrthoX := XValue(LastMouseClickPosition.X);
      MouseOrthoY := YValue(LastMouseClickPosition.Y);
    end;

  with H_Terminator_Goto_Form do
    begin
      if ConvertXYtoLonLat(MouseOrthoX,MouseOrthoY,MouseLon,MouseLat) then
        begin
          SetToLon_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(MouseLon)]);
          SetToLat_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(MouseLat)]);
        end;
      CenterX_LabeledNumericEdit.NumericEdit.Text := format('%0.4f',[MouseOrthoX]);
      CenterY_LabeledNumericEdit.NumericEdit.Text := format('%0.4f',[MouseOrthoY]);
    end;

  GoTo_MainMenuItemClick(Sender);
end;

procedure TTerminator_Form.DrawCircle_MainMenuItemClick(Sender: TObject);
begin
  if ShowingEarth then
    begin
      ShowMessage('This tool is not intended for use with Earth images');
      Exit;
    end;

  CircleDrawing_Form.ShowModal;
end;

procedure TTerminator_Form.DrawCircle_RightClickMenuItemClick(Sender: TObject);
var
 MouseOrthoX, MouseOrthoY, MouseLat, MouseLon : extended;
begin
  with JimsGraph1 do
    begin
      MouseOrthoX := XValue(LastMouseClickPosition.X);
      MouseOrthoY := YValue(LastMouseClickPosition.Y);
    end;

  with CircleDrawing_Form do
    begin
      if ConvertXYtoLonLat(MouseOrthoX,MouseOrthoY,MouseLon,MouseLat) then
        begin
          LonDeg_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(MouseLon)]);
          LatDeg_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(MouseLat)]);
        end;
    end;

  DrawCircle_MainMenuItemClick(Sender);
end;

function TTerminator_Form.LabelString(const FeatureToLabel : TCraterInfo;
  const IncludeName, IncludeParent, IncludeSize, IncludeUnits, ShowMore : Boolean) : String;
{returns string used for adding labels to map}
var
  SpacePos, ErrorCode : Integer;
  EVP : Extended;
  NameText, UnitsText, SizeText, FT_Code, NumericValue : string;
begin
  with FeatureToLabel.CraterData do
    begin
      NameText := Trim(Name);
      if NameText='' then NameText := AdditionalInfo1;
      if NameText='' then NameText := 'Name unknown';

      FT_Code := USGS_Code;

      if (FT_Code='CN') and (Length(AdditionalInfo2)>1) then FT_Code := 'CN5';

      if (not IncludeParent) and ((FT_Code='SF') or (FT_Code='GD') or (FT_Code='CD')) then
        begin // extract final suffix part of feature name
          SpacePos := Length(NameText);
          while (SpacePos>0) and (NameText[SpacePos]<>' ') do Dec(SpacePos);
          if (SpacePos>0) and (NameText[SpacePos]=' ') then NameText := Substring(NameText,SpacePos+1,MaxInt);
          if (Length(NameText)>0) and (NameText[Length(NameText)]=']') then NameText := '['+NameText; // complete bracket around discontinued names
        end;


      if (FT_Code='CN') or (FT_Code='CN5') then
        begin
          // "NumericValue" is actually Radial Distance
          UnitsText := ' km elev';
        end
      else if FT_Code='AT' then
        begin
          // "NumericValue" is actually Revolution Number
          UnitsText := 'Rev. ';
        end
      else
        begin
          UnitsText := ' km';
        end;

      NumericValue := NumericData;

      if ShowMore and (FT_Code='CN5') and (AdditionalInfo2<>'999999') then
        begin
          Val(AdditionalInfo2,EVP,ErrorCode);
          if ErrorCode=0 then
            NumericValue :=  NumericValue + Format(' +/- %0.3f',[EVP/1000]);
        end;

      if IncludeSize then
        begin
          if IncludeUnits and (NumericValue<>'') then
            begin
              if FT_Code='AT' then
                SizeText := UnitsText+NumericValue
              else
                SizeText := NumericValue+UnitsText;
            end
          else
            SizeText := NumericValue;

          if IncludeName then
            begin
              if SizeText<>'' then
                Result := NameText+' ('+SizeText+')'
              else
                Result := NameText;
            end
          else
            Result := SizeText;
        end
      else
        Result := NameText;

     if ShowMore then
       begin
         if FT_Code='CN' then
           Result := Result + ' Set '+AdditionalInfo2
         else if FT_Code='CN5' then
           Result := Result + ' Set '+AdditionalInfo1;
       end;
    end;
end;

function TTerminator_Form.UpperCaseParentName(const FeatureName, FT_Code : String) : String;
{attempts to extract uppercase version of parent part of FeatureName based on USGS Feature Type code; returns FeatureName if unsuccessful}
var
  TrialName, USGS_Code : String;
  SpacePos : Integer;
begin
  Result := FeatureName;

  TrialName := UpperCase(Trim(FeatureName));
  USGS_Code := UpperCase(FT_Code);

  if USGS_Code='LF' then
    Exit // don't process landing site names
  else if USGS_Code='AA' then
    // do nothing : Trial Name = parent name
  else if USGS_Code='SF' then
    begin
      SpacePos := Length(TrialName);
      while (SpacePos>1) and (TrialName[SpacePos]<>' ') do Dec(SpacePos);
      if TrialName[SpacePos]<>' ' then Exit;   // not a satellite feature name
      TrialName := Trim(Substring(TrialName,1,SpacePos-1));
    end
  else // assume name is a one word descriptor followed by parent name plus possible Greek suffix
    begin
      SpacePos := Pos(' ',TrialName);
      if SpacePos=0 then Exit;
      TrialName := Substring(TrialName,SpacePos+1,MaxInt);

      SpacePos := Pos('DELTA',TrialName);   // possible suffix for Mons
      if SpacePos<>0 then TrialName := Trim(Substring(TrialName,1,SpacePos-1));

      SpacePos := Pos('GAMMA',TrialName);
      if SpacePos<>0 then TrialName := Trim(Substring(TrialName,1,SpacePos-1));

      TrialName := Trim(TrialName);
    end;

  if TrialName<>'' then Result := TrialName;

end;

procedure TTerminator_Form.LabelDot(const DotInfo : TCraterInfo);
var
  LabelXPix, LabelYPix, PrimaryIndex,
  FontHeight, FontWidth, RadialPixels : Integer;
  FeatureVector, ParentVector, DirectionVector : TVector;
  DiffSqrd, Diff, XMultiplier, YMultiplier : Extended;

function ParentIndex(const FeatureName : String) : Integer;
// returns index of feature with same primary name in PrimaryFeatureList array
  var
    ParentFeatureName : String;
    I : Integer;
    NameFound : Boolean;
  begin {ParentIndex}
    Result := -999;

    ParentFeatureName := UpperCaseParentName(FeatureName,'SF');
    if ParentFeatureName=FeatureName then Exit;

    NameFound := False;

    I := -1;
    while (I<(Length(PrimaryCraterList)-2)) and not NameFound do
      begin
        Inc(I);
        NameFound := ParentFeatureName=UpperCase(PrimaryCraterList[I].Name);
      end;

    if NameFound then
      begin
        Result := I;
//        ShowMessage(FeatureName+' --> '+PrimaryCraterList[Result].Name);
      end
    else
      begin
//        ShowMessage('Primary not found for "'+FeatureName+'"');
      end;
  end;  {ParentIndex}

begin {LabelDot}
  with DotInfo do
    begin
      LabelXPix := Dot_X+Corrected_LabelXPix_Offset;
      LabelYPix := Dot_Y-Corrected_LabelYPix_Offset;
    end;

  with DotInfo.CraterData do
    begin
      if (not FullCraterNames) and RadialDotOffset and (Length(PrimaryCraterList)>0)
        and (USGS_Code='SF') then
        begin
          XMultiplier := 0;  // if parent can't be located plot name over dot
          YMultiplier := 0;

//          ShowMessage(Name);
//          PrimaryIndex := ParentIndex('Seeliger A');
          PrimaryIndex := ParentIndex(Name);
          if PrimaryIndex<>-999 then
            begin

              PolarToVector(Lat,Lon,1,FeatureVector);
              with PrimaryCraterList[PrimaryIndex] do PolarToVector(Lat,Lon,1,ParentVector);
              VectorDifference(ParentVector,FeatureVector,DirectionVector);   // Vector from Feature to Parent

              XMultiplier := DotProduct(DirectionVector,XPrime_UnitVector);  // Project into X-Y screen plane
              YMultiplier := DotProduct(DirectionVector,YPrime_UnitVector);

//              ShowMessage(Format('%s -> %s  %0.2f %0.2f',[Name,PrimaryCraterList[PrimaryIndex].Name, Lon,Lat]));

              DiffSqrd := Sqr(XMultiplier) + Sqr(YMultiplier);
              if DiffSqrd>0 then
                begin
                  Diff := Sqrt(DiffSqrd);
                  XMultiplier := XMultiplier/Diff;     // normalize to 0..1
                  YMultiplier := YMultiplier/Diff;
                end;

              if InvertLR then XMultiplier := -XMultiplier;
              If InvertUD then YMultiplier := -YMultiplier;

            end;

          FontHeight := Abs(JimsGraph1.Canvas.TextHeight('O'));
          FontWidth  := Abs(JimsGraph1.Canvas.TextWidth('O'));
//          ShowMessage('Font height = '+IntToStr(FontHeight));
          RadialPixels := (FontHeight div 2) + LabelXPix_Offset;

          LabelXPix := DotInfo.Dot_X + 2 - (FontWidth  div 2) + Round(XMultiplier*RadialPixels);
          LabelYPix := DotInfo.Dot_Y - 0 - (FontHeight div 2) - Round(YMultiplier*RadialPixels);

        end;

      JimsGraph1.Canvas.TextOut(LabelXPix,LabelYPix,
        LabelString(DotInfo,IncludeFeatureName,FullCraterNames,IncludeFeatureSize,IncludeUnits,False));
    end;
end;  {LabelDot}

procedure TTerminator_Form.LabelDots_ButtonClick(Sender: TObject);
var
  i : Integer;
begin
  if Length(CraterInfo)=0 then
    begin
      ShowMessage('This function labels all currently visible dots -- '+CR
                 +'   but there are no dots in the current view!');
    end
  else
    begin
      Screen.Cursor := crHourGlass;
      for i := 0 to (Length(CraterInfo)-1) do LabelDot(CraterInfo[i]);
      Screen.Cursor := DefaultCursor;
    end;
end;

function TTerminator_Form.FindClosestDot(var DotIndex : Integer) : Boolean;
{returns index in CraterInfo[] of dot closest to last mouse click}
var
  i, MinI, RSqrd, MinRsqrd : integer;

begin {FindClosestDot}
  if Length(CraterInfo)=0 then
    Result := False
  else
    begin
      MinI := 0;
      MinRsqrd := MaxInt;

      for i := 0 to (Length(CraterInfo)-1) do with CraterInfo[i] do
        begin
          RSqrd := Sqr(LastMouseClickPosition.X - Dot_X) + Sqr(LastMouseClickPosition.Y - Dot_Y);
          if RSqrd<MinRsqrd then
            begin
              MinRsqrd := RSqrd;
              MinI := i;
            end;
        end;

      DotIndex := MinI;
      Result := True;
    end;
end;  {FindClosestDot}

procedure TTerminator_Form.LabelNearestDot_RightClickMenuItemClick(Sender: TObject);
var
  ClosestDot : integer;
begin {TTerminator_Form.LabelNearestDot_RightClickMenuItemClick}
  if FindClosestDot(ClosestDot) then
    LabelDot(CraterInfo[ClosestDot])
  else
    ShowMessage('There are no dots to label');
end;  {TTerminator_Form.LabelNearestDot_RightClickMenuItemClick}

procedure TTerminator_Form.AddLabel_RightClickMenuItemClick(Sender: TObject);
var
  UserLabel : string;
begin
  UserLabel := InputBox('Add Label at Mouse Position',
    'Enter the text for the label you wish to add --'+CR
   +'If you want a special style go to Tools...Change dot/label prefs... before adding it.' ,'');
  if Trim(UserLabel)<>'' then with JimsGraph1.Canvas do
    begin
      TextOut(LastMouseClickPosition.X+Corrected_LabelXPix_Offset,
        LastMouseClickPosition.Y-Corrected_LabelYPix_Offset,UserLabel);
    end;
end;

function TTerminator_Form.PositionInCraterInfo(const ScreenX, ScreenY : integer) : boolean;
{tests if there is already a known dot at the stated pixel position}
var
  i : integer;
  ItemFound : boolean;
begin
  ItemFound := false;
  i := 0;
  while (i<Length(CraterInfo)) and not ItemFound do
    begin
      if (CraterInfo[i].Dot_X=ScreenX) and (CraterInfo[i].Dot_Y=ScreenY) then ItemFound := True;
      Inc(i);
    end;

  Result := ItemFound;
end;

function TTerminator_Form.FullFilename(const ShortName : string): string;
  begin
    if ExtractFilePath(ShortName)='' then
      Result := BasePath+ShortName
    else
      Result := ShortName;
  end;

procedure TTerminator_Form.Predict_ButtonClick(Sender: TObject);
var
  ImageCenterLon, ImageCenterLat, AngleToSun, SunAzimuth : extended;
begin
  if not EphemerisFileLoaded then
    begin
      FindAndLoadJPL_File(JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

  if not EphemerisFileLoaded then
    ShowMessage('The Moon Event Predictor cannot be used without a JPL ephemeris file')
  else
    with MoonEventPredictor_Form do
      begin
        Date_DateTimePicker.DateTime := Terminator_Form.Date_DateTimePicker.DateTime;
        Time_DateTimePicker.DateTime := Terminator_Form.Time_DateTimePicker.DateTime;

        if GeocentricSubEarthMode then
          begin
            GeocentricObserver_CheckBox.Checked := True;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := Format('%0.0f',[-REarth]);;
          end
        else
          begin
            GeocentricObserver_CheckBox.Checked := False;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObserverLongitudeText;
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObserverLatitudeText;
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObserverElevationText;
          end;

        Colongitude_LabeledNumericEdit.NumericEdit.Text := Colongitude_Label.Caption;
        SolarLatitude_LabeledNumericEdit.NumericEdit.Text := SubSol_Lat_LabeledNumericEdit.NumericEdit.Text;

        if ConvertXYtoLonLat(ImageCenterX,ImageCenterY,ImageCenterLon,ImageCenterLat) then
          begin
            Crater_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLon)]);
            Crater_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLat)]);
            ComputeDistanceAndBearing(ImageCenterLon, ImageCenterLat,
              SubSol_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue*OneDegree,
              SubSol_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue*OneDegree,
              AngleToSun, SunAzimuth);

            SunAngle_LabeledNumericEdit.NumericEdit.Text := Format('%0.4f',[RadToDeg(PiByTwo - AngleToSun)]);
            SunAzimuth_LabeledNumericEdit.NumericEdit.Text := Format('%0.4f',[RadToDeg(SunAzimuth)]);
          end;

//        CalculateCircumstances_Button.Click;

        MoonEventPredictor_Form.Show;
      end;
end;

procedure TTerminator_Form.TabulateLibrations_MainMenuItemClick(Sender: TObject);
var
  ImageCenterLon, ImageCenterLat : extended;
begin
  if not EphemerisFileLoaded then
    begin
      FindAndLoadJPL_File(JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

  if not EphemerisFileLoaded then
    ShowMessage('The Libration Tabulator cannot be used without a JPL ephemeris file')
  else
    with LibrationTabulator_Form do
      begin
        Date_DateTimePicker.DateTime := Terminator_Form.Date_DateTimePicker.DateTime;
        Time_DateTimePicker.DateTime := Terminator_Form.Time_DateTimePicker.DateTime;

        if GeocentricSubEarthMode then
          begin
            GeocentricObserver_CheckBox.Checked := True;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := Format('%0.0f',[-REarth]);;
          end
        else
          begin
            GeocentricObserver_CheckBox.Checked := False;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObserverLongitudeText;
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObserverLatitudeText;
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObserverElevationText;
          end;

        if ConvertXYtoLonLat(ImageCenterX,ImageCenterY,ImageCenterLon,ImageCenterLat) then
          begin
            Crater_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLon)]);
            Crater_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLat)]);
          end;

        LibrationTabulator_Form.Show;
      end;
end;

procedure TTerminator_Form.SearchUncalibratedPhotos_MainMenuItemClick(Sender: TObject);
var
  ImageCenterLon, ImageCenterLat : extended;
begin

  if not EphemerisFileLoaded then
    begin
      FindAndLoadJPL_File(JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

  if not EphemerisFileLoaded then
    ShowMessage('The PhotoSession Search requires a JPL ephemeris file')
  else
    with PhotosessionSearch_Form do
      begin
        PSS_JPL_Filename := FullFilename(JPL_Filename);
        PSS_JPL_Path := JPL_FilePath;
        if PhotoSessionsFilename='' then PhotoSessionsFilename := FullFilename(NormalPhotoSessionsFilename);

        Date_DateTimePicker.DateTime := Terminator_Form.Date_DateTimePicker.DateTime;
        Time_DateTimePicker.DateTime := Terminator_Form.Time_DateTimePicker.DateTime;
        if GeocentricSubEarthMode then
          begin
            GeocentricObserver_CheckBox.Checked := True;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := '0';
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := Format('%0.0f',[-REarth]);;
          end
        else
          begin
            GeocentricObserver_CheckBox.Checked := False;
            ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObserverLongitudeText;
            ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObserverLatitudeText;
            ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObserverElevationText;
          end;
        Colongitude_LabeledNumericEdit.NumericEdit.Text := Colongitude_Label.Caption;
        SolarLatitude_LabeledNumericEdit.NumericEdit.Text := SubSol_Lat_LabeledNumericEdit.NumericEdit.Text;

        if ConvertXYtoLonLat(ImageCenterX,ImageCenterY,ImageCenterLon,ImageCenterLat) then
          begin
            Crater_Lon_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLon)]);
            Crater_Lat_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLat)]);
          end;

        CalculateCircumstances_Button.Click;

        PhotosessionSearch_Form.Show;
      end;
end;

procedure TTerminator_Form.ChangeCartographicOptions_MainMenuItemClick(Sender: TObject);
begin
  WriteCartographicOptionsToForm;
  CartographicOptions_Form.ChangeOptions := False;
  CartographicOptions_Form.ShowModal;
  if CartographicOptions_Form.ChangeOptions then ReadCartographicOptionsFromForm;
end;

procedure TTerminator_Form.SaveCartographicOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);
  IniFile.WriteString('LTVT Defaults','Start_with_current_UT',BooleanToYesNo(StartWithCurrentUT));
//  IniFile.WriteString('LTVT Defaults','Cartographic_orientation',BooleanToYesNo(CartographicOrientation));
  case OrientationMode of
    LineOfCusps : IniFile.WriteString('LTVT Defaults','Cartographic_orientation','LineOfCusps');
    Cartographic : IniFile.WriteString('LTVT Defaults','Cartographic_orientation','Cartographic');
    Equatorial : IniFile.WriteString('LTVT Defaults','Cartographic_orientation','Equatorial');
    AltAz : IniFile.WriteString('LTVT Defaults','Cartographic_orientation','AltAz');
    end;
  IniFile.WriteString('LTVT Defaults','Invert_image_left-right',BooleanToYesNo(InvertLR));
  IniFile.WriteString('LTVT Defaults','Invert_image_up-down',BooleanToYesNo(InvertUD));
//  IniFile.WriteString('LTVT Defaults','Manual_Rotation_Angle',Format('%0.3f',[ManualRotationDegrees]));
  IniFile.WriteString('LTVT Defaults','Terminator_lines',BooleanToYesNo(IncludeTerminatorLines));
  IniFile.WriteString('LTVT Defaults','Libration_circle',BooleanToYesNo(IncludeLibrationCircle));
  IniFile.WriteString('LTVT Defaults','Libration_Circle_Color',Format('$%6.6x',[LibrationCircleColor]));
  IniFile.WriteString('LTVT Defaults','Sky_Color',Format('$%6.6x',[SkyColor]));
  IniFile.WriteString('LTVT Defaults','DotMode_SunlitColor',Format('$%6.6x',[DotModeSunlitColor]));
  IniFile.WriteString('LTVT Defaults','DotMode_ShadowedColor',Format('$%6.6x',[DotModeShadowedColor]));
  IniFile.WriteString('LTVT Defaults','NoData_Color',Format('$%6.6x',[NoDataColor]));
  IniFile.WriteInteger('LTVT Defaults','ShadowLineLength_pixels',ShadowLineLength_pixels);
  IniFile.WriteString('LTVT Defaults','SelenographicAxes_p1Angle_arcsec',p1Text);
  IniFile.WriteString('LTVT Defaults','SelenographicAxes_p2Angle_arcsec',p2Text);
  IniFile.WriteString('LTVT Defaults','SelenographicAxes_tauAngle_arcsec',tauText);
  IniFile.Free;
end;

procedure TTerminator_Form.RestoreCartographicOptions;
const
  p1_DefaultText = '-78.9316';
  p2_DefaultText = '0.2902';
  tau_DefaultText = '66.1898';
var
  IniFile : TIniFile;
  OrientationString : String;
begin
  IniFile := TIniFile.Create(IniFileName);
  StartWithCurrentUT := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Start_with_current_UT','no'));

  OrientationString := UpperCase(IniFile.ReadString('LTVT Defaults','Cartographic_orientation','Cartographic'));
// support older mode where orientation was boolean: YES = Cartographic, NO = LineOfCusps
  if (OrientationString='NO') or (OrientationString='LINEOFCUSPS') then
    OrientationMode := LineOfCusps
  else if OrientationString='EQUATORIAL' then
    OrientationMode := Equatorial
  else if OrientationString='ALTAZ' then
    OrientationMode := AltAz
  else
    OrientationMode := Cartographic;

  InvertLR := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Invert_image_left-right','no'));
  InvertUD := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Invert_image_up-down','no'));
{
  try
    ManualRotationDegrees := StrToFloat(IniFile.ReadString('LTVT Defaults','Manual_Rotation_Angle','0'));
  except
    ManualRotationDegrees := 0;
  end;
}  
  IncludeLibrationCircle := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Libration_circle','yes'));
  IncludeTerminatorLines := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Terminator_lines','yes'));
  try
    LibrationCircleColor := StrToInt(IniFile.ReadString('LTVT Defaults','Libration_Circle_Color',IntToStr(clWhite)));
  except
    LibrationCircleColor := clWhite;
  end;

  try
    SkyColor := StrToInt(IniFile.ReadString('LTVT Defaults','Sky_Color',IntToStr(clNavy)));
  except
    SkyColor := clWhite;
  end;

  try  // Note: original color was  $C8C8C8 (R=G=B= 200) -- very similar to clSilver
    DotModeSunlitColor := StrToInt(IniFile.ReadString('LTVT Defaults','DotMode_SunlitColor',IntToStr(clSilver)));
  except
    DotModeSunlitColor := clSilver;
  end;

  try  // Note: original color was  $646464 (R=G=B= 100)  -- a little darker than clGray
    DotModeShadowedColor := StrToInt(IniFile.ReadString('LTVT Defaults','DotMode_ShadowedColor',IntToStr(clGray)));
  except
    DotModeShadowedColor := clGray;
  end;

  try
    NoDataColor := StrToInt(IniFile.ReadString('LTVT Defaults','NoData_Color',IntToStr(clAqua)));
  except
    NoDataColor := clAqua;
  end;

  ShadowLineLength_pixels := IniFile.ReadInteger('LTVT Defaults','ShadowLineLength_pixels',300);

// Delete these older keys if present:
  IniFile.DeleteKey('LTVT Defaults','MeanEarthAxes_p1Angle_arcsec');
  IniFile.DeleteKey('LTVT Defaults','MeanEarthAxes_p2Angle_arcsec');
  IniFile.DeleteKey('LTVT Defaults','MeanEarthAxes_tauAngle_arcsec');
  IniFile.DeleteKey('LTVT Defaults','Use_black_sky');

// Note: it is not possible to enter these into the SetObserverLocation form at this point because
// the form has not been created!

  p1Text := Trim(IniFile.ReadString('LTVT Defaults','SelenographicAxes_p1Angle_arcsec',p1_DefaultText));
  p2Text := Trim(IniFile.ReadString('LTVT Defaults','SelenographicAxes_p2Angle_arcsec',p2_DefaultText));
  tauText := Trim(IniFile.ReadString('LTVT Defaults','SelenographicAxes_tauAngle_arcsec',tau_DefaultText));

  if p1Text='' then p1Text := p1_DefaultText;
  if p2Text='' then p2Text := p2_DefaultText;
  if tauText='' then tauText := tau_DefaultText;

  MoonPosition.p1 := OneArcSecond*ExtendedValue(p1Text);
  MoonPosition.p2 := OneArcSecond*ExtendedValue(p2Text);
  MoonPosition.tau := OneArcSecond*ExtendedValue(tauText);

  AdjustToMeanEarthSystem := (MoonPosition.p1<>0) or (MoonPosition.p2<>0) or (MoonPosition.tau<>0);

  if AdjustToMeanEarthSystem then ComputeMeanEarthSystemOffsetMatix;  // replace default with that specified in ini file

  IniFile.Free;
end;

procedure TTerminator_Form.WriteCartographicOptionsToForm;
begin
  with CartographicOptions_Form do
    begin
      UseCurrentUT_CheckBox.Checked := StartWithCurrentUT;
      Cartographic_RadioButton.Checked := OrientationMode=Cartographic;
      LineOfCusps_RadioButton.Checked := OrientationMode=LineOfCusps;
      Equatorial_RadioButton.Checked := OrientationMode=Equatorial;
      AltAz_RadioButton.Checked := OrientationMode=AltAz;
      InvertLR_CheckBox.Checked := InvertLR;
      InvertUD_CheckBox.Checked := InvertUD;
//      BlackSky_CheckBox.Checked := BlackSky;
      Sky_ColorBox.Selected := SkyColor;
      DotModeSunlitColor_ColorBox.Selected := DotModeSunlitColor;
      DotModeShadowedColor_ColorBox.Selected := DotModeShadowedColor;
      NoDataColor_ColorBox.Selected := NoDataColor;

      ShadowLineLength_LabeledNumericEdit.NumericEdit.Text := IntToStr(ShadowLineLength_pixels);

//      RotationAngle_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[ManualRotationDegrees]);

      TerminatorLines_CheckBox.Checked := IncludeTerminatorLines;

      LibrationCircle_CheckBox.Checked := IncludeLibrationCircle;
      LibrationCircle_ColorBox.Selected := LibrationCircleColor;

      ShowDetails_CheckBox.Checked := ShowDetails;
    end;
end;

procedure TTerminator_Form.ReadCartographicOptionsFromForm;
begin
  with CartographicOptions_Form do
    begin
      StartWithCurrentUT := UseCurrentUT_CheckBox.Checked;

      if LineOfCusps_RadioButton.Checked then
        OrientationMode := LineOfCusps
      else if Equatorial_RadioButton.Checked then
        OrientationMode := Equatorial
      else if AltAz_RadioButton.Checked then
        OrientationMode := AltAz
      else
        OrientationMode := Cartographic;

      InvertLR := InvertLR_CheckBox.Checked;
      InvertUD := InvertUD_CheckBox.Checked;
      SkyColor := Sky_ColorBox.Selected;
      DotModeSunlitColor := DotModeSunlitColor_ColorBox.Selected;
      DotModeShadowedColor := DotModeShadowedColor_ColorBox.Selected;
      NoDataColor := NoDataColor_ColorBox.Selected;
      ShadowLineLength_pixels := ShadowLineLength_LabeledNumericEdit.NumericEdit.IntegerValue;
//      ManualRotationDegrees := RotationAngle_LabeledNumericEdit.NumericEdit.ExtendedValue;
      IncludeTerminatorLines := TerminatorLines_CheckBox.Checked;
      IncludeLibrationCircle := LibrationCircle_CheckBox.Checked;
      LibrationCircleColor := LibrationCircle_ColorBox.Selected;
      ShowDetails := ShowDetails_CheckBox.Checked;
    end;
end;

procedure TTerminator_Form.Changelabelpreferences_MainMenuItemClick(Sender: TObject);
begin
  WriteLabelOptionsToForm;
  LabelFontSelector_Form.ShowModal;
  if LabelFontSelector_Form.ChangeSelections then  ReadLabelOptionsFromForm;
end;

procedure TTerminator_Form.SaveDefaultLabelOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);
  with JimsGraph1.Canvas.Font do
    begin
      IniFile.WriteString('LTVT Defaults','LabelFont_Name',Name);
      IniFile.WriteInteger('LTVT Defaults','LabelFont_CharSet',Byte(Charset));
      IniFile.WriteInteger('LTVT Defaults','LabelFont_Style',Byte(Style));
      IniFile.WriteInteger('LTVT Defaults','LabelFont_Size',Size);
      IniFile.WriteString('LTVT Defaults','LabelFont_Color',Format('$%6.6x',[Color]));
    end;
  IniFile.WriteInteger('LTVT Defaults','Label_XOffset',LabelXPix_Offset);
  IniFile.WriteInteger('LTVT Defaults','Label_YOffset',LabelYPix_Offset);
  IniFile.WriteString('LTVT Defaults','RadialDotOffset',BooleanToYesNo(RadialDotOffset));
  IniFile.WriteString('LTVT Defaults','IncludeFeatureName',BooleanToYesNo(IncludeFeatureName));
  IniFile.WriteString('LTVT Defaults','UseFullCraterNames',BooleanToYesNo(FullCraterNames));
  IniFile.WriteString('LTVT Defaults','IncludeFeatureSize',BooleanToYesNo(IncludeFeatureSize));
  IniFile.WriteString('LTVT Defaults','IncludeUnits',BooleanToYesNo(IncludeUnits));
  IniFile.WriteString('LTVT Defaults','IncludeDiscontinuedNames',BooleanToYesNo(IncludeDiscontinuedNames));
  IniFile.WriteInteger('LTVT Defaults','DotSizeInPixels',DotSize);
  IniFile.WriteInteger('LTVT Defaults','MediumCraterStartingDiameter',Round(MediumCraterDiam));
  IniFile.WriteInteger('LTVT Defaults','LargeCraterStartingDiameter',Round(LargeCraterDiam));
  IniFile.WriteString('LTVT Defaults','NonCraterDotColor',Format('$%6.6x',[NonCraterColor]));
  IniFile.WriteString('LTVT Defaults','SmallCraterDotColor',Format('$%6.6x',[SmallCraterColor]));
  IniFile.WriteString('LTVT Defaults','MediumCraterDotColor',Format('$%6.6x',[MediumCraterColor]));
  IniFile.WriteString('LTVT Defaults','LargeCraterDotColor',Format('$%6.6x',[LargeCraterColor]));
  IniFile.WriteString('LTVT Defaults','CraterCircleColor',Format('$%6.6x',[CraterCircleColor]));
  IniFile.WriteString('LTVT Defaults','ReferencePointColor',Format('$%6.6x',[ReferencePointColor]));
  IniFile.WriteString('LTVT Defaults','SnapShadowPointsToPlanView',BooleanToYesNo(SnapShadowPointsToPlanView));
  IniFile.WriteString('LTVT Defaults','AnnotateSavedImages',BooleanToYesNo(AnnotateSavedImages));
  IniFile.WriteString('LTVT Defaults','SavedImageUpperLabels_Color',Format('$%6.6x',[SavedImageUpperLabelsColor]));
  IniFile.WriteString('LTVT Defaults','SavedImageLowerLabels_Color',Format('$%6.6x',[SavedImageLowerLabelsColor]));
  IniFile.Free;
end;

procedure TTerminator_Form.RestoreDefaultLabelOptions;
var
  IniFile : TIniFile;
  StyleNum : Integer;
begin
  IniFile := TIniFile.Create(IniFileName);

  with JimsGraph1.Canvas.Font do
    begin
      Name := IniFile.ReadString('LTVT Defaults','LabelFont_Name','MS Sans Serif');
      CharSet := IniFile.ReadInteger('LTVT Defaults','LabelFont_CharSet',0);
      StyleNum := IniFile.ReadInteger('LTVT Defaults','LabelFont_Style',0);
      Style := [];
      if (StyleNum and 1)<>0 then Style := Style + [fsBold];
      if (StyleNum and 2)<>0 then Style := Style + [fsItalic];
      if (StyleNum and 4)<>0 then Style := Style + [fsUnderline];
      if (StyleNum and 8)<>0 then Style := Style + [fsStrikeOut];
      Size := IniFile.ReadInteger('LTVT Defaults','LabelFont_Size',8);
      try
        Color := StrToInt(IniFile.ReadString('LTVT Defaults','LabelFont_Color',IntToStr(clLime)));
      except
        Color := clLime;
      end;
    end;

  LabelXPix_Offset := IniFile.ReadInteger('LTVT Defaults','Label_XOffset',7);
  LabelYPix_Offset := IniFile.ReadInteger('LTVT Defaults','Label_YOffset',0);
  Corrected_LabelXPix_Offset := LabelXPix_Offset;
    // TextOut(X,Y) prints with Y = top of text, so need to center it per height
  Corrected_LabelYPix_Offset := LabelYPix_Offset + (Abs(JimsGraph1.Canvas.Font.Height) div 2);

  RadialDotOffset := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','RadialDotOffset','no'));
  IncludeFeatureName := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','IncludeFeatureName','yes'));
  FullCraterNames := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','UseFullCraterNames','no'));
  IncludeFeatureSize := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','IncludeFeatureSize','no'));
  IncludeUnits := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','IncludeUnits','no'));
  IncludeDiscontinuedNames := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','IncludeDiscontinuedNames','no'));

  DotSize := IniFile.ReadInteger('LTVT Defaults','DotSizeInPixels',2);
  MediumCraterDiam := IniFile.ReadInteger('LTVT Defaults','MediumCraterStartingDiameter',50);
  LargeCraterDiam := IniFile.ReadInteger('LTVT Defaults','LargeCraterStartingDiameter',100);
  try
    NonCraterColor := StrToInt(IniFile.ReadString('LTVT Defaults','NonCraterDotColor',IntToStr(clYellow)));
  except
    NonCraterColor := clYellow;
  end;
  try
    SmallCraterColor := StrToInt(IniFile.ReadString('LTVT Defaults','SmallCraterDotColor',IntToStr(clBlue)));
  except
    SmallCraterColor := clBlue;
  end;
  try
    MediumCraterColor := StrToInt(IniFile.ReadString('LTVT Defaults','MediumCraterDotColor',IntToStr(clLime)));
  except
    MediumCraterColor := clLime;
  end;
  try
    LargeCraterColor := StrToInt(IniFile.ReadString('LTVT Defaults','LargeCraterDotColor',IntToStr(clRed)));
  except
    LargeCraterColor := clRed;
  end;
  try
    CraterCircleColor := StrToInt(IniFile.ReadString('LTVT Defaults','CraterCircleColor',IntToStr(clWhite)));
  except
    CraterCircleColor := clWhite;
  end;
  try
    ReferencePointColor := StrToInt(IniFile.ReadString('LTVT Defaults','ReferencePointColor',IntToStr(clAqua)));
  except
    ReferencePointColor := clAqua;
  end;

  SnapShadowPointsToPlanView := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','SnapShadowPointsToPlanView','no'));

  AnnotateSavedImages := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','AnnotateSavedImages','yes'));

  try
    SavedImageUpperLabelsColor := StrToInt(IniFile.ReadString('LTVT Defaults','SavedImageUpperLabels_Color',IntToStr(clBlue)));
  except
    SavedImageUpperLabelsColor := clBlue;
  end;

  try
    SavedImageLowerLabelsColor := StrToInt(IniFile.ReadString('LTVT Defaults','SavedImageLowerLabels_Color',IntToStr(clOlive)));
  except
    SavedImageLowerLabelsColor := clOlive;
  end;

  IniFile.Free;
end;

procedure TTerminator_Form.WriteLabelOptionsToForm;
begin
  with LabelFontSelector_Form do
    begin
      DesiredFont.Assign(JimsGraph1.Canvas.Font);
      XOffset_LabeledNumericEdit.NumericEdit.Text := IntToStr(LabelXPix_Offset);
      YOffset_LabeledNumericEdit.NumericEdit.Text := IntToStr(LabelYPix_Offset);
      RadialDotOffset_CheckBox.Checked := RadialDotOffset;
      IncludeName_CheckBox.Checked := IncludeFeatureName;
      FullCraterNames_CheckBox.Checked := FullCraterNames;
      IncludeSize_CheckBox.Checked := IncludeFeatureSize;
      IncludeUnits_CheckBox.Checked := IncludeUnits;
      IncludeDiscontinuedNames_CheckBox.Checked := IncludeDiscontinuedNames;
      DotSize_LabeledNumericEdit.NumericEdit.Text := IntToStr(DotSize);
      MediumCraterDiam_NumericEdit.Text := Format('%0.0f',[MediumCraterDiam]);
      LargeCraterDiam_NumericEdit.Text  := Format('%0.0f',[LargeCraterDiam]);
      NonCrater_ColorBox.Selected := NonCraterColor;
      SmallCrater_ColorBox.Selected := SmallCraterColor;
      MediumCrater_ColorBox.Selected := MediumCraterColor;
      LargeCrater_ColorBox.Selected := LargeCraterColor;
      DotCircle_ColorBox.Selected := CraterCircleColor;
      RefPt_ColorBox.Selected := ReferencePointColor;
      SnapShadowPoint_CheckBox.Checked := SnapShadowPointsToPlanView;
      AnnotateSavedImages_CheckBox.Checked := AnnotateSavedImages;
      SavedImageUpperLabels_ColorBox.Selected := SavedImageUpperLabelsColor;
      SavedImageLowerLabels_ColorBox.Selected := SavedImageLowerLabelsColor;
    end;
end;

procedure TTerminator_Form.ReadLabelOptionsFromForm;
begin
  with LabelFontSelector_Form do
    begin
      JimsGraph1.Canvas.Font.Assign(DesiredFont);
      LabelXPix_Offset :=  XOffset_LabeledNumericEdit.NumericEdit.IntegerValue;
      LabelYPix_Offset :=  YOffset_LabeledNumericEdit.NumericEdit.IntegerValue;
      Corrected_LabelXPix_Offset := LabelXPix_Offset;
        // TextOut(X,Y) prints with Y = top of text, so need to center it per height
      Corrected_LabelYPix_Offset := LabelYPix_Offset + (Abs(JimsGraph1.Canvas.Font.Height) div 2);
      RadialDotOffset := RadialDotOffset_CheckBox.Checked;
      IncludeFeatureName := IncludeName_CheckBox.Checked;
      FullCraterNames := FullCraterNames_CheckBox.Checked;
      IncludeFeatureSize := IncludeSize_CheckBox.Checked;
      IncludeUnits := IncludeUnits_CheckBox.Checked;
      IncludeDiscontinuedNames := IncludeDiscontinuedNames_CheckBox.Checked;
      DotSize := DotSize_LabeledNumericEdit.NumericEdit.IntegerValue;
      MediumCraterDiam := MediumCraterDiam_NumericEdit.ExtendedValue;
      LargeCraterDiam := LargeCraterDiam_NumericEdit.ExtendedValue;
      NonCraterColor := NonCrater_ColorBox.Selected;
      SmallCraterColor := SmallCrater_ColorBox.Selected;
      MediumCraterColor := MediumCrater_ColorBox.Selected;
      LargeCraterColor := LargeCrater_ColorBox.Selected;
      CraterCircleColor := DotCircle_ColorBox.Selected;
      ReferencePointColor := RefPt_ColorBox.Selected;
      SnapShadowPointsToPlanView := SnapShadowPoint_CheckBox.Checked;
      AnnotateSavedImages := AnnotateSavedImages_CheckBox.Checked;
      SavedImageUpperLabelsColor := SavedImageUpperLabels_ColorBox.Selected;
      SavedImageLowerLabelsColor := SavedImageLowerLabels_ColorBox.Selected;
    end;
end;

procedure TTerminator_Form.MouseOptions_RightClickMenuItemClick(Sender: TObject);
begin
  ChangeMouseOptions_MainMenuItemClick(Sender);
end;

procedure TTerminator_Form.ChangeMouseOptions_MainMenuItemClick(Sender: TObject);
begin  {ChangeMouseOptions_MainMenuItemClick}
  with MouseOptions_Form do
    begin
      RefPtOptions_GroupBox.Caption :=
        Format(' Reference point is set at Longitude = %0.3f  and  Latitude = %0.3f  with  sun angle = %0.3f degrees ',
          [RadToDeg(RefPtLon),RadToDeg(RefPtLat),RadToDeg(RefPtSunAngle)]);

      WriteMouseOptionsToForm;

      ChangeOptions := False;
      ShowModal;

      if ChangeOptions then ReadMouseOptionsFromForm;
    end;
end;   {ChangeMouseOptions_MainMenuItemClick}

procedure TTerminator_Form.SaveMouseOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);

  if CursorType=UseCrosshairCursor then
    IniFile.WriteString('LTVT Defaults','Cursor_Type','cross-hair')
  else
    IniFile.WriteString('LTVT Defaults','Cursor_Type','normal');

  if RefPtReadoutMode=NoRefPtReadout then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','none')
  else if RefPtReadoutMode=DistanceAndBearingRefPtMode then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','distance')
  else if RefPtReadoutMode=ShadowLengthRefPtMode then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','shadow-length')
  else if RefPtReadoutMode=InverseShadowLengthRefPtMode then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','inverse-shadow-length')
  else if RefPtReadoutMode=RayHeightsRefPtMode then
    IniFile.WriteString('LTVT Defaults','RefPt_readout','ray-height');
  IniFile.Free;
end;

procedure TTerminator_Form.RestoreMouseOptions;
var
  IniFile : TIniFile;
  CursorMode, RefMode : String;
begin
  IniFile := TIniFile.Create(IniFileName);

  CursorMode := UpperCase(Trim(IniFile.ReadString('LTVT Defaults','Cursor_Type','normal')));
  if CursorMode='CROSS-HAIR' then
    begin
      JimsGraph1.Cursor := crCross;
      CursorType := UseCrosshairCursor;
    end
  else
    begin
      JimsGraph1.Cursor := crDefault;
      CursorType := UseDefaultCursor;
    end;

  RefMode := UpperCase(Trim(IniFile.ReadString('LTVT Defaults','RefPt_readout','none')));
  if RefMode='DISTANCE' then
    RefPtReadoutMode := DistanceAndBearingRefPtMode
  else if RefMode='SHADOW-LENGTH' then
    RefPtReadoutMode := ShadowLengthRefPtMode
  else if RefMode='INVERSE-SHADOW-LENGTH' then
    RefPtReadoutMode := ShadowLengthRefPtMode
  else if RefMode='RAY-HEIGHT' then
    RefPtReadoutMode := RayHeightsRefPtMode
  else
    RefPtReadoutMode := NoRefPtReadout;

  IniFile.Free;
end;

procedure TTerminator_Form.WriteMouseOptionsToForm;
begin
  with MouseOptions_Form do
    begin
      NormalCursor_RadioButton.Checked := (CursorType=UseDefaultCursor);
      CrosshairCursor_RadioButton.Checked := (CursorType=UseCrosshairCursor);

      case RefPtReadoutMode of
        DistanceAndBearingRefPtMode : DistanceAndBearingFromRefPt_RadioButton.Checked := True;
        ShadowLengthRefPtMode : ShadowLengthRefPtReadout_RadioButton.Checked := True;
        InverseShadowLengthRefPtMode : InverseShadowLengthRefPtReadout_RadioButton.Checked := True;
        RayHeightsRefPtMode : PointOfLightRefPtReadout_RadioButton.Checked := True;
        else
          NoRefPtReadout_RadioButton.Checked := True;
        end;

    end;
end;

procedure TTerminator_Form.ReadMouseOptionsFromForm;
begin
  with MouseOptions_Form do
    begin
      if CrosshairCursor_RadioButton.Checked then
        begin
          JimsGraph1.Cursor := crCross;
          CursorType := UseCrosshairCursor;
        end
      else
        begin
          JimsGraph1.Cursor := crDefault;
          CursorType := UseDefaultCursor;
        end;

      if DistanceAndBearingFromRefPt_RadioButton.Checked then
        RefPtReadoutMode := DistanceAndBearingRefPtMode
      else if ShadowLengthRefPtReadout_RadioButton.Checked then
        RefPtReadoutMode := ShadowLengthRefPtMode
      else if InverseShadowLengthRefPtReadout_RadioButton.Checked then
        RefPtReadoutMode := InverseShadowLengthRefPtMode
      else if PointOfLightRefPtReadout_RadioButton.Checked then
        RefPtReadoutMode := RayHeightsRefPtMode
      else
        RefPtReadoutMode := NoRefPtReadout;

    end;

end;

procedure TTerminator_Form.ChangeExternalFiles_MainMenuItemClick(Sender: TObject);
begin
      WriteFileOptionsToForm;
      ExternalFileSelection_Form.ChangeFileNames := False;
      ExternalFileSelection_Form.ShowModal;

      if ExternalFileSelection_Form.ChangeFileNames then  ReadFileOptionsFromForm;
end;

function TTerminator_Form.BriefName(const FullName : string) : string;
{strip off path if it is the same as LTVT.exe}
  begin
    if ExtractFilePath(FullName)=BasePath then
      Result := ExtractFileName(FullName)
    else
      Result := FullName;
  end;

procedure TTerminator_Form.SaveFileOptions;
var
  IniFile : TIniFile;

begin  {TTerminator_Form.SaveFileOptions}
  IniFile := TIniFile.Create(IniFileName);

  IniFile.WriteString('LTVT Defaults','Linux_Compatibility_Mode',BooleanToYesNo(LinuxCompatibilityMode));

  if TAIOffsetFile.FileLoaded then
    begin
      IniFile.WriteString('LTVT Defaults','Correct_for_Ephemeris_Time_TAI_Offset','yes');
      IniFile.WriteString('LTVT Defaults','TAI_Offset_Data_File',BriefName(TAIOffsetFile.FileName));
    end
  else
    begin
      IniFile.WriteString('LTVT Defaults','Correct_for_Ephemeris_Time_TAI_Offset','no');
      IniFile.DeleteKey('LTVT Defaults','TAI_Offset_Data_File');
    end;

  IniFile.WriteString('LTVT Defaults','Crater_File',BriefName(CraterFilename));
  IniFile.WriteString('LTVT Defaults','Photo_File',BriefName(NormalPhotoSessionsFilename));
  IniFile.WriteString('LTVT Defaults','Calibrated_Photo_File',BriefName(CalibratedPhotosFilename));
  IniFile.WriteString('LTVT Defaults','Observatory_List_File',BriefName(ObservatoryListFilename));
  IniFile.WriteString('LTVT Defaults','JPL_Ephemeris_File',BriefName(JPL_Filename));

  IniFile.WriteString('LTVT Defaults','Texture1_Caption',LoResUSGS_RadioButton.Caption);
  IniFile.WriteString('LTVT Defaults','Texture1_File',BriefName(LoResFilename));

  IniFile.WriteString('LTVT Defaults','Texture2_Caption',HiResUSGS_RadioButton.Caption);
  IniFile.WriteString('LTVT Defaults','Texture2_File',BriefName(HiResFilename));

  IniFile.WriteString('LTVT Defaults','Texture3_Caption',Clementine_RadioButton.Caption);
  IniFile.WriteString('LTVT Defaults','Texture3_File',BriefName(ClementineFilename));

  IniFile.WriteString('LTVT Defaults','Texture3_MinLon_deg',Tex3MinLonText);
  IniFile.WriteString('LTVT Defaults','Texture3_MaxLon_deg',Tex3MaxLonText);
  IniFile.WriteString('LTVT Defaults','Texture3_MinLat_deg',Tex3MinLatText);
  IniFile.WriteString('LTVT Defaults','Texture3_MaxLat_deg',Tex3MaxLatText);

  IniFile.WriteString('LTVT Defaults','EarthTexture_File',BriefName(EarthTextureFilename));

  FileSettingsChanged := False;
  IniFile.Free;
end;   {TTerminator_Form.SaveFileOptions}

procedure TTerminator_Form.RestoreFileOptions;
const
  Texture1_DefaultText = 'Low Resolution Shaded Relief';
  Texture2_DefaultText = 'High Resolution Shaded Relief';
  Texture3_DefaultText = 'Clementine Photo Mosaic';

var
  IniFile : TIniFile;
  TempTexture1Name, TempTexture2Name, TempTexture3Name, TempEarthTextureName : String;

begin  {TTerminator_Form.RestoreFileOptions}
//  ShowMessage('Reading options from ini file...');
  IniFile := TIniFile.Create(IniFileName);

  LinuxCompatibilityMode := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Linux_Compatibility_Mode','no'));

  NormalPhotoSessionsFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Photo_File','PhotoSessions.csv'));
  CalibratedPhotosFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Calibrated_Photo_File','PhotoCalibrationData.txt'));
  ObservatoryListFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Observatory_List_File','Observatory_List.txt'));

  if YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Correct_for_Ephemeris_Time_TAI_Offset','yes')) then
    begin
      OldFilename := FullFilename(IniFile.ReadString('LTVT Defaults','TAI_Offset_Data_File','TAI_Offset_Data.txt'));
      if (not FileExists(OldFilename)) and (MessageDlg('LTVT is looking for a TAI_Offset file'+CR
                        +'   Do you want help with this topic?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TAI_Offsets.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      TAIOffsetFile.SetFile(OldFilename);  // this initiates dialog if file does not exist.
      if TAIOffsetFile.FileName<>OldFilename then FileSettingsChanged := True;
// note: if no file was loaded, TAIOffsetFile returns the default offset of 65.184 sec
//   also, when the options are saved, this key will be deleted if there is no file currently loaded
    end;

  JPL_Filename   := FullFilename(IniFile.ReadString('LTVT Defaults','JPL_Ephemeris_File','UNXP2000.405'));
  JPL_FilePath := ExtractFilePath(JPL_Filename);

  CraterFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Crater_File','Named_Lunar_Features.csv'));

  TempTexture1Name := LoResFilename;
  LoResUSGS_RadioButton.Caption  := Substring(IniFile.ReadString('LTVT Defaults','Texture1_Caption',Texture1_DefaultText),1,40);
  if Trim(LoResUSGS_RadioButton.Caption)='' then LoResUSGS_RadioButton.Caption := Texture1_DefaultText;
  LoResFilename  := IniFile.ReadString('LTVT Defaults','Low_Resolution_USGS_Relief_Map','');
  if LoResFilename<>'' then
    begin
      IniFile.WriteString('LTVT Defaults','Texture1_File',LoResFilename);
      IniFile.DeleteKey('LTVT Defaults','Low_Resolution_USGS_Relief_Map');
    end;
  LoResFilename  := FullFilename(IniFile.ReadString('LTVT Defaults','Texture1_File','lores.jpg'));
  if TempTexture1Name<>LoResFilename then
    begin
      LoRes_TextureMap.Free;
      LoRes_Texture_Loaded := False;
      LoResUSGS_RadioButton.Font.Color := clGray;
    end;

  TempTexture2Name := HiResFilename;
  HiResUSGS_RadioButton.Caption  := Substring(IniFile.ReadString('LTVT Defaults','Texture2_Caption',Texture2_DefaultText),1,40);
  if Trim(HiResUSGS_RadioButton.Caption)='' then HiResUSGS_RadioButton.Caption := Texture2_DefaultText;
  HiResFilename  := IniFile.ReadString('LTVT Defaults','High_Resolution_USGS_Relief_Map','');
  if HiResFilename<>'' then
    begin
      IniFile.WriteString('LTVT Defaults','Texture2_File',HiResFilename);
      IniFile.DeleteKey('LTVT Defaults','High_Resolution_USGS_Relief_Map');
    end;
  HiResFilename  := FullFilename(IniFile.ReadString('LTVT Defaults','Texture2_File','hires.jpg'));
  if TempTexture2Name<>HiResFilename then
    begin
      HiRes_TextureMap.Free;
      HiRes_Texture_Loaded := False;
      HiResUSGS_RadioButton.Font.Color := clGray;
    end;

  TempTexture3Name := ClementineFilename;
  Clementine_RadioButton.Caption  := Substring(IniFile.ReadString('LTVT Defaults','Texture3_Caption',Texture3_DefaultText),1,40);
  if Trim(Clementine_RadioButton.Caption)='' then Clementine_RadioButton.Caption := Texture3_DefaultText;
  ClementineFilename := IniFile.ReadString('LTVT Defaults','Clementine_Texture_Map','');
  if ClementineFilename<>'' then
    begin
      IniFile.WriteString('LTVT Defaults','Texture3_File',ClementineFilename);
      IniFile.DeleteKey('LTVT Defaults','Clementine_Texture_Map');
    end;
  ClementineFilename := FullFilename(IniFile.ReadString('LTVT Defaults','Texture3_File','hires_clem.jpg'));
  if TempTexture3Name<>ClementineFilename then
    begin
      Clementine_TextureMap.Free;
      Clementine_Texture_Loaded := False;
      Clementine_RadioButton.Font.Color := clGray;
    end;

  Tex3MinLonText := IniFile.ReadString('LTVT Defaults','Texture3_MinLon_deg',Tex3MinLon_DefaultText);
  Tex3MaxLonText := IniFile.ReadString('LTVT Defaults','Texture3_MaxLon_deg',Tex3MaxLon_DefaultText);
  Tex3MinLatText := IniFile.ReadString('LTVT Defaults','Texture3_MinLat_deg',Tex3MinLat_DefaultText);
  Tex3MaxLatText := IniFile.ReadString('LTVT Defaults','Texture3_MaxLat_deg',Tex3MaxLat_DefaultText);

  TempEarthTextureName := EarthTextureFilename;
  EarthTextureFilename := FullFilename(IniFile.ReadString('LTVT Defaults','EarthTexture_File','land_shallow_topo_2048.jpg'));
  if TempEarthTextureName<>EarthTextureFilename then
    begin
      Earth_TextureMap.Free;
      Earth_Texture_Loaded := False;
    end;

  IniFile.Free;
end;   {TTerminator_Form.RestoreFileOptions}

procedure TTerminator_Form.WriteFileOptionsToForm;
begin
//  ShowMessage('Copying options to form...');
  with ExternalFileSelection_Form do
    begin
      WineCompatibility_CheckBox.Checked := LinuxCompatibilityMode;

      Texture1Description_Edit.Text := LoResUSGS_RadioButton.Caption;
      TempTexture1Name := LoResFilename;
      Texture2Description_Edit.Text := HiResUSGS_RadioButton.Caption;
      TempTexture2Name := HiResFilename;
      Texture3Description_Edit.Text := Clementine_RadioButton.Caption;
      TempTexture3Name := ClementineFilename;
      Tex3MinLon_LabeledNumericEdit.NumericEdit.Text := Tex3MinLonText;
      Tex3MaxLon_LabeledNumericEdit.NumericEdit.Text := Tex3MaxLonText;
      Tex3MinLat_LabeledNumericEdit.NumericEdit.Text := Tex3MinLatText;
      Tex3MaxLat_LabeledNumericEdit.NumericEdit.Text := Tex3MaxLatText;
      TempEarthTextureName := EarthTextureFilename;

      TempDotFilename := CraterFilename;
      H_Terminator_Goto_Form.MinimizeGotoList_CheckBox.Checked :=
        (ExtractFileName(CraterFilename)='ClementineAltimeterData.csv') or (ExtractFileName(CraterFilename)='2005_ULCN.csv');

// check if Photo Sessions Search form has been used, if so, adopt current name in it.
// otherwise retain name probably read from LTVT.ini .
      if PhotosessionSearch_Form.PhotoSessionsFilename<>'' then
        NormalPhotoSessionsFilename := PhotosessionSearch_Form.PhotoSessionsFilename;
      TempNormalPhotoSessionsFilename := NormalPhotoSessionsFilename;

      TempCalibratedPhotosFilename := CalibratedPhotosFilename;
      TempObservatoryListFilename := ObservatoryListFilename;

      TempEphemerisFilename := JPL_Filename;
      TempTAIFilename := TAIOffsetFile.FileName;
    end;
end;

procedure TTerminator_Form.ReadFileOptionsFromForm;
var
  SelectedFilename : String;
begin
  with ExternalFileSelection_Form do
    begin
      if WineCompatibility_CheckBox.Checked<>LinuxCompatibilityMode then
        begin
          LinuxCompatibilityMode := WineCompatibility_CheckBox.Checked;
          FileSettingsChanged := True;
        end;

      LoResUSGS_RadioButton.Caption := Texture1Description_Edit.Text;
      if TempTexture1Name<>LoResFilename then
        begin
          LoRes_TextureMap.Free;
          LoRes_Texture_Loaded := False;
          LoResUSGS_RadioButton.Font.Color := clGray;
          LoResFilename := TempTexture1Name;
          FileSettingsChanged := True;
        end;

      HiResUSGS_RadioButton.Caption := Texture2Description_Edit.Text;
      if TempTexture2Name<>HiResFilename then
        begin
          HiRes_TextureMap.Free;
          HiRes_Texture_Loaded := False;
          HiResUSGS_RadioButton.Font.Color := clGray;
          HiResFilename := TempTexture2Name;
          FileSettingsChanged := True;
        end;

      Clementine_RadioButton.Caption := Texture3Description_Edit.Text;
      if TempTexture3Name<>ClementineFilename then
        begin
          Clementine_TextureMap.Free;
          Clementine_Texture_Loaded := False;
          Clementine_RadioButton.Font.Color := clGray;
          ClementineFilename := TempTexture3Name;
          FileSettingsChanged := True;
        end;

      Tex3MinLonText := Tex3MinLon_LabeledNumericEdit.NumericEdit.Text;
      Tex3MaxLonText := Tex3MaxLon_LabeledNumericEdit.NumericEdit.Text;
      Tex3MinLatText := Tex3MinLat_LabeledNumericEdit.NumericEdit.Text;
      Tex3MaxLatText := Tex3MaxLat_LabeledNumericEdit.NumericEdit.Text;

      if TempEarthTextureName<>EarthTextureFilename then
        begin
          Earth_TextureMap.Free;
          Earth_Texture_Loaded := False;
          EarthTextureFilename := TempEarthTextureName;
          FileSettingsChanged := True;
        end;

      if TempDotFilename<>CraterFilename then
        begin
          CraterFilename := TempDotFilename;
          FileSettingsChanged := True;
          SelectedFilename := ExtractFileName(CraterFilename);
          H_Terminator_Goto_Form.MinimizeGotoList_CheckBox.Checked :=
            (SelectedFilename='ClementineAltimeterData.csv') or (SelectedFilename='2005_ULCN.csv');
        end;

      if TempNormalPhotoSessionsFilename<>NormalPhotoSessionsFilename then
        begin
          NormalPhotoSessionsFilename := TempNormalPhotoSessionsFilename;
          PhotosessionSearch_Form.PhotoSessionsFilename := NormalPhotoSessionsFilename;
          FileSettingsChanged := True;
        end;

      if TempCalibratedPhotosFilename<>CalibratedPhotosFilename then
        begin
          CalibratedPhotosFilename := TempCalibratedPhotosFilename;
          FileSettingsChanged := True;
        end;

      if TempObservatoryListFilename<>ObservatoryListFilename then
        begin
          ObservatoryListFilename := TempObservatoryListFilename;
          FileSettingsChanged := True;
        end;

      if TempEphemerisFilename<>JPL_Filename then
        begin
          JPL_Filename := TempEphemerisFilename;
          JPL_FilePath := ExtractFilePath(JPL_Filename);
          FileSettingsChanged := True;
        end;

      if TempTAIFilename<>TAIOffsetFile.FileName then
        begin
          TAIOffsetFile.SetFile(TempTAIFilename);
          FileSettingsChanged := True;
        end;

    end;
end;

procedure TTerminator_Form.SetLocation_ButtonClick(Sender: TObject);
begin
  FocusControl(MousePosition_GroupBox); // need to remove focus or button will remain pictured in a depressed state
  WriteLocationOptionsToForm;
  SetObserverLocation_Form.ShowModal;
  if not SetObserverLocation_Form.ActionCanceled then ReadLocationOptionsFromForm;
end;

procedure TTerminator_Form.SaveLocationOptions;
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);
  IniFile.WriteString('LTVT Defaults','Geocentric_Observer',BooleanToYesNo(GeocentricSubEarthMode));
  IniFile.WriteString('LTVT Defaults','Observer_East_Longitude',ObserverLongitudeText);
  IniFile.WriteString('LTVT Defaults','Observer_North_Latitude',ObserverLatitudeText);
  IniFile.WriteString('LTVT Defaults','Observer_Elevation',ObserverElevationText);
  IniFile.Free;
end;

procedure TTerminator_Form.RestoreLocationOptions;
const
  Longitude_DefaultText = '0.000';
  Latitude_DefaultText = '0.000';
  Elevation_DefaultText = '0.0';
var
  IniFile : TIniFile;
begin
  IniFile := TIniFile.Create(IniFileName);

  GeocentricSubEarthMode := YesNoToBoolean(IniFile.ReadString('LTVT Defaults','Geocentric_Observer','yes'));
  ObserverLongitudeText := Trim(IniFile.ReadString('LTVT Defaults','Observer_East_Longitude',Longitude_DefaultText));
  ObserverLatitudeText := Trim(IniFile.ReadString('LTVT Defaults','Observer_North_Latitude',Latitude_DefaultText));
  ObserverElevationText := Trim(IniFile.ReadString('LTVT Defaults','Observer_Elevation',Elevation_DefaultText));

  if ObserverLongitudeText='' then ObserverLongitudeText := Longitude_DefaultText;
  if ObserverLatitudeText='' then ObserverLatitudeText := Latitude_DefaultText;
  if ObserverElevationText='' then ObserverElevationText := Elevation_DefaultText;

  IniFile.Free;
end;

procedure TTerminator_Form.WriteLocationOptionsToForm;
begin
  with SetObserverLocation_Form do
    begin
      Geocentric_RadioButton.Checked := GeocentricSubEarthMode;
      UserSpecified_RadioButton.Checked := not Geocentric_RadioButton.Checked;
      ObserverLongitude_LabeledNumericEdit.NumericEdit.Text := ObserverLongitudeText;
      ObserverLatitude_LabeledNumericEdit.NumericEdit.Text := ObserverLatitudeText;
      ObserverElevation_LabeledNumericEdit.NumericEdit.Text := ObserverElevationText;
    end;
end;

procedure TTerminator_Form.ReadLocationOptionsFromForm;
begin
  with SetObserverLocation_Form do
    begin
      GeocentricSubEarthMode := Geocentric_RadioButton.Checked;
      ObserverLongitudeText := ObserverLongitude_LabeledNumericEdit.NumericEdit.Text;
      ObserverLatitudeText := ObserverLatitude_LabeledNumericEdit.NumericEdit.Text;
      ObserverElevationText := ObserverElevation_LabeledNumericEdit.NumericEdit.Text;
      EstimateData_Button.Click;
    end;
end;

procedure TTerminator_Form.Saveoptions_MainMenuItemClick(Sender: TObject);
var
  IniFile : TIniFile;

begin  {Saveoptions_MainMenuItemClick}
  if MessageDlg('Save all current settings as defaults?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    begin
      IniFile := TIniFile.Create(IniFileName);

      if DrawingMode=DotMode then
        IniFile.WriteString('LTVT Defaults','Draw_Dots_on_Startup','yes')
      else
        IniFile.WriteString('LTVT Defaults','Draw_Dots_on_Startup','no');

      IniFile.WriteString('LTVT Defaults','Feature_size_threshold',CraterThreshold_LabeledNumericEdit.NumericEdit.Text);

      IniFile.Free;

      SaveCartographicOptions;
      SaveDefaultLabelOptions;
      SaveMouseOptions;
      SaveFileOptions;
      SaveLocationOptions;

    end;
end;   {Saveoptions_MainMenuItemClick}

procedure TTerminator_Form.CalibratePhoto_MainMenuItemClick(Sender: TObject);
begin
  PhotoCalibrator_Form.Show;
end;

procedure TTerminator_Form.Calibrateasatellitephoto1Click(Sender: TObject);
begin
  SatellitePhotoCalibrator_Form.Show;
end;

procedure TTerminator_Form.SearchPhotoSessions_ButtonClick(Sender: TObject);
begin
  with CalibratedPhotoLoader_Form do
    begin
      Sort_CheckBox.Checked := True;
      FilterPhotos_CheckBox.Checked := True;
    end;
  LoadCalibratedPhoto_MainMenuItemClick(Sender);
end;

procedure TTerminator_Form.LoadCalibratedPhoto_MainMenuItemClick(Sender: TObject);
var
  ImageCenterLon, ImageCenterLat : Extended;

  ErrorCode, Ref2XPixel, Ref2YPixel : Integer;
  SubObsLonDeg, SubObsLatDeg, Ref1LonDeg, Ref1LatDeg,
  Ref2LonDeg, Ref2LatDeg, Ref2X, Ref2Y,
  PhotoCenterX, PhotoCenterY,
  PixelDistSqrd, XYDistSqrd,
  RotationAngle,
  SatelliteNLatDeg, SatelliteELonDeg, SatelliteElevKm : Extended;
  GroundPointVector : TVector;

  LoadSuccessful : Boolean;

begin  {TTerminator_Form.LoadCalibratedPhoto_MainMenuItemClick}
  with CalibratedPhotoLoader_Form do
    begin
      PhotoSelected := False;
      if ConvertXYtoLonLat(ImageCenterX,ImageCenterY,ImageCenterLon,ImageCenterLat) then
        begin
          TargetLon_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLon)]);
          TargetLat_LabeledNumericEdit.NumericEdit.Text := Format('%0.2f',[RadToDeg(ImageCenterLat)]);
        end;

      ListPhotos_Button.Click;

      ShowModal;
      if PhotoSelected then
        begin
          LoadSuccessful := True;
          UserPhotoLoaded := False;
          UserPhoto_RadioButton.Font.Color := clGray;
          UserPhotoData := SelectedPhotoData;

          if UserPhotoData.PhotoCalCode='U1' then
            UserPhotoType := Satellite
          else
            UserPhotoType := EarthBased;

          Val(UserPhotoData.InversionCode,UserPhoto_InversionCode,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.SubObsLon,SubObsLonDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.SubObsLat,SubObsLatDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          if UserPhotoType=Satellite then with UserPhotoData do
            begin
              Val(PhotoObsNLatDeg,SatelliteNLatDeg,ErrorCode);
              LoadSuccessful := LoadSuccessful and (ErrorCode=0);

              Val(PhotoObsELonDeg,SatelliteElonDeg,ErrorCode);
              LoadSuccessful := LoadSuccessful and (ErrorCode=0);

              Val(PhotoObsHt,SatelliteElevKm,ErrorCode);
              LoadSuccessful := LoadSuccessful and (ErrorCode=0);

              PolarToVector(DegToRad(SatelliteNLatDeg), DegToRad(SatelliteElonDeg),
                MoonRadius + SatelliteElevKm, SatelliteVector);

              Terminator_Form.PolarToVector(DegToRad(SubObsLatDeg),
                DegToRad(SubObsLonDeg), MoonRadius, GroundPointVector);

              VectorDifference(GroundPointVector,SatelliteVector,UserPhoto_ZPrime_Unit_Vector);

              if VectorMagnitude(UserPhoto_ZPrime_Unit_Vector)=0 then
                begin
                  ShowMessage('Satellite and Ground Point must be at different positions!');
                  Exit
                end;

              NormalizeVector(UserPhoto_ZPrime_Unit_Vector);

              CrossProduct(UserPhoto_ZPrime_Unit_Vector, Uy, UserPhoto_XPrime_Unit_Vector);
              if VectorMagnitude(UserPhoto_XPrime_Unit_Vector)=0 then
                begin
                  CrossProduct(UserPhoto_ZPrime_Unit_Vector, Ux, UserPhoto_XPrime_Unit_Vector);
                end;

              if VectorMagnitude(UserPhoto_XPrime_Unit_Vector)=0 then
                begin // this should never happen
                  ShowMessage('Internal error: unable to establish camera axis');
                  Exit
                end;

              NormalizeVector(UserPhoto_XPrime_Unit_Vector);

              CrossProduct(UserPhoto_ZPrime_Unit_Vector, UserPhoto_XPrime_Unit_Vector, UserPhoto_YPrime_Unit_Vector);

              SubObsLatDeg := RadToDeg(ArcSin(-UserPhoto_ZPrime_Unit_Vector[y]));   // results in radians
              SubObsLonDeg := RadToDeg(ArcTan2(-UserPhoto_ZPrime_Unit_Vector[x],-UserPhoto_ZPrime_Unit_Vector[z]));

              SubObsLat := Format('%0.3f',[SubObsLatDeg]);
              SubObsLon := Format('%0.3f',[PosNegDegrees(SubObsLonDeg)]);
//                  ShowMessage('Sub-obs lon = '+SubObsLon);
            end;

          PolarToVector(DegToRad(SubObsLatDeg),DegToRad(SubObsLonDeg),1,UserPhoto_SubObsVector);
          NormalizeVector(UserPhoto_SubObsVector);

          if UserPhotoType=Earthbased then
            begin
              UserPhoto_ZPrime_Unit_Vector := UserPhoto_SubObsVector;
              CrossProduct(Uy,UserPhoto_ZPrime_Unit_Vector,UserPhoto_XPrime_Unit_Vector);
              if VectorMagnitude(UserPhoto_XPrime_Unit_Vector)=0 then UserPhoto_XPrime_Unit_Vector := Ux;  //UserPhoto_SubObsVector parallel to Uy (looking from over north or south pole)
              NormalizeVector(UserPhoto_XPrime_Unit_Vector);
              CrossProduct(UserPhoto_SubObsVector,UserPhoto_XPrime_Unit_Vector,UserPhoto_YPrime_Unit_Vector);
              MultiplyVector(UserPhoto_InversionCode,UserPhoto_XPrime_Unit_Vector);
            end;


          Val(UserPhotoData.Ref1XPix,UserPhoto_StartXPix,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref1YPix,UserPhoto_StartYPix,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref1Lon,Ref1LonDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref1Lat,Ref1LatDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          LoadSuccessful := LoadSuccessful and ConvertLonLatToUserPhotoXY(DegToRad(Ref1LonDeg),DegToRad(Ref1LatDeg),
            MoonRadius,UserPhoto_StartX,UserPhoto_StartY);

          Val(UserPhotoData.Ref2XPix,Ref2XPixel,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref2YPix,Ref2YPixel,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref2Lon,Ref2LonDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          Val(UserPhotoData.Ref2Lat,Ref2LatDeg,ErrorCode);
          LoadSuccessful := LoadSuccessful and (ErrorCode=0);

          LoadSuccessful := LoadSuccessful and ConvertLonLatToUserPhotoXY(DegToRad(Ref2LonDeg),DegToRad(Ref2LatDeg),
            MoonRadius,Ref2X,Ref2Y);
          PixelDistSqrd := Sqr(Ref2XPixel - UserPhoto_StartXPix) + Sqr(Ref2YPixel - UserPhoto_StartYPix);
          XYDistSqrd := Sqr(Ref2X - UserPhoto_StartX) + Sqr(Ref2Y - UserPhoto_StartY);
          LoadSuccessful := LoadSuccessful and  (PixelDistSqrd<>0) and (XYDistSqrd<>0);

          if not LoadSuccessful then
            begin
              ShowMessage('An error occurred reading the calibration data -- please load a different photo');
              UserPhoto_RadioButton.Hide;
              LoResUSGS_RadioButton.Checked := True;
              Exit;
            end;

          UserPhoto_PixelsPerXYUnit := Sqrt(PixelDistSqrd/XYDistSqrd);

//Note: Y pixels run backwards to Y coordinate on Moon
          RotationAngle :=
            ArcTan2(Ref2Y - UserPhoto_StartY,Ref2X - UserPhoto_StartX)
            - ArcTan2(UserPhoto_StartYPix - Ref2YPixel,Ref2XPixel - UserPhoto_StartXPix);

//          ShowMessage('Rotation = '+FloatToStr(RadToDeg(RotationAngle)));

          UserPhotoSinTheta := Sin(RotationAngle);
          UserPhotoCosTheta := Cos(RotationAngle);

          UserPhoto_RadioButton.Caption := ExtractFileName(UserPhotoData.PhotoFilename);
          UserPhoto_RadioButton.Show;
          UserPhoto_RadioButton.Checked := True;

          if not OverwriteNone_RadioButton.Checked then SetManualGeometryLabels; // will be overwritten if there is a call to EstimateData_Button.Click

          if OverwriteAll_RadioButton.Checked then with SelectedPhotoData do
            begin
              Date_DateTimePicker.Date := PhotoDate;
              Time_DateTimePicker.Time := PhotoTime;
              GeocentricSubEarthMode := False;
              OrientationMode := Cartographic;
              InvertLR := UserPhoto_InversionCode<0;
              InvertUD := False;
//                  ManualRotationDegrees := Sign(UserPhoto_InversionCode)*RadToDeg(RotationAngle);
              RotationAngle_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[Sign(UserPhoto_InversionCode)*RadToDeg(RotationAngle)]);
              Zoom_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[UserPhoto_PixelsPerXYUnit/(JimsGraph1.Width/2)]);
              PhotoCenterX := (UserPhoto_StartX + Ref2X)/2;
              PhotoCenterY := (UserPhoto_StartY + Ref2Y)/2;
//                  ConvertUserPhotoXPixYPixToXY(Ref2XPixel, Ref2YPixel, PhotoCenterX, PhotoCenterY);
              ImageCenterX := UserPhoto_InversionCode*(PhotoCenterX*Cos(RotationAngle) + PhotoCenterY*Sin(RotationAngle));
              ImageCenterY := -PhotoCenterX*Sin(RotationAngle) + PhotoCenterY*Cos(RotationAngle);
              if (PhotoObsHt<>'-999') and (PhotoCalCode<>'U1') then
                begin
                  ObserverLongitudeText := PhotoObsELonDeg;
                  ObserverLatitudeText  := PhotoObsNLatDeg;
                  ObserverElevationText := PhotoObsHt;
                  EstimateData_Button.Click;
                end
              else
                begin
                  SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLon;
                  SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLat;
                  SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
                  SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
                  DrawTexture_Button.Click;
                end;
            end
          else if OverwriteDateTime_RadioButton.Checked then with SelectedPhotoData do
            begin
              Date_DateTimePicker.Date := PhotoDate;
              Time_DateTimePicker.Time := PhotoTime;
              GeocentricSubEarthMode := False;
              if (PhotoObsHt<>'-999') and (PhotoCalCode<>'U1') then
                begin
                  ObserverLongitudeText := PhotoObsELonDeg;
                  ObserverLatitudeText  := PhotoObsNLatDeg;
                  ObserverElevationText := PhotoObsHt;
                  EstimateData_Button.Click;
                end
              else
                begin
                  SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLon;
                  SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLat;
                  SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
                  SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
                  DrawTexture_Button.Click;
                end;
            end
          else if OverwriteGeometry_RadioButton.Checked then with SelectedPhotoData do
            begin
              SubObs_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLon;
              SubObs_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubObsLat;
              SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
              SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
              DrawTexture_Button.Click;
            end
          else if SunAngleOnly_RadioButton.Checked then with SelectedPhotoData do
            begin
              SubSol_Lon_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLon;
              SubSol_Lat_LabeledNumericEdit.NumericEdit.Text := UserPhotoData.SubSolLat;
              DrawTexture_Button.Click;
            end
          else
            DrawTexture_Button.Click;
        end;
    end;

end;   {TTerminator_Form.LoadCalibratedPhoto_MainMenuItemClick}

procedure TTerminator_Form.OpenAnLTOchart1Click(Sender: TObject);
begin
  LTO_Viewer_Form.Show;
end;

function TTerminator_Form.LTO_SagCorrectionDeg(const DelLonDeg, LatDeg : Extended) : Extended;
{amount to be added to true Latitude to get Latitude as read on central meridian;
 DelLonDeg = displacement in longitude from center of map}
begin
  Result := 0.045*Sin(DegToRad(LatDeg))*Sqr((DelLonDeg)/2.5);
end;

function TTerminator_Form.ConvertLTOLonLatToXY(const LTO_LonDeg, LTO_LatDeg : Extended; var LTO_XPix, LTO_YPix : Integer) : Boolean;
var
  DelLon, DelX, DelY, TrueX, TrueY, RawX, RawY, Tangent, Rho : Extended;
begin
  Result := False;

  case LTO_MapMode of
    LTO_map :
      begin
        DelLon := LTO_LonDeg - LTO_CenterLon;
        while DelLon>180 do DelLon := DelLon - 360;
        while DelLon<-180 do DelLon := DelLon + 360;
        DelX := DelLon*LTO_HorzPixPerDeg*Cos(DegToRad(LTO_LatDeg));
        DelY := (LTO_LatDeg - LTO_CenterLat + LTO_SagCorrectionDeg(DelLon,LTO_LatDeg))*LTO_VertPixPerDeg ;
        LTO_XPix := Round(LTO_CenterXPix + DelX*LTO_CosTheta - DelY*LTO_SinTheta);
        LTO_YPix := Round(LTO_CenterYPix + DelX*LTO_SinTheta + DelY*LTO_CosTheta);
        Result := True;
      end;

    Mercator_map :
      begin
        DelLon := LTO_LonDeg - LTO_CenterLon;
        while DelLon>180 do DelLon := DelLon - 360;
        while DelLon<-180 do DelLon := DelLon + 360;
        TrueX := LTO_CenterXPix + LTO_MercatorScaleFactor*DegToRad(DelLon);
        Tangent := Tan((PiByTwo +DegToRad(LTO_LatDeg))/2);
        if Tangent>0 then
          begin
            TrueY := LTO_CenterYPix - LTO_MercatorScaleFactor*Ln(Tangent);
            RawX := TrueX*LTO_CosTheta - TrueY*LTO_SinTheta;  // this is the inverse of the rotation in the LTO_Viewer
            RawY := TrueX*LTO_SinTheta + TrueY*LTO_CosTheta;
            RawY := RawY*LTO_VertCorrection;  // note, LTO_VertCorrection is the reciprocal of VertCorrection in the LTO viewer

            LTO_XPix := Round(RawX);
            LTO_YPix := Round(RawY);
            Result := True;
          end;
      end;

    Lambert_map :
      begin
        DelLon := LTO_LonDeg - LTO_CenterLon;
        while DelLon>180 do DelLon := DelLon - 360;
        while DelLon<-180 do DelLon := DelLon + 360;
        Tangent := Tan((PiByTwo + DegToRad(LTO_LatDeg))/2);
        if Tangent>0 then
          begin
            Rho := LTO_Lambert_F/Power(Tangent,LTO_Lambert_n);

            TrueX := LTO_CenterXPix + LTO_Lambert_ScaleFactor*Rho*Sin(LTO_Lambert_n*DegToRad(DelLon));
            TrueY := LTO_CenterYPix - LTO_Lambert_ScaleFactor*(LTO_Lambert_Rho_zero - Rho*Cos(LTO_Lambert_n*DegToRad(DelLon)));

            RawX := TrueX*LTO_CosTheta - TrueY*LTO_SinTheta;  // this is the inverse of the rotation in the LTO_Viewer
            RawY := TrueX*LTO_SinTheta + TrueY*LTO_CosTheta;
            RawY := RawY*LTO_VertCorrection;  // note, LTO_VertCorrection is the reciprocal of VertCorrection in the LTO viewer

            LTO_XPix := Round(RawX);
            LTO_YPix := Round(RawY);
            Result := True;
          end;
      end;

    end;
end;

procedure TTerminator_Form.DrawLimb_MainMenuItemClick(Sender: TObject);
var
  Theta : Extended;
  SubObsPoint, SubSolPoint : TPolarCoordinates;
begin
  if ShowingEarth then
    begin
      ShowMessage('This tool is not intended for use with Earth images');
      Exit;
    end;

  if not CalculateSubPoints(DateTimeToModifiedJulianDate(DateOf(Date_DateTimePicker.Date) + TimeOf(Time_DateTimePicker.Time)),
    ExtendedValue(ObserverLongitudeText),ExtendedValue(ObserverLatitudeText),ExtendedValue(ObserverElevationText),
    SubObsPoint,SubSolPoint) then exit;

  Theta := ArcCos(MoonRadius*OneKm/OneAU/ObserverToMoonAU);  // angle from sub-observer point to limb [rad]

  with CircleDrawing_Form do
    begin
      LonDeg_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubObsPoint.Longitude)]);
      LatDeg_LabeledNumericEdit.NumericEdit.Text := Format('%0.3f',[RadToDeg(SubObsPoint.Latitude)]);
      Diam_LabeledNumericEdit.NumericEdit.Text := Format('%0.1f',[2*Theta*MoonRadius]);
      DrawCircle_Button.Click;
    end;
end;

procedure TTerminator_Form.DrawRuklGrid1Click(Sender: TObject);
{note: this is a simplified routine that works only for a zero libration view}
var
  I : Integer;
  X, Y : Extended;
  WantRuklSubgrid : Boolean;
begin
  if not ((SubObs_Lon_LabeledNumericEdit.NumericEdit.ExtendedValue=0)
   and (SubObs_Lat_LabeledNumericEdit.NumericEdit.ExtendedValue=0))
     and (MessageDlg('Rükl grid is valid only for zero libration views',mtWarning,mbOKCancel,0)=mrCancel) then
       Exit;

  WantRuklSubgrid := not H_Terminator_Goto_Form.Center_RadioButton.Checked; // assume subgrid is wanted only after a GoTo to a quadrant

  with JimsGraph1 do
    begin
      with Canvas do
        begin
          Pen.Color := clWhite;

          X := -1;
          for I := 1 to (NumRuklCols+1) do
            begin
              Pen.Style := psSolid;
              MoveTo(XPix(X),YPix(1));
              LineTo(XPix(X),YPix(-1));    // note: LineTo stops short of destination by 1 pixel

              if WantRuklSubgrid then
                begin
                  X := X + RuklXiStep/2;
                  Pen.Style := psDashDot;
                  MoveTo(XPix(X),YPix(1));
                  LineTo(XPix(X),YPix(-1));    // note: LineTo stops short of destination by 1 pixel
                  X := X + RuklXiStep/2;
                end
              else
                X := X + RuklXiStep;

            end;

          Y := 1;
          for I := 1 to (NumRuklCols+1) do
            begin
              Pen.Style := psSolid;
              MoveTo(XPix(-1),YPix(Y));
              LineTo(XPix(1),YPix(Y));    // note: LineTo stops short of destination by 1 pixel

              if WantRuklSubgrid then
                begin
                  Y := Y - RuklEtaStep/2;
                  Pen.Style := psDashDot;
                  MoveTo(XPix(-1),YPix(Y));
                  LineTo(XPix(1),YPix(Y));    // note: LineTo stops short of destination by 1 pixel
                  Y := Y - RuklEtaStep/2;
                end
              else
                  Y := Y - RuklEtaStep;
            end;

          Pen.Style := psSolid; // probably not necessary if other routines set desired style

        end;
    end;
end;

procedure TTerminator_Form.Image_PopupMenuPopup(Sender: TObject);

  procedure SetItems(const DesiredState : Boolean);
    begin
      MouseOptions_RightClickMenuItem.Visible := DesiredState;
      DrawLinesToPoleAndSun_RightClickMenuItem.Visible := DesiredState;
//      Goto_RightClickMenuItem.Visible := DesiredState;
      IdentifyNearestFeature_RightClickMenuItem.Visible := DesiredState;
      LabelFeatureAndSatellites_RightClickMenuItem.Visible := DesiredState;
      LabelNearestDot_RightClickMenuItem.Visible := DesiredState;
      CountDots_RightClickMenuItem.Visible := DesiredState;
      DrawCircle_RightClickMenuItem.Visible := DesiredState;
      SetRefPt_RightClickMenuItem.Visible := DesiredState;
      NearestDotToReferencePoint_RightClickMenuItem.Visible := DesiredState;
      Recordshadowmeasurement_RightClickMenuItem.Visible := DesiredState;
    end;
    
begin
  if ShowingEarth then
    SetItems(False)  // hide most options
  else
    begin
      SetItems(True);  // make same options visible
      Recordshadowmeasurement_RightClickMenuItem.Visible :=
        (RefPtReadoutMode=ShadowLengthRefPtMode) or (RefPtReadoutMode=InverseShadowLengthRefPtMode);
    end;
end;

procedure TTerminator_Form.ShowEarth_MainMenuItemClick(Sender: TObject);
var
  UT_MJD : extended;
  SubLunar, SubSolar : TPolarCoordinates;
  TempPicture : TPicture;
  ScaledMap : TBitMap;

  MapPtr : ^TBitmap;

  i, j,                {screen coords}
  RawXPix, RawYPix  : Integer;

  Lat, Lon,            {selenographic latitude, longitude [radians]}
  MinLon, MaxLon, MinLat, MaxLat,  {of TextureMap}
  XPixPerRad, YPixPerRad,  {of TextureMap}
  Y, Gamma  : Extended;

  RawRow, ScaledRow  :  pRGBArray;

  SkyPixel, NoDataPixel : TRGBTriple;

function GeographicLatitude(const VectorLatitude : Extended) : Extended;
  const
  // WGS-84 values from http://www.movable-type.co.uk/scripts/latlong-vincenty.html
  // for others see http://en.wikipedia.org/wiki/Figure_of_the_Earth
    a = 6378137.0;    // [km]
    b = 6356752.3142;
    ab_ratio_sqrd = (a*a)/(b*b);
  begin
    if VectorLatitude>=PiByTwo then
      Result := PiByTwo
    else if VectorLatitude<=-PiByTwo then
      Result := -PiByTwo
    else
    // formula verified at  http://bse.unl.edu/adamchuk/web_ssm/web_GPS_eq.html
      Result := ArcTan(ab_ratio_sqrd*Tan(VectorLatitude));
  end;

begin {TTerminator_Form.ShowEarth_MainMenuItemClick}
  ImageDate := DateOf(Date_DateTimePicker.Date);
  ImageTime := TimeOf(Time_DateTimePicker.Time);

// Note time correction is needed to make results agree with JPL Ephemeris and maximum zenith elevation in mouseover
  UT_MJD := DateTimeToModifiedJulianDate(ImageDate + ImageTime) - 1.5*OneMinute/OneDay; // add empirical time correction

  if not EphemerisDataAvailable(UT_MJD) then
    begin
      ShowMessage('Cannot estimate geometry -- ephemeris file not loaded');
      Exit;
    end;

  SubLunar := SubLunarPointOnEarth(UT_MJD);
  SubSolar := SubSolarPointOnEarth(UT_MJD);

  PolarToVector(SubLunar.Latitude,SubLunar.Longitude,1,SubObsvrVector);
  PolarToVector(SubSolar.Latitude,SubSolar.Longitude,1,SubSolarVector);

  with SubLunar do   // for labeling if image is saved
    begin
      ImageSubObsLon := Longitude;
      ImageSubObsLat := GeographicLatitude(Latitude);
    end;

  with SubSolar do
    begin
      ImageSubSolLon := Longitude;
      ImageSubSolLat := GeographicLatitude(Latitude);
    end;

{
  ShowMessage(Format('Sun at %0.3f, %0.3f (%0.3f)'+CR+'Moon at %0.3f, %0.3f (%0.3f)',
    [RadToDeg(SubSolar.Longitude),RadToDeg(SubSolar.Latitude),RadToDeg(GeographicLatitude(SubSolar.Latitude)),
    RadToDeg(SubLunar.Longitude),RadToDeg(SubLunar.Latitude),RadToDeg(GeographicLatitude(SubLunar.Latitude))]));
}

  PolarToVector(GeographicLatitude(SubLunar.Latitude), SubLunar.Longitude, 1, ZPrime_UnitVector); {sub-observer point}

  NormalizeVector(ZPrime_UnitVector);

  CrossProduct(Uy,ZPrime_UnitVector,XPrime_UnitVector);
  if VectorMagnitude(XPrime_UnitVector)=0 then XPrime_UnitVector := Ux;  //ZPrime_UnitVector parallel to Uy (looking from over north or south pole)
  NormalizeVector(XPrime_UnitVector);
  CrossProduct(ZPrime_UnitVector,XPrime_UnitVector,YPrime_UnitVector);

  Gamma := Gamma_LabeledNumericEdit.NumericEdit.ExtendedValue;
  if Gamma<>0 then
    Gamma := 1/Gamma
  else
    Gamma := 1000;

  ClearImage;

  SkyPixel := ColorToRGBTriple(SkyColor);
  NoDataPixel := ColorToRGBTriple(NoDataColor);

  if not Earth_Texture_Loaded then
    begin
      OldFilename := EarthTextureFilename;
      Earth_TextureMap := TBitmap.Create;

      if (not FileExists(EarthTextureFilename)) and (MessageDlg('LTVT cannot find the Earth texture map'+CR
                        +'   Do you want help with this?',
          mtWarning,[mbYes,mbNo],0)=mrYes) then
            begin
              HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/TextureFilesStepByStep.htm'),HH_DISPLAY_TOPIC, 0);
            end;

      if FileExists(EarthTextureFilename) or PictureFileFound('Earth Texture File','land_shallow_topo_2048.jpg',EarthTextureFilename) then
        begin
          Screen.Cursor := crHourGlass;
          StatusLine_Label.Caption := 'Please wait, reading texture file...';
          Application.ProcessMessages;
          TempPicture := TPicture.Create;
          TempPicture.OnProgress := ImageLoadProgress;
//          TempPicture.Bitmap.PixelFormat := pf24bit; // doesn't help
          TRY
            TRY
              TempPicture.LoadFromFile(EarthTextureFilename);
              if LinuxCompatibilityMode then
                begin
                  Earth_TextureMap.Width  := TempPicture.Graphic.Width;
                  Earth_TextureMap.Height := TempPicture.Graphic.Height;
                  Earth_TextureMap.PixelFormat := pf24bit;
                  Earth_TextureMap.Canvas.Draw(0,0, TempPicture.Graphic);
                end
              else
                begin
                  Earth_TextureMap.Assign(TempPicture.Graphic);
                  Earth_TextureMap.PixelFormat := pf24bit;  // Note: this seems essential and needs to be done AFTER loading the graphic
                    // but it significantly slows down the loading of the image, particularly if it is already in BMP format.
                end;
              Earth_Texture_Loaded := true;
            EXCEPT
              ShowMessage('Unable to load "'+EarthTextureFilename+'"');
            END;

          FINALLY
            TempPicture.Free;
            StatusLine_Label.Caption := '';
            Application.ProcessMessages;
            Screen.Cursor := DefaultCursor;
          END;
        end;

      if EarthTextureFilename<>OldFilename then FileSettingsChanged := True;
    end;

  MapPtr := @Earth_TextureMap;
  TextureFilename := EarthTextureFilename;

  if MapPtr=nil then
    begin
      ShowMessage('No texture map loaded -- drawing map in Dots mode');
      DrawDots_Button.Click;
    end
  else
    begin
      DrawingMap_Label.Caption := 'Drawing texture map...';
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      ProgressBar1.Max := JimsGraph1.Height-1;
      ProgressBar1.Step := 1;
      ProgressBar1.Show;
      DrawCircles_CheckBox.Hide;
      MarkCenter_CheckBox.Hide;

      MinLon := DegToRad(-180);
      MaxLon := DegToRad(180);
      MinLat := DegToRad(-90);
      MaxLat := DegToRad(90);

      XPixPerRad := MapPtr^.Width/(MaxLon - MinLon);
      YPixPerRad := MapPtr^.Height/(MaxLat - MinLat);

      JimsGraph1.SetRange(-1,1,-1,1);

//      ShowMessage(Format('Min lon: %0.3f  Max Lon: %0.3f  ppd: %0.3f',[RadToDeg(MinLon),RadToDeg(MaxLon),XPixPerRad*DegToRad(1)]));

      ScaledMap := TBitmap.Create;
      ScaledMap.PixelFormat := pf24bit;
      ScaledMap.Height := JimsGraph1.Height;
      ScaledMap.Width := JimsGraph1.Width;

      for j := 0 to JimsGraph1.Height-1 do with JimsGraph1 do
        begin
    //      Application.ProcessMessages;
          ProgressBar1.StepIt;
          Y := YValue(j);
          ScaledRow := ScaledMap.ScanLine[j];

          for i := 0 to JimsGraph1.Width-1 do
            begin
              if ConvertXYtoLonLat(XValue(i),Y,Lon,Lat) then {point is inside circle, want to draw}
                begin
                      RawXPix := Trunc((Lon - MinLon)*XPixPerRad);
                      RawYPix := Trunc((MaxLat - Lat)*YPixPerRad);

                   // wrap around if necessary
                      while RawXPix<0 do RawXPix := RawXPix + MapPtr^.Width;
                      while RawXPix>(MapPtr^.Width-1) do RawXPix := RawXPix - MapPtr^.Width;
                      while RawYPix<0 do RawYPix := RawYPix + MapPtr^.Height;
                      while RawYPix>(MapPtr^.Height-1) do RawYPix := RawYPix - MapPtr^.Height;

                      RawRow := MapPtr^.ScanLine[RawYPix];
                      ScaledRow[i] := RawRow[RawXPix];
                      GammaCorrectPixelValue(ScaledRow[i],Gamma);
                end
              else if SkyColor<>clWhite then
                begin
                  ScaledRow[i] := SkyPixel;  // generates background of specified color outside image area
                end;
            end;

        end;

      JimsGraph1.Canvas.Draw(0,0,ScaledMap);

      ScaledMap.Free;

      DrawCircle(RadToDeg(SubSolar.Longitude),RadToDeg(SubSolar.Latitude),RadToDeg(Pi/2-SunRad),clRed); // Evening terminator
      DrawCircle(RadToDeg(SubSolar.Longitude),RadToDeg(SubSolar.Latitude),RadToDeg(Pi/2+SunRad),clBlue); // Morning terminator

      MarkXY(0,0,ReferencePointColor);

      ProgressBar1.Hide;
      DrawCircles_CheckBox.Show;
      MarkCenter_CheckBox.Show;
      DrawingMap_Label.Caption := '';
      Screen.Cursor := DefaultCursor;

      ShowingEarth := True;
    end;


end;  {TTerminator_Form.ShowEarth_MainMenuItemClick}

function TTerminator_Form.EphemerisDataAvailable(const MJD : Extended) : Boolean;
var
  JED : Extended;

  procedure LookForJPLFile;
    var
      JPL_Year : integer;
    begin  // try to silently load another file
      JPL_Year := Round(YearOf(Date_DateTimePicker.Date));
      FindAndLoadJPL_File(JPL_FilePath+'UNXP'+IntToStr(50*(JPL_Year div 50))+'.405');
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

begin {TTerminator_Form.EphemerisDataAvailable}
  Result := False;

  if not EphemerisFileLoaded then
    begin
      FindAndLoadJPL_File(JPL_Filename);  // load default file if it has not yet been done
      if EphemerisFileLoaded then
        begin
          JPL_Filename := EphemerisFilname;
          JPL_FilePath := ExtractFilePath(EphemerisFilname);
        end;
    end;

  JED := MJD + MJDOffset;

  if EphemerisFileLoaded and ((JED<SS[1]) or (JED>SS[2])) then
  {JED = requested Julian date;  SS[1] = start date of file; SS[2] = end date of file}
    LookForJPLFile;

  if EphemerisFileLoaded and ((JED<SS[1]) or (JED>SS[2])) then
    begin // ask for assistance only if necessary
      if MessageDlg(format('Unable to estimate geometry: requested date is not within ephemeris file limits of %0s to %0s',
        [DateToStr(JulianDateToDateTime(SS[1])),DateToStr(JulianDateToDateTime(SS[2]))])
        +' Load a different JPL file?',mtConfirmation,mbOKCancel,0)=mrOK then
        LookForJPLFile
      else
        Exit;
    end;

  if (not EphemerisFileLoaded) or ((JED<SS[1]) or (JED>SS[2])) then
    begin
//      ShowMessage('Cannot estimate geometry -- ephemeris file not loaded');
      Exit;
    end;

  Result := True;

end;   {TTerminator_Form.EphemerisDataAvailable}

procedure TTerminator_Form.DisplayF1Help(const PressedKey : Word; const ShiftState : TShiftState; const HelpFileName : String);
{launches .chm help on indicated page if PressedKey=F1}
type
  TFormList = (PhotoCalibratorForm, SatellitePhotoCalibratorForm, LTO_ViewerForm,
    MoonEventPredictorForm, LibrationTabulatorForm, PhotosessionSearchForm, Unknown);
const
  LastCallingForm : TFormList = Unknown;
begin
  if PressedKey=VK_F1 then HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/'+HelpFileName),HH_DISPLAY_TOPIC, 0);
  if (ssCtrl in ShiftState) and (PressedKey=VK_TAB) then
    begin //  CTRL-Tab pressed
      if not Terminator_Form.Active then
        begin
          if PhotoCalibrator_Form.Active then
            LastCallingForm := PhotoCalibratorForm
          else if SatellitePhotoCalibrator_Form.Active then
            LastCallingForm := SatellitePhotoCalibratorForm
          else if LTO_Viewer_Form.Active then
            LastCallingForm := LTO_ViewerForm
          else if MoonEventPredictor_Form.Active then
            LastCallingForm := MoonEventPredictorForm
          else if LibrationTabulator_Form.Active then
            LastCallingForm := LibrationTabulatorForm
          else if PhotosessionSearch_Form.Active then
            LastCallingForm := PhotosessionSearchForm;

          Terminator_Form.Show
        end
      else // Terminator_Form active
        begin
          case LastCallingForm of
            PhotoCalibratorForm :    PhotoCalibrator_Form.Show;
            SatellitePhotoCalibratorForm : SatellitePhotoCalibrator_Form.Show;
            LTO_ViewerForm :         LTO_Viewer_Form.Show;
            MoonEventPredictorForm : MoonEventPredictor_Form.Show;
            LibrationTabulatorForm : LibrationTabulator_Form.Show;
            PhotosessionSearchForm : PhotosessionSearch_Form.Show;
            Unknown :
              begin
                if PhotoCalibrator_Form.Visible then
                  PhotoCalibrator_Form.Show
                else if SatellitePhotoCalibrator_Form.Visible then
                  SatellitePhotoCalibrator_Form.Show
                else if LTO_Viewer_Form.Visible then
                  LTO_Viewer_Form.Show
                else if MoonEventPredictor_Form.Visible then
                  MoonEventPredictor_Form.Show
                else if LibrationTabulator_Form.Visible then
                  MoonEventPredictor_Form.Show
                else if PhotosessionSearch_Form.Visible then
                  PhotosessionSearch_Form.Show;
              end;
            end; {case}
        end;
    end;
end;

procedure TTerminator_Form.Now_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Current_UT');
end;

procedure TTerminator_Form.Date_DateTimePickerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=27 then with Terminator_SetYear_Form do
    begin
      ShowModal;
      if SetYearRequested then
        Date_DateTimePicker.DateTime :=
          EncodeDate(DesiredYear_LabeledNumericEdit.NumericEdit.IntegerValue,
            MonthOf(Date_DateTimePicker.DateTime),DayOf(Date_DateTimePicker.DateTime));
    end
  else
    DisplayF1Help(Key,Shift,'MainForm.htm#Date_Time');
end;

procedure TTerminator_Form.Time_DateTimePickerKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Date_Time');
end;

procedure TTerminator_Form.SetLocation_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Set_Location');
end;

procedure TTerminator_Form.EstimateData_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Compute_Geometry');
end;

procedure TTerminator_Form.SubObs_Lon_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#SubObserver_Location');
end;

procedure TTerminator_Form.SubObs_Lat_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#SubObserver_Location');
end;

procedure TTerminator_Form.SubSol_Lon_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#SubSolar_Location');
end;

procedure TTerminator_Form.SubSol_Lat_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#SubSolar_Location');
end;

procedure TTerminator_Form.CraterThreshold_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Feature_Threshold');
end;

procedure TTerminator_Form.DrawDots_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Dots');
end;

procedure TTerminator_Form.DrawTexture_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Texture');
end;

procedure TTerminator_Form.OverlayDots_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Overlay_Dots');
end;

procedure TTerminator_Form.LabelDots_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Label');
end;

procedure TTerminator_Form.LoResUSGS_RadioButtonKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TTerminator_Form.HiResUSGS_RadioButtonKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TTerminator_Form.Clementine_RadioButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TTerminator_Form.UserPhoto_RadioButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TTerminator_Form.LTO_RadioButtonKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#ReferenceMapSelectors');
end;

procedure TTerminator_Form.Gamma_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Gamma');
end;

procedure TTerminator_Form.Zoom_LabeledNumericEditNumericEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Zoom');
end;

procedure TTerminator_Form.ResetZoom_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Reset');
end;

procedure TTerminator_Form.SaveImage_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Save_Image');
end;

procedure TTerminator_Form.Predict_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Predict');
end;

procedure TTerminator_Form.SearchPhotoSessions_ButtonKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Search_for_Photos');
end;

procedure TTerminator_Form.RotationAngle_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Rotation');
end;

procedure TTerminator_Form.GridSpacing_LabeledNumericEditNumericEditKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Grid');
end;

procedure TTerminator_Form.DrawCircles_CheckBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#Circles');
end;

procedure TTerminator_Form.MarkCenter_CheckBoxKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm#MarkCenter');
end;

procedure TTerminator_Form.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  DisplayF1Help(Key,Shift,'MainForm.htm');
end;

procedure TTerminator_Form.Help_RightClickMenuItemClick(Sender: TObject);
begin
  HtmlHelp(0,PChar(Application.HelpFile+'::/Help Topics/MainForm.htm#Right_Click_Menu'),HH_DISPLAY_TOPIC, 0);
end;

procedure TTerminator_Form.CountDots_RightClickMenuItemClick(
  Sender: TObject);
begin
  ShowMessage('Number of dots in current display: '+IntToStr(Length(CraterInfo)));
end;

end.
