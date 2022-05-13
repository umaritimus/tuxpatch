# @summary Apply Tuxedo patch
#
# Call this class to apply tuxedo patches
#
# @example
#   include tuxpatch
class tuxpatch (
  Optional[Hash[Integer,String]] $tuxedo_patches = lookup('tuxedo_patches',undef,undef,undef)
){
  if ($facts['operatingsystem'] == 'windows') {
    if (!empty($tuxedo_patches)) {
      debug ("Running on Windows OS with patches set to ${tuxedo_patches}")
      $tuxedo_patches.each | Integer $patch_index, String $patch_path | {
        if (!empty($patch_path)) {
          $tuxedo_path = regsubst("${lookup('tuxedo_path')}", '(/|\\\\)', '\\', 'G')
          $pkgtemp = regsubst("${tuxedo_path}-${patch_index}", '(/|\\\\)', '\\', 'G')
          $opatch_path = regsubst("${lookup('tuxedo_location')}/Opatch/opatch.bat", '(/|\\\\)', '\\', 'G')
          exec { "Check ${patch_path}" :
            command   => Sensitive(@("EOT")),
                Test-Path -Path ${regsubst("\'${patch_path}\'", '(/|\\\\)', '\\', 'G')} -ErrorAction Stop
              |-EOT
            provider  => powershell,
            logoutput => true,
          }

          exec { "Expand ${patch_path} to ${pkgtemp}" :
            command   => Sensitive(@("EOT")),
                Try {
                  Expand-Archive `
                    -Path ${regsubst("\'${patch_path}\'", '(/|\\\\)', '\\', 'G')} `
                    -DestinationPath ${regsubst("\'${pkgtemp}\'", '(/|\\\\)', '\\', 'G')} `
                    -Force `
                    -ErrorAction Stop
                } Catch {
                  Exit 1
                }
              |-EOT
            provider  => powershell,
            logoutput => true,
            require   => [ Exec["Check ${patch_path}"] ],
          }

          exec { "Deploy ${pkgtemp}" :
            command   => Sensitive(@("EOT")),
                Try {
                  Set-Location -Path ${pkgtemp}
                  Stop-Service -Name 'ORACLE ProcMGr*', 'TUXEDO*' -Force
                  Start-Process `
                    -FilePath "${opatch_path}" `
                    -ArgumentList @( `
                      "apply", `
                      "$(((Get-Content -Path './README.txt') | Select-String 'PATCHID #').ToString().Split()[2]).zip", `
                      "-silent", `
                      "-force" `
                    ) `
                    -Wait `
                    -ErrorAction Stop `
                    -NoNewWindow | Out-Null
                  Start-Service -Name 'ORACLE ProcMGr*', 'TUXEDO*'
                } Catch {
                  Exit 1
                }
              |-EOT
            provider  => powershell,
            logoutput => true,
            require   => [ Exec["Expand ${patch_path} to ${pkgtemp}"] ],
          }

          exec { "Delete ${pkgtemp} Directory" :
            command   =>  Sensitive(@("EOT")),
                New-Item -Path ${regsubst("\'${tuxedo_path}-empty\'", '(/|\\\\)', '\\', 'G')} -Type Directory -Force
                Start-Process `
                  -FilePath "C:\\windows\\system32\\Robocopy.exe" `
                  -ArgumentList @( `
                    ${regsubst("\'${tuxedo_path}-empty\'", '(/|\\\\)', '\\', 'G')}, `
                    ${regsubst("\'${pkgtemp}\'" ,'/', '\\\\', 'G')}, `
                    "/E /PURGE /NOCOPY /MOVE /NFL /NDL /NJH /NJS > nul" `
                  ) `
                  -Wait `
                  -NoNewWindow | Out-Null
                Get-Item -Path ${regsubst("\'${pkgtemp}\'" ,'/', '\\\\', 'G')} -ErrorAction SilentlyContinue `
                | Remove-Item -Force -Recurse
              |-EOT
            provider  => powershell,
            logoutput => true,
            require   => [ Exec["Deploy ${pkgtemp}"] ],
          }
        }
      }
    }
  }
}
