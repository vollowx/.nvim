if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetMarkdownIndent()
setlocal indentkeys=!^F,o,O,0=,0=&=,0-,0*,0+,.

function! s:in_mathzone(...) abort
  return !exists('g:loaded_vimtex') || !g:loaded_vimtex
        \ || call('vimtex#syntax#in_mathzone', a:000)
endfunction

function! s:in_normalzone(...) abort
  return !exists('g:loaded_vimtex') || !g:loaded_vimtex
        \ || !call('vimtex#syntax#in_mathzone', a:000)
endfunction

" Find the first previous non-blank line that matches the given pattern if
" trimmed, stops on the first line that has a larger indent than its next
" non-blank line
" Returns the line number, the index of the match, and the substring that
" matches the pattern
function! s:trimmed_prevnonblank_matches(lnum, pattern) abort
  let l:lnum = prevnonblank(a:lnum - 1)
  let l:indent = indent(l:lnum)
  while l:lnum >= 1
    let l:line = trim(getline(l:lnum))
    let l:match_idx = match(l:line, a:pattern)
    let l:match = matchstr(l:line, a:pattern)
    if l:match_idx >= 0
      return [l:lnum, l:match_idx, l:match]
    endif
    let l:lnum = prevnonblank(l:lnum - 1)
    let l:new_indent = indent(l:lnum)
    if l:new_indent <= l:indent
      let l:indent = l:new_indent
    else
      break
    endif
  endwhile
  return [0, -1, '']
endfunction

function! GetMarkdownIndent() abort
  let l:line = getline(v:lnum)
  let l:prev_lnum = prevnonblank(v:lnum - 1)
  let l:prev_line = getline(l:prev_lnum)
  let l:sw = shiftwidth()
  if l:prev_lnum == 0
      return indent(v:lnum)
  endif

  if s:in_mathzone()
    " Align to the equal sign of the first previous line that contains '=' or
    " '&=' if the current line starts with '=' or '&='
    if l:line =~# '^\s*&\?='
      let [l:prev_eq_lnum, l:eq_pos, l:_] =
            \ s:trimmed_prevnonblank_matches(v:lnum, '&\?=')
      if l:prev_eq_lnum > 0 && s:in_mathzone(l:prev_eq_lnum, 1)
        return indent(l:prev_eq_lnum) + l:eq_pos
      endif
    endif
    if s:in_mathzone(l:prev_lnum, 1)
      " Add extra indent if previous line starts with '=' or '&='
      " and has no trailing double backslash '\\'
      if l:prev_line =~# '^\s*&\?=' && l:prev_line !~# '\\\\\s*$'
        return indent(l:prev_lnum) + l:sw
      endif
      " Reduce indent if previous line ends with '\\' but does not contain '='
      if l:prev_line !~# '=' && l:prev_line =~# '\\\\\s*$'
        return indent(l:prev_lnum) - l:sw
      endif
    endif
  endif

  if s:in_normalzone()
    " Reindent unsordered list bullet points
    if l:line =~# '^\s*[-*+]'
      return indent(v:lnum) / l:sw * l:sw
    endif
    " Reindent ordered list items
    let l:order = str2nr(matchstr(l:line, '\(^\s*\)\@<=\d\+\.\@='))
    if l:order > 0
      let [l:prev_item_lnum, l:_, l:prev_item_order] =
            \ s:trimmed_prevnonblank_matches(v:lnum, '^\d\+\.\@=')
      if s:in_normalzone(l:prev_item_lnum, 1)
        return str2nr(l:order) > l:prev_item_order
              \ ? indent(l:prev_item_lnum)
              \ : indent(l:prev_item_lnum) + l:sw
      endif
    endif
    " Only align multi-line list items if adjacent previous line is non-empty
    " ---------------------------------------------
    " 1234. aaa-bbb
    "       ccc <- should align with the 'aaa'
    " ---------------------------------------------
    " 5678. ddd
    "
    "     eee <- should not align with 'ddd'
    " ---------------------------------------------
    if l:prev_lnum == v:lnum - 1 && s:in_normalzone(l:prev_lnum, 1)
      " Align unordered list multi-line items
      let l:prev_line_char_pos = match(l:prev_line, '\(^\s*[-*+]\s*\)\@<=\S')
      if l:prev_line_char_pos >= 0
        return l:prev_line_char_pos
      endif
      " Align ordered list multi-line items
      let l:ordered_list_extra_indent =
            \ match(l:prev_line, '\(^\s*\d\+\.\s*\)\@<=\S')
      if l:ordered_list_extra_indent >= 0
        return indent(l:prev_lnum) + l:ordered_list_extra_indent
      endif
    endif
  endif

  return indent(v:lnum)
endfunction
