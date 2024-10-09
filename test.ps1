function MakeTestCase {
    param(
        [Parameter(Mandatory)][string]$Path,
        [int64]$MaxFileSize = 200MB,
        [int64]$MinFileSize = 50MB,
        [int64]$MaxDirSize = 500MB,
        [string]$DirectoryName = "Test_Data",
        [string]$DataFileName = "" #"Test_Data_File"
    )

    New-Item -Path $Path -Name $DirectoryName -ItemType "directory" -ErrorAction Ignore

    $DirSize = 0
    $i = 1
    while($DirSize -lt $MaxDirSize) {
        if ($DataFileName.Length -eq 0) {
            $FileName = [System.IO.Path]::GetRandomFileName()
        } else {
            $FileName = "$DataFileName$i.dat" 
        }
        $FullFileName = Join-Path $Path -ChildPath $DirectoryName | Join-Path -ChildPath $FileName
        $FileSize = Get-Random -Minimum $MinFileSize -Maximum $MaxFileSize
        $content = New-Object byte[] $FileSize
        (New-Object System.Random).NextBytes($content)
        [System.IO.File]::WriteAllBytes($FullFileName, $content)

        $DirSize += $FileSize
        $i += 1
    }    
}

MakeTestCase -Path "D:\" -DirectoryName "TestCase1" -DataFileName "Test_Data_File"
MakeTestCase -Path "D:\" -DirectoryName "TestCase2"
MakeTestCase -Path "D:\" -DirectoryName "TestCase3" -DataFileName "Test_File"
MakeTestCase -Path "D:\" -DirectoryName "TestCase4"
