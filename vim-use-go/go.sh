
if [ ! -d ~/.vim/bundle ]; then
	mkdir ~/.vim/bundle
fi

cp autoload -rf ~/.vim/
cp -rf vim-go ~/.vim/bundle/

echo "\" go语言需要配置【开始】-----" >> ~/.vimrc
echo "call pathogen#infect()" >> ~/.vimrc
echo syntax enable  >> ~/.vimrc
echo filetype plugin on >> ~/.vimrc
echo set number >> ~/.vimrc 
echo let g:go_disable_autoinstall = 0 >> ~/.vimrc
echo let g:go_highlight_functions = 1 >> ~/.vimrc
echo let g:go_highlight_methods = 1 >> ~/.vimrc
echo let g:go_highlight_structs = 1 >> ~/.vimrc
echo let g:go_highlight_operators = 1 >> ~/.vimrc
echo let g:go_highlight_build_constraints = 1 >> ~/.vimrc
echo "\" go语言需要配置【结束】-----" >> ~/.vimrc 

