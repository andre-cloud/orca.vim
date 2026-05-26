# Vim syntax and autocomplete for Orca

This project provides syntax highlighting and context-aware autocompletion for the [Orca quantum chemistry](https://orcaforum.kofo.mpg.de/app.php/portal) program compatible with the Orca 6.1.1 release (and backwards compatible with 5.0.2).

## Features

- **Syntax Highlighting:** Full coverage for ORCA 6.x methods, basis sets, functionals, and directives.
- **Autocompletion:** Context-sensitive dropdown menus for ORCA blocks (`%scf`, `%geom`, etc.) and internal block keywords.

## Installation

### Local Installation (Single User)

Copy the required directories to your local `vim` runtime directory:

```bash
mkdir -p ~/.vim/{syntax,ftdetect,ftplugin}
cp syntax/orca.vim ~/.vim/syntax/
cp ftdetect/orca.vim ~/.vim/ftdetect/
cp ftplugin/orca.vim ~/.vim/ftplugin/
```

Add the following line to your ~/.vimrc to ensure plugins are loaded:

```Vim Scrip
filetype plugin on
````
##Global Installation (Cluster / Multi-User)

To install the plugin globally for all users on a Linux system (e.g., AlmaLinux/RHEL), run the following commands with sudo privileges:

```Bash
sudo mkdir -p /usr/share/vim/vimfiles/{syntax,ftdetect}
sudo cp syntax/orca.vim /usr/share/vim/vimfiles/syntax/
sudo cp ftdetect/orca.vim /usr/share/vim/vimfiles/ftdetect/
```
Ensure global filetype plugins are enabled by appending to /etc/vimrc:
```Bash
echo "filetype plugin on" | sudo tee -a /etc/vimrc
```

##Usage
- **Block Autocomplete**: Type % in Normal/Insert mode to automatically trigger a dropdown menu listing all available ORCA blocks.

- **Keyword Autocomplete**: Inside a block, press <Space> or <C-Space> (Ctrl+Space) to trigger a dropdown menu with the specific keywords available for that context. Standard Vim completion (Ctrl+x followed by Ctrl+o) also works.

###File type detection
####Vim

If you prefer not to use the ftdetect folder, you can manually add these lines to your ~/.vimrc:

```Vim Script
" For vim >= 8
au BufRead,BufNewFile *.orca set filetype=orca
au BufRead,BufNewFile orca.inp set filetype=orca
au BufRead,BufNewFile *.inp set filetype=orca
```
####Neovim

Add these lines to your lua configuration files to use the Orca syntax highlighting for all files ending in .orca and files named orca.inp.  

```Lua
-- For neovim >= 0.8
local create_autocmd = vim.api.nvim_create_autocmd
local events = {"BufRead", "BufNewFile"}
create_autocmd(events, { pattern = {"*.orca"}, command = [[ set filetype=orca ]]})
create_autocmd(events, { pattern = {"orca.inp"}, command = [[ set filetype=orca ]]})
````

##Changelog
###6.1.1 (2026-04-27)

Added syntax coverage for all new features introduced between ORCA 5.0.2 and ORCA 6.1.1.
Added context-aware omni-completion (omnifunc) for ORCA blocks and internal keywords via ftplugin.  

####New DFT functionals  

- `r2SCAN`-based hybrids and double-hybrids: `R2SCANH`, `R2SCAN50`, `PR2SCAN50`, `PR2SCAN69`, `WPR2SCAN50`, `KPR2SCAN50`, `R2SCAN-CIDH`, `R2SCAN-QIDH`, `R2SCAN0-DH`, `R2SCAN0-2` (including RI- and DLPNO- variants)

- Composite `3c` methods: `wB97X-3c`, `B3LYP-3c` (including QM/MM variants)

- Revised dispersion: `wB97M(2)`, `wB97X-D4rev`, `wB97M-D4rev`, `REVDSD-PBEP86-D4`, `REVDOD-PBEP86-D4
`
- Non-covalent double-hybrid: `B2NC-PLYP`

####New wavefunction methods

- `NEVPT3`, `ICE-FR-NEVPT2`, `CCSDTQ`, `RPAC`

- `UHF-IP-EOM-CCSD`, `UHF-EA-EOM-CCSD`, `UHF-STEOM-CCSD`

####New optimizer and structure keywords

- `GOAT` modes: `GOAT-ENTROPY`, `GOAT-EXPLORE`, `GOAT-REACT`, `GOAT-DIVERSITY`, `GOAT-COARSE`

- `RIGIDBODYOPT`, `S-IDPP`

####New docking keywords

- `QUICKDOCK`, `NORMALDOCK`, `COMPLETEDOCK`

- `DOCK(GFN-FF)`, `DOCK(GFN0-XTB)`, `DOCK(GFN1-XTB)`, `DOCK(GFN2-XTB)`

####New analysis and SCF keywords

- `DELTASCF`, `LEANSCF`, `MIXGUESS`, `BUPO`, `AUTOTRAH`

- `MBIS`, `RESP`, `DRACO`, `ADLD`, `ADEX`, `DBOC`, `VCD`, `SMD18`, `COVALED`

####New basis sets

- vDZP (for wB97X-3C), CRENBL, CRENBL-ECP

- HGBS family (hydrogenic Gaussian): HGBS-5/7/9, HGBSP1/2/3-5/7/9, AHGBS-5/7/9, AHGBSP1/2/3-5/7/9

- pcX family (core X-ray spectroscopy): PCX-1/2/3/4, AUG-PCX-1/2/3/4

- pcH family (hyperfine coupling): PCH-1/2/3/4, AUG-PCH-1/2/3/4

####New block directives

%goat, %docker, %solvator, %casresp, %frag, %casdft, %mcd

###5.0.2 (initial release)

Initial syntax highlighting rules for ORCA 5.0.2.

Similar projects
mrymtsk/orca-vim by Toshiki Murayama (@mrymtsk)

#License
Licensed under the Apache License, Version 2.0. See LICENSE file for details.