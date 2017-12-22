$projectRoot = Split-Path -Parent $myInvocation.InvocationName
$projectRootUnix = $projectRoot -replace '\\','/'
$ordinalIgnorecase = [System.StringComparison]::OrdinalIgnoreCase

function ProcessPath($path, $procDir)
{
  if(-not $path.StartsWith($projectRoot, $ordinalIgnorecase) -and -not $path.StartsWith($projectRootUnix, $ordinalIgnorecase)) 
  {
    # not in project folder or already relative
    return $path
  }

  $last = $null
 
  if($path.EndsWith("\") -or $path.EndsWith("/"))
  {
    if(-not [system.io.directory]::Exists($path))
    {
      [system.io.directory]::CreateDirectory($path)
    }
  }
  elseif([system.io.file]::Exists($path))
  {
    # do nothing
  }
  else
  {
    $pathSep = '\'
    $index = $path.LastIndexOf($pathSep)
    if(-1 -eq $index)
    {
      $pathSep = '/'
      $index = $path.LastIndexOf($pathSep)
    }
    $last = $path.Substring($index + 1)
    $path = $path.Substring(0, $index)
    if(-not [system.io.directory]::Exists($path))
    {
      [system.io.directory]::CreateDirectory($path)
    }
    if($last -eq ".." -or $last -eq ".")
    {
      $path = $path + $pathSep + $last
      $last = $null
    }
  }

  Push-Location $procDir.FullName

  $resolved = Resolve-Path -Relative $path

  Pop-Location

  if($last -ne $null)
  {
    $resolved = $resolved + "\" + $last
  }

  return $resolved
}

function ProcessElement($element, $procDir)
{
  $text = $element.Node."#text"
  $paths = $text -split ";" | ForEach-Object { $_.Trim() }
  $paths = $paths | ForEach-Object { ProcessPath $_ $procDir }
  $text = $paths -join ";"
  $element.Node."#text" = $text
}

function ProcessFile($file)
{
  $ext = $file.Extension.ToUpper()
  if(($ext -ne ".VCXPROJ") -and ($ext -ne ".FILTERS")) {return}

  $xml = [xml] (Get-Content $file.FullName)
  $namespace = @{ ns = "http://schemas.microsoft.com/developer/msbuild/2003"; }
  
  $query = "//ns:OutDir|//ns:IntDir|//ns:AdditionalIncludeDirectories|//ns:AdditionalLibraryDirectories|//ns:ImportLibrary|//ns:ProgramDataBaseFile"
  $elements = Select-Xml -XPath $query -Xml $xml -Namespace $namespace
  $elements | ForEach-Object { ProcessElement $_ $file.Directory }

  $query = "//ns:ClCompile|//ns:ClInclude"
  $elements = Select-Xml -XPath $query -Xml $xml -Namespace $namespace
  $elements | ForEach-Object `
  { 
    $include = $_.Node.Include
    if($include -ne $null)
    {
      $resolved = ProcessPath $_.Node.Include $file.Directory
      $_.Node.SetAttribute("Include", $resolved) 
    }
  }

  $xml.Save($file.FullName)
}

function ProcessDir ($dir) 
{
  Get-ChildItem -Path $dir.FullName -File | ForEach-Object { ProcessFile $_ }
  Get-ChildItem -Path $dir.FullName -Directory | ForEach-Object { ProcessDir $_ }
}

Get-ChildItem -Path $projectRoot -Directory | ForEach-Object { ProcessDir $_ }

