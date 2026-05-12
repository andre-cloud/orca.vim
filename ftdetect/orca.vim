au BufRead,BufNewFile *.orca set filetype=orca
au BufRead,BufNewFile orca.inp set filetype=orca
au BufRead,BufNewFile *.inp set filetype=orca

" Enable completion menu
set completeopt=menu,menuone,noselect

" Custom omnifunc for Orca blocks
function! OrcaBlockComplete(findstart, base)
    if a:findstart
        let l:line = getline('.')
        let l:start = col('.') - 1
        
        " Locate the start of the word
        while l:start > 0 && l:line[l:start - 1] =~ '\a'
            let l:start -= 1
        endwhile
        
        " Trigger only if preceded by %
        if l:start > 0 && l:line[l:start - 1] == '%'
            return l:start
        endif
        return -1
    else
        " List of Orca block directives
        let l:blocks = [
            \ 'method', 'basis', 'scf', 'mp2', 'cis', 'tddft', 'mrci', 'geom', 
            \ 'freq', 'vpt2', 'esd', 'dftmrci', 'coords', 'output', 'ci', 'plots', 
            \ 'parameters', 'ndoparas', 'rel', 'dkh', 'pal', 'cosmo', 'rr', 
            \ 'eprnmr', 'loc', 'elprop', 'casscf', 'mcrpa', 'mdci', 'dlpnocc', 
            \ 'mm', 'mtr', 'xes', 'chelpg', 'numgrad', 'mecp', 'ecp', 'rocis', 
            \ 'mrcc', 'cipsi', 'ice', 'iceci', 'md', 'nbo', 'lft', 'autoci', 
            \ 'cpcm', 'cim', 'compound', 'neb', 'irc', 'anmr', 'cregen', 
            \ 'confscript', 'anmrrc', 'qmmm', 'conical', 'ecrism', 'shark', 
            \ 'symmetry', 'sym', 'xtb', 'goat', 'docker', 'solvator', 'casresp', 
            \ 'frag', 'casdft', 'mcd', 'maxcore', 'moread'
            \ ]
        
        let l:res = []
        for l:b in l:blocks
            if l:b =~ '^' . a:base
                call add(l:res, l:b)
            endif
        endfor
        return l:res
    endif
endfunction

" Set omnifunc and trigger it automatically when typing %
setlocal omnifunc=OrcaBlockComplete
inoremap <buffer> % %<C-x><C-o>