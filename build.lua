--[==========================================[--
        L3BUILD FILE FOR BEAMER-WESTLAKE
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module              = "beamertheme-westlake"
version             = "v0.2A"
date                = "2026-03-06"
maintainer          = "Mingyu Xia"
uploader            = "Mingyu Xia"
maintainid          = "myhsia"
email               = "myhsia@outlook.com"
repository          = "https://github.com/" .. maintainid .. "/" .. module
summary             = "A beamer theme inspired by West Lake and Westlake University."
description         = "The `westlake` Beamer Theme is inspired by West Lake, a famous freshwater lake in Hangzhou, China, and also inspired by Westlake University"

--[==========================================[--
          Build, Pack, Tag, and Upload
         Do not Modify Unless Necessary
--]==========================================]--

ctanzip             = module
cleanfiles          = {"*.log", "*.pdf", "*.zip", "*.curlopt"}
docsuppdirs         = {"media"}
excludefiles        = {"*~"}
typesetdemofiles    = {module .. "-demo.tex"}
textfiles           = {"README.md", "LICENSE", "*.lua"}
typesetexe          = "latexmk -pdflatex"
typesetruns         = 1
uploadconfig  = {
  announcement_file = "announcement.md",
  pkg               = module,
  version           = version .. " " .. date,
  author            = maintainer,
  uploader          = uploader,
  email             = email,
  summary           = summary,
  description       = description,
  license           = "lppl1.3c",  
  ctanPath          = "/macros/latex/contrib/beamer-contrib/themes/" .. module,
  bugtracker        = repository .. "/issues",
  repository        = repository,
  development       = "https://github.com/" .. maintainid,
  update            = true
}
function update_tag(file, content, tagname, tagdate)
  tagname = version
  tagdate = date
  if string.match(file, "%.dtx$") then
    content = string.gsub(content,
      "\\def \\westlake@date    %{[^}]+%}",
      "\\def \\westlake@date    {" .. tagdate .. "}")
    content = string.gsub(content,
      "\\def \\westlake@version %{[^}]+%}",
      "\\def \\westlake@version {" .. tagname .. "}")
    content = string.gsub(content,
      "\\date{Released %d+%-%d+%-%d+\\quad \\texttt{v([%d%.A-Z]+)}}",
      "\\date{Released " .. tagdate .. "\\quad \\texttt{" .. tagname .. "}}")
  end
  return content
end

--[== "Hacks" to `l3build` | Do not Modify ==]--

function docinit_hook()
  cp(ctanreadme, unpackdir, currentdir)
  for _,glob in pairs(docsuppdirs) do
    run(currentdir, "cp -r " .. glob .. " " .. typesetdir)
  end
  return 0
end
function tex(file,dir,cmd)
  dir = dir or "."
  cmd = cmd or typesetexe
  if os.getenv("WINDIR") ~= nil or os.getenv("COMSPEC") ~= nil then
    upretex_aux = "-usepretex=\"" .. typesetcmds .. "\""
    makeidx_aux = "-e \"$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\""
    sandbox_aux = "set \"TEXINPUTS=../unpacked;%TEXINPUTS%;\" &&"
  else
    upretex_aux = "-usepretex=\'" .. typesetcmds .. "\'"
    makeidx_aux = "-e \'$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\'"
    sandbox_aux = "TEXINPUTS=\"../unpacked:$(kpsewhich -var-value=TEXINPUTS):\""
  end
  return run(dir, sandbox_aux .. " " .. cmd         .. " " ..
                  upretex_aux .. " " .. makeidx_aux .. " " .. file)
end
