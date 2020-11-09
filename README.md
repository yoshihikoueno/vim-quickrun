# vim-quickrun

## plugin of the nvim users, by the nvim users, for the nvim users

This is the fork project from [thinca/vim-quickrun](https://github.com/thinca/vim-quickrun).

The core purpose of this project is to provide **better and optimal features in a simpler way** by leveraging
cool features available in Neovim.
This plugin will provide **asynchronous** program execution with **real-time outputs**.


# Demo
![screenshot](./demo.gif)


# Usage

* Just run: <Leader>r

Execute inside *terminal*.
It'll open a new window in the bottom for the terminal.
Automatically close the terminal if the exit code is 0.

* Sticky run: <Leader>R

Execute inside *terminal*.
It'll open a new window in the bottom for the terminal.
The terminal window will remain open.

* Tab run: <Leader>t

Execute inside *terminal*.
The terminal will be opened in a new tab.

# Install

For dein plugin manager users, just add the lines below to your dein.vim.
```
[[plugins]]
repo = 'yoshihikoueno/vim-quickrun'
hook_add= '''
  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config._ = {
            \   'runner': 'terminal',
            \   'runner/terminal/opener': "botright new \[quickrun\ output\]",
  \ }
  let g:quickrun_config.tex = {
            \   'command' : 'preview_tex',
  \ }
  let g:quickrun_config.python = {
            \   'command' : 'python3',
  \ }
  let g:quickrun_config["nooutput"] = {
            \   'runner/terminal/opener': "tabnew \[quickrun\ output\]",
  \}
  let g:quickrun_config["sticky"] = {
            \   'runner/terminal/closeonsuccess': 0,
  \}

  command! -bar CloseQuickRunOutput ccl | call Close_quickrun_terminal() | silent! bw! \[quickrun\ output\]
  command! -bar RunWithouOutput call quickrun#run(g:quickrun_config.nooutput)
  command! -bar RunSticky call quickrun#run(g:quickrun_config.sticky)

  nnoremap <Leader>q :CloseQuickRunOutput<CR>
  nnoremap <Leader>t :RunWithouOutput<CR>
  nnoremap <Leader>R :RunSticky<CR>
'''
```

# Motivation

## It was just too complicated.

Originally, I was using *thinca/vim-quickrun*. But soon, I notice quite a few inconvenience
in the plugin. For example, asynchronous execution is not supported by default.
In order to get that, we have to install and build an additional plugin for it.
It's getting complicated, right?

But the story doesn't stop here.
After installing all the necessary additional plugins, I had my program running asynchronously,
*without outputs* in real-time.
It was not acceptable at all. I tried my best to make this simple thing running, but it just won't work.

Then I thought to myself, *"Well, why does it have to be so complicated in the first place?"*
I mean, we have "terminal" feature built-in to our nvim, which supports everything we need
including asynchronous execution and real-time output presentation.
It just didn't make sense to me that we have to do something complicated just to get things
we already have.


## The maintainer of the original project isn't willing to add features for nvim.

Apparently, there were someone like me in the past according to the pull request history.
He offered some new feature which will be available only for nvim users.
But the maintainer rejected this pull request because he isn't using nvim and he can't maintain it.

As a open source project maintainer, this is how he is supposed to do. So I don't have any complain of it.
But I just felt like to have a forked project of vim-quickrun for nvim.
