Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$modRoot = $PSScriptRoot
$modName = "Spawn-Weapons-With-Mag-And-Ammo"
$modsDir = "D:\Games\SteamLibrary\steamapps\common\Road to Vostok\mods"
$vmzPath = "$modRoot\$modName.vmz"

Remove-Item -Force -ErrorAction SilentlyContinue $vmzPath

$stream = [System.IO.File]::Open($vmzPath, [System.IO.FileMode]::Create)
$zip    = New-Object System.IO.Compression.ZipArchive($stream, [System.IO.Compression.ZipArchiveMode]::Create)

function Add-Dir($zip, $entryName) {
    $entry = $zip.CreateEntry($entryName, [System.IO.Compression.CompressionLevel]::Optimal)
    $entry.ExternalAttributes = 16
}

function Add-File($zip, $entryName, $filePath) {
    $entry = $zip.CreateEntry($entryName, [System.IO.Compression.CompressionLevel]::Optimal)
    $entry.ExternalAttributes = 32
    $entry.LastWriteTime = [System.IO.File]::GetLastWriteTime($filePath)
    $writer = $entry.Open()
    $bytes  = [System.IO.File]::ReadAllBytes($filePath)
    $writer.Write($bytes, 0, $bytes.Length)
    $writer.Dispose()
}

Add-File $zip "CHANGELOG.md"                   "$modRoot\CHANGELOG.md"
Add-File $zip "mod.txt"                        "$modRoot\mod.txt"
Add-Dir  $zip "mods/"
Add-Dir  $zip "mods/scripts/"
Add-File $zip "mods/scripts/LootContainer.gd"  "$modRoot\mods\scripts\LootContainer.gd"
Add-File $zip "mods/scripts/LootSimulation.gd" "$modRoot\mods\scripts\LootSimulation.gd"
Add-File $zip "mods/scripts/Main.gd"           "$modRoot\mods\scripts\Main.gd"
Add-File $zip "README.md"                      "$modRoot\README.md"

$zip.Dispose()
$stream.Dispose()

Copy-Item -Path $vmzPath -Destination "$modsDir\$modName.vmz" -Force

Write-Host "Done: $modsDir\$modName.vmz"
