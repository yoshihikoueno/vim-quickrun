" quickrun: runner/terminal: Runs by terminal feature.
" Author : thinca <thinca+vim@gmail.com>
" License: zlib License

let s:VT = g:quickrun#V.import('Vim.ViewTracer')

let s:is_win = g:quickrun#V.Prelude.is_windows()
let s:runner = {
\   'config': {
\     'name': 'new',
\     'opener': 'new',
\     'into': 0,
\   },
\ }

let s:winid = -1

function! s:runner.validate() abort
  if !has('nvim')
    throw 'Needs +nvim.'
  endif
  if !s:is_win && !executable('sh')
    throw 'Needs "sh" on other than MS Windows.'
  endif
endfunction

function! s:runner.init(session) abort
  let a:session.config.outputter = 'null'
  let g:quickrun#closeonsuccess = get(a:session.config, 'runner/terminal/closeonsuccess', 1)
endfunction

function! s:runner.run(commands, input, session) abort
  let command = join(a:commands, ' && ')
  if a:input !=# ''
    let inputfile = a:session.tempname()
    call writefile(split(a:input, "\n", 1), inputfile, 'b')
    let command = printf('(%s) < %s', command, inputfile)
  endif
  let cmd_arg = s:is_win ? printf('cmd.exe /c (%s)', command)
  \                      : ['sh', '-c', command]
  let options = {
  \   'term_name': 'quickrun: ' . command,
  \   'curwin': 1,
  \   'on_exit': self._job_exit_cb,
  \ }

  let self._key = a:session.continue()
  let prev_window = s:VT.trace_window()
  execute self.config.opener
  let g:quickrun#terminalid = get(g:, 'quickrun#terminalid', [])
  call add(g:quickrun#terminalid, win_getid())
  let s:winid = win_getid()
  let self._bufnr = termopen(cmd_arg, options)
  if !self.config.into
    call s:VT.jump(prev_window)
  endif
endfunction

function! g:Close_quickrun_terminal() abort
  let l:winview = winsaveview()
  for term_id in g:quickrun#terminalid
      let winnr = win_id2win(term_id)
      if winnr > 0
          execute winnr.'wincmd c'
      endif
  endfor
  call winrestview(l:winview)
endfunction

function! s:runner.sweep() abort
  if has_key(self, '_bufnr') && bufexists(self._bufnr)
    let job = term_getjob(self._bufnr)
    while job_status(job) ==# 'run'
      call job_stop(job)
    endwhile
  endif
endfunction

function! s:runner._job_exit_cb(job, exit_status, event) abort
  if has_key(self, '_job_exited')
    call quickrun#session(self._key, 'finish', a:exit_status)
  else
    let self._job_exited = a:exit_status
  endif
  let closeonsuccess = g:quickrun#closeonsuccess
  if self._job_exited == 0 && closeonsuccess
      let winnr = win_id2win(s:winid)
      if winnr > 0
          execute winnr.'wincmd c'
      endif
  endif
endfunction

function! quickrun#runner#terminal#new() abort
  return deepcopy(s:runner)
endfunction
