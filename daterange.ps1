param(
  [String]
  $DateStart,

  [String]
  $DateFinish
)


Function ParseDateStr {
  param(
    [String]
    $s
  )
  return Get-Date `
           -Month $s.substring(0,2) `
           -Day $s.substring(2,2) `
           -Year ('20'+$s.substring(4,2)) `
           -Hour 0 -Minute 0 -Second 0
}

$start = ( ParseDateStr $DateStart )
$finish = ( ParseDateStr $DateFinish )

$delta = New-TimeSpan -Days 1

for ($d = $start; $d -le $finish; $d +=$delta) {
    Write-Host $d.toString("MMddyy")
}