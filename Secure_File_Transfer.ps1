<#
.SYNOPSIS
  Securely encrypts or decrypts files using AES, with optional transfer.

.DESCRIPTION
  A PowerShell tool to securely handle file transfers with encryption support.
  Requires .NET for secure AES key generation.

.NOTES
  Author: David Sakai
  Version: 1.0
#>

function Get-SecureKey {
    param ([string]$Password)

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Password)
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    return $sha256.ComputeHash($bytes)
}

function Encrypt-File {
    param (
        [string]$InputFile,
        [string]$OutputFile,
        [string]$Password
    )

    try {
        $Key = Get-SecureKey -Password $Password
        $AES = [System.Security.Cryptography.Aes]::Create()
        $AES.Key = $Key
        $AES.GenerateIV()

        $IV = $AES.IV
        $Encryptor = $AES.CreateEncryptor()

        $InputBytes = [System.IO.File]::ReadAllBytes($InputFile)
        $EncryptedBytes = $Encryptor.TransformFinalBlock($InputBytes, 0, $InputBytes.Length)

        # Prepend IV to the encrypted data
        $FinalBytes = $IV + $EncryptedBytes
        [System.IO.File]::WriteAllBytes($OutputFile, $FinalBytes)

        Write-Host "✅ Encrypted '$InputFile' to '$OutputFile'"
    } catch {
        Write-Warning "❌ Encryption failed: $_"
    }
}

function Decrypt-File {
    param (
        [string]$EncryptedFile,
        [string]$OutputFile,
        [string]$Password
    )

    try {
        $Key = Get-SecureKey -Password $Password
        $EncryptedBytes = [System.IO.File]::ReadAllBytes($EncryptedFile)

        $IV = $EncryptedBytes[0..15]
        $ActualData = $EncryptedBytes[16..($EncryptedBytes.Length - 1)]

        $AES = [System.Security.Cryptography.Aes]::Create()
        $AES.Key = $Key
        $AES.IV = $IV
        $Decryptor = $AES.CreateDecryptor()

        $DecryptedBytes = $Decryptor.TransformFinalBlock($ActualData, 0, $ActualData.Length)
        [System.IO.File]::WriteAllBytes($OutputFile, $DecryptedBytes)

        Write-Host "✅ Decrypted '$EncryptedFile' to '$OutputFile'"
    } catch {
        Write-Warning "❌ Decryption failed: $_"
    }
}

function Secure-Transfer {
    param (
        [ValidateSet("encrypt", "decrypt")]
        [string]$Mode,
        [string]$Source,
        [string]$Destination,
        [string]$Password
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $LogFile = ".\Transfer_Log_$Timestamp.txt"

    if (!(Test-Path $Source)) {
        Write-Warning "⚠️ Source file does not exist."
        return
    }

    switch ($Mode) {
        "encrypt" {
            Encrypt-File -InputFile $Source -OutputFile $Destination -Password $Password
            Add-Content -Path $LogFile -Value "Encrypted: $Source to $Destination"
        }
        "decrypt" {
            Decrypt-File -EncryptedFile $Source -OutputFile $Destination -Password $Password
            Add-Content -Path $LogFile -Value "Decrypted: $Source to $Destination"
        }
    }

    Write-Host "📄 Log saved to $LogFile"
}

# === EXAMPLE USAGE ===
# Secure-Transfer -Mode "encrypt" -Source "C:\file.txt" -Destination "C:\file.enc" -Password "MySecret"
# Secure-Transfer -Mode "decrypt" -Source "C:\file.enc" -Destination "C:\file.txt" -Password "MySecret"

# Uncomment this to prompt user when script is run directly:

$mode = Read-Host "Choose mode [encrypt/decrypt]"
$src = Read-Host "Enter source file path"
$dest = Read-Host "Enter destination file path"
$pwd = Read-Host "Enter password"

Secure-Transfer -Mode $mode -Source $src -Destination $dest -Password $pwd

