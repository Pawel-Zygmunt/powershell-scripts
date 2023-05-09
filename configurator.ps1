$biezacyKatalog = Split-Path -Parent $MyInvocation.MyCommand.Path

$generateSSHKeys = Join-Path $biezacyKatalog "generateSSHKeys.ps1"
$configureServerSecurity = Join-Path $biezacyKatalog "configureServerSecurity.ps1"
$archiveSSH = Join-Path $biezacyKatalog "archiveSSH.ps1"

# Definiowanie opcji menu
$opcje = @{
    '1' = 'Wygeneruj klucze SSH'
    '2' = 'Konfiguruj bezpieczenstwo serwera' 
    '3' = 'Archiwizuj folder .ssh z haslem'
    '4' = 'Zakoncz program'
}

# Pętla menu
while ($true) {
    # Wyświetlanie opcji menu
    Write-Host "Wybierz opcje:"
    foreach ($opcja in $opcje.GetEnumerator() | Sort-Object Name) {
        Write-Host "$($opcja.Name). $($opcja.Value)"
    }

    # Pobieranie wyboru od użytkownika
    $wybor = Read-Host

    # Obsługa wyboru
    switch ($wybor) {
        '1' {
            . $generateSSHKeys
        }
        '2' {
            .$configureServerSecurity
        }
        '3' {
            .$archiveSSH
        }
        '4' {
            Exit 
        }
        default {
            Write-Host "Nieprawidlowa opcja. Wybierz poprawny numer."
        }
    }

    Write-Host "`n" # Dodanie dwóch pustych linii
}