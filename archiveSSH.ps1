Write-Host "7zip musi byc zainstalowany w sciezce C:\Program Files\7-Zip\7z.exe"

# Ścieżka do folderu, który chcemy skompresować
$homePath = $env:HOME
if ([string]::IsNullOrEmpty($homePath)) {
    $homePath = $env:USERPROFILE
}

$today = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFileName = "$today ssh keys"

if (-not (Test-Path "$homePath\.ssh")) {
    Write-Host "Plik .ssh nie istnieje w $homePath"
    return
}

Write-Host "Plik o nazwie '$backupFileName' zostanie zapisany na pulpicie"

# Pobieranie hasła od użytkownika
$securePassword = Read-Host -Prompt "Podaj haslo" -AsSecureString
$plainPassword = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($plainPassword)

$desktopPath = [Environment]::GetFolderPath("Desktop")
$archives = Get-ChildItem -Path $desktopPath -Filter "*.7z" -File

foreach ($archive in $archives) {
    
    if ($archive.Name -like "*ssh keys*") {
        Write-Host "Zastapiono plik $archive"
        Remove-Item -Path $archive.FullName -Force
    }
}


Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "a", "-p$password", "$desktopPath/`"$backupFileName`".7z", "$homePath\.ssh" -Wait

Write-Host "Backup został zapisany na pulpicie"