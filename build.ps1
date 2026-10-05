# Builds the static holding site into .\docs from the files in .\_src.
# The legal text is the live xoori.ai pages captured on 2026-10-05, copied word for word
# (Twilio's toll-free verification was approved against them) — only styling is new.
# CSS is inlined and nav links are relative so the GitHub Pages preview URL
# (a sub-path) works before the domain is moved; 404.html uses root links because
# it is served at arbitrary depths.
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$src  = Join-Path $root '_src'
$out  = Join-Path $root 'docs'
# Empty rather than delete the folder: an editor or Explorer window often holds it open.
New-Item -ItemType Directory -Force $out | Out-Null
Get-ChildItem $out -Force | Remove-Item -Recurse -Force

$css = "<style>`n" + [IO.File]::ReadAllText("$src\style.css") + "</style>"
$holding = [IO.File]::ReadAllText("$src\holding.html").Replace('{{CSS}}', $css)
[IO.File]::WriteAllText("$out\index.html", $holding.Replace('{{B}}', './'))
[IO.File]::WriteAllText("$out\404.html",   $holding.Replace('{{B}}', '/'))   # any old app URL lands here
[IO.File]::WriteAllText("$out\.nojekyll", '')

$titles = @{ 'privacy' = 'Privacy Policy'; 'terms' = 'Terms of Service'; 'sms-consent' = 'SMS Terms' }
foreach ($name in $titles.Keys) {
  $main = [IO.File]::ReadAllText("$src\$name.main.html")
  $page = @"
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$($titles[$name]) — Xoori</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Solway:wght@400;500;600;700;800&display=swap" rel="stylesheet">
$css
</head>
<body>
<div class="legal">
  <header><a class="wordmark" href="../">XOORI</a></header>
  <p class="notice">Xoori Fit is on a short break. This page is kept exactly as published on xoori.ai.</p>
  $main
  <footer>
    <span>Xoori, Inc. · Cambridge, MA</span>
    <a href="../privacy/">Privacy</a>
    <a href="../terms/">Terms</a>
    <a href="../sms-consent/">SMS Terms</a>
  </footer>
</div>
</body>
</html>
"@
  New-Item -ItemType Directory "$out\$name" | Out-Null
  [IO.File]::WriteAllText("$out\$name\index.html", $page)
}
Get-ChildItem $out -Recurse -File -Force | ForEach-Object { $_.FullName.Substring($out.Length + 1) }
