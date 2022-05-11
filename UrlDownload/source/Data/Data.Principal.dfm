object DtmPrincipal: TDtmPrincipal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 450
  Width = 555
  object Base: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Protocol=TCPIP'
      'Server=10.2.0.87'
      'CharacterSet=WIN1252'
      'DriverID=SQLite'
      'Database=C:\UrlDownload\db\LOGDOWNLOAD.db'
      'Port=3121'
      'Encrypt=No'
      'ForeignKeys=Off')
    Connected = True
    LoginPrompt = False
    Left = 120
    Top = 200
  end
  object QryUrl: TFDQuery
    Connection = Base
    UpdateOptions.AssignedValues = [uvGeneratorName]
    UpdateOptions.UpdateTableName = 'LOGDOWNLOAD'
    UpdateOptions.KeyFields = 'CODIGO'
    UpdateOptions.AutoIncFields = 'CODIGO'
    SQL.Strings = (
      'select * from LOGDOWNLOAD')
    Left = 128
    Top = 296
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 'C:\Windows\SysWOW64\SQLITE.DLL'
    Left = 224
    Top = 200
  end
end
