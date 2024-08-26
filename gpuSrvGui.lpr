program gpuSrvGui;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uGpuSrv
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='GpuSrvControl';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormGpuControl, FormGpuControl);
  Application.Run;
end.

