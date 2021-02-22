unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Layouts, FMX.MultiView, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Menus, FMX.TabControl, FMX.ListView, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, UDM,
  FMX.ScrollBox, FMX.ListBox, Data.Bind.Controls, FMX.Edit,
  Fmx.Bind.Navigator, FMX.Objects, FMX.EditBox, FMX.NumberBox, FMX.DateTimeCtrls,
  FMX.ActnList, System.Actions, FMX.StdActns, FMX.Memo.Types, FMX.Memo, FMX.Platform;

type
  TMouvement = (depense,recette);
  TFMain = class(TForm)
    ListeEcritures: TListView;
    Pages: TTabControl;
    Ecritures: TTabItem;
    Comptes: TTabItem;
    Categories: TTabItem;
    MenuBar1: TMenuBar;
    btnMenu: TButton;
    MultiView1: TMultiView;
    Layout1: TLayout;
    btnQuit: TButton;
    btnCategories: TButton;
    btnComptes: TButton;
    Layout2: TLayout;
    BindSourceEcritures: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    BindSourceComptes: TBindSourceDB;
    ComboBox1: TComboBox;
    LinkListControlToField2: TLinkListControlToField;
    Text1: TText;
    Layout3: TLayout;
    lstbxComptes: TListBox;
    LinkListControlToField4: TLinkListControlToField;
    BindNavigator2: TBindNavigator;
    VertScrollBox1: TVertScrollBox;
    Text2: TText;
    edtLibelleCompte: TEdit;
    LinkControlToField1: TLinkControlToField;
    VertScrollBox2: TVertScrollBox;
    lstbxcategories: TListBox;
    Layout4: TLayout;
    BindNavigator4: TBindNavigator;
    Text3: TText;
    edtLibelleCategorie: TEdit;
    BindSourceCategories: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    BtnBack1: TButton;
    btnBack2: TButton;
    Layout5: TLayout;
    btnDepense: TButton;
    btnRecette: TButton;
    Button5: TButton;
    Button6: TButton;
    Saisie: TTabItem;
    VertScrollBox3: TVertScrollBox;
    Layout6: TLayout;
    btnOk: TButton;
    btnCancel: TButton;
    Layout8: TLayout;
    CbxCategorie: TComboBox;
    Text4: TText;
    LytMontant: TLayout;
    lblMontant: TText;
    Layout9: TLayout;
    lblLibelle: TText;
    lytDate: TLayout;
    lblDate: TText;
    edtDateEcriture: TDateEdit;
    edtmontant: TNumberBox;
    LinkListControlToField5: TLinkListControlToField;
    LinkControlToField2: TLinkControlToField;
    OkPath: TPath;
    CancelPath: TPath;
    lytMessage: TLayout;
    Rectangle1: TRectangle;
    TexteMessage: TText;
    btnExitMessage: TButton;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    ActionList1: TActionList;
    FileExit1: TFileExit;
    edtEcriture: TMemo;
    SwitchStyle: TSwitch;
    Layout7: TLayout;
    Text5: TText;
    Text6: TText;
    StyleBook1: TStyleBook;
    procedure btnQuitClick(Sender: TObject);
    procedure btnCategoriesClick(Sender: TObject);
    procedure btnComptesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1ClosePopup(Sender: TObject);
    procedure BackClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDepenseClick(Sender: TObject);
    procedure btnRecetteClick(Sender: TObject);
    procedure btnExitMessageClick(Sender: TObject);
    procedure BackExecute(Sender: TObject);
    procedure FileExit1CanActionExec(Sender: TCustomAction;
      var CanExec: Boolean);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure SwitchStyleSwitch(Sender: TObject);
    procedure ListeEcrituresApplyStyleLookup(Sender: TObject);
    procedure ListeEcrituresUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Déclarations privées }
    mouvement : tmouvement;
    LightStyle, DarkStyle : String;
    FKBBounds: TRectF;                  // for Vert scroll box
    FNeedOffset: Boolean;               // for Vert scroll box
    procedure MessageErreur(Texte : String);
    procedure MontrerClavier(aScrollBox : TScrollBox);
    procedure CacherClavier(aScrollBox : TScrollBox);
  public
    { Déclarations publiques }
  end;

var
  FMain: TFMain;

implementation

{$R *.fmx}

uses system.StrUtils,
     FMX.Styles,FMX.Styles.Objects,
     FMX.VirtualKeyboard,
     FMX.TextLayout,
     FMX.SearchBox;

// todo : listview passage en mode édition pour ajout suppression
// todo : listview ajouter checkbox pour écriture rapprochée


procedure TFMain.BackExecute(Sender: TObject);
begin
Pages.First();
end;

procedure TFMain.btnCancelClick(Sender: TObject);
begin
CbxCategorie.ItemIndex:=0;
edtEcriture.Lines.Clear;
edtDateEcriture.Date:=Date;
edtmontant.Value:=0.00;
Pages.First();
end;

procedure TFMain.btnCategoriesClick(Sender: TObject);
begin
Pages.ActiveTab:=Categories;
Multiview1.HideMaster;
end;

procedure TFMain.btnComptesClick(Sender: TObject);
begin
Pages.Activetab:=Comptes;
Multiview1.HideMaster;
end;

procedure TFMain.btnDepenseClick(Sender: TObject);
begin
mouvement:=depense;
Pages.Next();
end;

procedure TFMain.btnOkClick(Sender: TObject);
begin
if cbxCategorie.ItemIndex=-1 then
 begin
   messageErreur('Catégorie doit exister');
   cbxCategorie.SetFocus;
   exit;
 end;
if edtEcriture.Lines.Text.IsEmpty then
  begin
   messageErreur('un libellé doit être renseigné');
   edtEcriture.SetFocus;
   Exit;
  end;
if edtmontant.Value=0 then
 begin
   messageErreur('Montant doit être supérieur à Zéro');
   edtMontant.SetFocus;
   exit;
 end;
dm.AjoutEcriture(edtEcriture.Lines.Text,
                 IfThen(mouvement=depense,'-','+'),
                 FormatDateTime('yyyymmdd',edtDateEcriture.Date),
                 edtmontant.Value,
                 Dm.tblComptes.FieldByName('id').asInteger,
                 Dm.tblCategories.FieldByName('id').asInteger);
btnCancelClick(Sender);
end;

procedure TFMain.btnQuitClick(Sender: TObject);
begin
Close;
end;

procedure TFMain.btnRecetteClick(Sender: TObject);
begin
mouvement:=recette;
Pages.Next();
end;

procedure TFMain.BackClick(Sender: TObject);
begin
Pages.First();
end;

procedure TFMain.btnExitMessageClick(Sender: TObject);
begin
lytMessage.Visible:=False;
end;

procedure TFMain.CacherClavier(aScrollBox : TScrollBox);
begin
  aScrollBox.ViewportPosition := PointF(aScrollBox.ViewportPosition.X, 0);
//  loMain.Align := TAlignLayout.Client;
  aScrollBox.RealignContent;
end;

procedure TFMain.MontrerClavier(aScrollBox : TScrollBox);
// for Vert scroll box
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
//    LFocusRect.Offset(Self.vsboxMain.ViewportPosition);
    LFocusRect.Offset(aScrollBox.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
//      Self.loutMain.Align := TAlignLayout.Horizontal;
//      loMain.Align := TAlignLayout.Horizontal;
//      Self.vsboxMain.RealignContent;
      aScrollBox.RealignContent;
      Application.ProcessMessages;
//      Self.vsboxMain.ViewportPosition :=
//        PointF(Self.vsboxMain.ViewportPosition.X,
//               LFocusRect.Bottom - FKBBounds.Top);
      aScrollBox .ViewportPosition :=
        PointF(aScrollBox.ViewportPosition.X,
               LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then CacherClavier(aScrollbox);
end;

procedure TFMain.ComboBox1ClosePopup(Sender: TObject);
begin
 Dm.FDQEcritures.Open('',[dm.tblComptes.FieldByName('id').asInteger]);
end;

procedure TFMain.FileExit1CanActionExec(Sender: TCustomAction;
  var CanExec: Boolean);
begin
CanExec:=true;
Close;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin

{Les styles sont chargés à partir de ressources,
 des styles .fsf sont conseillés }

{$IFDEF MSWINDOWS}
 LightStyle:='windowslight';
 DarkStyle:='windowsdark';
{$ENDIF}
{$IFDEF ANDROID}
 LightStyle:='androidlight';
 DarkStyle:='androiddark';
{$ENDIF}
// todo : menu apple
Dm.FDQEcritures.Open('',[dm.tblComptes.FieldByName('id').asInteger]);
Pages.TabIndex:=0;

// application style
SwitchStyleSwitch(Sender);

// Barre de recherche
// https://www.developpez.net/forums/blogs/138527-sergiomaster/b6927/fmx-modifier-hauteur-accessoirement-dautres-proprietes-boite-recherche-liste/
if ListeEcritures.controls[1].ClassType = TSearchBox then
  begin
    // hauteur
    if TSearchBox(ListeEcritures.controls[1]).Height<30 then // certains styles ou cibles proposent une hauteur plus importante
      TSearchBox(ListeEcritures.controls[1]).Height:=30;
  end;

end;

procedure TFMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
// todo : gestion clavier

// hide
// FKBBounds.Create(0, 0, 0, 0);
//  FNeedOffset := False;
//  RestorePosition;

// show
 FKBBounds := TRectF.Create(Bounds);
 FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
 FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
 MontrerClavier(TScrollBox(VertScrollBox1));
end;


procedure TFMain.ListeEcrituresApplyStyleLookup(Sender: TObject);
var item: TListBoxItem absolute Sender;
begin
end;

procedure TFMain.ListeEcrituresUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
// todo  billet
var
  Element: TListItemText;
  Texte: string;
  LargeurDispo, PositionDebut: Single;
  LargeurMontant : Single;

  function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
    var  Layout: TTextLayout;
         Hauteur : Single;
    begin
      // Creer un TTextLayout pour obtenir les dimennsions du texte
      Layout := TTextLayoutManager.DefaultTextLayout.Create;
      try
        Layout.BeginUpdate;
        try
          // Initialieer le layout parameters avec ceux de l'élément (style)
          Layout.Font.Assign(D.Font);
          Layout.VerticalAlign := D.TextVertAlign;
          Layout.HorizontalAlign := D.TextAlign;
          Layout.WordWrap := D.WordWrap;
          Layout.Trimming := D.Trimming;
          Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
          Layout.Text := Text;
        finally
          Layout.EndUpdate;
        end;
        // nécessite un single
        Hauteur:=Layout.Height;
        // petit gap supplémentaire, la hauteur d'un 'm'
        Layout.Text := 'm';
        Hauteur:=Hauteur+Layout.Height;
        Result := Round(Hauteur);
      finally
        Layout.Free;
      end;
    end;

begin
LargeurMontant:=TListItemText(AItem.View.FindDrawable('Montant')).Width;
PositionDebut:=TListItemText(AItem.View.FindDrawable('Categorie')).Height;
LargeurDispo:=TListView(Sender).Width - TListView(Sender).ItemSpaces.Left
             - TListView(Sender).ItemSpaces.Right - LargeurMontant;

Element:=TListItemText(AItem.View.FindDrawable('Libelle'));
Texte:=Element.Text;

AItem.Height := GetTextHeight(Element, LargeurDispo, Texte) + Trunc(PositionDebut);
Element.Height := AItem.Height;
Element.Width := LargeurDispo;
end;



{
  FKBBounds: TRectF;                  // for Vert scroll box
  FNeedOffset: Boolean;               // for Vert scroll box

procedure TfMain.RestorePosition;
// for Vert scroll box
begin
//  Self.vsboxMain.ViewportPosition := PointF(Self.vsboxMain.ViewportPosition.X, 0);
  VertScrollBox1.ViewportPosition := PointF(VertScrollBox1.ViewportPosition.X, 0);
//  Self.loutMain.Align := TAlignLayout.Client;
  loMain.Align := TAlignLayout.Client;
//  Self.vsboxMain.RealignContent;
  VertScrollBox1.RealignContent;
end;

procedure TfMain.UpdateKBBounds;
// for Vert scroll box
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
//    LFocusRect.Offset(Self.vsboxMain.ViewportPosition);
    LFocusRect.Offset(VertScrollBox1.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
//      Self.loutMain.Align := TAlignLayout.Horizontal;
      loMain.Align := TAlignLayout.Horizontal;
//      Self.vsboxMain.RealignContent;
      VertScrollBox1.RealignContent;
      Application.ProcessMessages;
//      Self.vsboxMain.ViewportPosition :=
//        PointF(Self.vsboxMain.ViewportPosition.X,
//               LFocusRect.Bottom - FKBBounds.Top);
      VertScrollBox1 .ViewportPosition :=
        PointF(VertScrollBox1.ViewportPosition.X,
               LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;

procedure TfMain.VertScrollBox1CalcContentBounds(Sender: TObject;
  var ContentBounds: TRectF);
// for Vert scroll box
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
                                2 * ClientHeight - FKBBounds.Top);
  end;
end;


}

procedure TFMain.MessageErreur(Texte: String);
begin
TexteMessage.Text:=Texte;
lytMessage.Visible:=True;
end;

procedure TFMain.SwitchStyleSwitch(Sender: TObject);
var vstyle : String;
    aFMXObj : TFMXObject;
    vColor : TAlphaColor;
begin
if SwitchStyle.IsChecked then vstyle:=DarkStyle
                     else vstyle:=LightStyle;
if TStyleManager.TrySetStyleFromResource(vStyle)
                 then TStyleManager.UpdateScenes;

vColor:=TAlphaColors.Null;
aFmxObj:=TStyleManager.ActiveStyle(Self).FindStyleResource('labelstyle.text');
if assigned(aFmxObj) then
    vColor:=TText(aFmxObj).TextSettings.FontColor;
aFMXObj:=TStyleManager.ActiveStyle(Self).FindStyleResource('buttonstyle.text');
if Assigned(aFMXObj) then
  vColor:=TButtonStyleTextObject(aFmxObj).HotColor;
CancelPath.Fill.Color:=vColor;
OkPath.Fill.Color:=vColor;
end;


end.
