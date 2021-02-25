object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 495
  Width = 353
  object FDCnxcomptes: TFDConnection
    Params.Strings = (
      'Database=D:\Test\Test\madb.sdb'
      'DriverID=SQLite')
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale, fvDataSnapCompatibility]
    FormatOptions.MaxBcdPrecision = 4
    FormatOptions.MaxBcdScale = 18
    ConnectedStoredUsage = []
    LoginPrompt = False
    AfterConnect = FDCnxcomptesAfterConnect
    BeforeConnect = FDCnxcomptesBeforeConnect
    Left = 48
    Top = 24
  end
  object FDQEcritures: TFDQuery
    Connection = FDCnxcomptes
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        TypeMask = 'Montant'
        SourceDataType = dtWideString
        TargetDataType = dtCurrency
      end
      item
        TypeMask = 'DateEcriture'
        SourceDataType = dtWideString
        TargetDataType = dtDate
      end>
    UpdateObject = FDUpdateEcritures
    SQL.Strings = (
      'SELECT E.id,E.Libelle,e.Montant,e.sens,E.Date,e.verifie,'
      '      e.categorie_id,e.compte_id,C.Libelle Categorie'
      'FROM ECRITURES E JOIN CATEGORIES C ON E.CATEGORIE_ID=C.ID'
      'WHERE e.Compte_id=:id'
      'ORDER BY e.Date,e.id')
    Left = 56
    Top = 112
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = 1
      end>
    object FDQEcrituresid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQEcritureslibelle: TStringField
      FieldName = 'libelle'
      Origin = 'libelle'
      Required = True
      Size = 255
    end
    object FDQEcrituresCategorie: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'Categorie'
      Origin = 'libelle'
      ProviderFlags = []
      ReadOnly = True
      Size = 255
    end
    object FDQEcrituresmontant: TFMTBCDField
      FieldName = 'montant'
      Origin = 'montant'
      Required = True
      Precision = 10
      Size = 2
    end
    object FDQEcrituressens: TStringField
      FieldName = 'sens'
      Origin = 'sens'
      Required = True
      FixedChar = True
      Size = 1
    end
    object FDQEcrituresdate: TStringField
      FieldName = 'date'
      Origin = 'date'
      Required = True
      FixedChar = True
      Size = 8
    end
    object FDQEcrituresverifie: TBooleanField
      FieldName = 'verifie'
      Origin = 'verifie'
    end
    object FDQEcriturescategorie_id: TIntegerField
      FieldName = 'categorie_id'
      Origin = 'categorie_id'
      Required = True
    end
    object FDQEcriturescompte_id: TIntegerField
      FieldName = 'compte_id'
      Origin = 'compte_id'
      Required = True
    end
  end
  object tblComptes: TFDTable
    ActiveStoredUsage = []
    IndexFieldNames = 'libelle'
    Connection = FDCnxcomptes
    UpdateOptions.UpdateTableName = 'comptes'
    TableName = 'comptes'
    Left = 56
    Top = 208
  end
  object tblCategories: TFDTable
    ActiveStoredUsage = []
    AfterPost = tblCategoriesAfterPost
    IndexFieldNames = 'libelle'
    Connection = FDCnxcomptes
    UpdateOptions.AssignedValues = [uvEUpdate]
    UpdateOptions.UpdateTableName = 'categories'
    TableName = 'categories'
    Left = 144
    Top = 208
  end
  object FDScripts: TFDScript
    SQLScripts = <
      item
        Name = 'Version0'
        SQL.Strings = (
          'PRAGMA user_version=1;'
          ''
          'CREATE TABLE IF NOT EXISTS categories ('
          '    id      INTEGER       PRIMARY KEY AUTOINCREMENT'
          '                          NOT NULL,'
          '    libelle VARCHAR (255) NOT NULL'
          ');'
          ''
          'CREATE TABLE IF NOT EXISTS comptes ('
          '    id      INTEGER       PRIMARY KEY AUTOINCREMENT'
          '                          NOT NULL,'
          '    libelle VARCHAR (255) NOT NULL'
          ');'
          ''
          'CREATE TABLE IF NOT EXISTS ecritures ('
          '    id           INTEGER         PRIMARY KEY AUTOINCREMENT'
          '                                 NOT NULL,'
          '    libelle      VARCHAR (255)   NOT NULL,'
          '    montant      NUMERIC (10, 2) NOT NULL,'
          '    sens         CHAR (1)        NOT NULL'
          
            '                                 CONSTRAINT Sens_check CHECK (SE' +
            'NS = '#39'+'#39' OR '
          
            '                                                              SE' +
            'NS = '#39'-'#39'),'
          '    date         CHAR (8)        NOT NULL,'
          '    categorie_id INTEGER         NOT NULL'
          
            '                                 CONSTRAINT Categorie_check REFE' +
            'RENCES categories (id) ON DELETE CASCADE'
          
            '                                                                ' +
            '                       ON UPDATE CASCADE,'
          '    compte_id    INTEGER         NOT NULL'
          
            '                                 CONSTRAINT Compte_check REFEREN' +
            'CES comptes (id) ON DELETE CASCADE'
          
            '                                                                ' +
            '                 ON UPDATE CASCADE'
          ');')
      end
      item
        Name = 'Version1'
        SQL.Strings = (
          'PRAGMA foreign_keys = 0;'
          ''
          'CREATE TABLE sqlitestudio_temp_table AS SELECT *'
          '                                          FROM ecritures;'
          ''
          'DROP TABLE ecritures;'
          ''
          'CREATE TABLE ecritures ('
          '    id           INTEGER         PRIMARY KEY AUTOINCREMENT'
          '                                 NOT NULL,'
          '    libelle      VARCHAR (255)   NOT NULL,'
          '    montant      NUMERIC (10, 2) NOT NULL,'
          '    sens         CHAR (1)        NOT NULL'
          
            '                                 CONSTRAINT Sens_check CHECK (SE' +
            'NS = '#39'+'#39' OR '
          
            '                                                              SE' +
            'NS = '#39'-'#39'),'
          '    date         CHAR (8)        NOT NULL,'
          '    categorie_id INTEGER         NOT NULL'
          
            '                                 CONSTRAINT Categorie_check REFE' +
            'RENCES categories (id) ON DELETE CASCADE'
          
            '                                                                ' +
            '                       ON UPDATE CASCADE,'
          '    compte_id    INTEGER         NOT NULL'
          
            '                                 CONSTRAINT Compte_check REFEREN' +
            'CES comptes (id) ON DELETE CASCADE'
          
            '                                                                ' +
            '                 ON UPDATE CASCADE,'
          '    verifie      BOOLEAN         DEFAULT (False) '
          ');'
          ''
          'INSERT INTO ecritures ('
          '                          id,'
          '                          libelle,'
          '                          montant,'
          '                          sens,'
          '                          date,'
          '                          categorie_id,'
          '                          compte_id'
          '                      )'
          '                      SELECT id,'
          '                             libelle,'
          '                             montant,'
          '                             sens,'
          '                             date,'
          '                             categorie_id,'
          '                             compte_id'
          '                        FROM sqlitestudio_temp_table;'
          ''
          'DROP TABLE sqlitestudio_temp_table;'
          ''
          'CREATE UNIQUE INDEX ecritures_par_categorie ON ecritures ('
          '    categorie_id,'
          '    date,'
          '    id'
          ');'
          ''
          'CREATE UNIQUE INDEX ecritures_par_date ON ecritures ('
          '    date,'
          '    id'
          ');'
          ''
          'CREATE UNIQUE INDEX ecritures_par_compte ON ecritures ('
          '    compte_id,'
          '    date,'
          '    id'
          ');'
          ''
          'PRAGMA foreign_keys = 1;'
          'PRAGMA user_version=2;')
      end>
    Connection = FDCnxcomptes
    Params = <>
    Macros = <>
    FetchOptions.AssignedValues = [evItems, evAutoClose, evAutoFetchAll]
    FetchOptions.AutoClose = False
    FetchOptions.Items = [fiBlobs, fiDetails]
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvDirectExecute, rvPersistent]
    ResourceOptions.MacroCreate = False
    ResourceOptions.DirectExecute = True
    Left = 272
    Top = 32
  end
  object FDUpdateEcritures: TFDUpdateSQL
    Connection = FDCnxcomptes
    InsertSQL.Strings = (
      'INSERT INTO ECRITURES'
      '(LIBELLE, MONTANT, SENS, DATE, CATEGORIE_ID, '
      '  COMPTE_ID, VERIFIE)'
      
        'VALUES (:NEW_libelle, :NEW_montant, :NEW_sens, :NEW_date, :NEW_c' +
        'ategorie_id, '
      '  :NEW_compte_id, :NEW_verifie);'
      
        'SELECT LAST_INSERT_AUTOGEN() AS ID, LIBELLE, MONTANT, SENS, DATE' +
        ', CATEGORIE_ID, '
      '  COMPTE_ID, VERIFIE'
      'FROM ECRITURES'
      'WHERE ID = LAST_INSERT_AUTOGEN()')
    ModifySQL.Strings = (
      'UPDATE ECRITURES'
      
        'SET LIBELLE = :NEW_libelle, MONTANT = :NEW_montant, SENS = :NEW_' +
        'sens, '
      
        '  DATE = :NEW_date, CATEGORIE_ID = :NEW_categorie_id, COMPTE_ID ' +
        '= :NEW_compte_id, '
      '  VERIFIE = :NEW_verifie'
      'WHERE ID = :OLD_id;'
      
        'SELECT LIBELLE, MONTANT, SENS, DATE, CATEGORIE_ID, COMPTE_ID, VE' +
        'RIFIE'
      'FROM ECRITURES'
      'WHERE ID = :NEW_id')
    DeleteSQL.Strings = (
      'DELETE FROM ECRITURES'
      'WHERE ID = :OLD_id')
    FetchRowSQL.Strings = (
      'SELECT E.ID, E.LIBELLE, E.MONTANT, E.SENS, E.DATE, '
      '       E.CATEGORIE_ID, E.COMPTE_ID, E.VERIFIE,'
      '       C.LIBELLE CATEGORIE '
      'FROM ECRITURES E JOIN JOIN CATEGORIES C ON E.CATEGORIE_ID=C.ID'
      'WHERE E.ID = :OLD_id')
    Left = 144
    Top = 112
  end
end
