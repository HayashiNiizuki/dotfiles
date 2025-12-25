# Unix-like `which`
function Get-CommandPath {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$name
    )

    (Get-Command $name).Path
}
New-Alias -Name which -Value Get-CommandPath

# 使用PSFzf的搜索
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
# 使用PSFzf的Tab补全
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

function prompt {
    $user = [Environment]::UserName
    $currentFolder = Split-Path -Leaf (Get-Location)

    $gitBranch = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        try {
            $branch = git rev-parse --abbrev-ref HEAD 2>$null
            if ($branch) {
                $gitBranch = "($branch) "
            }
        } catch {}
    }

    # 颜色
    $userColor = "Green"
    $hostColor = "Magenta"
    $folderColor = "DarkYellow"
    $symbolColor = "White"
    $gitColor = "Cyan"

    # 输出提示符
    Write-Host "[" -NoNewline -ForegroundColor "White"
    Write-Host "$user" -NoNewline -ForegroundColor $userColor
    Write-Host "] " -NoNewline -ForegroundColor $symbolColor
    Write-Host "$currentFolder "  -NoNewline -ForegroundColor $folderColor
    Write-Host "$gitBranch" -NoNewline -ForegroundColor $gitColor
    # Write-Host " "  -NoNewline -ForegroundColor "White"
    return "> "
}
