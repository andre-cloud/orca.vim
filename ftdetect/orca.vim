au BufRead,BufNewFile *.orca set filetype=orca
au BufRead,BufNewFile orca.inp set filetype=orca
au BufRead,BufNewFile *.inp set filetype=orca

" Enable completion menu
set completeopt=menu,menuone,noselect

function! OrcaComplete(findstart, base)
    if a:findstart
        let l:line = getline('.')
        let l:start = col('.') - 1
        " Match letters, numbers, %, and hyphens
        while l:start > 0 && l:line[l:start - 1] =~ '[A-Za-z0-9_%-]'
            let l:start -= 1
        endwhile
        return l:start
    else
        " 1. Check if typing a block name
        if a:base =~ '^%'
            let l:blocks = ['%method', '%basis', '%scf', '%mp2', '%cis', '%tddft', '%mrci', '%geom', '%freq', '%vpt2', '%esd', '%dftmrci', '%coords', '%output', '%ci', '%plots', '%parameters', '%ndoparas', '%rel', '%dkh', '%pal', '%cosmo', '%rr', '%eprnmr', '%loc', '%elprop', '%casscf', '%mcrpa', '%mdci', '%dlpnocc', '%mm', '%mtr', '%xes', '%chelpg', '%numgrad', '%mecp', '%ecp', '%rocis', '%mrcc', '%cipsi', '%ice', '%iceci', '%md', '%nbo', '%lft', '%autoci', '%cpcm', '%cim', '%compound', '%neb', '%irc', '%anmr', '%cregen', '%confscript', '%anmrrc', '%qmmm', '%conical', '%ecrism', '%shark', '%symmetry', '%sym', '%xtb', '%goat', '%docker', '%solvator', '%casresp', '%frag', '%casdft', '%mcd', '%maxcore', '%moread']
            let l:res = []
            for l:b in l:blocks
                if l:b =~? '^' . a:base
                    call add(l:res, l:b)
                endif
            endfor
            return l:res
        endif

        " 2. Find the current block context
        " 2. Find the current block context
        let l:current_block = ''
        let l:lnum = line('.')
        while l:lnum > 0
            let l:line_text = getline(l:lnum)
            
            if l:line_text =~? '^%\s*\w\+'
                let l:current_block = matchstr(tolower(l:line_text), '^%\s*\zs\w\+')
                break
            
            elseif l:line_text =~? '^end\>' && l:lnum != line('.')
                break
            endif
            
            let l:lnum -= 1
        endwhile

        " 3. Block-specific dictionaries (Expand this list based on manual)
        let l:block_keywords = {
            \ 'scf': ['MaxIter', 'Conv', 'TolE', 'TolR', 'TolMaxP', 'TolRMSP', 'Shift', 'DIIS', 'SOSCF', 'NRSCF', 'Guess', 'PrintLevel', 'DirectResetFreq', 'CNVTrafo', 'AutoStart', 'NoIter'],
            \ 'geom': ['MaxIter', 'TolE', 'TolMAXG', 'TolRMSG', 'TolMAXD', 'TolRMSD', 'Scan', 'Constraints', 'InHessName', 'Calc_Hess', 'NumHess', 'Bofill', 'GDIIS', 'Trust', 'MaxStep', 'XYZFile'],
            \ 'pal': ['nprocs','nprocs_group'],
            \ 'basis': ['NewGTO', 'DelGTO', 'Extrapolate', 'Basis', 'AuxJ', 'AuxC', 'AuxJK'],
            \ 'mp2': ['Density', 'NActiveCore', 'DoF12', 'DoOO', 'MaxIter'],
            \ 'tddft': ['NRoots', 'MaxDim', 'Triplets', 'Singlets', 'DoQuad', 'TDA', 'Iroot', 'NState', 'DoTrans', 'MaxIter', 'DoSOC'],
            \ 'output': ['PrintLevel', 'Print', 'NoPrint'],
            \ 'rel': ['PictureChange', 'DoSOC', 'SOC', 'Zeff'],
            \ 'elprop': ['Dipole', 'Polar', 'Quadrupole'],
            \ 'freq': ['Temp', 'Restart', 'NumFreq', 'CentralDiff'],
            \ 'md': ['Timestep', 'InitVel', 'Thermostat', 'DumpFreq', 'MaxIter', 'RungeKutta'],
            \ 'plots': ['dim1', 'dim2', 'dim3', 'Format', 'ElDens', 'SpinDens', 'MO'],
            \ 'casscf': ['nel', 'norb', 'mult', 'nroots', 'weights', 'bdtol', 'trafo', 'maxiter', 'rel'],
            \ 'mrci': ['maxiter', 'tolerr', 'acpf', 'aqcc', 'davids', 'nroots', 'selthresh']
            \ }

        " 4. Return matching keywords for the active block
        let l:res = []
        if has_key(l:block_keywords, l:current_block)
            for l:kw in l:block_keywords[l:current_block]
                if l:kw =~? '^' . a:base
                    call add(l:res, l:kw)
                endif
            endfor
        endif
        
        return l:res
    endif
endfunction

setlocal omnifunc=OrcaComplete

" Key mappings
inoremap <buffer> % %<C-x><C-o>
inoremap <buffer> <Space> <Space><C-x><C-o>
inoremap <buffer> <C-Space> <C-x><C-o>