Write-Host "Generuje klucze SSH na kliencie"

$fileName = Read-Host "Podaj nazwe klucza - bedziesz jej uzywal potem logujac sie na serwer: ssh mojaNazwaKlucza"
$serverAddress = Read-Host "Podaj ip serwera"
$userName = Read-Host "Podaj nazwe usera, ktorym chcesz sie zalogowac na serwer"

$homePath = $env:HOME
if ([string]::IsNullOrEmpty($homePath)) {
    $homePath = $env:USERPROFILE
}

#Sprawdzanie czy istnieje katalog .ssh w folderze uzytkownika, jesli nie to zostanie utworzony
if (-not (Test-Path "$homePath\.ssh")) {
    Write-Host "Tworzenie katalogu .ssh w folderze glownym uzytkownika"
    New-Item -ItemType Directory -Path "$homePath\.ssh" | Out-Null
}

$rsaKeyPath = "$homePath\.ssh\$fileName";

if (Test-Path $rsaKeyPath) {
    Write-Host "Plik klucza o nazwie '$fileName' juz istnieje. Wybierz inna nazwe."
    return
}


# Wygeneruj klucz SSH
$sshKeygen = "ssh-keygen"
$sshKeygenArgs = "-t rsa -b 4096 -C 'generated_from_script' -f $rsaKeyPath -N ''"
Start-Process -Wait -NoNewWindow -FilePath $sshKeygen -ArgumentList $sshKeygenArgs



#plik config
$sshConfigPath = "$homePath\.ssh\config"

$configContent = ""
if (Test-Path $sshConfigPath) {
    Write-Host "Dodawanie kolejnego hosta do istniejacego pliku config..."
    $configContent = Get-Content -Path $sshConfigPath -Raw
}

$newHostConfig = @"
Host $fileName
 HostName $serverAddress
 User $userName
 Port 22
 IdentityFile $rsaKeyPath

"@

$newConfigContent = $configContent + $newHostConfig
$newConfigContent | Set-Content -Path $sshConfigPath -Force
