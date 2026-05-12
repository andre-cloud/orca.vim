au BufRead,BufNewFile *.orca set filetype=orca
au BufRead,BufNewFile orca.inp set filetype=orca
au BufRead,BufNewFile *.inp set filetype=orca

" Abilita il menu di completamento
set completeopt=menu,menuone,noselect

function! OrcaComplete(findstart, base)
    if a:findstart
        let l:line = getline('.')
        let l:start = col('.') - 1
        " Rileva l'inizio della parola (include caratteri comuni in ORCA come % e -)
        while l:start > 0 && l:line[l:start - 1] =~ '[A-Za-z0-9_%-]'
            let l:start -= 1
        endwhile
        return l:start
    else
        " LISTA 1: Blocchi principali (iniziano con %)
        let l:blocks = ['%method', '%basis', '%scf', '%mp2', '%cis', '%tddft', '%mrci', '%geom', '%freq', '%vpt2', '%esd', '%dftmrci', '%coords', '%output', '%ci', '%plots', '%parameters', '%ndoparas', '%rel', '%dkh', '%pal', '%cosmo', '%rr', '%eprnmr', '%loc', '%elprop', '%casscf', '%mcrpa', '%mdci', '%dlpnocc', '%mm', '%mtr', '%xes', '%chelpg', '%numgrad', '%mecp', '%ecp', '%rocis', '%mrcc', '%cipsi', '%ice', '%iceci', '%md', '%nbo', '%lft', '%autoci', '%cpcm', '%cim', '%compound', '%neb', '%irc', '%anmr', '%cregen', '%confscript', '%anmrrc', '%qmmm', '%conical', '%ecrism', '%shark', '%symmetry', '%sym', '%xtb', '%goat', '%docker', '%solvator', '%casresp', '%frag', '%casdft', '%mcd', '%maxcore', '%moread']

        " LISTA 2: Keyword interne ai blocchi (estratte dai tuoi file .vim)
        let l:inner_keywords = [
            \ 'VERSION', 'RUNTYP', 'AMASSES', 'FROZENCORE', 'FUNCTIONAL', 'RADIALGRID', 'ANGULARGRID',
            \ 'USESYMMETRY', 'DOMP2', 'USELIBINT', 'USESHARK', 'RI', 'ALLOWRHF',
            \ 'SYMTHRESH', 'INTACC', 'CUTOFF', 'CONV', 'MAXITER', 'TOL',
            \ 'PROGSCF', 'PROGMP2', 'PROGGTOINT', 'FORCE_SHARK', 'FORCE_LIBINT',
            \ 'TRUE', 'FALSE', 'T', 'F', 'ON', 'OFF'
            \ ]

        " Determina quale lista usare
        let l:source = (a:base =~ '^%') ? l:blocks : l:inner_keywords
        
        let l:res = []
        for l:item in l:source
            if l:item =~? '^' . l:base
                call add(l:res, l:item)
            endif
        endfor
        return l:res
    endif
endfunction

setlocal omnifunc=OrcaComplete

" 1. Trigger automatico quando scrivi %
inoremap <buffer> % %<C-x><C-o>

" 2. Trigger automatico dopo uno spazio dentro un blocco
" Questo aprirà il menu delle keyword interne ogni volta che premi spazio
inoremap <buffer> <Space> <Space><C-x><C-o>

" 3. Scorciatoia manuale (Ctrl+Spazio o Ctrl+n)
inoremap <buffer> <C-Space> <C-x><C-o>