unit uSaddlePoints;

interface
uses Spring;

type
  ISaddlePoints = interface(IInvokable)
  ['{8C41B1A2-335D-4C6D-AF55-9F307F358227}']
    function Calculate: TArray<Tuple<integer, integer>>;
    function getStatus: string;
    property Status: string read getStatus;
  end;

  function NewSaddlePoints(aValues: TArray<TArray<integer>>): ISaddlePoints;

implementation
uses Spring.Collections;

type
  TSaddlePoints = class(TInterfacedObject, ISaddlePoints)
  private
    fValues: TArray<TArray<integer>>;
    fmaxRows: TArray<integer>;
    fminCols: TArray<integer>;
    fStatus: string;
    function getRows: TArray<integer>;
    function getColumns: TArray<integer>;
    function Coordinates: IList<Tuple<integer, integer>>;
    function ColumnCount: integer;
    function RowCount: integer;
    function IsSaddlePoint(const coordinate: Tuple<integer, integer>): boolean;
    function getStatus: string;
  public
    constructor create(aValues: TArray<TArray<integer>>);
    function Calculate: TArray<Tuple<integer, integer>>;
    property Status: string read getStatus;
  end;

function NewSaddlePoints(aValues: TArray<TArray<integer>>): ISaddlePoints;
begin
  result := TSaddlePoints.create(aValues);
end;

constructor TSaddlePoints.create(aValues: TArray<TArray<Integer>>);
var I: integer;
    J: integer;
begin
  fValues := copy(aValues);
  fmaxRows := getRows;
  fminCols := getColumns;
  fStatus := 'Calculation not performed';
end;

function TSaddlePoints.getStatus: string;
begin
  result := fStatus;
end;

function TSaddlePoints.getRows: TArray<integer>;
var I: integer;
    J: integer;
    lRow: IList<integer>;
begin
  lRow := TCollections.CreateList<integer>;
  SetLength(result, RowCount);
  for I := 0 to RowCount - 1 do
  begin
    for J := 0 to ColumnCount - 1 do
      lRow.Add(fValues[I,J]);
    result[I] := lRow.Max;
    lRow.Clear;
  end;
end;

function TSaddlePoints.getColumns: TArray<integer>;
var I: integer;
    J: integer;
    lColumn: IList<integer>;
begin
  lColumn := TCollections.CreateList<integer>;
  SetLength(result, ColumnCount);
  for I := 0 to ColumnCount - 1 do
  begin
    for J := 0 to RowCount - 1 do
      lColumn.Add(fValues[J,I]);
    result[I] := lColumn.Min;
    lColumn.Clear;
  end;
end;

function TSaddlePoints.Coordinates: IList<Tuple<integer, integer>>;
var I, J: integer;
begin
  result := TCollections.CreateList<Tuple<integer, integer>>;
  for I := 0 to RowCount - 1 do
    for J := 0 to ColumnCount - 1 do
      result.Add(Tuple<integer, integer>.Create(I,J));
end;

function TSaddlePoints.Calculate: TArray<Tuple<integer, integer>>;
begin
  result := Coordinates.Where(IsSaddlePoint).ToArray;
  if length(result) = 0 then
    fStatus := 'No saddle points'
  else
    fStatus := '';
end;

function TSaddlePoints.ColumnCount: integer;
begin
  result := length(fValues[1]);
end;

function TSaddlePoints.RowCount: integer;
begin
  result := length(fValues);
end;

function TSaddlePoints.IsSaddlePoint(const coordinate: Tuple<integer, integer>): boolean;
begin
  result := (fmaxRows[coordinate.Value1] = fValues[coordinate.Value1, coordinate.Value2]) and
            (fminCols[coordinate.Value2] = fValues[coordinate.Value1, coordinate.Value2]);
end;

end.
