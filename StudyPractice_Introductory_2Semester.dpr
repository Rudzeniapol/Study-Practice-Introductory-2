program StudyPractice_Introductory_2Semester;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, Windows;

type
  DoctorPointer = ^TDoctor;
  TicketPointer = ^TTicket;
  TMinute = 0 .. 59;
  THour = 0 .. 23;

  TypeTime = record
    Minute: TMinute;
    Hour: THour;
  end;

  TWorkDay = record
    STime: TypeTime;
    ETime: TypeTime;
  end;

  TWorkWeek = record
    Mon: TWorkDay;
    Tue: TWorkDay;
    Wed: TWorkDay;
    Thr: TWorkDay;
    Fri: TWorkDay;
    Sat: TWorkDay;
  end;

  TDoctorInf = record
    ID: Integer;
    Surname: string[30];
    FName: string[30];
    MName: string[30];
    Specialization: string[30];
    Shledule: TWorkWeek;
  end;

  TDoctor = record
    Data: TDoctorInf;
    Next: DoctorPointer;
  end;

  TPatient = record
    Surname: string;
    FName: string;
    MName: string;
  end;

  TTicketInfo = record
    DoctorID: Integer;
    CabinetNum: Integer;
    QueueNum: Integer;
    Date: TDate;
    Time: TypeTime;
    Patient: TPatient;
  end;

  TTicket = record
    Inf: TTicketInfo;
    Next: TicketPointer;
  end;

  TDoctorFile = file of TDoctorInf;

  TTicketsFile = TextFile;

var
  FDPT: DoctorPointer;
  FTPT: TicketPointer;
  ST, ET: TypeTime;
  GlobID: Integer;
  FDoctor: TDoctorFile;
  FTicket: TTicketsFile;
  TicketsCount: Integer;
  ReadFlag: Boolean;

procedure Clear; forward;
procedure MenuOptionsOutput; forward;
procedure SetShledule(Pt: DoctorPointer); forward;

procedure Clear;
var
  cursor: COORD;
  r: cardinal;
begin
  r := 300;
  cursor.X := 0;
  cursor.Y := 0;
  FillConsoleOutputCharacter(GetStdHandle(STD_OUTPUT_HANDLE), ' ', 80 * r,
    cursor, r);
  SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cursor);
end;

procedure ReadFromFile(First: DoctorPointer; TFirst: TicketPointer);
var
  Inp, TimeStr, FIO, IDStr, CabinetStr, QueueStr, DateStr, TempStr, HourStr,
    MinuteStr, FStr, IStr, OStr: string;
  RFlag, TempFlag: Boolean;
  Counter, j: Integer;
begin
  Counter := 1;
  RFlag := false;
  Write('������� �������� ����� ��������: ');
  Readln(Inp);
  Inp := AnsiLowerCase(Inp);
  if not FileExists(Inp + '.dat') then
  begin
    Writeln('������ ����� �� ����������!');
    Writeln('����������� � ����������� ����!');
    Readln;
    Clear;
    MenuOptionsOutput;
  end
  else
  begin
    AssignFile(FDoctor, Inp + '.dat');
    Reset(FDoctor);
    while not EoF(FDoctor) do
    begin
      if not RFlag then
      begin
        New(First);
        FDPT := First;
        Read(FDoctor, First.Data);
        RFlag := True;
      end
      else
      begin
        New(First^.Next);
        Read(FDoctor, First^.Next^.Data);
        First := First^.Next;
      end;
    end;
  end;
  RFlag := false;
  CloseFile(FDoctor);
  while FileExists(Inp + '_Ticket_�' + IntToStr(Counter) + '.txt') do
  begin
    AssignFile(FTicket, Inp + '_Ticket_�' + IntToStr(Counter) + '.txt');
    Reset(FTicket);
    if not RFlag then
    begin
      j := 1;
      FStr := '';
      IStr := '';
      OStr := '';
      TempFlag := false;
      HourStr := '';
      MinuteStr := '';
      FIO := '';
      IDStr := '';
      CabinetStr := '';
      QueueStr := '';
      DateStr := '';
      TimeStr := '';
      New(TFirst);
      FTPT := TFirst;
      Readln(FTicket);
      Readln(FTicket, TempStr);
      for var i := 13 to TempStr.Length do
      begin
        IDStr := IDStr + TempStr[i];
      end;
      TFirst.Inf.DoctorID := StrToInt(IDStr);
      Readln(FTicket, TempStr);
      for var i := 17 to TempStr.Length do
      begin
        CabinetStr := CabinetStr + TempStr[i];
      end;
      TFirst.Inf.CabinetNum := StrToInt(CabinetStr);
      Readln(FTicket, TempStr);
      for var i := 18 to TempStr.Length do
      begin
        QueueStr := QueueStr + TempStr[i];
      end;
      TFirst.Inf.QueueNum := StrToInt(QueueStr);
      Readln(FTicket, TempStr);
      for var i := 7 to TempStr.Length do
      begin
        DateStr := DateStr + TempStr[i];
      end;
      TFirst.Inf.Date := StrToDate(DateStr);
      Readln(FTicket, TempStr);
      for var i := 8 to TempStr.Length do
      begin
        TimeStr := TimeStr + TempStr[i];
      end;
      for var i := 1 to TimeStr.Length do
      begin
        if TimeStr[i] = ':' then
        begin
          TempFlag := True;
        end
        else
        begin
          if TempFlag then
          begin
            MinuteStr := MinuteStr + TimeStr[i];
          end
          else
          begin
            HourStr := HourStr + TimeStr[i];
          end;
        end;
      end;
      TFirst.Inf.Time.Hour := StrToInt(HourStr);
      TFirst.Inf.Time.Minute := StrToInt(MinuteStr);
      Readln(FTicket, TempStr);
      for var i := 10 to TempStr.Length do
      begin
        FIO := FIO + TempStr[i];
      end;
      while FIO[j] <> ' ' do
      begin
        FStr := FStr + FIO[j];
        inc(j);
      end;
      inc(j);
      while FIO[j] <> ' ' do
      begin
        IStr := IStr + FIO[j];
        inc(j);
      end;
      inc(j);
      for var i := j to FIO.Length do
        OStr := OStr + FIO[i];
      TFirst.Inf.Patient.Surname := FStr;
      TFirst.Inf.Patient.FName := IStr;
      TFirst.Inf.Patient.MName := OStr;
      RFlag := True;
    end
    else
    begin
      j := 1;
      FStr := '';
      IStr := '';
      OStr := '';
      TempFlag := false;
      HourStr := '';
      MinuteStr := '';
      FIO := '';
      IDStr := '';
      CabinetStr := '';
      QueueStr := '';
      DateStr := '';
      TimeStr := '';
      New(TFirst^.Next);
      TFirst := TFirst^.Next;
      Readln(FTicket);
      Readln(FTicket, TempStr);
      for var i := 13 to TempStr.Length do
      begin
        IDStr := IDStr + TempStr[i];
      end;
      TFirst.Inf.DoctorID := StrToInt(IDStr);
      Readln(FTicket, TempStr);
      for var i := 17 to TempStr.Length do
      begin
        CabinetStr := CabinetStr + TempStr[i];
      end;
      TFirst.Inf.CabinetNum := StrToInt(CabinetStr);
      Readln(FTicket, TempStr);
      for var i := 18 to TempStr.Length do
      begin
        QueueStr := QueueStr + TempStr[i];
      end;
      TFirst.Inf.QueueNum := StrToInt(QueueStr);
      Readln(FTicket, TempStr);
      for var i := 7 to TempStr.Length do
      begin
        DateStr := DateStr + TempStr[i];
      end;
      TFirst.Inf.Date := StrToDate(DateStr);
      Readln(FTicket, TempStr);
      for var i := 8 to TempStr.Length do
      begin
        TimeStr := TimeStr + TempStr[i];
      end;
      for var i := 1 to TimeStr.Length do
      begin
        if TimeStr[i] = ':' then
        begin
          TempFlag := True;
        end
        else
        begin
          if TempFlag then
          begin
            MinuteStr := MinuteStr + TimeStr[i];
          end
          else
          begin
            HourStr := HourStr + TimeStr[i];
          end;
        end;
      end;
      TFirst.Inf.Time.Hour := StrToInt(HourStr);
      TFirst.Inf.Time.Minute := StrToInt(MinuteStr);
      Readln(FTicket, TempStr);
      for var i := 10 to TempStr.Length do
      begin
        FIO := FIO + TempStr[i];
      end;
      while FIO[j] <> ' ' do
      begin
        FStr := FStr + FIO[j];
        inc(j);
      end;
      inc(j);
      while FIO[j] <> ' ' do
      begin
        IStr := IStr + FIO[j];
        inc(j);
      end;
      inc(j);
      for var i := j to FIO.Length do
        OStr := OStr + FIO[i];
      TFirst.Inf.Patient.Surname := FStr;
      TFirst.Inf.Patient.FName := IStr;
      TFirst.Inf.Patient.MName := OStr;
    end;
    inc(Counter);
    CloseFile(FTicket);
  end;
  TFirst^.Next := nil;
  ReadFlag := True;
  Writeln('������ ������� ������� �� �����!');
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure ExitProgWithSaving(First: DoctorPointer; TFirst: TicketPointer);
var
  Inp: string;
  Counter: Integer;
begin
  Counter := 0;
  Writeln('�� �������, ��� ������ ����� �� ���������? [Y/N]');
  Readln(Inp);
  Inp := AnsiUpperCase(Inp);
  if Inp = 'Y' then
  begin
    Write('������� �������� ����� ��������: ');
    Readln(Inp);
    Inp := AnsiLowerCase(Inp);
    AssignFile(FDoctor, Inp + '.dat');
    Rewrite(FDoctor);
    while First <> nil do
    begin
      Write(FDoctor, First.Data);
      First := First^.Next;
    end;
    CloseFile(FDoctor);
    while TFirst <> nil do
    begin
      inc(Counter);
      AssignFile(FTicket, Inp + '_Ticket_�' + IntToStr(Counter) + '.txt');
      Rewrite(FTicket);
      Writeln(FTicket,
        '------------------------------------------------------------');
      Writeln(FTicket, 'ID �������: ' + IntToStr(TFirst.Inf.DoctorID));
      Writeln(FTicket, '����� ��������: ' + IntToStr(TFirst.Inf.CabinetNum));
      Writeln(FTicket, '����� � �������: ' + IntToStr(TFirst.Inf.QueueNum));
      Writeln(FTicket, '����: ' + DateToStr(TFirst.Inf.Date));
      Writeln(FTicket, '�����: ' + IntToStr(TFirst.Inf.Time.Hour) + ':' +
        IntToStr(TFirst.Inf.Time.Minute));
      Writeln(FTicket, '�������: ' + TFirst.Inf.Patient.Surname + ' ' +
        TFirst.Inf.Patient.FName + ' ' + TFirst.Inf.Patient.MName);
      Writeln(FTicket,
        '------------------------------------------------------------');
      CloseFile(FTicket);
      TFirst := TFirst^.Next;
    end;
    for var i := Counter + 1 to TicketsCount do
    begin
      AssignFile(FTicket, Inp + '_Ticket_�' + IntToStr(i) + '.txt');
      Erase(FTicket);
      CloseFile(FTicket);
    end;
    Writeln('���������� ������� ���������!');
    Readln;
  end
  else
  begin
    if Inp = 'N' then
    begin
      Writeln('����������� � ������� ����!');
      Readln;
      Clear;
      MenuOptionsOutput;
    end
    else
    begin
      while (Inp <> 'N') and (Inp <> 'Y') do
      begin
        Writeln('������������ ������. ������� ���������� ������!');
        Writeln('�� �������, ��� ������ ����� �� ���������? [Y/N]');
        Readln(Inp);
        Inp := AnsiUpperCase(Inp);
      end;
      if Inp = 'Y' then
      begin
        Write('������� �������� ����� ��������: ');
        Readln(Inp);
        Inp := AnsiLowerCase(Inp);
        AssignFile(FDoctor, Inp + '.dat');
        Rewrite(FDoctor);
        while First <> nil do
        begin
          Write(FDoctor, First.Data);
          First := First^.Next;
        end;
        CloseFile(FDoctor);
        while TFirst <> nil do
        begin
          inc(Counter);
          AssignFile(FTicket, Inp + '_Ticket_�' + IntToStr(Counter) + '.txt');
          Rewrite(FTicket);
          Writeln(FTicket,
            '------------------------------------------------------------');
          Writeln(FTicket, 'ID �������: ' + IntToStr(TFirst.Inf.DoctorID));
          Writeln(FTicket, '����� ��������: ' +
            IntToStr(TFirst.Inf.CabinetNum));
          Writeln(FTicket, '����� � �������: ' + IntToStr(TFirst.Inf.QueueNum));
          Writeln(FTicket, '����: ' + DateToStr(TFirst.Inf.Date));
          Writeln(FTicket, '�����: ' + IntToStr(TFirst.Inf.Time.Hour) + ':' +
            IntToStr(TFirst.Inf.Time.Minute));
          Writeln(FTicket, '�������: ' + TFirst.Inf.Patient.Surname + ' ' +
            TFirst.Inf.Patient.FName + ' ' + TFirst.Inf.Patient.MName);
          Writeln(FTicket,
            '------------------------------------------------------------');
          CloseFile(FTicket);
          TFirst := TFirst^.Next;
        end;
        for var i := Counter + 1 to TicketsCount do
        begin
          AssignFile(FTicket, Inp + '_Ticket_�' + IntToStr(i) + '.txt');
          Erase(FTicket);
          CloseFile(FTicket);
        end;
        Writeln('���������� ������� ���������!');
        Readln;
      end
      else
      begin
        Writeln('����������� � ������� ����!');
        Readln;
        Clear;
        MenuOptionsOutput;
      end;
    end;
  end;
end;

procedure ExitProgWithoutSaving;
var
  Inp: string;
begin
  Writeln('�� �������, ��� ������ ����� �� ���������? [Y/N]');
  Readln(Inp);
  Inp := AnsiUpperCase(Inp);
  if Inp = 'Y' then
  begin
    // ���������� � ���� � �����
  end
  else
  begin
    if Inp = 'N' then
    begin
      Writeln('����������� � ������� ����!');
      Readln;
      Clear;
      MenuOptionsOutput;
    end
    else
    begin
      while (Inp <> 'N') and (Inp <> 'Y') do
      begin
        Writeln('������������ ������. ������� ���������� ������!');
        Writeln('�� �������, ��� ������ ����� �� ���������? [Y/N]');
        Readln(Inp);
        Inp := AnsiUpperCase(Inp);
      end;
      if Inp = 'Y' then
      begin
        // ���������� � ���� � �����
      end
      else
      begin
        Writeln('����������� � ������� ����!');
        Readln;
        Clear;
        MenuOptionsOutput;
      end;
    end;
  end;

end;

procedure Delete(First: TicketPointer); overload;
var
  flag, inpflag, DateFlag, DocFlag: Boolean;
  Cnt, Inpt, TempID: Integer;
  Date: TDateTime;
  Hours: THour;
  Minutes: TMinute;
  Inp, Spec: string;
  FirstD: DoctorPointer;
  Arr: array of DoctorPointer;
begin
  cnt:=1;
  FirstD := FDPT;
  flag := false;
  DateFlag := false;
  if First = nil then
  begin
    Writeln('������ ����!');
  end
  else
  begin
    inpflag := false;
    Write('������� �������� �������������:');
    Readln(Spec);
    while FirstD <> nil do
    begin
      if (AnsiUpperCase(FirstD.Data.Specialization) = AnsiUpperCase(Spec)) then
      begin
        DocFlag := True;
        SetLength(Arr, Cnt);
        Arr[Cnt - 1] := FirstD;
        Writeln(Cnt, '.');
        Writeln('��� �����: ', FirstD.Data.Surname, ' ', FirstD.Data.FName, ' ',
          FirstD.Data.MName);
        Writeln('ID �����: ', FirstD.Data.ID);
        Writeln('�������������: ', FirstD.Data.Specialization);
        Writeln;
        Writeln;
        inc(Cnt);
      end;
      FirstD := FirstD^.Next;
    end;
    if DocFlag then
    begin
      Write('������� ����� ��������� ����� ��� �������� ������: ');
      while inpflag = false do
      begin
        try
          Readln(Inpt);
          TempID := Arr[Inpt - 1].Data.ID;
          inpflag := True;
        except
          Writeln('������������ ����! ������� ���������� ��������!');
        end;
      end;
      InpFlag:=false;
      while inpflag = false do
      begin
        try
          DateFlag := false;
          while not DateFlag do
          begin
            Write('������� ���� ���������� ������ (� ������� �����/����/���): ');
            Readln(Inp);
            Cnt := 0;
            for var s := 1 to Length(Inp) do
            begin
              if Inp[s] = '/' then
                inc(Cnt);
            end;
            if Cnt = 2 then
              DateFlag := True
            else
              Writeln('�� ����������� ����� ����!');
          end;
          Date := StrTodateTime(Inp);
          inpflag := True;
        except
          Writeln('������������ ����! ������� ���������!');
        end;
      end;
      inpflag := false;
      while inpflag = false do
      begin
        try
          Write('������� ����� ������(����): ');
          Readln(Inp);
          Hours := StrToInt(Inp);
          inpflag := True;
        except
          Writeln('������������ ����!');
        end;
      end;
      inpflag := false;
      while inpflag = false do
      begin
        try
          Write('������� ����� ������(������): ');
          Readln(Inp);
          Minutes := StrToInt(Inp);
          inpflag := True;
        except
          Writeln('������������ ����!');
        end;
      end;
      inpflag := false;
      while First^.Next <> nil do
      begin
        if (First^.Next.Inf.Date = Date) and (First^.Next.Inf.Time.Hour = Hours)
          and (First^.Next.Inf.Time.Minute = Minutes) and
          (TempID = First^.Next.Inf.DoctorID) then
        begin
          First^.Next := First^.Next^.Next;
          flag := True;
        end
        else
          First := First.Next;
      end;
      if (First^.Inf.Date = Date) and (First^.Inf.Time.Hour = Hours) and
        (First^.Inf.Time.Minute = Minutes) and (First^.Inf.DoctorID = TempID)
      then
      begin
        First := nil;
        flag := True;
      end;
      if (FTPT^.Next.Inf.Date = Date) and (FTPT^.Next.Inf.Time.Hour = Hours) and
        (FTPT^.Next.Inf.Time.Minute = Minutes) and (FTPT^.Inf.DoctorID = TempID)
      then
      begin
        FTPT := FTPT.Next;
        flag := True;
      end;
      if flag then
      begin
        Writeln('����� ������� �����');
      end
      else
      begin
        Writeln('������ ������ ��� � ����! ����������� � ����������� ����.');
      end;
    end
    else
    begin
      Writeln('������ � ����� �������������� ��� � ���� ������!');
    end;
  end;
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure Delete(First: DoctorPointer); overload;
var
  F, i, O: string;
  flag: Boolean;
  DFirst, TempPT: TicketPointer;
  ID: Integer;
begin
  DFirst := FTPT;
  flag := false;
  if First = nil then
  begin
    Writeln('������ ����!');
  end
  else
  begin
    Writeln('������� ��� ���������� �����');
    Write('������� ������� �����: ');
    Readln(F);
    Write('������� ��� �����: ');
    Readln(i);
    Write('������� �������� �����: ');
    Readln(O);
    if (AnsiUpperCase(First^.Data.Surname) = AnsiUpperCase(F)) and
      (AnsiUpperCase(First^.Data.FName) = AnsiUpperCase(i)) and
      (AnsiUpperCase(First^.Data.MName) = AnsiUpperCase(O)) then
    begin
      ID := First^.Data.ID;
      FDPT := First^.Next;
      Writeln('���� ����� �� ������');
      while DFirst^.Next <> nil do
      begin
        if DFirst^.Next^.Inf.DoctorID = ID then
        begin
          DFirst^.Next := DFirst^.Next^.Next;
        end
        else
        begin
          DFirst := DFirst^.Next;
        end;
      end;
      if DFirst^.Inf.DoctorID = ID then
        DFirst := nil;
      if FTPT^.Inf.DoctorID = ID then
        FTPT := FTPT^.Next;
    end
    else
    begin
      while First^.Next <> nil do
      begin
        if (AnsiUpperCase(First^.Next^.Data.Surname) = AnsiUpperCase(F)) and
          (AnsiUpperCase(First^.Next^.Data.FName) = AnsiUpperCase(i)) and
          (AnsiUpperCase(First^.Next^.Data.MName) = AnsiUpperCase(O)) then
        begin
          ID := First^.Next^.Data.ID;
          First^.Next := First^.Next^.Next;
          flag := True;
          Writeln('���� ����� �� ������');
        end
        else
          First := First^.Next;
      end;
      if flag then
      begin
        while DFirst^.Next <> nil do
        begin
          if DFirst^.Inf.DoctorID = ID then
          begin
            DFirst^.Next := DFirst^.Next^.Next;
          end
          else
            DFirst := DFirst^.Next;
        end;
        if DFirst^.Inf.DoctorID = ID then
          DFirst := nil;
        if FTPT.Inf.DoctorID = ID then
          FTPT := FTPT^.Next;
      end
      else
      begin
        Writeln('�������� ����� ��� � ���� ������');
      end;
    end;
  end;
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure Poisk(First: TicketPointer; SN, FN, MN: string); overload;
var
  i: Integer;
  flag: Boolean;
begin
  flag := false;
  i := 1;
  if First = nil then
  begin
    Writeln('������ ����!');
  end
  else
  begin
    while First <> nil do
    begin
      if (AnsiUpperCase(First^.Inf.Patient.Surname) = AnsiUpperCase(SN)) and
        (AnsiUpperCase(First^.Inf.Patient.FName) = AnsiUpperCase(FN)) and
        (AnsiUpperCase(First^.Inf.Patient.MName) = AnsiUpperCase(MN)) then
      begin
        Writeln(i, '.');
        Writeln('ID �����: ', First.Inf.DoctorID);
        Writeln('����� ��������: ', First.Inf.CabinetNum);
        Writeln('����� � �������: ', First.Inf.QueueNum);
        Writeln('����: ', DateToStr(First.Inf.Date), ' �����: ',
          First.Inf.Time.Hour, ':', First.Inf.Time.Minute);
        Writeln('��� ��������: ', First.Inf.Patient.Surname, ' ',
          First.Inf.Patient.FName, ' ', First.Inf.Patient.MName);
        inc(i);
        flag := True;
      end;
      First := First^.Next;
    end;
    if not flag then
      Writeln('������ �������� ��� � ���� �������!');
  end;
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure Poisk(FirstD: DoctorPointer; First: TicketPointer;
  Spec: string); overload;
var
  TempPT: TicketPointer;
  i: Integer;
  flag, flagRec: Boolean;
begin
  TempPT := First;
  i := 1;
  flag := false;
  flagRec := false;
  if FirstD = nil then
  begin
    Writeln('������ ����!');
  end
  else
  begin
    while FirstD <> nil do
    begin
      if (AnsiUpperCase(FirstD.Data.Specialization) = AnsiUpperCase(Spec)) then
      begin
        flag := True;
        Writeln(i, '.');
        Writeln('��� �����: ', FirstD.Data.Surname, ' ', FirstD.Data.FName, ' ',
          FirstD.Data.MName);
        Writeln('ID �����: ', FirstD.Data.ID);
        Writeln('�������������: ', FirstD.Data.Specialization);
        Writeln('������ ������ � �����������: ',
          FirstD.Data.Shledule.Mon.STime.Hour, ':',
          FirstD.Data.Shledule.Mon.STime.Minute,
          ' ����� ������ � �����������: ', FirstD.Data.Shledule.Mon.ETime.Hour,
          ':', FirstD.Data.Shledule.Mon.ETime.Minute);
        Writeln('������ ������ �� �������: ',
          FirstD.Data.Shledule.Tue.STime.Hour, ':',
          FirstD.Data.Shledule.Tue.STime.Minute, ' ����� ������ �� �������: ',
          FirstD.Data.Shledule.Tue.ETime.Hour, ':',
          FirstD.Data.Shledule.Tue.ETime.Minute);
        Writeln('������ ������ � �����: ', FirstD.Data.Shledule.Wed.STime.Hour,
          ':', FirstD.Data.Shledule.Wed.STime.Minute, ' ����� ������ � �����: ',
          FirstD.Data.Shledule.Wed.ETime.Hour, ':',
          FirstD.Data.Shledule.Wed.ETime.Minute);
        Writeln('������ ������ � �������: ',
          FirstD.Data.Shledule.Thr.STime.Hour, ':',
          FirstD.Data.Shledule.Thr.STime.Minute, ' ����� ������ � �������: ',
          FirstD.Data.Shledule.Thr.ETime.Hour, ':',
          FirstD.Data.Shledule.Thr.ETime.Minute);
        Writeln('������ ������ � �������: ',
          FirstD.Data.Shledule.Fri.STime.Hour, ':',
          FirstD.Data.Shledule.Fri.STime.Minute, ' ����� ������ � �������: ',
          FirstD.Data.Shledule.Fri.ETime.Hour, ':',
          FirstD.Data.Shledule.Fri.ETime.Minute);
        Writeln('������ ������ � �������: ',
          FirstD.Data.Shledule.Sat.STime.Hour, ':',
          FirstD.Data.Shledule.Sat.STime.Minute, ' ����� ������ � �������: ',
          FirstD.Data.Shledule.Sat.ETime.Hour, ':',
          FirstD.Data.Shledule.Sat.ETime.Minute);
        inc(i);
        Writeln;
        Writeln;
        First := TempPT;
        while First <> nil do
        begin
          if (First.Inf.DoctorID = FirstD.Data.ID) and
            (First.Inf.Patient.Surname <> '') and
            (First.Inf.Patient.FName <> '') and (First.Inf.Patient.MName <> '')
          then
          begin
            flagRec := True;
            Writeln('ID �����: ', First.Inf.DoctorID);
            Writeln('����� ��������: ', First.Inf.CabinetNum);
            Writeln('����� � �������: ', First.Inf.QueueNum);
            Writeln('����: ', DateTimeTOStr(First.Inf.Date), ' �����: ',
              First.Inf.Time.Hour, ':', First.Inf.Time.Minute);
            Writeln('��� ��������: ', First.Inf.Patient.Surname, ' ',
              First.Inf.Patient.FName, ' ', First.Inf.Patient.MName);
            Writeln;
            Writeln;
          end;
          First := First^.Next;
        end;
        if not flagRec then
        begin
          Writeln('� ����� ��� �������!');
          Writeln;
        end;
      end;
      FirstD := FirstD^.Next;
    end;
    if not flag then
    begin
      Writeln('������ � ����� �������������� ��� � ����!');
    end;
  end;
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure Correct(First: DoctorPointer); overload;
var
  Inp, Cnt: Integer;
  F, i, O, TInpt, temp, MStr, Spec: string;
  flag, TimeFlag, FindFlag: Boolean;
  TempPT: DoctorPointer;
  Arr: Array of DoctorPointer;
begin
  flag := false;
  FindFlag := false;
  temp := '';
  MStr := '';
  Cnt := 1;
  if First = nil then
  begin
    Writeln('������ ����!');
  end
  else
  begin
    TimeFlag := false;
    Write('������� ������������� �����: ');
    Readln(Spec);
    TempPT := First;
    while TempPT <> nil do
    begin
      if AnsiUpperCase(TempPT.Data.Specialization) = AnsiUpperCase(Spec) then
      begin
        FindFlag := True;
        SetLength(Arr, Cnt);
        Arr[Cnt - 1] := TempPT;
        Writeln(Cnt, '.');
        Writeln('��� �����: ', First.Data.Surname, ' ', First.Data.FName, ' ',
          First.Data.MName);
        Writeln('ID �����: ', First.Data.ID);
        Writeln('�������������: ', First.Data.Specialization);
        Writeln('������ ������ � �����������: ',
          First.Data.Shledule.Mon.STime.Hour, ':',
          First.Data.Shledule.Mon.STime.Minute, ' ����� ������ � �����������: ',
          First.Data.Shledule.Mon.ETime.Hour, ':',
          First.Data.Shledule.Mon.ETime.Minute);
        Writeln('������ ������ �� �������: ',
          First.Data.Shledule.Tue.STime.Hour, ':',
          First.Data.Shledule.Tue.STime.Minute, ' ����� ������ �� �������: ',
          First.Data.Shledule.Tue.ETime.Hour, ':',
          First.Data.Shledule.Tue.ETime.Minute);
        Writeln('������ ������ � �����: ', First.Data.Shledule.Wed.STime.Hour,
          ':', First.Data.Shledule.Wed.STime.Minute, ' ����� ������ � �����: ',
          First.Data.Shledule.Wed.ETime.Hour, ':',
          First.Data.Shledule.Wed.ETime.Minute);
        Writeln('������ ������ � �������: ', First.Data.Shledule.Thr.STime.Hour,
          ':', First.Data.Shledule.Thr.STime.Minute,
          ' ����� ������ � �������: ', First.Data.Shledule.Thr.ETime.Hour, ':',
          First.Data.Shledule.Thr.ETime.Minute);
        Writeln('������ ������ � �������: ', First.Data.Shledule.Fri.STime.Hour,
          ':', First.Data.Shledule.Fri.STime.Minute,
          ' ����� ������ � �������: ', First.Data.Shledule.Fri.ETime.Hour, ':',
          First.Data.Shledule.Fri.ETime.Minute);
        Writeln('������ ������ � �������: ', First.Data.Shledule.Sat.STime.Hour,
          ':', First.Data.Shledule.Sat.STime.Minute,
          ' ����� ������ � �������: ', First.Data.Shledule.Sat.ETime.Hour, ':',
          First.Data.Shledule.Sat.ETime.Minute);
        inc(Cnt);
        Writeln;
        Writeln;
      end;
      TempPT := TempPT^.Next;
    end;
    if FindFlag then
    begin
      Write('�������� ����� �����, ������ �������� ������ ���������������: ');
      while flag = false do
      begin
        try
          Readln(Inp);
          flag := True;
        except
          Writeln('������������ ����!');
        end;
      end;
      flag := false;
      while (Inp < 1) or (Inp > Length(Arr)) do
      begin
        Writeln('�� ����� ������������ ��������!');
        Write('�������� ����� �����, ������ �������� ������ ���������������: ');
        while flag = false do
        begin
          try
            Readln(Inp);
            flag := True;
          except
            Writeln('������������ ����!');
          end;
        end;
        flag := false;
      end;
      First := Arr[Inp - 1];
      Writeln('������� ����� ���������, ������� ������ �������������');
      Writeln('1. �������');
      Writeln('2. ���');
      Writeln('3. ��������');
      Writeln('4. �������������');
      Writeln('5. ������');
      while flag = false do
      begin
        try
          Readln(Inp);
          flag := True;
        except
          Writeln('������������ ����!');
        end;
      end;
      flag := false;
      case Inp of
        1:
          begin
            Writeln('������� ����� �������� ���������');
            Readln(First.Data.Surname);
            Writeln('�������� ���������������');
          end;
        2:
          begin
            Writeln('������� ����� �������� ���������');
            Readln(First.Data.FName);
            Writeln('�������� ���������������');
          end;
        3:
          begin
            Writeln('������� ����� �������� ���������');
            Readln(First.Data.MName);
            Writeln('�������� ���������������');
          end;
        4:
          begin
            Writeln('������� ����� �������� ���������');
            Readln(First.Data.Specialization);
            Writeln('�������� ���������������');
          end;
        5:
          begin
            SetShledule(First);
          end;
      else
        begin
          Writeln('�� ����� ������������ ��������!');
          Writeln('������� ����� ���������, ������� ������ �������������');
          while flag = false do
          begin
            try
              Readln(input);
              flag := True;
            except
              Writeln('������������ ����!');
            end;
          end;
          flag := false;
        end;
      end;
    end
    else
    begin
      Writeln('������ � ����� �������������� ��� � ���� ��� � ����!');
    end;
  end;
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure Correct(First: TicketPointer); overload;
begin

end;

procedure View(First: DoctorPointer); overload;
var
  i: Integer;
begin
  if First = nil then
  begin
    Writeln('������ ����!');
  end
  else
  begin
    i := 1;
    while First <> nil do
    begin
      Writeln(i, '.');
      Writeln('��� �����: ', First.Data.Surname, ' ', First.Data.FName, ' ',
        First.Data.MName);
      Writeln('ID �����: ', First.Data.ID);
      Writeln('�������������: ', First.Data.Specialization);
      Writeln('������ ������ � �����������: ',
        First.Data.Shledule.Mon.STime.Hour, ':',
        First.Data.Shledule.Mon.STime.Minute, ' ����� ������ � �����������: ',
        First.Data.Shledule.Mon.ETime.Hour, ':',
        First.Data.Shledule.Mon.ETime.Minute);
      Writeln('������ ������ �� �������: ', First.Data.Shledule.Tue.STime.Hour,
        ':', First.Data.Shledule.Tue.STime.Minute, ' ����� ������ �� �������: ',
        First.Data.Shledule.Tue.ETime.Hour, ':',
        First.Data.Shledule.Tue.ETime.Minute);
      Writeln('������ ������ � �����: ', First.Data.Shledule.Wed.STime.Hour,
        ':', First.Data.Shledule.Wed.STime.Minute, ' ����� ������ � �����: ',
        First.Data.Shledule.Wed.ETime.Hour, ':',
        First.Data.Shledule.Wed.ETime.Minute);
      Writeln('������ ������ � �������: ', First.Data.Shledule.Thr.STime.Hour,
        ':', First.Data.Shledule.Thr.STime.Minute, ' ����� ������ � �������: ',
        First.Data.Shledule.Thr.ETime.Hour, ':',
        First.Data.Shledule.Thr.ETime.Minute);
      Writeln('������ ������ � �������: ', First.Data.Shledule.Fri.STime.Hour,
        ':', First.Data.Shledule.Fri.STime.Minute, ' ����� ������ � �������: ',
        First.Data.Shledule.Fri.ETime.Hour, ':',
        First.Data.Shledule.Fri.ETime.Minute);
      Writeln('������ ������ � �������: ', First.Data.Shledule.Sat.STime.Hour,
        ':', First.Data.Shledule.Sat.STime.Minute, ' ����� ������ � �������: ',
        First.Data.Shledule.Sat.ETime.Hour, ':',
        First.Data.Shledule.Sat.ETime.Minute);
      inc(i);
      Writeln;
      Writeln;
      First := First^.Next;
    end;
  end;
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure View(First: TicketPointer); overload;
var
  i: Integer;
begin
  if First = nil then
  begin
    Writeln('������ ����!');
  end
  else
  begin
    i := 1;
    while First <> nil do
    begin
      Writeln(i, '.');
      Writeln('ID �����: ', First.Inf.DoctorID);
      Writeln('����� ��������: ', First.Inf.CabinetNum);
      Writeln('����� � �������: ', First.Inf.QueueNum);
      Writeln('����: ', DateTimeTOStr(First.Inf.Date), ' �����: ',
        First.Inf.Time.Hour, ':', First.Inf.Time.Minute);
      if (First.Inf.Patient.Surname <> '') and (First.Inf.Patient.FName <> '')
        and (First.Inf.Patient.MName <> '') then
        Writeln('��� ��������: ', First.Inf.Patient.Surname, ' ',
          First.Inf.Patient.FName, ' ', First.Inf.Patient.MName)
      else
        Writeln('����� �� �����');
      Writeln;
      Writeln;
      inc(i);
      First := First^.Next;
    end;
  end;
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure TrashCan;
begin
  // TShledule = record
  // case Day: TDay of
  // Mon:
  // (MonSTime: TTime; MonETime: TTime);
  // Tue:
  // (TueSTime: TTime; TueETime: TTime);
  // Wed:
  // (WedSTime: TTime; WedETime: TTime);
  // Thr:
  // (ThrSTime: TTime; ThrETime: TTime);
  // Fri:
  // (FriSTime: TTime; FriETime: TTime);
  // Sat:
  // (SatSTime: TTime; SatETime: TTime);
  // end;
  // temp := '';
  // MStr := '';
  // InpFlag := false;
  // TimeFlag := false;
  // flag := false;
  // writeln('������� ��� ������ �����');
  // Write('������� ������� �����: ');
  // readln(F);
  // Write('������� ��� �����: ');
  // readln(i);
  // Write('������� �������� �����: ');
  // readln(O);
  // if First = nil then
  // begin
  // New(FDPT);
  // First := FDPT;
  // First^.Surname := F;
  // First^.FName := i;
  // First^.MName := O;
  // First^.ID := 1;
  // Write('������� ������������� ������ �����: ');
  // readln(spec);
  // First^.Specialization := spec;
  // while InpFlag = false do
  // begin
  // try
  // Write('������� ����� ������ ������(� ������� ����:������): ');
  // readln(TInpt);
  // for var a := 1 to TInpt.Length do
  // begin
  // if (TInpt[a] = ':') then
  // begin
  // TimeFlag := true;
  // end
  // else
  // begin
  // if not TimeFlag then
  // begin
  // temp := temp + TInpt[a];
  // end
  // else
  // begin
  // MStr := MStr + TInpt[a];
  // end;
  // end;
  // end;
  // ST.Hour := StrToInt(temp);
  // ST.Minute := StrToInt(MStr);
  // InpFlag := true;
  // except
  // writeln('������������ ����!');
  // temp := '';
  // MStr := '';
  // end;
  // end;
  // if TimeFlag then
  // begin
  //
  // InpFlag := false;
  // TimeFlag := false;
  // temp := '';
  // MStr := '';
  // Write('������� ����� ����� ������(� ������� ����:������): ');
  // readln(TInpt);
  // for var k := 1 to TInpt.Length do
  // begin
  // if (TInpt[k] = ':') then
  // begin
  // TimeFlag := true;
  // end
  // else
  // begin
  // if not TimeFlag then
  // begin
  // temp := temp + TInpt[k];
  // end
  // else
  // begin
  // MStr := MStr + TInpt[k];
  // end;
  // end;
  // end;
  // if TimeFlag then
  // begin
  // while InpFlag = false do
  // begin
  // try
  // Write('������� ����� ����� ������(� ������� ����:������): ');
  // temp := '';
  // MStr := '';
  // readln(TInpt);
  // for var k := 1 to TInpt.Length do
  // begin
  // if (TInpt[k] = ':') then
  // begin
  // TimeFlag := true;
  // end
  // else
  // begin
  // if not TimeFlag then
  // begin
  // temp := temp + TInpt[k];
  // end
  // else
  // begin
  // MStr := MStr + TInpt[k];
  // end;
  // end;
  // end;
  // ET.Hour := StrToInt(temp);
  // ET.Minute := StrToInt(MStr);
  // InpFlag := true;
  // except
  // writeln('������������ ����!');
  // end;
  // end;
  // InpFlag := false;
  // if (ET.Hour * 60 + ET.Minute) > (ST.Hour * 60 + ST.Minute) then
  // begin
  // First^.Shledule.Mon.STime.Minute := ST.Minute;
  // First^.Shledule.Mon.STime.Hour := ST.Hour;
  // First^.Shledule.Mon.ETime.Minute := ET.Minute;
  // First^.Shledule.Mon.ETime.Hour := ET.Hour;
  // First^.Shledule.Tue.STime.Minute := ST.Minute;
  // First^.Shledule.Tue.STime.Hour := ST.Hour;
  // First^.Shledule.Tue.ETime.Minute := ET.Minute;
  // First^.Shledule.Tue.ETime.Hour := ET.Hour;
  // First^.Shledule.Wed.STime.Minute := ST.Minute;
  // First^.Shledule.Wed.STime.Hour := ST.Hour;
  // First^.Shledule.Wed.ETime.Minute := ET.Minute;
  // First^.Shledule.Wed.ETime.Hour := ET.Hour;
  // First^.Shledule.Thr.STime.Minute := ST.Minute;
  // First^.Shledule.Thr.STime.Hour := ST.Hour;
  // First^.Shledule.Thr.ETime.Minute := ET.Minute;
  // First^.Shledule.Thr.ETime.Hour := ET.Hour;
  // First^.Shledule.Fri.STime.Minute := ST.Minute;
  // First^.Shledule.Fri.STime.Hour := ST.Hour;
  // First^.Shledule.Fri.ETime.Minute := ET.Minute;
  // First^.Shledule.Fri.ETime.Hour := ET.Hour;
  // First^.Shledule.Sat.STime.Minute := ST.Minute;
  // First^.Shledule.Sat.STime.Hour := ST.Hour;
  // First^.Shledule.Sat.ETime.Minute := ET.Minute;
  // First^.Shledule.Sat.ETime.Hour := ET.Hour;
  // writeln('������ ���������!');
  // end
  // else
  // begin
  // writeln('������� ������� �����!');
  // writeln('������������� ���������� ����� � 8 ���� �� 8 ������!');
  // First^.Shledule.Mon.STime.Minute := 0;
  // First^.Shledule.Mon.STime.Hour := 8;
  // First^.Shledule.Mon.ETime.Minute := 0;
  // First^.Shledule.Mon.ETime.Hour := 20;
  // First^.Shledule.Tue.STime.Minute := 0;
  // First^.Shledule.Tue.STime.Hour := 8;
  // First^.Shledule.Tue.ETime.Minute := 0;
  // First^.Shledule.Tue.ETime.Hour := 20;
  // First^.Shledule.Wed.STime.Minute := 0;
  // First^.Shledule.Wed.STime.Hour := 8;
  // First^.Shledule.Wed.ETime.Minute := 0;
  // First^.Shledule.Wed.ETime.Hour := 20;
  // First^.Shledule.Thr.STime.Minute := 0;
  // First^.Shledule.Thr.STime.Hour := 8;
  // First^.Shledule.Thr.ETime.Minute := 0;
  // First^.Shledule.Thr.ETime.Hour := 20;
  // First^.Shledule.Fri.STime.Minute := 0;
  // First^.Shledule.Fri.STime.Hour := 8;
  // First^.Shledule.Fri.ETime.Minute := 0;
  // First^.Shledule.Fri.ETime.Hour := 20;
  // First^.Shledule.Sat.STime.Minute := 0;
  // First^.Shledule.Sat.STime.Hour := 8;
  // First^.Shledule.Sat.ETime.Minute := 0;
  // First^.Shledule.Sat.ETime.Hour := 20;
  // end;
  // end
  // else
  // begin
  // writeln('������� ������� �����!');
  // writeln('������������� ���������� ����� � 8 ���� �� 8 ������!');
  // First^.Shledule.Mon.STime.Minute := 0;
  // First^.Shledule.Mon.STime.Hour := 8;
  // First^.Shledule.Mon.ETime.Minute := 0;
  // First^.Shledule.Mon.ETime.Hour := 20;
  // First^.Shledule.Tue.STime.Minute := 0;
  // First^.Shledule.Tue.STime.Hour := 8;
  // First^.Shledule.Tue.ETime.Minute := 0;
  // First^.Shledule.Tue.ETime.Hour := 20;
  // First^.Shledule.Wed.STime.Minute := 0;
  // First^.Shledule.Wed.STime.Hour := 8;
  // First^.Shledule.Wed.ETime.Minute := 0;
  // First^.Shledule.Wed.ETime.Hour := 20;
  // First^.Shledule.Thr.STime.Minute := 0;
  // First^.Shledule.Thr.STime.Hour := 8;
  // First^.Shledule.Thr.ETime.Minute := 0;
  // First^.Shledule.Thr.ETime.Hour := 20;
  // First^.Shledule.Fri.STime.Minute := 0;
  // First^.Shledule.Fri.STime.Hour := 8;
  // First^.Shledule.Fri.ETime.Minute := 0;
  // First^.Shledule.Fri.ETime.Hour := 20;
  // First^.Shledule.Sat.STime.Minute := 0;
  // First^.Shledule.Sat.STime.Hour := 8;
  // First^.Shledule.Sat.ETime.Minute := 0;
  // First^.Shledule.Sat.ETime.Hour := 20;
  // end;
  // end
  // else
  // begin
  // writeln('������� ������� �����!');
  // writeln('������������� ���������� ����� � 8 ���� �� 8 ������!');
  // First^.Shledule.Mon.STime.Minute := 0;
  // First^.Shledule.Mon.STime.Hour := 8;
  // First^.Shledule.Mon.ETime.Minute := 0;
  // First^.Shledule.Mon.ETime.Hour := 20;
  // First^.Shledule.Tue.STime.Minute := 0;
  // First^.Shledule.Tue.STime.Hour := 8;
  // First^.Shledule.Tue.ETime.Minute := 0;
  // First^.Shledule.Tue.ETime.Hour := 20;
  // First^.Shledule.Wed.STime.Minute := 0;
  // First^.Shledule.Wed.STime.Hour := 8;
  // First^.Shledule.Wed.ETime.Minute := 0;
  // First^.Shledule.Wed.ETime.Hour := 20;
  // First^.Shledule.Thr.STime.Minute := 0;
  // First^.Shledule.Thr.STime.Hour := 8;
  // First^.Shledule.Thr.ETime.Minute := 0;
  // First^.Shledule.Thr.ETime.Hour := 20;
  // First^.Shledule.Fri.STime.Minute := 0;
  // First^.Shledule.Fri.STime.Hour := 8;
  // First^.Shledule.Fri.ETime.Minute := 0;
  // First^.Shledule.Fri.ETime.Hour := 20;
  // First^.Shledule.Sat.STime.Minute := 0;
  // First^.Shledule.Sat.STime.Hour := 8;
  // First^.Shledule.Sat.ETime.Minute := 0;
  // First^.Shledule.Sat.ETime.Hour := 20;
  // end;
  // end
  // else
  // begin
  // while First^.Next <> nil do
  // begin
  // if (AnsiUpperCase(F) = AnsiUpperCase(First^.Surname)) and
  // (AnsiUpperCase(i) = AnsiUpperCase(First^.FName)) and
  // (AnsiUpperCase(O) = AnsiUpperCase(First^.MName)) then
  // begin
  // flag := true;
  // end;
  // First := First^.Next;
  // end;
  // if not flag then
  // begin
  // New(First^.Next);
  // First^.Next^.ID := First^.ID + 1;
  // First := First^.Next;
  // First^.FName := i;
  // First^.Surname := F;
  // First^.MName := O;
  // Write('������� ������������� ������ �����: ');
  // readln(spec);
  // First^.Specialization := spec;
  // Write('������� ����� ������ ������(� ������� ����:������): ');
  // readln(TInpt);
  // for var k := 1 to TInpt.Length do
  // begin
  // if (TInpt[k] = ':') then
  // begin
  // TimeFlag := true;
  // end
  // else
  // begin
  // if not TimeFlag then
  // begin
  // temp := temp + TInpt[k];
  // end
  // else
  // begin
  // MStr := MStr + TInpt[k];
  // end;
  // end;
  // end;
  // if TimeFlag then
  // begin
  // TimeFlag := false;
  // while InpFlag = false do
  // begin
  // try
  // ST.Hour := StrToInt(temp);
  // ST.Minute := StrToInt(MStr);
  // InpFlag := true;
  // except
  // writeln('������������ ����!');
  // Write('������� ����� ������ ������(� ������� ����:������): ');
  // temp := '';
  // MStr := '';
  // readln(TInpt);
  // for var k := 1 to TInpt.Length do
  // begin
  // if (TInpt[k] = ':') then
  // begin
  // TimeFlag := true;
  // end
  // else
  // begin
  // if not TimeFlag then
  // begin
  // temp := temp + TInpt[k];
  // end
  // else
  // begin
  // MStr := MStr + TInpt[k];
  // end;
  // end;
  // end;
  // end;
  // end;
  // InpFlag := false;
  // temp := '';
  // MStr := '';
  // Write('������� ����� ����� ������(� ������� ����:������): ');
  // readln(TInpt);
  // for var k := 1 to TInpt.Length do
  // begin
  // if (TInpt[k] = ':') then
  // begin
  // TimeFlag := true;
  // end
  // else
  // begin
  // if not TimeFlag then
  // begin
  // temp := temp + TInpt[k];
  // end
  // else
  // begin
  // MStr := MStr + TInpt[k];
  // end;
  // end;
  // end;
  // if TimeFlag then
  // begin
  // while InpFlag = false do
  // begin
  // try
  // ET.Hour := StrToInt(temp);
  // ET.Minute := StrToInt(MStr);
  // InpFlag := true;
  // except
  // writeln('������������ ����!');
  // Write('������� ����� ����� ������(� ������� ����:������): ');
  // temp := '';
  // MStr := '';
  // readln(TInpt);
  // for var k := 1 to TInpt.Length do
  // begin
  // if (TInpt[k] = ':') then
  // begin
  // TimeFlag := true;
  // end
  // else
  // begin
  // if not TimeFlag then
  // begin
  // temp := temp + TInpt[k];
  // end
  // else
  // begin
  // MStr := MStr + TInpt[k];
  // end;
  // end;
  // end;
  // end;
  // end;
  // InpFlag := false;
  // InpFlag := false;
  // if (ET.Hour * 60 + ET.Minute) > (ST.Hour * 60 + ST.Minute) then
  // begin
  // First^.Shledule.Mon.STime.Minute := ST.Minute;
  // First^.Shledule.Mon.STime.Hour := ST.Hour;
  // First^.Shledule.Mon.ETime.Minute := ET.Minute;
  // First^.Shledule.Mon.ETime.Hour := ET.Hour;
  // First^.Shledule.Tue.STime.Minute := ST.Minute;
  // First^.Shledule.Tue.STime.Hour := ST.Hour;
  // First^.Shledule.Tue.ETime.Minute := ET.Minute;
  // First^.Shledule.Tue.ETime.Hour := ET.Hour;
  // First^.Shledule.Wed.STime.Minute := ST.Minute;
  // First^.Shledule.Wed.STime.Hour := ST.Hour;
  // First^.Shledule.Wed.ETime.Minute := ET.Minute;
  // First^.Shledule.Wed.ETime.Hour := ET.Hour;
  // First^.Shledule.Thr.STime.Minute := ST.Minute;
  // First^.Shledule.Thr.STime.Hour := ST.Hour;
  // First^.Shledule.Thr.ETime.Minute := ET.Minute;
  // First^.Shledule.Thr.ETime.Hour := ET.Hour;
  // First^.Shledule.Fri.STime.Minute := ST.Minute;
  // First^.Shledule.Fri.STime.Hour := ST.Hour;
  // First^.Shledule.Fri.ETime.Minute := ET.Minute;
  // First^.Shledule.Fri.ETime.Hour := ET.Hour;
  // First^.Shledule.Sat.STime.Minute := ST.Minute;
  // First^.Shledule.Sat.STime.Hour := ST.Hour;
  // First^.Shledule.Sat.ETime.Minute := ET.Minute;
  // First^.Shledule.Sat.ETime.Hour := ET.Hour;
  // writeln('������ ���������!');
  // end
  // else
  // begin
  // writeln('������� ������� �����!');
  // writeln('������������� ���������� ����� � 8 ���� �� 8 ������!');
  // First^.Shledule.Mon.STime.Minute := 0;
  // First^.Shledule.Mon.STime.Hour := 8;
  // First^.Shledule.Mon.ETime.Minute := 0;
  // First^.Shledule.Mon.ETime.Hour := 20;
  // First^.Shledule.Tue.STime.Minute := 0;
  // First^.Shledule.Tue.STime.Hour := 8;
  // First^.Shledule.Tue.ETime.Minute := 0;
  // First^.Shledule.Tue.ETime.Hour := 20;
  // First^.Shledule.Wed.STime.Minute := 0;
  // First^.Shledule.Wed.STime.Hour := 8;
  // First^.Shledule.Wed.ETime.Minute := 0;
  // First^.Shledule.Wed.ETime.Hour := 20;
  // First^.Shledule.Thr.STime.Minute := 0;
  // First^.Shledule.Thr.STime.Hour := 8;
  // First^.Shledule.Thr.ETime.Minute := 0;
  // First^.Shledule.Thr.ETime.Hour := 20;
  // First^.Shledule.Fri.STime.Minute := 0;
  // First^.Shledule.Fri.STime.Hour := 8;
  // First^.Shledule.Fri.ETime.Minute := 0;
  // First^.Shledule.Fri.ETime.Hour := 20;
  // First^.Shledule.Sat.STime.Minute := 0;
  // First^.Shledule.Sat.STime.Hour := 8;
  // First^.Shledule.Sat.ETime.Minute := 0;
  // First^.Shledule.Sat.ETime.Hour := 20;
  // end;
  // end
  // else
  // begin
  // writeln('������� ������� �����!');
  // writeln('������������� ���������� ����� � 8 ���� �� 8 ������!');
  // First^.Shledule.Mon.STime.Minute := 0;
  // First^.Shledule.Mon.STime.Hour := 8;
  // First^.Shledule.Mon.ETime.Minute := 0;
  // First^.Shledule.Mon.ETime.Hour := 20;
  // First^.Shledule.Tue.STime.Minute := 0;
  // First^.Shledule.Tue.STime.Hour := 8;
  // First^.Shledule.Tue.ETime.Minute := 0;
  // First^.Shledule.Tue.ETime.Hour := 20;
  // First^.Shledule.Wed.STime.Minute := 0;
  // First^.Shledule.Wed.STime.Hour := 8;
  // First^.Shledule.Wed.ETime.Minute := 0;
  // First^.Shledule.Wed.ETime.Hour := 20;
  // First^.Shledule.Thr.STime.Minute := 0;
  // First^.Shledule.Thr.STime.Hour := 8;
  // First^.Shledule.Thr.ETime.Minute := 0;
  // First^.Shledule.Thr.ETime.Hour := 20;
  // First^.Shledule.Fri.STime.Minute := 0;
  // First^.Shledule.Fri.STime.Hour := 8;
  // First^.Shledule.Fri.ETime.Minute := 0;
  // First^.Shledule.Fri.ETime.Hour := 20;
  // First^.Shledule.Sat.STime.Minute := 0;
  // First^.Shledule.Sat.STime.Hour := 8;
  // First^.Shledule.Sat.ETime.Minute := 0;
  // First^.Shledule.Sat.ETime.Hour := 20;
  // end;
  // end
  // else
  // begin
  // writeln('������� ������� �����!');
  // writeln('������������� ���������� ����� � 8 ���� �� 8 ������!');
  // First^.Shledule.Mon.STime.Minute := 0;
  // First^.Shledule.Mon.STime.Hour := 8;
  // First^.Shledule.Mon.ETime.Minute := 0;
  // First^.Shledule.Mon.ETime.Hour := 20;
  // First^.Shledule.Tue.STime.Minute := 0;
  // First^.Shledule.Tue.STime.Hour := 8;
  // First^.Shledule.Tue.ETime.Minute := 0;
  // First^.Shledule.Tue.ETime.Hour := 20;
  // First^.Shledule.Wed.STime.Minute := 0;
  // First^.Shledule.Wed.STime.Hour := 8;
  // First^.Shledule.Wed.ETime.Minute := 0;
  // First^.Shledule.Wed.ETime.Hour := 20;
  // First^.Shledule.Thr.STime.Minute := 0;
  // First^.Shledule.Thr.STime.Hour := 8;
  // First^.Shledule.Thr.ETime.Minute := 0;
  // First^.Shledule.Thr.ETime.Hour := 20;
  // First^.Shledule.Fri.STime.Minute := 0;
  // First^.Shledule.Fri.STime.Hour := 8;
  // First^.Shledule.Fri.ETime.Minute := 0;
  // First^.Shledule.Fri.ETime.Hour := 20;
  // First^.Shledule.Sat.STime.Minute := 0;
  // First^.Shledule.Sat.STime.Hour := 8;
  // First^.Shledule.Sat.ETime.Minute := 0;
  // First^.Shledule.Sat.ETime.Hour := 20;
  // end;
  // end
  // else
  // begin
  // writeln('����� ���� ��� ����������');
  // end;
  // end;
end;

procedure SetShledule(Pt: DoctorPointer);
var
  SMinutes, EMinutes: 0 .. 59;
  SHours, EHours: 0 .. 23;
  Inp: string;
  flag: Boolean;
begin
  flag := false;
  for var i := 1 to 6 do
  begin
    SMinutes := 1;
    SHours := 1;
    EMinutes := 0;
    EHours := 0;
    while SMinutes + SHours * 60 >= EMinutes + EHours * 60 do
    begin
      while flag = false do
      begin
        try
          Write('������� ������ ������� ������  � ', i,
            '-� ���� ������ (����): ');
          Readln(Inp);
          SHours := StrToInt(Inp);
          flag := True;
        except
          Writeln('������������ ����!');
        end;
      end;
      flag := false;
      while flag = false do
      begin
        try
          Write('������� ������ ������� ������  � ', i,
            '-� ���� ������ (������): ');
          Readln(Inp);
          SMinutes := StrToInt(Inp);
          flag := True;
        except
          Writeln('������������ ����!');
        end;
      end;
      flag := false;
      while flag = false do
      begin
        try
          Write('������� ����� ������� ������  � ', i,
            '-� ���� ������ (����): ');
          Readln(Inp);
          EHours := StrToInt(Inp);
          flag := True;
        except
          Writeln('������������ ����!');
        end;
      end;
      flag := false;
      while flag = false do
      begin
        try
          Write('������� ����� ������� ������  � ', i,
            '-� ���� ������ (������): ');
          Readln(Inp);
          EMinutes := StrToInt(Inp);
          flag := True;
        except
          Writeln('������������ ����!');
        end;
      end;
      flag := false;
      if SMinutes + SHours * 60 >= EMinutes + EHours * 60 then
        Writeln('������������ ����!')
    end;
    case i of
      1:
        begin
          Pt.Data.Shledule.Mon.STime.Hour := SHours;
          Pt.Data.Shledule.Mon.STime.Minute := SMinutes;
          Pt.Data.Shledule.Mon.ETime.Hour := EHours;
          Pt.Data.Shledule.Mon.ETime.Minute := EMinutes;
        end;
      2:
        begin
          Pt.Data.Shledule.Tue.STime.Hour := SHours;
          Pt.Data.Shledule.Tue.STime.Minute := SMinutes;
          Pt.Data.Shledule.Tue.ETime.Hour := EHours;
          Pt.Data.Shledule.Tue.ETime.Minute := EMinutes;
        end;
      3:
        begin
          Pt.Data.Shledule.Wed.STime.Hour := SHours;
          Pt.Data.Shledule.Wed.STime.Minute := SMinutes;
          Pt.Data.Shledule.Wed.ETime.Hour := EHours;
          Pt.Data.Shledule.Wed.ETime.Minute := EMinutes;
        end;
      4:
        begin
          Pt.Data.Shledule.Thr.STime.Hour := SHours;
          Pt.Data.Shledule.Thr.STime.Minute := SMinutes;
          Pt.Data.Shledule.Thr.ETime.Hour := EHours;
          Pt.Data.Shledule.Thr.ETime.Minute := EMinutes;
        end;
      5:
        begin
          Pt.Data.Shledule.Fri.STime.Hour := SHours;
          Pt.Data.Shledule.Fri.STime.Minute := SMinutes;
          Pt.Data.Shledule.Fri.ETime.Hour := EHours;
          Pt.Data.Shledule.Fri.ETime.Minute := EMinutes;
        end;
      6:
        begin
          Pt.Data.Shledule.Sat.STime.Hour := SHours;
          Pt.Data.Shledule.Sat.STime.Minute := SMinutes;
          Pt.Data.Shledule.Sat.ETime.Hour := EHours;
          Pt.Data.Shledule.Sat.ETime.Minute := EMinutes;
        end;
    end;
  end;
end;

procedure Add(First: DoctorPointer); overload;
var
  F, i, O, Spec, temp, TInpt, MStr: string;
  flag, FirstFlag: Boolean;
  Pt: DoctorPointer;
begin
  FirstFlag := false;
  Write('������� ������� ������ �����: ');
  Readln(F);
  Write('������� ��� ������ �����: ');
  Readln(i);
  Write('������� �������� ������ �����: ');
  Readln(O);
  Write('������� ������������� ������ �����: ');
  Readln(Spec);
  if First = nil then
    FirstFlag := True
  else
    while First^.Next <> nil do
    begin
      if (First.Data.Surname = F) and (First.Data.FName = i) and
        (First.Data.MName = O) and (First.Data.Specialization = Spec) then
      begin
        Writeln('����� ���� ��� ����������!');
        Readln;
        Clear;
        MenuOptionsOutput;
      end
      else
      begin
        First := First^.Next;
      end;
    end;
  if FirstFlag then
  begin
    New(FDPT);
    First := FDPT;
  end
  else
  begin
    New(First^.Next);
    First := First^.Next;
  end;
  First.Data.ID := GlobID + 1;
  inc(GlobID);
  First.Data.Surname := F;
  First.Data.FName := i;
  First.Data.MName := O;
  First.Data.Specialization := Spec;
  SetShledule(First);
  Writeln('���� ������� �������� � ����!');
  First^.Next := nil;
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure Add(First: TicketPointer; FirstD: DoctorPointer); overload;
var
  Inp, Spec, F, i, O: string;
  Num, Cnt, Inpt, TempID: Integer;
  TempPT: TicketPointer;
  TempDPT: DoctorPointer;
  flag, inpflag: Boolean;
  FreeTickets: array of TicketPointer;
  Arr: Array of DoctorPointer;
begin
  Cnt := 1;
  flag := false;
  inpflag := false;
  if First = nil then
  begin
    Writeln('������ �� �������������! ');
    Readln;
    Clear;
    MenuOptionsOutput;
  end
  else
  begin
    Write('������� �������� �������������:');
    Readln(Spec);
    while FirstD <> nil do
    begin
      if (AnsiUpperCase(FirstD.Data.Specialization) = AnsiUpperCase(Spec)) then
      begin
        SetLength(Arr, Cnt);
        Arr[Cnt - 1] := FirstD;
        Writeln(Cnt, '.');
        Writeln('��� �����: ', FirstD.Data.Surname, ' ', FirstD.Data.FName, ' ',
          FirstD.Data.MName);
        Writeln('ID �����: ', FirstD.Data.ID);
        Writeln('�������������: ', FirstD.Data.Specialization);
        Writeln('������ ������ � �����������: ',
          FirstD.Data.Shledule.Mon.STime.Hour, ':',
          FirstD.Data.Shledule.Mon.STime.Minute,
          ' ����� ������ � �����������: ', FirstD.Data.Shledule.Mon.ETime.Hour,
          ':', FirstD.Data.Shledule.Mon.ETime.Minute);
        Writeln('������ ������ �� �������: ',
          FirstD.Data.Shledule.Tue.STime.Hour, ':',
          FirstD.Data.Shledule.Tue.STime.Minute, ' ����� ������ �� �������: ',
          FirstD.Data.Shledule.Tue.ETime.Hour, ':',
          FirstD.Data.Shledule.Tue.ETime.Minute);
        Writeln('������ ������ � �����: ', FirstD.Data.Shledule.Wed.STime.Hour,
          ':', FirstD.Data.Shledule.Wed.STime.Minute, ' ����� ������ � �����: ',
          FirstD.Data.Shledule.Wed.ETime.Hour, ':',
          FirstD.Data.Shledule.Wed.ETime.Minute);
        Writeln('������ ������ � �������: ',
          FirstD.Data.Shledule.Thr.STime.Hour, ':',
          FirstD.Data.Shledule.Thr.STime.Minute, ' ����� ������ � �������: ',
          FirstD.Data.Shledule.Thr.ETime.Hour, ':',
          FirstD.Data.Shledule.Thr.ETime.Minute);
        Writeln('������ ������ � �������: ',
          FirstD.Data.Shledule.Fri.STime.Hour, ':',
          FirstD.Data.Shledule.Fri.STime.Minute, ' ����� ������ � �������: ',
          FirstD.Data.Shledule.Fri.ETime.Hour, ':',
          FirstD.Data.Shledule.Fri.ETime.Minute);
        Writeln('������ ������ � �������: ',
          FirstD.Data.Shledule.Sat.STime.Hour, ':',
          FirstD.Data.Shledule.Sat.STime.Minute, ' ����� ������ � �������: ',
          FirstD.Data.Shledule.Sat.ETime.Hour, ':',
          FirstD.Data.Shledule.Sat.ETime.Minute);
        Writeln;
        Writeln;
        inc(Cnt);
      end;
      FirstD := FirstD^.Next;
    end;
    if Length(Arr) > 0 then
    begin
      Write('�������� ����� �����, � �������� ������ ����������: ');
      while inpflag = false do
      begin
        try
          Readln(Inpt);
          TempDPT := Arr[Inpt - 1];
          TempID := Arr[Inpt - 1].Data.ID;
          inpflag := True;
        except
          Write('������������ ����! ������� ���������� ��������: ');
        end;
      end;
      inpflag := false;
      TempPT := First;
      while TempPT <> nil do
      begin
        if (TempPT.Inf.Patient.Surname = '') and (TempPT.Inf.Patient.MName = '')
          and (TempPT.Inf.Patient.FName = '') and (TempPT.Inf.DoctorID = TempID)
        then
        begin
          flag := True;
        end;
        TempPT := TempPT^.Next;
      end;
      if flag then
      begin
        TempPT := First;
        Writeln('1 - �����������');
        Writeln('2 - �������');
        Writeln('3 - �����');
        Writeln('4 - �������');
        Writeln('5 - �������');
        Writeln('6 - �������');
        Write('������� ����� ��� ������ �� ������� ������ �� ���������� (�� 1 �� 6): ');
        Readln(Inp);
        while (Inp <> '1') and (Inp <> '2') and (Inp <> '3') and (Inp <> '4')
          and (Inp <> '5') and (Inp <> '6') do
        begin
          Write('�������� ����! ������� �������� ���������: ');
          Readln(Inp);
        end;
        Num := StrToInt(Inp);
        Writeln;
        case Num of
          1:
            begin
              Writeln('������ ������ � �����������: ',
                TempDPT.Data.Shledule.Mon.STime.Hour, ':',
                TempDPT.Data.Shledule.Mon.STime.Minute,
                ' ����� ������ � �����������: ',
                TempDPT.Data.Shledule.Mon.ETime.Hour, ':',
                TempDPT.Data.Shledule.Mon.ETime.Minute);
            end;
          2:
            begin
              Writeln('������ ������ �� �������: ',
                TempDPT.Data.Shledule.Tue.STime.Hour, ':',
                TempDPT.Data.Shledule.Tue.STime.Minute,
                ' ����� ������ �� �������: ',
                TempDPT.Data.Shledule.Tue.ETime.Hour, ':',
                TempDPT.Data.Shledule.Tue.ETime.Minute);
            end;
          3:
            begin
              Writeln('������ ������ � �����: ',
                TempDPT.Data.Shledule.Wed.STime.Hour, ':',
                TempDPT.Data.Shledule.Wed.STime.Minute,
                ' ����� ������ � �����: ', TempDPT.Data.Shledule.Wed.ETime.Hour,
                ':', TempDPT.Data.Shledule.Wed.ETime.Minute);
            end;
          4:
            begin
              Writeln('������ ������ � �������: ',
                TempDPT.Data.Shledule.Thr.STime.Hour, ':',
                TempDPT.Data.Shledule.Thr.STime.Minute,
                ' ����� ������ � �������: ',
                TempDPT.Data.Shledule.Thr.ETime.Hour, ':',
                TempDPT.Data.Shledule.Thr.ETime.Minute);
            end;
          5:
            begin
              Writeln('������ ������ � �������: ',
                TempDPT.Data.Shledule.Fri.STime.Hour, ':',
                TempDPT.Data.Shledule.Fri.STime.Minute,
                ' ����� ������ � �������: ',
                TempDPT.Data.Shledule.Fri.ETime.Hour, ':',
                TempDPT.Data.Shledule.Fri.ETime.Minute);
            end;
          6:
            begin
              Writeln('������ ������ � �������: ',
                TempDPT.Data.Shledule.Sat.STime.Hour, ':',
                TempDPT.Data.Shledule.Sat.STime.Minute,
                ' ����� ������ � �������: ',
                TempDPT.Data.Shledule.Sat.ETime.Hour, ':',
                TempDPT.Data.Shledule.Sat.ETime.Minute);
            end;
        end;
        Writeln;
        Writeln('��������� ������ � ����� �� ���� ���� ������: ');
        Cnt := 1;
        while TempPT <> nil do
        begin
          if (TempPT.Inf.Patient.Surname = '') and
            (TempPT.Inf.Patient.MName = '') and (TempPT.Inf.Patient.FName = '')
            and (TempPT.Inf.DoctorID = TempID) and
            (DayOfWeek(TempPT.Inf.Date) = Num + 1) then
          begin
            Write(Cnt, '. ');
            SetLength(FreeTickets, Cnt);
            FreeTickets[Cnt - 1] := TempPT;
            inc(Cnt);
            Write('����: ', DateToStr(TempPT.Inf.Date));
            Writeln(' �����: ', TempPT.Inf.Time.Hour, ':',
              TempPT.Inf.Time.Minute);
            Writeln;
          end;
          TempPT := TempPT^.Next;
        end;
        Write('�������� ����� ������, ������� ��� ��������(� ������, ���� �� ���� �� �������� ������� 0): ');
        while inpflag = false do
        begin
          try
            Readln(Inpt);
            if Inpt = 0 then
            begin
              Writeln('����������� � ����������� ����!');
              Readln;
              Clear;
              MenuOptionsOutput;
            end
            else
            begin
              TempPT := FreeTickets[Inpt - 1];
            end;
            inpflag := True;
          except
            Write('������������ ����! ������� ���������� ��������: ');
          end;
        end;
        inpflag := false;
        Writeln('������� ��� ���');
        Write('������� ���� �������: ');
        Readln(F);
        while Trim(F) = '' do
        begin
          Write('�� �� ����� �������! ������� �������: ');
          Readln(F);
        end;
        Write('������� ��� ���: ');
        Readln(i);
        while Trim(i) = '' do
        begin
          Write('�� �� ����� ���! ������� ���: ');
          Readln(i);
        end;
        Write('������� ��� ��������: ');
        Readln(O);
        while Trim(O) = '' do
        begin
          Write('�� �� ����� ��������! ������� ��������: ');
          Readln(O);
        end;
        TempPT.Inf.Patient.Surname := Trim(F);
        TempPT.Inf.Patient.FName := Trim(i);
        TempPT.Inf.Patient.MName := Trim(O);
        Writeln('�� ������� ���������� � �����!');
      end
      else
      begin
        Writeln('��� ��������� ������� � ���������� �����!');
      end;
    end
    else
    begin
      Writeln('������ � ����� �������������� ��� � ����!');
      Readln;
      Clear;
      MenuOptionsOutput;
    end;
    Readln;
    Clear;
    MenuOptionsOutput;
  end;
end;

procedure Sort(First: TicketPointer); overload;
var
  Sorted: TicketPointer;
begin
  if (First = nil) or (First^.Next = nil) then
  begin
    Writeln('� ������ ������ �����������!');
    Readln;
    Clear;
    MenuOptionsOutput;
  end
  else
  begin
    // FTPT:=InsertionSortTickets(First);
    Writeln('������ ������� ������������!');
    Readln;
    Clear;
    MenuOptionsOutput;
  end;
end;

function InsertionSortDoctors(var Head: DoctorPointer): DoctorPointer;
var
  Current, Prev, NextNode, Sorted, temp: DoctorPointer;
begin
  Sorted := nil;
  Current := Head;
  while Current <> nil do
  begin
    NextNode := Current^.Next;
    if (Sorted = nil) or (AnsiUpperCase(Sorted^.Data.Specialization) >
      AnsiUpperCase(Current^.Data.Specialization)) then
    begin
      Current^.Next := Sorted;
      Sorted := Current;
    end
    else
    begin
      Prev := Sorted;
      while (Prev^.Next <> nil) and
        (AnsiUpperCase(Prev^.Next^.Data.Specialization) <
        AnsiUpperCase(Current^.Data.Specialization)) do
        Prev := Prev^.Next;
      Current^.Next := Prev^.Next;
      Prev^.Next := Current;
    end;
    Current := NextNode;
  end;
  Result := Sorted;
end;

procedure Sort(First: DoctorPointer); overload;
var
  Sorted: DoctorPointer;
begin
  if (First = nil) or (First^.Next = nil) then
  begin
    Writeln('� ������ ������ �����������!');
    Readln;
    Clear;
    MenuOptionsOutput;
  end
  else
  begin
    FDPT := InsertionSortDoctors(First);
    // or
    // ((AnsiUpperCase(Prev^.Next^.Data.Specialization)
    // = AnsiUpperCase(Current^.Data.Specialization)) and
    // (AnsiUpperCase(Prev^.Next^.Data.Surname) <
    // AnsiUpperCase(Current^.Data.Surname)))

    // or
    // ((AnsiUpperCase(Sorted^.Data.Specialization)
    // = AnsiUpperCase(Current^.Data.Specialization)) and
    // (AnsiUpperCase(Sorted^.Data.Surname) >
    // AnsiUpperCase(Current^.Data.Surname)))
    // while First^.Next <> nil do
    // begin
    // TempPT := First^.Next;
    // Min := AnsiUpperCase(First^.Data.Specialization);
    // MinPt := First;
    // while TempPT <> nil do
    // begin
    // if AnsiUpperCase(TempPT^.Data.Specialization) < Min then
    // begin
    // MinPt := TempPT;
    // Min := AnsiUpperCase(TempPT^.Data.Specialization);
    // end;
    // TempPT := TempPT^.Next;
    // end;
    // SwapPointers(First, MinPt);
    // First := First^.Next;
    // end;
    Writeln('������ ������� ������������!');
    Readln;
    Clear;
    MenuOptionsOutput;
  end;
end;

Procedure Generate(First: TicketPointer; FirstD: DoctorPointer);
var
  Day, TempID, j, Cnt, Inpt: Integer;
  Inp, F, i, O, Spec: string;
  Date: TDateTime;
  TempTime: TypeTime;
  TempPT: DoctorPointer;
  flag, ptflag, inpflag, DateFlag: Boolean;
  Arr: Array of DoctorPointer;
begin
  DateFlag := false;
  Cnt := 1;
  inpflag := false;
  j := 1;
  flag := false;
  ptflag := false;
  Write('������� �������� �������������:');
  Readln(Spec);
  while FirstD <> nil do
  begin
    if (AnsiUpperCase(FirstD.Data.Specialization) = AnsiUpperCase(Spec)) then
    begin
      flag := True;
      SetLength(Arr, Cnt);
      Arr[Cnt - 1] := FirstD;
      Writeln(Cnt, '.');
      Writeln('��� �����: ', FirstD.Data.Surname, ' ', FirstD.Data.FName, ' ',
        FirstD.Data.MName);
      Writeln('ID �����: ', FirstD.Data.ID);
      Writeln('�������������: ', FirstD.Data.Specialization);
      Writeln('������ ������ � �����������: ',
        FirstD.Data.Shledule.Mon.STime.Hour, ':',
        FirstD.Data.Shledule.Mon.STime.Minute, ' ����� ������ � �����������: ',
        FirstD.Data.Shledule.Mon.ETime.Hour, ':',
        FirstD.Data.Shledule.Mon.ETime.Minute);
      Writeln('������ ������ �� �������: ', FirstD.Data.Shledule.Tue.STime.Hour,
        ':', FirstD.Data.Shledule.Tue.STime.Minute,
        ' ����� ������ �� �������: ', FirstD.Data.Shledule.Tue.ETime.Hour, ':',
        FirstD.Data.Shledule.Tue.ETime.Minute);
      Writeln('������ ������ � �����: ', FirstD.Data.Shledule.Wed.STime.Hour,
        ':', FirstD.Data.Shledule.Wed.STime.Minute, ' ����� ������ � �����: ',
        FirstD.Data.Shledule.Wed.ETime.Hour, ':',
        FirstD.Data.Shledule.Wed.ETime.Minute);
      Writeln('������ ������ � �������: ', FirstD.Data.Shledule.Thr.STime.Hour,
        ':', FirstD.Data.Shledule.Thr.STime.Minute, ' ����� ������ � �������: ',
        FirstD.Data.Shledule.Thr.ETime.Hour, ':',
        FirstD.Data.Shledule.Thr.ETime.Minute);
      Writeln('������ ������ � �������: ', FirstD.Data.Shledule.Fri.STime.Hour,
        ':', FirstD.Data.Shledule.Fri.STime.Minute, ' ����� ������ � �������: ',
        FirstD.Data.Shledule.Fri.ETime.Hour, ':',
        FirstD.Data.Shledule.Fri.ETime.Minute);
      Writeln('������ ������ � �������: ', FirstD.Data.Shledule.Sat.STime.Hour,
        ':', FirstD.Data.Shledule.Sat.STime.Minute, ' ����� ������ � �������: ',
        FirstD.Data.Shledule.Sat.ETime.Hour, ':',
        FirstD.Data.Shledule.Sat.ETime.Minute);
      Writeln;
      Writeln;
      inc(Cnt);
    end;
    FirstD := FirstD^.Next;
  end;
  if flag then
  begin
    Write('������� ����� ��������� ����� ��� ��������� �������: ');
    while inpflag = false do
    begin
      try
        Readln(Inpt);
        TempPT := Arr[Inpt - 1];
        TempID := Arr[Inpt - 1].Data.ID;
        inpflag := True;
      except
        Writeln('������������ ����! ������� ���������� ��������!');
      end;
    end;

    inpflag := false;
    while inpflag = false do
    begin
      try
        DateFlag := false;
        while not DateFlag do
        begin
          Write('������� ����, ������� � ������� ������������� ������ �� ������ (� ������� �����/����/���): ');
          Readln(Inp);
          Cnt := 0;
          for var s := 1 to Length(Inp) do
          begin
            if Inp[s] = '/' then
              inc(Cnt);
          end;
          if Cnt = 2 then
            DateFlag := True
          else
            Writeln('�� ����������� ����� ����!');
        end;
        Date := StrTodateTime(Inp);
        inpflag := True;
      except
        Writeln('������������ ����! ������� ���������!');
      end;
    end;
    inpflag := false;
    Day := DayOfWeek(Date);
    if FTPT = nil then
    begin
      j := 1;
      New(FTPT);
      First := FTPT;
      First.Next := nil;
      case Day of
        7:
          begin
            TempTime := TempPT.Data.Shledule.Sat.STime;
            Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
            while (TempTime.Hour * 60 + TempTime.Minute) <
              (TempPT.Data.Shledule.Sat.ETime.Hour * 60 +
              TempPT.Data.Shledule.Sat.ETime.Minute) do
            begin
              if not ptflag then
              begin
                ptflag := True;
              end
              else
              begin
                New(First^.Next);
                First := First^.Next;
              end;
              First.Inf.DoctorID := TempID;
              First.Inf.CabinetNum := TempID;
              First.Inf.Date := Date;
              First.Inf.QueueNum := j;
              inc(j);
              First.Inf.Time := TempTime;
              First.Inf.Patient.Surname := '';
              First.Inf.Patient.FName := '';
              First.Inf.Patient.MName := '';
              TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
              TempTime.Minute := (TempTime.Minute + 15) mod 60;
            end;
            Date := Date + 1;
            inc(Day);
          end;
        6:
          begin
            TempTime := TempPT.Data.Shledule.Fri.STime;
            Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
            while (TempTime.Hour * 60 + TempTime.Minute) <
              (TempPT.Data.Shledule.Fri.ETime.Hour * 60 +
              TempPT.Data.Shledule.Fri.ETime.Minute) do
            begin
              if not ptflag then
              begin
                ptflag := True;
              end
              else
              begin
                New(First^.Next);
                First := First^.Next;
              end;
              First.Inf.DoctorID := TempID;
              First.Inf.CabinetNum := TempID;
              First.Inf.Date := Date;
              First.Inf.QueueNum := j;
              inc(j);
              First.Inf.Time := TempTime;
              First.Inf.Patient.Surname := '';
              First.Inf.Patient.FName := '';
              First.Inf.Patient.MName := '';
              TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
              TempTime.Minute := (TempTime.Minute + 15) mod 60;
            end;
            Date := Date + 1;
            inc(Day);
          end;
        5:
          begin
            TempTime := TempPT.Data.Shledule.Thr.STime;
            Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
            while (TempTime.Hour * 60 + TempTime.Minute) <
              (TempPT.Data.Shledule.Thr.ETime.Hour * 60 +
              TempPT.Data.Shledule.Thr.ETime.Minute) do
            begin
              if not ptflag then
              begin
                ptflag := True;
              end
              else
              begin
                New(First^.Next);
                First := First^.Next;
              end;
              First.Inf.DoctorID := TempID;
              First.Inf.CabinetNum := TempID;
              First.Inf.Date := Date;
              First.Inf.QueueNum := j;
              inc(j);
              First.Inf.Time := TempTime;
              First.Inf.Patient.Surname := '';
              First.Inf.Patient.FName := '';
              First.Inf.Patient.MName := '';
              TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
              TempTime.Minute := (TempTime.Minute + 15) mod 60;

            end;
            Date := Date + 1;
            inc(Day);
          end;
        4:
          begin
            TempTime := TempPT.Data.Shledule.Wed.STime;
            Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
            while (TempTime.Hour * 60 + TempTime.Minute) <
              (TempPT.Data.Shledule.Wed.ETime.Hour * 60 +
              TempPT.Data.Shledule.Wed.ETime.Minute) do
            begin
              if not ptflag then
              begin
                ptflag := True;
              end
              else
              begin
                New(First^.Next);
                First := First^.Next;
              end;
              First.Inf.DoctorID := TempID;
              First.Inf.CabinetNum := TempID;
              First.Inf.Date := Date;
              First.Inf.QueueNum := j;
              inc(j);
              First.Inf.Time := TempTime;
              First.Inf.Patient.Surname := '';
              First.Inf.Patient.FName := '';
              First.Inf.Patient.MName := '';
              TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
              TempTime.Minute := (TempTime.Minute + 15) mod 60;

            end;
            Date := Date + 1;
            inc(Day);
          end;
        3:
          begin
            TempTime := TempPT.Data.Shledule.Tue.STime;
            Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
            while (TempTime.Hour * 60 + TempTime.Minute) <
              (TempPT.Data.Shledule.Tue.ETime.Hour * 60 +
              TempPT.Data.Shledule.Tue.ETime.Minute) do
            begin
              if not ptflag then
              begin
                ptflag := True;
              end
              else
              begin
                New(First^.Next);
                First := First^.Next;
              end;
              First.Inf.DoctorID := TempID;
              First.Inf.CabinetNum := TempID;
              First.Inf.Date := Date;
              First.Inf.QueueNum := j;
              inc(j);
              First.Inf.Time := TempTime;
              First.Inf.Patient.Surname := '';
              First.Inf.Patient.FName := '';
              First.Inf.Patient.MName := '';
              TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
              TempTime.Minute := (TempTime.Minute + 15) mod 60;

            end;
            Date := Date + 1;
            inc(Day);
          end;
        2:
          begin
            TempTime := TempPT.Data.Shledule.Mon.ETime;
            Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
            while (TempTime.Hour * 60 + TempTime.Minute) <
              (TempPT.Data.Shledule.Mon.ETime.Hour * 60 +
              TempPT.Data.Shledule.Mon.ETime.Minute) do
            begin
              if not ptflag then
              begin
                ptflag := True;
              end
              else
              begin
                New(First^.Next);
                First := First^.Next;
              end;
              First.Inf.DoctorID := TempID;
              First.Inf.CabinetNum := TempID;
              First.Inf.Date := Date;
              First.Inf.QueueNum := j;
              inc(j);
              First.Inf.Time := TempTime;
              First.Inf.Patient.Surname := '';
              First.Inf.Patient.FName := '';
              First.Inf.Patient.MName := '';
              TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
              TempTime.Minute := (TempTime.Minute + 15) mod 60;

            end;
            Date := Date + 1;
            inc(Day);
          end;
        1:
          begin
            inc(Day);
            Date := Date + 1;
          end;

      end;
      for var k := 1 to 6 do
      begin
        j := 1;
        case Day of
          1:
            begin
              inc(Day);
              Date := Date + 1;
            end;
          2:
            begin
              TempTime := TempPT.Data.Shledule.Mon.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Mon.ETime.Hour * 60 +
                TempPT.Data.Shledule.Mon.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;
              end;
              inc(Day);
              Date := Date + 1;
            end;
          3:
            begin
              TempTime := TempPT.Data.Shledule.Tue.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Tue.ETime.Hour * 60 +
                TempPT.Data.Shledule.Tue.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);

                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
          5:
            begin
              TempTime := TempPT.Data.Shledule.Thr.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Thr.ETime.Hour * 60 +
                TempPT.Data.Shledule.Thr.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
          4:
            begin
              TempTime := TempPT.Data.Shledule.Wed.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Wed.ETime.Hour * 60 +
                TempPT.Data.Shledule.Wed.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
          6:
            begin
              TempTime := TempPT.Data.Shledule.Fri.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Fri.ETime.Hour * 60 +
                TempPT.Data.Shledule.Fri.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
          7:
            begin
              TempTime := TempPT.Data.Shledule.Sat.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Sat.ETime.Hour * 60 +
                TempPT.Data.Shledule.Sat.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
        else
          begin
            Day := 2;
            Date := Date + 1;
          end;
        end;
      end;
    end
    else
    begin
      while (First^.Next <> nil) do
      begin
        First := First^.Next;
      end;
      for var k := 1 to 7 do
      begin
        j := 1;
        case Day of
          1:
            begin
              inc(Day);
              Date := Date + 1;
            end;
          2:
            begin
              TempTime := TempPT.Data.Shledule.Mon.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Mon.ETime.Hour * 60 +
                TempPT.Data.Shledule.Mon.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
          3:
            begin
              TempTime := TempPT.Data.Shledule.Tue.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Tue.ETime.Hour * 60 +
                TempPT.Data.Shledule.Tue.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
          5:
            begin
              TempTime := TempPT.Data.Shledule.Thr.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Thr.ETime.Hour * 60 +
                TempPT.Data.Shledule.Thr.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
          4:
            begin
              TempTime := TempPT.Data.Shledule.Wed.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Wed.ETime.Hour * 60 +
                TempPT.Data.Shledule.Wed.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
          6:
            begin
              TempTime := TempPT.Data.Shledule.Fri.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Fri.ETime.Hour * 60 +
                TempPT.Data.Shledule.Fri.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
          7:
            begin
              TempTime := TempPT.Data.Shledule.Sat.STime;
              Writeln('������ �� ', Day - 1, '-� ���� ������ �������������');
              while (TempTime.Hour * 60 + TempTime.Minute) <
                (TempPT.Data.Shledule.Sat.ETime.Hour * 60 +
                TempPT.Data.Shledule.Sat.ETime.Minute) do
              begin
                New(First^.Next);
                First := First^.Next;
                First.Inf.DoctorID := TempID;
                First.Inf.CabinetNum := TempID;
                First.Inf.Date := Date;
                First.Inf.QueueNum := j;
                inc(j);
                First.Inf.Time := TempTime;
                First.Inf.Patient.Surname := '';
                First.Inf.Patient.FName := '';
                First.Inf.Patient.MName := '';
                TempTime.Hour := TempTime.Hour + (TempTime.Minute + 15) div 60;
                TempTime.Minute := (TempTime.Minute + 15) mod 60;

              end;
              inc(Day);
              Date := Date + 1;
            end;
        else
          begin
            Day := 2;
            Date := Date + 1;
          end;
        end;
      end;
    end;
    First^.Next := nil;
  end
  else
  begin
    Writeln('������ � ����� �������������� ��� � ���� ������!');
  end;
  Readln;
  Clear;
  MenuOptionsOutput;
end;

procedure MenuOptionsOutput;
var
  input, input2: Integer;
  flag: Boolean;
begin
  flag := false;
  Writeln('�������� �������� �����');
  Writeln('1. ������ ������ �� �����'); // R
  Writeln('2. �������� ����� ������'); // R
  Writeln('3. ���������� ������'); // R?
  Writeln('4. ����� ������'); // R
  Writeln('5. ���������� ������ �����'); // R
  Writeln('6. ������� ������ �� ������'); // R
  Writeln('7. �������������� ������ �� ������'); // R/NR
  Writeln('8. ����-�������'); // R
  Writeln('9. ����� �� ��������� ��� ���������� ���������'); // R
  Writeln('10. ����� �� ��������� � ����������� ���������'); // R
  Write('������� ����� �����:');
  while flag = false do
  begin
    try
      Readln(input);
      flag := True;
    except
      Writeln('������������ ����!');
    end;
  end;
  flag := false;
  Clear;
  case input of
    1:
      if not ReadFlag then
      begin
        ReadFromFile(FDPT, FTPT);
      end
      else
      begin
        Writeln('���� ��� ��������!');
        Readln;
        Clear;
        MenuOptionsOutput;
      end;
    3:
      begin
        Writeln('�������� �������� �����');
        Writeln('1. ���������� ������ ������ �� �������������');
        Writeln('2. ���������� ������ ������� �� ���� � �������');
        Write('������� ����� �����:');
        while flag = false do
        begin
          try
            Readln(input2);
            flag := True;
          except
            Writeln('������������ ����!');
          end;
        end;
        flag := false;
        case input2 of
          1:
            begin
              Sort(FDPT);
            end;
          2:
            begin
              Sort(FTPT);
            end;
        else
          begin
            Writeln('�� ����� ������������ ��������, ���������� ������� �������� � ��������� �� 1 �� 2!');
            Readln;
            Clear;
            MenuOptionsOutput;
          end;
        end;
      end;
    9:
      ExitProgWithoutSaving;
    10:
      ExitProgWithSaving(FDPT, FTPT);
    4:
      begin
        var
          F, i, O: string;
        Writeln('�������� �������� �����');
        Writeln('1. ����� ���� ������� � ����� �� �������������');
        Writeln('2. ����� ������� � ������� �� ���');
        Write('������� ����� �����:');
        while flag = false do
        begin
          try
            Readln(input2);
            flag := True;
          except
            Writeln('������������ ����!');
          end;
        end;
        flag := false;
        case input2 of
          1:
            begin
              Write('������� ������������� �����: ');
              Readln(F);
              Poisk(FDPT, FTPT, F);
            end;
          2:
            begin
              Write('������� ������� ��������: ');
              Readln(F);
              Write('������� ��� ��������: ');
              Readln(i);
              Write('������� �������� ��������: ');
              Readln(O);
              Poisk(FTPT, F, i, O);
            end;
        else
          begin
            Writeln('�� ����� ������������ ��������, ���������� ������� �������� � ��������� �� 1 �� 2!');
            Readln;
            Clear;
            MenuOptionsOutput;
          end;
        end;

      end;
    5:
      begin
        Add(FDPT);
      end;
    6:
      begin
        Writeln('�������� �������� �����');
        Writeln('1. ������� ������ ������');
        Writeln('2. ������� ������ �����');
        Write('������� ����� �����:');
        while flag = false do
        begin
          try
            Readln(input2);
            flag := True;
          except
            Writeln('������������ ����!');
          end;
        end;
        flag := false;
        case input2 of
          1:
            begin
              Delete(FTPT);
            end;
          2:
            begin
              Delete(FDPT);
            end;
        else
          begin
            Writeln('�� ����� ������������ ��������, ���������� ������� �������� � ��������� �� 1 �� 2!');
            Readln;
            Clear;
            MenuOptionsOutput;
          end;
        end;
      end;
    2:
      begin
        Writeln('�������� �������� �����');
        Writeln('1. �������� ������ �������');
        Writeln('2. �������� ������ ������');
        Write('������� ����� �����:');
        while flag = false do
        begin
          try
            Readln(input2);
            flag := True;
          except
            Writeln('������������ ����!');
          end;
        end;
        flag := false;
        case input2 of
          1:
            begin
              View(FTPT);
            end;
          2:
            begin
              View(FDPT);
            end;
        else
          begin
            Writeln('�� ����� ������������ ��������, ���������� ������� �������� � ��������� �� 1 �� 2!');
            Readln;
            Clear;
            MenuOptionsOutput;
          end;
        end;
      end;
    7:
      Correct(FDPT);
    8:
      begin
        Writeln('�������� �������� �����');
        Writeln('1. ��������� ������� �� ������ �����');
        Writeln('2. ������ ������� � �����');
        Write('������� ����� �����:');
        while flag = false do
        begin
          try
            Readln(input2);
            flag := True;
          except
            Writeln('������������ ����!');
          end;
        end;
        flag := false;
        case input2 of
          1:
            begin
              Generate(FTPT, FDPT);
            end;
          2:
            begin
              Add(FTPT, FDPT);
            end;
        else
          begin
            Writeln('�� ����� ������������ ��������, ���������� ������� �������� � ��������� �� 1 �� 2!');
            Readln;
            Clear;
            MenuOptionsOutput;
          end;
        end;
      end;
  else
    begin
      Writeln('�� ����� ������������ ��������, ���������� ������� �������� � ��������� �� 1 �� 10!');
      Readln;
      Clear;
      MenuOptionsOutput;
    end;
  end;

end;

begin
  TicketsCount := 0;
  GlobID := 0;
  ReadFlag := false;
  MenuOptionsOutput;

end.
