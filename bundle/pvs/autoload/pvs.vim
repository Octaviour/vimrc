" soft wrapping with nofile to force 80 columns {{{1
function! pvs#softwrapclose()
    if exists('w:pvs_softwrap')
        let l:main_window = winnr()
        " close previous buffer
        wincmd l
        if &filetype == 'MARGIN'
            wincmd c
        endif
        execute l:main_window.'wincmd w'
        unlet w:pvs_softwrap
    endif
endfunction
function! pvs#softwrap(width)
    call pvs#softwrapclose()
    " open new buffer
    vnew
    setfiletype MARGIN
    set buftype=nofile
    wincmd p
    execute 'vertical res '.(80+&numberwidth)
    let w:pvs_softwrap = 1
endfunction
function! pvs#updatewrap()
    if &wrap
        call pvs#softwrap(80)
    else
        call pvs#softwrapclose()
    endif
endfunction

" case change for symbols {{{1
function! pvs#changecase()
    let l:cchar = matchstr(getline('.'), '\%'.col('.').'c.')
    let l:cword = expand('<cword>')

    if l:cword == 'draft'
        normal ciwfinal
    elseif l:cword == 'final'
        normal ciwdraft
    elseif l:cchar == '+'
        normal r-
    elseif l:cchar == '-'
        normal r+
    elseif l:cchar == '*'
        normal r/
    elseif l:cchar == '/'
        normal r*
    elseif l:cchar == '('
        normal r)
    elseif l:cchar == ')'
        normal r(
    elseif l:cchar == '{'
        normal r}
    elseif l:cchar == '}'
        normal r{
    elseif l:cchar == '['
        normal r]
    elseif l:cchar == ']'
        normal r[
    elseif l:cchar == '<'
        normal r>
    elseif l:cchar == '>'
        normal r<
    elseif l:cchar == "'"
        normal r"
    elseif l:cchar == '"'
        normal r'
    elseif l:cchar == ' '
        normal r_
    elseif l:cchar == '_'
        normal r<space>
    else
        normal g~l
    endif
endfunction
" map in) etc to next brace {{{1
function! pvs#selectclosestbracket(brackets, command)
    " find character under cursor
    let l:current_character = matchstr(getline('.'), '\%' . col('.') . 'c.')

    if a:brackets =~# l:current_character
        let l:next_brace = col('.')
    else
        let l:search_string = join(split(a:brackets, '\zs'), '\|')
        let l:next_brace = match(getline('.'), l:search_string, col('.')) + 1

        " if no matches are found
        if l:next_brace == 0
            call feedkeys("\<esc>")
            return
        end
    endif

    execute 'normal! ' . l:next_brace . '|'
    execute 'normal! v' . a:command
endfunction

" open temporary buffer {{{1
function! pvs#opentemporarybuffer()
    split tmp
    set buftype=nofile
endfunction

" remove trailing space {{{1
" TODO rehighlight previous search
function! pvs#removetrailingspace()
    let l:save_view = winsaveview()
    %s/\v\s+$//e
    call winrestview(l:save_view)
    call histdel('search', -1)
endfunction

" increment subsequent lines {{{1
function! pvs#incrementsubsequentlines()
    " TODO: make work for count~=1
    " TODO: do not use normal if not required
    " jump to next number and save initial location
    execute "normal mp"
    execute "normal \<c-a>\<c-x>"
    let l:col = col('.')

    let l:increment=1
    let l:number=1
    while l:number
        " get the word on next line
        execute 'normal j'.l:col.'|'
        let l:firstWord=expand('<cword>')

        " test if it contains a number
        if l:firstWord=~#"[0-9]"
            " increment the number in the text
            for i in range(1,increment)
                execute "normal \<c-a>"
            endfor

            " increment next line more
            let l:increment=l:increment+1

            " stop on last line
            if line('.') == line('$')
                let l:number=0
            endif
        else
            let l:number=0
        endif
    endwhile

    " restore cursor position
    execute "normal 'p"
endfunction

" detect m files properly (matlab vs mathematica) {{{1
function pvs#detectmfiletype()
    if getline(1) =~ 'mathematica'
        setlocal filetype=mma
    else
        setlocal filetype=matlab
    endif
endfunction