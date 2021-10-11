object MainForm: TMainForm
  Left = 216
  Top = 128
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Chipmunk 2D physics engine'
  ClientHeight = 503
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object InfoLbl: TLabel
    Left = 10
    Top = 10
    Width = 410
    Height = 54
    AutoSize = False
    Caption = 
      'Chipmunk est un moteur physique bidimensionnelle code en C++. Il' +
      ' est toutefois disponible sous forme de DLL, ce qui nous permet ' +
      'de s'#39'en servir en Delphi, avec l'#39'interface Chipmunk.pas.'
    WordWrap = True
  end
  object SepBevel: TBevel
    Left = 10
    Top = 73
    Width = 410
    Height = 3
  end
  object InfoLbl2: TLabel
    Left = 10
    Top = 84
    Width = 385
    Height = 17
    Caption = 'Gardez le bouton de souris enfonce pour creer des particules ...'
  end
  object Panel: TPanel
    Left = 10
    Top = 110
    Width = 410
    Height = 383
    BevelOuter = bvLowered
    BorderStyle = bsSingle
    TabOrder = 0
    object Img: TImage
      Left = 1
      Top = 1
      Width = 404
      Height = 377
      Align = alClient
      OnMouseMove = ImgMouseMove
    end
  end
end
