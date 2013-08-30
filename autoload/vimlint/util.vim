" ユーティリティ
scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! s:valid_pos(pos) "{{{
  return has_key(a:pos, 'lnum')
endfunction "}}}

function! s:get_pos(node, depth) " {{{
  if a:depth <= 0
    return {}
  endif

  if type(a:node) != type({}) 
    return {}
  endif

  if has_key(a:node, 'pos')
    let pos = a:node.pos
    if s:valid_pos(pos)
      return pos
    endif
  endif

  for k in ['left', 'right']
    if has_key(a:node, k)
      echo a:node[k]
      let p = s:get_pos(a:node[k], a:depth - 1)
      if s:valid_pos(p)
        return p
      endif
    endif
  endfor

  return {}
endfunction " }}}

function! vimlint#util#get_pos(node) " {{{
  let p = s:get_pos(a:node, 10)
  if s:valid_pos(p)
    return p
  else
    return {'lnum' : '', 'col' : '', 'i' : 'EVL999'}
  endif
endfunction " }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et ts=2 sts=2 sw=2 tw=0 foldmethod=marker:
