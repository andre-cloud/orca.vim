au BufRead,BufNewFile *.orca set filetype=orca
au BufRead,BufNewFile orca.inp set filetype=orca
au BufRead,BufNewFile *.inp set filetype=orca

set completeopt=menu,menuone,noselect

function! OrcaComplete(findstart, base)
    if a:findstart
        let l:line = getline('.')
        let l:start = col('.') - 1
        " Match letters, numbers, %, and hyphens (-)
        while l:start > 0 && l:line[l:start - 1] =~ '[A-Za-z0-9_%-]'
            let l:start -= 1
        endwhile
        return l:start
    else
        " If word starts with %, return block list
        if a:base =~ '^%'
            let l:blocks = [
                \ '%method', '%basis', '%scf', '%mp2', '%cis', '%tddft', '%mrci', '%geom', 
                \ '%freq', '%vpt2', '%esd', '%dftmrci', '%coords', '%output', '%ci', '%plots', 
                \ '%parameters', '%ndoparas', '%rel', '%dkh', '%pal', '%cosmo', '%rr', 
                \ '%eprnmr', '%loc', '%elprop', '%casscf', '%mcrpa', '%mdci', '%dlpnocc', 
                \ '%mm', '%mtr', '%xes', '%chelpg', '%numgrad', '%mecp', '%ecp', '%rocis', 
                \ '%mrcc', '%cipsi', '%ice', '%iceci', '%md', '%nbo', '%lft', '%autoci', 
                \ '%cpcm', '%cim', '%compound', '%neb', '%irc', '%anmr', '%cregen', 
                \ '%confscript', '%anmrrc', '%qmmm', '%conical', '%ecrism', '%shark', 
                \ '%symmetry', '%sym', '%xtb', '%goat', '%docker', '%solvator', '%casresp', 
                \ '%frag', '%casdft', '%mcd', '%maxcore', '%moread'
                \ ]
            let l:res = []
            for l:b in l:blocks
                if l:b =~ '^' . a:base
                    call add(l:res, l:b)
                endif
            endfor
            return l:res
        else
            " Delegate to native syntax completion for all ORCA keywords
            return syntaxcomplete#Complete(0, a:base)
        endif
    endif
endfunction

setlocal omnifunc=OrcaComplete

" Auto-trigger on % for blocks
inoremap <buffer> % %<C-x><C-o>

" Map Ctrl+Space to trigger auto-complete manually for inside-block keywords
inoremap <buffer> <C-Space> <C-x><C-o>
inoremap <buffer> <C-@> <C-x><C-o>