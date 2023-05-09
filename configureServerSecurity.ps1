$keyName = Read-Host "Podaj nazwe klucza zapisanego w pliku .ssh/config, ktory chcesz ustawic na serwerze"
$sshPassword = Read-Host -AsSecureString "Podaj haslo do polaczenia ssh" 


$homePath = $env:HOME
if ([string]::IsNullOrEmpty($homePath)) {
    $homePath = $env:USERPROFILE
}

$configPath = "$homePath\.ssh\config";

if (-not (Test-Path $configPath)) {
    Write-Host "Blad! Brak pliku .ssh/config"
    return
}

$content = Get-Content -Path $configPath -Raw
$pattern = "(?smi)Host\s+$keyName\s*HostName\s+([^\r\n]+)\s*User\s+([^\r\n]+)\s*Port\s+(\d+)\s*IdentityFile\s+([^\r\n]+)"
$match = [regex]::Match($content, $pattern)

if (-not $match.Success) {
    Write-Output "Nie znaleziono klucza: $keyName w pliku .ssh/config"
    return
}

$hostNameValue = $match.Groups[1].Value.Trim()
$userValue = $match.Groups[2].Value.Trim()
$portValue = $match.Groups[3].Value.Trim()
$identityFileValue = $match.Groups[4].Value.Trim()

Write-Output "HostName: $hostNameValue"
Write-Output "User: $userValue"
Write-Output "Port: $portValue"
Write-Output "IdentityFile: $identityFileValue"


#Login to SSH
Write-Host "---------------------Laczenie z serwerem $hostNameValue przy pomocy SSH------------------------"
# Tworzenie obiektu klasy PSCredential na podstawie nazwy użytkownika i hasła
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $userValue, $sshPassword
# Tworzenie obiektu klasy SSH.Session i łączenie się z serwerem
$session = New-SSHSession -ComputerName $hostNameValue -Credential $credential -AcceptKey

if (-not $session) {
    Write-Host "Blad logowania na serwer SSH."
    return
}

Write-Host "Zalogowano pomyslnie, Oczekiwanie 5 sekund"
Start-Sleep -Seconds 5  # Oczekiwanie 5 sekund

Remove-SSHSession -Index 0

Write-Host "Sesja ssh zamknieta"
