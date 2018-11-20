unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, uDtmPrincipal, Enter,
  ufrmAtualizaDB, ShellApi, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  VclTee.TeeGDIPlus, Data.DB, VCLTee.Series, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.DBChart, cUsuarioLogado, ZDbcIntfs, cAcaoAcesso, RLReport;

type
  TfrmMenuPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    CADASTRO1: TMenuItem;
    Cliente1: TMenuItem;
    N1: TMenuItem;
    PRODUTO1: TMenuItem;
    CATEGORIAS1: TMenuItem;
    N2: TMenuItem;
    FECHAR1: TMenuItem;
    MOVIMENTAO1: TMenuItem;
    VENDA1: TMenuItem;
    RELATRIOS1: TMenuItem;
    CLIENTE2: TMenuItem;
    PRODUTO2: TMenuItem;
    N3: TMenuItem;
    VENDAPORDIA1: TMenuItem;
    CATEGORIAS2: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    StbPrincipal: TStatusBar;
    GridPanel1: TGridPanel;
    PRODUTOSPORCATEGORIAS1: TMenuItem;
    FICHADECLIENTE1: TMenuItem;
    USURIOS1: TMenuItem;
    N4: TMenuItem;
    ALTERARSENHA1: TMenuItem;
    AESDEACESSO1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FECHAR1Click(Sender: TObject);
    procedure CATEGORIAS1Click(Sender: TObject);
    procedure Cliente1Click(Sender: TObject);
    procedure PRODUTO1Click(Sender: TObject);
    procedure VENDA1Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure CATEGORIAS2Click(Sender: TObject);
    procedure PRODUTO2Click(Sender: TObject);
    procedure PRODUTOSPORCATEGORIAS1Click(Sender: TObject);
    procedure CLIENTE2Click(Sender: TObject);
    procedure FICHADECLIENTE1Click(Sender: TObject);
    procedure VENDAPORDIA1Click(Sender: TObject);
    procedure USURIOS1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ALTERARSENHA1Click(Sender: TObject);
    procedure AESDEACESSO1Click(Sender: TObject);
  private
    { Private declarations }
    TeclaEnter:TMREnter;
    procedure AtualizacaoBancoDados(aForm: TfrmAtualizaBancoDados);
    procedure CriarForm(aNomeForm: TFormClass);
    procedure CriarRelatorio(aNomeForm: TFormClass; aNomeGerador: String);

  public
    { Public declarations }
  end;

var
  frmMenuPrincipal: TfrmMenuPrincipal;
  oUsuarioLogado: TUsuarioLogado;

implementation

{$R *.dfm}

uses uCadCategorias, uCadCliente, uCadProdutos, uProVendas, uRelCadCategorias,
  uRelCadProdutos, uRelCadProdutosComGrupoCategoria, uRelCadClientes,
  uRelCadClientesFicha, uRelProVendaPorData, uSelecionarData, uCadUsuario,
  uLogin, uAlterarSenha, cAtualizacaoBancoDeDados, cArquivoIni, uAcaoAcesso;

procedure TfrmMenuPrincipal.CATEGORIAS1Click(Sender: TObject);
begin
  CriarForm(TfrmCadCategoria);
end;

procedure TfrmMenuPrincipal.CATEGORIAS2Click(Sender: TObject);
begin
  frmRelCadCategorias:= TfrmRelCadCategorias.Create(Self);
  frmRelCadCategorias.Relatorio.PreviewModal;
  frmRelCadCategorias.Release;

end;

procedure TfrmMenuPrincipal.Cliente1Click(Sender: TObject);
begin
  CriarForm(TfrmCadCliente);
end;

procedure TfrmMenuPrincipal.CLIENTE2Click(Sender: TObject);
begin
  CriarRelatorio(TfrmRelCadClientes,'Relatorio');
  frmRelCadClientes:=TfrmRelCadClientes.Create(Self);
  frmRelCadClientes.Relatorio.PreviewModal;
  frmRelCadClientes.Release;
end;

procedure TfrmMenuPrincipal.FECHAR1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMenuPrincipal.FICHADECLIENTE1Click(Sender: TObject);
begin
  frmRelCadClientesFicha:=TfrmRelCadClientesFicha.Create(Self);
  frmRelCadClientesFicha.Relatorio.PreviewModal;
  frmRelCadClientesFicha.Release;
end;

procedure TfrmMenuPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if Assigned(DtmPrincipal) then
     FreeAndNil(DtmPrincipal);

  if Assigned(oUsuarioLogado) then
     FreeAndNil(oUsuarioLogado);
end;

procedure TfrmMenuPrincipal.FormCreate(Sender: TObject);
begin
  {
  DtmPrincipal:=TDtmPrincipal.Create(self);     //Instancia o DataModule
  DtmPrincipal.ConexaoDB.SQLHourGlass:=True;    //Habilita o Cursor em cada transa��o no banco de dados
  DtmPrincipal.ConexaoDB.LibraryLocation:=ExtractFilePath(Application.ExeName)+'ntwdblib.dll';  //Seta a DLL para conexao do SQL
  DtmPrincipal.ConexaoDB.Protocol:='mssql';  //Protocolo do banco de dados
  DtmPrincipal.ConexaoDB.HostName:='.\INSTANCIA'; //Instancia do SQLServer
  DtmPrincipal.ConexaoDB.Port:=1433;          //Porta do SQL Server
  DtmPrincipal.ConexaoDB.User := 'sa';  //Usuario do Banco de Dados
  DtmPrincipal.ConexaoDB.Password:='SENHA';  //Senha do Usu�rio do banco
  DtmPrincipal.ConexaoDB.Database:='BANCODEDADOS';  //Nome do Banco de Dados
  DtmPrincipal.ConexaoDB.Connected:=True;  //Faz a Conex�o do Banco
  }

{  DtmPrincipal:=TDtmPrincipal.Create(self);     //Instancia o DataModule
  with DtmPrincipal.ConexaoDB do begin
    SQLHourGlass:=True;    //Habilita o Cursor em cada transa��o no banco de dados
    LibraryLocation:=ExtractFilePath(Application.ExeName)+'ntwdblib.dll';  //Seta a DLL para conexao do SQL
    Protocol:='mssql';  //Protocolo do banco de dados
    HostName:='.\SERVERCURSO'; //Instancia do SQLServer
    Port:=1433;          //Porta do SQL Server
    User := 'sa';  //Usuario do Banco de Dados
    Password:='mudar@123';  //Senha do Usu�rio do banco
    Database:='vendas';  //Nome do Banco de Dados
    Connected:=True;  //Faz a Conex�o do Banco
  end;
  }

  frmAtualizaBancoDados:=TfrmAtualizaBancoDados.Create(self);
  frmAtualizaBancoDados.Show;
  frmAtualizaBancoDados.Refresh;

  if not FileExists(TArquivoIni.ArquivoIni) then
  begin
    TArquivoIni.AtualizarIni('SERVER', 'TipoDataBase', 'MSSQL');
    TArquivoIni.AtualizarIni('SERVER', 'HostName', '.\');
    TArquivoIni.AtualizarIni('SERVER', 'Port', '1433');
    TArquivoIni.AtualizarIni('SERVER', 'User', 'sa');
    TArquivoIni.AtualizarIni('SERVER', 'Password', 'mudar@123');
    TArquivoIni.AtualizarIni('SERVER', 'Database', 'vendas');
    MessageDlg('Arquivo '+ TArquivoIni.ArquivoIni +' Criado com sucesso' +#13+
               'Configure o arquivo antes de inicializar aplica��o',MtInformation,[mbok],0);

    Application.Terminate;
  end
  else
  begin
    DtmPrincipal:=TDtmPrincipal.Create(self);     //Instancia o DataModule
    with DtmPrincipal.ConexaoDB do begin
      SQLHourGlass:=False;    //Habilita o Cursor em cada transa��o no banco de dados
      LibraryLocation:=ExtractFilePath(Application.ExeName)+'ntwdblib.dll';  //Seta a DLL para conexao do SQL
      if TArquivoIni.LerIni('SERVER','TipoDataBase')='MSSQL' then
         Protocol:='mssql';  //Protocolo do banco de dados

      HostName:= TArquivoIni.LerIni('SERVER','HostName'); //Instancia do SQLServer
      Port    := StrToInt(TArquivoIni.LerIni('SERVER','Port'));  //Porta do SQL Server
      User    := TArquivoIni.LerIni('SERVER','User');  //Usuario do Banco de Dados
      Password:= TArquivoIni.LerIni('SERVER','Password');  //Senha do Usu�rio do banco
      Database:= TArquivoIni.LerIni('SERVER','DataBase');;  //Nome do Banco de Dados
      AutoCommit:= True;
      TransactIsolationLevel:=tiReadCommitted;
      Connected:=True;  //Faz a Conex�o do Banco
    end;

    AtualizacaoBancoDados(frmAtualizaBancoDados);

    TAcaoAcesso.CriarAcoes(TfrmCadCategoria,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmCadCliente,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmCadProduto,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmCadUsuario,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmCadAcaoAcesso,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmAlterarSenha,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmProVenda,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelProVendaPorData,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelCadClientesFicha,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelCadClientes,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelCadProdutosComGrupoCategoria,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelCadProdutos,DtmPrincipal.ConexaoDB);
    TAcaoAcesso.CriarAcoes(TfrmRelCadCategorias,DtmPrincipal.ConexaoDB);

    frmAtualizaBancoDados.Free;
	
    TeclaEnter:=TMREnter.Create(Self);
    TeclaEnter.FocusEnabled:=True;
    TeclaEnter.FocusColor:=clInfoBk;
  end;

end;

procedure TfrmMenuPrincipal.FormShow(Sender: TObject);
begin
  try
    oUsuarioLogado := TUsuarioLogado.Create;

    frmLogin:=TfrmLogin.Create(Self);
    frmLogin.ShowModal;

  finally
    frmLogin.Release;
    StbPrincipal.Panels[0].Text:='USU�RIO: '+oUsuarioLogado.nome;
  end;
end;

procedure TfrmMenuPrincipal.Label1Click(Sender: TObject);
begin
  ShellExecute(Handle,'open','https://www.udemy.com/desenvolver-sistema-com-delphi-e-sql-server-na-pratica/',nil,nil,SW_SHOW);
end;

procedure TfrmMenuPrincipal.PRODUTO1Click(Sender: TObject);
begin
  CriarForm(TfrmCadProduto);
end;

procedure TfrmMenuPrincipal.PRODUTO2Click(Sender: TObject);
begin
  frmRelCadProdutos:=TfrmRelCadProdutos.Create(Self);
  frmRelCadProdutos.Relatorio.PreviewModal;
  frmRelCadProdutos.Release;
end;

procedure TfrmMenuPrincipal.PRODUTOSPORCATEGORIAS1Click(Sender: TObject);
begin
  frmRelCadProdutosComGrupoCategoria:=TfrmRelCadProdutosComGrupoCategoria.Create(Self);
  frmRelCadProdutosComGrupoCategoria.Relatorio.PreviewModal;
  frmRelCadProdutosComGrupoCategoria.Release;
end;

procedure TfrmMenuPrincipal.USURIOS1Click(Sender: TObject);
begin
  CriarForm(TfrmCadUsuario);
end;

procedure TfrmMenuPrincipal.VENDA1Click(Sender: TObject);
begin
  CriarForm(TfrmProVenda);
end;

procedure TfrmMenuPrincipal.VENDAPORDIA1Click(Sender: TObject);
begin
  Try
    frmSelecionarData:=TfrmSelecionarData.Create(self);
    frmSelecionarData.ShowModal;

    frmRelProVendaPorData:=TfrmRelProVendaPorData.Create(self);
    frmRelProVendaPorData.QryVendas.Close;
    frmRelProVendaPorData.QryVendas.ParamByName('DataInicio').AsDate:=frmSelecionarData.EdtDataInicio.Date;
    frmRelProVendaPorData.QryVendas.ParamByName('DataFim').AsDate:=frmSelecionarData.EdtDataFinal.Date;
    frmRelProVendaPorData.QryVendas.Open;
    frmRelProVendaPorData.Relatorio.PreviewModal;
  Finally
    frmSelecionarData.Release;
    frmRelProVendaPorData.Release;
  End;
end;

procedure TfrmMenuPrincipal.AESDEACESSO1Click(Sender: TObject);
begin
  CriarForm(TfrmCadAcaoAcesso);
end;

procedure TfrmMenuPrincipal.ALTERARSENHA1Click(Sender: TObject);
begin
  CriarForm(TfrmAlterarSenha);
end;

procedure TfrmMenuPrincipal.AtualizacaoBancoDados(aForm:TfrmAtualizaBancoDados);
var oAtualizarMSSQL:TAtualizaBancoDadosMSSQL;
begin
  try
    oAtualizarMSSQL:=TAtualizaBancoDadosMSSQL.Create(DtmPrincipal.ConexaoDB);
    oAtualizarMSSQL.AtualizarBancoDeDadosMSSQL;
  finally
    if Assigned(oAtualizarMSSQL) then
       FreeAndNil(oAtualizarMSSQL);
  end;
end;

procedure TfrmMenuPrincipal.CriarForm(aNomeForm: TFormClass);
var form: TForm;
begin
  try
    form := aNomeForm.Create(Application);
    form.ShowModal;
  finally
    if Assigned(form) then
       form.Release;
  end;
end;

procedure TfrmMenuPrincipal.CriarRelatorio(aNomeForm: TFormClass; aNomeGerador:String);
var form: TForm;
    aRelatorio:TRLReport;
begin
  try
    form := aNomeForm.Create(Application);
    with form do begin
      aRelatorio.PreviewModal;
    end;
  finally
    if Assigned(form) then
       form.Release;
  end;
end;
end.
