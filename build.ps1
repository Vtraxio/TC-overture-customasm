param (
    [string]$inFile
)

if (-Not (Test-Path $inFile)) {
    Write-Host "Input file does not exist: $inFile"
    exit 1
}

$outputFile = ".\dist\$((Get-Item $inFile).BaseName).hex"
$customasmPath = ".\tools\customasm.exe"

try {
    $assembled = & $customasmPath -f tcgame,base:16,group:2 -p -q $inFile
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Compilation successful."
    }
    else {
        Write-Host "Compilation failed with exit code $LASTEXITCODE."
        Write-Host $customasmOutput
        exit $LASTEXITCODE
    }

    $processed = $assembled | ForEach-Object {
        # Replace all # with //
        $str = $_ -replace '#', '//'
    
        # If the line is not a comment (doesn't start with //), replace spaces with ' <U8> '
        $str = $str.Trim()
        if ($str -notmatch '^\s*//' -and -not [string]::IsNullOrWhiteSpace($str)) {
            $str = $str -replace ' ', ' <U8> '
            $str = "<U8> " + $str
        }
    
        return $str
    }

    $processed | Set-Content $outputFile
}
catch {
    Write-Host "An error occurred: $_"
    exit 1
}