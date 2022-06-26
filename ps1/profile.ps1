function get-colours {
	# output all the colour combinations for text/background
	# https://stackoverflow.com/questions/20541456/list-of-all-colors-available-for-powershell/41954792#41954792
	$colors = [enum]::GetValues([System.ConsoleColor])
	Foreach ($bgcolor in $colors){
		Foreach ($fgcolor in $colors) { Write-Host "$fgcolor|"  -ForegroundColor $fgcolor -BackgroundColor $bgcolor -NoNewLine }
		Write-Host " on $bgcolor"
	}
}

function shorten-path([string] $path) {
	$loc = $path.Replace($HOME, '~')
	# remove prefix for UNC paths
	$loc = $loc -replace '^[^:]+::', ''
	# make path shorter like tabs in Vim,
	# handle paths starting with \\ and . correctly
	return ($loc -replace '\\(\.?)([^\\]{1,1})[^\\]*(?=\\)','\$1$2')
}

function get-git-branch {
    try {
        $branch = git rev-parse --abbrev-ref HEAD
        if ($branch -eq "HEAD") {
            # probably in detached HEAD state -> print the SHA
            $branch = git rev-parse --short HEAD
		}
		return $branch
    } catch {
        return $null
    }
}

function prompt {
#	┌[user@host]者[09:30:30]時[C:\P\G\bin]道{master}枝
#	└$
	$uc = [char[]] @(
		0x250C, 0x2514, 0x679D, 0x8005, 0x6642, # ┌└枝者時
		0x9053, 0x8AA4		    				# 道誤
	)

	$cdlim = [ConsoleColor]::Green
	$chost = [ConsoleColor]::DarkCyan
	$cuser = [ConsoleColor]::Yellow
	$cdate = [ConsoleColor]::White
	$cloc = [ConsoleColor]::Cyan
	
	$_host = [net.dns]::GetHostName()
	$_user = [System.Environment]::UserName
	$_path = shorten-path (pwd).Path
	$_date = get-date -format "HH:mm:ss"
	#$_exit = $LastExitCode
	$_brnc = get-git-branch

	write-host -n -f $cdlim $uc[0]"[" -s ''
	write-host -n -f $cuser $_user"@" -s ''
	write-host -n -f $chost $_host
	write-host -n -f $cdlim "]"$uc[3]"[" -s ''
	write-host -n -f $cdate $_date
	write-host -n -f $cdlim "]"$uc[4]"[" -s '' 
	write-host -n 	 		$_path
	write-host -n -f $cdlim "]"$uc[5] -s ''
	if ($_brnc -ne $null) {
		write-host -n -f $cdlim "{"
		write-host $_brnc -n
		write-host -n -f $cdlim "}"$uc[2] -s ''
	}

	write-host ''
	write-host $uc[1] -n -f $cdlim
	write-host "$" -n -f "Red"
	return ' '
}

if ($host.Name -match 'ConsoleHost') {
    Import-Module PSReadLine
	Set-PSReadlineOption -EditMode vi -BellStyle None

	New-Alias -Name vi -Value  'C:\Program Files\vim\vim82\vim.exe'
	New-Alias -Name vim -Value 'C:\Program Files\vim\vim82\vim.exe'
}
