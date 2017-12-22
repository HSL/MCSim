# CMake generates a solution using absolute paths
# This script converts absolute paths to relative paths in .vcxproj and .filter files
# Run it from a parent folder common to both solution and source

$projectRoot = Split-Path -Parent $myInvocation.InvocationName
$projectRootUnix = $projectRoot -replace '\\','/'
$ordinalIgnorecase = [System.StringComparison]::OrdinalIgnoreCase

function ProcessPath($path, $procDir)
{
  if (-not $path.StartsWith($projectRoot, $ordinalIgnorecase) -and -not $path.StartsWith($projectRootUnix, $ordinalIgnorecase)) 
  {
    # not in project folder, or already relative
    return $path
  }

  $lastComponent = $null
 
  if ($path.EndsWith("\") -or $path.EndsWith("/"))
  {
    if (-not [System.IO.Directory]::Exists($path))
    {
      # For Resolve-Path to operate
      [System.IO.Directory]::CreateDirectory($path)
    }
  }
  elseif ([System.IO.File]::Exists($path))
  {
    # do nothing
  }
  else
  {
    $pathSep = '\'
    $index = $path.LastIndexOf($pathSep)
    if (-1 -eq $index)
    {
      $pathSep = '/'
      $index = $path.LastIndexOf($pathSep)
    }
    $lastComponent = $path.Substring($index + 1)
    $path = $path.Substring(0, $index)
    if (-not [System.IO.Directory]::Exists($path))
    {
      [System.IO.Directory]::CreateDirectory($path)
    }
    if ($lastComponent -eq ".." -or $lastComponent -eq ".")
    {
      $path = $path + $pathSep + $lastComponent
      $lastComponent = $null
    }
  }

  Push-Location $procDir.FullName
  $resolved = Resolve-Path -Relative $path
  Pop-Location

  if ($lastComponent -ne $null)
  {
    $resolved = $resolved + "\" + $lastComponent
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
  if (($ext -ne ".VCXPROJ") -and ($ext -ne ".FILTERS")) { return }

  $xml = [xml] (Get-Content $file.FullName)
  $namespace = @{ ns = "http://schemas.microsoft.com/developer/msbuild/2003"; }

  $query = "//ns:OutDir"
  $elements = Select-Xml -XPath $query -Xml $xml -Namespace $namespace
  $elements | ForEach-Object `
  { 
    ProcessElement $_ $file.Directory
    $text = $_.Node."#text"
    if (-not $text.EndsWith("\"))
    {
      # avoid MSB8004 warning
      $_.Node."#text" = $text + "\"
    }
  }
  
  $query = "//ns:IntDir|//ns:AdditionalIncludeDirectories|//ns:AdditionalLibraryDirectories|//ns:ImportLibrary|//ns:ProgramDataBaseFile"
  $elements = Select-Xml -XPath $query -Xml $xml -Namespace $namespace
  $elements | ForEach-Object { ProcessElement $_ $file.Directory }

  $query = "//ns:ClCompile|//ns:ClInclude"
  $elements = Select-Xml -XPath $query -Xml $xml -Namespace $namespace
  $elements | ForEach-Object `
  { 
    $include = $_.Node.Include
    if ($include -ne $null)
    {
      $resolved = ProcessPath $_.Node.Include $file.Directory
      $_.Node.SetAttribute("Include", $resolved) 
    }
  }

  $xml.Save($file.FullName)
}

function ProcessDir($dir) 
{
  Get-ChildItem -Path $dir.FullName -File | ForEach-Object { ProcessFile $_ }
  Get-ChildItem -Path $dir.FullName -Directory | ForEach-Object { ProcessDir $_ }
}

Get-ChildItem -Path $projectRoot -Directory | ForEach-Object { ProcessDir $_ }
