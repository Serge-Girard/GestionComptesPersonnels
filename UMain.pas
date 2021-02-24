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
    BindSourceComptes: TBindSourceDB;
    ComboBox1: TComboBox;
    LinkListControlToField2: TLinkListControlToField;
    lblcompte: TLabel;
    Layout3: TLayout;
    lstbxComptes: TListBox;
    LinkListControlToField4: TLinkListControlToField;
    BindNavigator2: TBindNavigator;
    VScrollCompte: TVertScrollBox;
    VScrollCategorie: TVertScrollBox;
    lstbxcategories: TListBox;
    Layout4: TLayout;
    BindSourceCategories: TBindSourceDB;
    LinkListControlToField3: TLinkListControlToField;
    btnBack2: TButton;
    Layout5: TLayout;
    btnDepense: TButton;
    btnRecette: TButton;
    Button5: TButton;
    Button6: TButton;
    Saisie: TTabItem;
    Vscrollecriture: TVertScrollBox;
    Layout6: TLayout;
    btnOk: TButton;
    btnCancel: TButton;
    Layout8: TLayout;
    CbxCategorie: TComboBox;
    lblCategorie: TLabel;
    LytMontant: TLayout;
    lblMontant: TLabel;
    Layout9: TLayout;
    lblLibelle: TLabel;
    lytDate: TLayout;
    lblDate: TLabel;
    edtDateEcriture: TDateEdit;
    edtmontant: TNumberBox;
    LinkListControlToField5: TLinkListControlToField;
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
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtLibelleCompte: TEdit;
    Label4: TLabel;
    edtLibelleCateg: TEdit;
    LinkControlToField3: TLinkControlToField;
    Layout10: TLayout;
    Layout11: TLayout;
    Button1: TButton;
    BindNavigator1: TBindNavigator;
    LinkListControlToField1: TLinkListControlToField;
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
    procedure ListeEcrituresUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure CalcContentBounds(Sender: TObject;
      var ContentBounds: TRectF);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ListeEcrituresItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Déclarations privées }
    Mouvement : TMouvement;
    LightStyle, DarkStyle : String;
    LargeurDispo : Single;
    TopLibelleItem : integer;
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

uses system.StrUtils, System.Math,
     FMX.Styles,FMX.Styles.Objects,
     FMX.VirtualKeyboard,
     FMX.ListView.DynamicAppearance, FMX.TextLayout,FMX.SearchBox;


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
        if D.Wordwrap then begin
          Layout.Text := 'm';
          Hauteur:=Hauteur+Layout.Height;
        end;
        Result := Round(Hauteur);
      finally
        Layout.Free;
      end;
    end;


// todo : listview passage en mode édition pour ajout suppression /checkbox

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

{
// contrôle taille edtEcritures
// inutile si maxlength est indiqué
if edtEcriture.Lines.Text.Length>DM.FDQEcritures.FieldByName('libelle').Size then
  begin
   edtEcriture.Lines.Text:=edtEcriture.Lines.Text.Substring(1,DM.FDQEcritures.FieldByName('libelle').Size);
   messageErreur('un libellé tronqué taille max dépassée');
   edtEcriture.SetFocus;
  end;
}

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
  aScrollBox.RealignContent;
end;

procedure TFMain.MontrerClavier(aScrollBox : TScrollBox);
var
  LFocused : TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);
    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(aScrollBox.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
       (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      aScrollBox.RealignContent;
      Application.ProcessMessages;
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
{$IFDEF ANDROID}
{TODO : à tester
 permettrai (en théorie) de forcer le dessin de la ListView
 pour régler le problème de hauteur d'item variable
 force un redraw ?
 sinon essayer switchstyle}
ListeEcritures.BeginUpdate;
ListeEcritures.EndUpdate;

{$ENDIF}
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

procedure TFMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
// todo : gestion mobile ? vérifier que vkhardwareback est supporté utile ?
if (key=vkHardwareBack) AND (Pages.TabIndex>0) then
 begin
   // permet d'utiliser la touche hardware de retour
   Pages.First();
   Key:=0;
 end;

end;

procedure TFMain.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
var vScrollBox : TScrollBox;
begin
 case Pages.Tabindex of
   1 : vScrollBox:= TScrollBox(VScrollEcriture);
   2 : vScrollBox:= TScrollBox(VScrollCompte);
   3 : vScrollBox:= TScrollBox(VScrollCategorie);
   else exit;
 end;

FKBBounds.Create(0, 0, 0, 0);
FNeedOffset := False;
CacherClavier(vScrollBox);

end;

procedure TFMain.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
var vScrollBox : TScrollBox;
begin
 case Pages.Tabindex of
   1 : vScrollBox:= TScrollBox(VScrollEcriture);
   2 : vScrollBox:= TScrollBox(VScrollCompte);
   3 : vScrollBox:= TScrollBox(VScrollCategorie);
   else exit;
 end;
 FKBBounds := TRectF.Create(Bounds);
 FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
 FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
 MontrerClavier(vScrollBox);
end;

procedure TFMain.ListeEcrituresItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
 DM.EcritureValidee(DM.FDQEcritures.FieldByName('id').asInteger);
end;

procedure TFMain.ListeEcrituresUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
// todo  billet sur les hauteurs variables d'items de liste
var
  Element: TListItemDrawable;
  PositionDebut, LargeurMontant, LargeurCheck : Single;
  Hauteur : Integer;
  Coche : String;
begin
 if AItem.Purpose<>TListItemPurpose.None then exit;

 Element:=AItem.View.FindDrawable('Text6');
 Coche:=TListItemText(Element).Text;

 Element:=AItem.View.FindDrawable('Verifie');
 TListItemAccessory(Element).Visible:=SameText(Coche,'True');

 if assigned(element) then  LargeurCheck:=Element.Width else LargeurCheck:=0;
 Element:=AItem.View.FindDrawable('Montant');
 LargeurCheck:=Element.Width;
 LargeurDispo:=ListeEcritures.Width - ListeEcritures.ItemSpaces.Left
               - ListeEcritures.ItemSpaces.Right - LargeurMontant
               - LargeurCheck;

 Element:=AItem.View.FindDrawable('Libelle');
 PositionDebut:=Element.PlaceOffset.Y;
 Hauteur:=GetTextHeight(TListItemText(Element), LargeurDispo, TListItemText(Element).Text);
 AItem.Height := Hauteur + Ceil(PositionDebut);
 Element.Height:= Hauteur ;
 Element.Width := LargeurDispo;
end;


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


procedure TFMain.CalcContentBounds(Sender: TObject;
  var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
                                2 * ClientHeight - FKBBounds.Top);
  end;
end;

end.
