unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Chipmunk;

type
  TMainForm = class(TForm)
    InfoLbl: TLabel;
    SepBevel: TBevel;
    InfoLbl2: TLabel;
    Panel: TPanel;
    Img: TImage;
    procedure FormCreate(Sender: TObject);
    procedure ImgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure AppIdle(Sender: TObject; var Done: Boolean);
  end;

type
 { Dans Chipmunk, chaque objet a une structure Body qui définit ses attributs
   tels que sa position initiale, sa vélocité, sa masse ... et une structure
   Shape qui définit de façon plus spécialisée comment l'objet intéragit avec
   l'environnement (par exemple, si c'est un cercle ou un polygone)           }
 TChipmunkObject = record
  Body: PcpBody;
  Shape: PcpShape;
 end;

var
  MainForm: TMainForm;
  Particles: array of TChipmunkObject;
  Static: array [0..3] of TChipmunkObject;
  Space: PcpSpace;
  Bmp: TBitmap;

implementation

{$R *.dfm}

function MakeVector(const X, Y: Double): cpVect;
begin
 Result.X := X;
 Result.Y := Y;
end;

procedure CreateStaticShapes;
Var
 I: Longword;
begin
 // les murs, en fait
 for I := 0 to 3 do
  with Static[I] do begin
   Body := cpBodyNew(INFINITY, INFINITY);
   case I of
    0: Shape := cpSegmentShapeNew(Body, MakeVector(0, 0), MakeVector(307, 0), 5);
    1: Shape := cpSegmentShapeNew(Body, MakeVector(0, 0), MakeVector(0, 287), 5);
    2: Shape := cpSegmentShapeNew(Body, MakeVector(307, 0), MakeVector(307, 287), 5);
    3: Shape := cpSegmentShapeNew(Body, MakeVector(0, 287), MakeVector(307, 287), 5);
   end;
   Shape.e := 1;
   Shape.u := 0.45;
   Shape.collision_type := 0;
   cpSpaceAddStaticShape(Space, Shape);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
 DoubleBuffered := True;
 Panel.DoubleBuffered := True;
 Application.OnIdle := AppIdle;
end;

procedure Callback(Shape: PcpShape; Reserved: Pointer); stdcall;
begin
 // nothing
end;

procedure TMainForm.AppIdle(Sender: TObject; var Done: Boolean);
Var
 I: Integer;
 X, Y, R: Integer;
begin
 cpSpaceStep(Space, 1/60);
 cpSpaceHashEach(Space.activeShapes, cpSpaceHashIterator(@Callback), nil);
 // draw stuff
 BitBlt(Bmp.Canvas.Handle, 0, 0, 307, 287, 0, 0, 0, WHITENESS);
 for I := 0 to High(Particles) do
  begin
   X := Round(Particles[I].Body.P.X);
   Y := Round(Particles[I].Body.P.Y);
   R := Longword(Particles[I].Shape.data);
   Bmp.Canvas.Ellipse(X - R, Y - R, X + R, Y + R);
  end;

 Img.Canvas.Draw(0, 0, Bmp);
 sleep(16);
end;

procedure TMainForm.ImgMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 if Shift = [ssLeft] then
  begin
   if (X < 10) or (Y < 10) or (X > 298) or (Y > 278) then Exit; 

   // create one more particle
   SetLength(Particles, Length(Particles) + 1);
   with Particles[High(Particles)] do
    begin
     Body := cpBodyNew(100, INFINITY);
     Body.p := MakeVector(X - 8, Y - 8);
     cpSpaceAddBody(Space, Body);
     Shape := cpCircleShapeNew(Body, 8, MakeVector(0, 0));
     Shape.data := Pointer(8);
     Shape.e := 0.55;
     Shape.u := 0.5;
     Shape.collision_type := 1;
     cpSpaceAddShape(Space, Shape);
    end;
  end;

 if Shift = [ssRight] then
  begin
   if (X < 34) or (Y < 34) or (X > 272) or (Y > 252) then Exit; 

   // create one more particle
   SetLength(Particles, Length(Particles) + 1);
   with Particles[High(Particles)] do
    begin
     Body := cpBodyNew(100, INFINITY);
     Body.p := MakeVector(X - 32, Y - 32);
     cpSpaceAddBody(Space, Body);
     Shape := cpCircleShapeNew(Body, 32, MakeVector(0, 0));
     Shape.data := Pointer(32);
     Shape.e := 0.5;
     Shape.u := 0.5;
     Shape.collision_type := 1;
     cpSpaceAddShape(Space, Shape);
    end;
  end;
end;

initialization
 randomize;
 cpLoad(libChipmunk);
 cpInitChipmunk;
 Bmp := TBitmap.Create;
 Bmp.Width := 307;
 Bmp.Height := 287;
 Bmp.PixelFormat := pf8bit;
 Space := cpSpaceNew;
 Space.gravity := MakeVector(0, 980);
 Space.iterations := 100;
 Space.elasticIterations := 100;
 cpSpaceResizeActiveHash(Space, 16, 100);
 CreateStaticShapes;

finalization
 Bmp.Free;
 cpSpaceFree(Space);
 cpFree;

end.
