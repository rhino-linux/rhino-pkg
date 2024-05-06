# As of nushell 0.89.0, for directory modules, 
# all exported nu files must be listed in the mod.nu file as exports
export module rpk-cleanup.nu
export module rpk-install-or-remove.nu
export module rpk-search.nu
export module rpk-sync.nu
export module rpk-update.nu

def main [] -> {}