object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 475
  Width = 404
  object FDCnxcomptes: TFDConnection
    Params.Strings = (
      'Database=D:\Test\Test\madb.sdb'
      'DriverID=SQLite')
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale, fvDataSnapCompatibility]
    FormatOptions.MaxBcdPrecision = 4
    FormatOptions.MaxBcdScale = 18
    ConnectedStoredUsage = []
    LoginPrompt = False
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
    SQL.Strings = (
      'SELECT E.Libelle,C.Libelle Categorie,Montant,e.sens,E.Date'
      'FROM ECRITURES E JOIN CATEGORIES C ON E.CATEGORIE_ID=C.ID'
      'WHERE Compte_id=:id'
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
  end
  object FDQAjoutEcriture: TFDQuery
    Connection = FDCnxcomptes
    Left = 160
    Top = 120
  end
  object tblComptes: TFDTable
    ActiveStoredUsage = [auDesignTime]
    IndexFieldNames = 'libelle'
    Connection = FDCnxcomptes
    UpdateOptions.UpdateTableName = 'comptes'
    TableName = 'comptes'
    Left = 56
    Top = 208
  end
  object tblCategories: TFDTable
    ActiveStoredUsage = [auDesignTime]
    AfterPost = tblCategoriesAfterPost
    IndexFieldNames = 'libelle'
    Connection = FDCnxcomptes
    UpdateOptions.UpdateTableName = 'categories'
    TableName = 'categories'
    Left = 144
    Top = 208
  end
end
