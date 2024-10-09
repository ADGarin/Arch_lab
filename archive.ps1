param(
    [Parameter(Mandatory)][string]$Archive,
    [Parameter(Mandatory)][string]$Path,
    [int64]$MaxSize = 1024,
    [double]$ThreshHold = 0.7,
    [int32]$LastFileCount = 3
)

$valid_in = Test-Path -Path $Path
if ($valid_in -eq $false) {
    Write-Host "Input path $Path is not valid"
    break
}

$items = Get-ChildItem -Path $Path -File | Sort-Object -Property LastWriteTime | Select-Object -First $LastFileCount

$dir_size = ($items | Measure-Object -Property Length -Sum).Sum
if ($dir_size -gt $MaxSize * $ThreshHold) {
    foreach ($item in $items) {
        # Write-Host $item.FullName
        Compress-Archive -Update $item.FullName $Archive
    }
}

$items | Remove-Item

# Write-Host "Directory $in size:" $dir_size
