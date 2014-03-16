source plugin/quickfix-reflector.vim

describe 'the quickfix window'
	before
		copen
	end

	after
		cclose
		bdelete!
	end

  it 'sets the modified flag'
		Expect &modified == 0
		put! ='i can insert lines'
		Expect &modified != 0
		write
		Expect &modified == 0
  end

  it 'links to the right places even after changing lines (and writing the buffer)'
		vimgrep /^/ t/3-lines.txt
		copen
		1delete
		1delete
		1put
		write
		Expect getline(1) ==# 't/3-lines.txt|3 col 1| line 3'
		Expect getline(2) ==# 't/3-lines.txt|2 col 1| line 2'

		1
		execute "normal! \<CR>"
		Expect bufname('%') ==# 't/3-lines.txt'
		Expect line('.') == 3

		copen
		2
		execute "normal! \<CR>"
		Expect bufname('%') ==# 't/3-lines.txt'
		Expect line('.') == 2
	end

  it 'works in parallel with location list windows'
		wincmd p
		lvimgrep /^/ t/3-lines.txt
		vsplit
		lopen
		wincmd l
		lopen

		" Just making sure there are no errors

		lclose
		quit
		lclose
	end 
end

" vim:ts=2:sw=2:sts=2
