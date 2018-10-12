unit H_HTMLHelpViewer;

interface

uses Windows;

const
  HH_DISPLAY_TOPIC        = $0000;
  HH_DISPLAY_TOC          = $0001;
  HH_CLOSE_ALL            = $0012;

function HtmlHelp(hwndCaller: HWND; pszFile: PChar; uCommand: UINT; dwData: DWORD): HWND; stdcall;
  external 'HHCTRL.OCX' name 'HtmlHelpA';

implementation

end.
