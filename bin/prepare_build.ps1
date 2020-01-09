param([String]$type="2019\Community")
# Set 64-bit build envs for compiler - START
cmd.exe /c "call `"C:\Program Files (x86)\Microsoft Visual Studio\$type\VC\Auxiliary\Build\vcvars64.bat`" && set > %temp%\vcvars.txt"

Get-Content "$env:temp\vcvars.txt" | Foreach-Object {
  if ($_ -match "^(.*?)=(.*)$") {
    Set-Content "env:\$($matches[1])" $matches[2]
  }
}
# Set 64-bit build envs for compiler - END

# Test nmake
nmake -help
# Copy alias for bison and flex
$win_bison = where.exe win_bison
cp $win_bison $win_bison.Replace('win_bison', 'bison')
$win_flex = where.exe win_flex
cp $win_flex $win_flex.Replace('win_flex', 'flex')
bison --help
flex --help
