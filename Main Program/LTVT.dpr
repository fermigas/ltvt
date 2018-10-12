program LTVT;

uses
  Forms,
  LTVT_Unit in 'LTVT_Unit.pas' {Terminator_Form},
  LabeledNumericEdit in '..\..\..\..\MyUnits\LabeledNumericEdit.pas' {LabeledNumericEdit: TFrame},
  H_Terminator_About_Unit in 'H_Terminator_About_Unit.pas' {TerminatorAbout_Form},
  H_Terminator_Goto_Unit in 'H_Terminator_Goto_Unit.pas' {H_Terminator_Goto_Form},
  H_Terminator_SetYear_Unit in 'H_Terminator_SetYear_Unit.pas' {Terminator_SetYear_Form},
  H_Terminator_SelectObserverLocation_Unit in 'H_Terminator_SelectObserverLocation_Unit.pas' {SetObserverLocation_Form},
  LibrationTabulator_Unit in 'LibrationTabulator_Unit.pas' {LibrationTabulator_Form},
  H_PhotosessionSearch_Unit in 'H_PhotosessionSearch_Unit.pas' {PhotosessionSearch_Form},
  H_HTMLHelpViewer in 'H_HTMLHelpViewer.pas',
  H_Terminator_LabelFontSelector_Unit in 'H_Terminator_LabelFontSelector_Unit.pas' {LabelFontSelector_Form},
  H_ExternalFileSelection_Unit in 'H_ExternalFileSelection_Unit.pas' {ExternalFileSelection_Form},
  H_CartographicOptions_Unit in 'H_CartographicOptions_Unit.pas' {CartographicOptions_Form},
  H_MouseOptions_Unit in 'H_MouseOptions_Unit.pas' {MouseOptions_Form},
  Satellite_PhotoCalibrator_Unit in 'Satellite_PhotoCalibrator_Unit.pas' {SatellitePhotoCalibrator_Form},
  LTO_Viewer_Unit in 'LTO_Viewer_Unit.pas' {LTO_Viewer_Form},
  H_PhotoCalibrator_Unit in 'H_PhotoCalibrator_Unit.pas' {PhotoCalibrator_Form},
  CircleDrawing_Unit in 'CircleDrawing_Unit.pas' {CircleDrawing_Form},
  H_MoonEventPredictor_Unit in 'H_MoonEventPredictor_Unit.pas' {MoonEventPredictor_Form},
  H_CalibratedPhotoSelector_Unit in 'H_CalibratedPhotoSelector_Unit.pas' {CalibratedPhotoLoader_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'LTVT';
  Application.HelpFile := 'C:\Program Files\Borland\Delphi6\Projects\MyProjects\Astron\Henrik Terminator\LTVT Version 0_2\LTVT_UserGuide.chm';
  Application.CreateForm(TTerminator_Form, Terminator_Form);
  Application.CreateForm(TTerminatorAbout_Form, TerminatorAbout_Form);
  Application.CreateForm(TH_Terminator_Goto_Form, H_Terminator_Goto_Form);
  Application.CreateForm(TTerminator_SetYear_Form, Terminator_SetYear_Form);
  Application.CreateForm(TSetObserverLocation_Form, SetObserverLocation_Form);
  Application.CreateForm(TLibrationTabulator_Form, LibrationTabulator_Form);
  Application.CreateForm(TPhotosessionSearch_Form, PhotosessionSearch_Form);
  Application.CreateForm(TLabelFontSelector_Form, LabelFontSelector_Form);
  Application.CreateForm(TExternalFileSelection_Form, ExternalFileSelection_Form);
  Application.CreateForm(TCartographicOptions_Form, CartographicOptions_Form);
  Application.CreateForm(TMouseOptions_Form, MouseOptions_Form);
  Application.CreateForm(TSatellitePhotoCalibrator_Form, SatellitePhotoCalibrator_Form);
  Application.CreateForm(TLTO_Viewer_Form, LTO_Viewer_Form);
  Application.CreateForm(TPhotoCalibrator_Form, PhotoCalibrator_Form);
  Application.CreateForm(TCircleDrawing_Form, CircleDrawing_Form);
  Application.CreateForm(TMoonEventPredictor_Form, MoonEventPredictor_Form);
  Application.CreateForm(TCalibratedPhotoLoader_Form, CalibratedPhotoLoader_Form);
  Application.Run;
end.
